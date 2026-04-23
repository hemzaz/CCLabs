# Lab 028 — Claude in CI

⏱ **30 min**   📦 **You'll add**: `.github/workflows/claude-review.yml`   🔗 **Builds on**: Lab 027   🎯 **Success**: `claude-review.yml` exists, parses as valid YAML, and references `anthropics/claude-code-action` and `ANTHROPIC_API_KEY`

<!--
  Template contract - do not remove this comment.
  CI (lint-prose + structure linter) enforces:
    1. Header line above (one line, five fields, in this exact order)
    2. Nine sections below (in this exact order, same H2 titles)
    3. Single new concept (a "Concept:" Bloom-tagged line)
    4. Every Do step ends with a verify COMMAND, not a screenshot
  See CONTRIBUTING.md and docs/DESIGN.md §7 for the full author contract.
-->

!!! hint "Overview"
    - You will learn how `anthropics/claude-code-action` runs Claude inside a GitHub Actions workflow, triggered by pull request events.
    - You will configure the `ANTHROPIC_API_KEY` secret in your repository and understand why it lives in GitHub Secrets rather than your workflow file.
    - You will create a workflow that automatically posts Claude's review as a PR comment, scope it to specific paths, and add a human-approval gate before any automated action is merged.
    - By the end you will have a working CI review loop that any collaborator can trigger simply by opening or pushing to a pull request.

**Concept**: `claude-code-action runs Claude in a GitHub workflow` (Bloom: Create)

---

## Prerequisites

- A GitHub repository where you have admin access (to add repository secrets)
- A working `ANTHROPIC_API_KEY` from console.anthropic.com (or a Claude Pro/Max plan key)
- Git configured locally with push access to that repository
- Familiarity with basic GitHub Actions YAML structure (triggers, jobs, steps)

## What You Will Learn

- How `anthropics/claude-code-action` invokes Claude non-interactively inside a runner
- Which GitHub events trigger the action and why `pull_request` is the canonical starting point
- How to scope a review with `paths:` filters so Claude only runs when relevant files change
- How to add an environment protection rule as a human-approval gate before automated actions proceed
- The difference between running `claude -p` locally and a CI invocation through the action

## Why

Claude Code runs locally in your terminal. The same model also runs headless inside GitHub Actions — triggered by a pull request, with no human at the keyboard. Every team member sees the feedback without running anything themselves. Code lands reviewed, not just reviewed-after-merge.

The key difference from local usage is accountability. Locally you can clarify, iterate, and ask Claude to reconsider. In CI, the workflow is the entire context. Claude cannot ask for input or wait — it reads the diff, posts its findings, and exits. That constraint makes the workflow file the most important artifact: it defines what Claude sees, what it can write to, and what requires a human decision before anything goes further.

This lab introduces O9 — `anthropics/claude-code-action` — the GitHub Action that bridges Claude Code and your CI pipeline.

## Walkthrough

`anthropics/claude-code-action` is a composite GitHub Action that wraps the Claude Code CLI. When a workflow step calls `uses: anthropics/claude-code-action@v1`, the action installs Node, resolves the API key from your repository secrets, and invokes Claude in non-interactive (`-p`) mode against the pull request diff. Claude writes its output as a comment on the PR using the GitHub API.

**How it gets triggered**

The action responds to whatever event the enclosing workflow declares. Common patterns:

| Event | When it fires | Typical use |
|---|---|---|
| `pull_request` (types: `opened`) | When a PR is first opened | Initial review on the full diff |
| `pull_request` (types: `synchronize`) | When new commits are pushed to an open PR | Incremental review of new changes |
| `issue_comment` (created) | When a comment is posted on the PR | On-demand re-review triggered by a phrase like `/claude review` |

For this lab you will use the default `pull_request` trigger, which covers both `opened` and `synchronize` unless you restrict it with a `types:` key.

**Secrets and why they live in GitHub Secrets**

The action requires the Anthropic API key to call Claude. You pass it as an input named `anthropic_api_key` using `${{ secrets.ANTHROPIC_API_KEY }}`. The value comes from your repository's Actions Secrets, never from the workflow file itself — so the key never appears in source control.

To add the secret: go to your repository on GitHub, then Settings → Secrets and variables → Actions → New repository secret. Name it exactly `ANTHROPIC_API_KEY`.

**Permissions**

The job needs two GitHub token permissions:

- `contents: read` — to check out the code and read the diff
- `pull-requests: write` — to post the review comment

Declaring permissions explicitly follows the principle of least privilege. If you omit the `permissions` stanza the job inherits the repository default, which is often `write-all` — a much wider blast radius than the action actually needs.

**Scoping with `paths:`**

By default the action runs on every PR regardless of which files changed. You can limit runs by adding a `paths:` filter to the trigger:

```yaml
on:
  pull_request:
    paths:
      - 'src/**'
```

With this filter, PRs that only touch `docs/` or `*.md` do not run the workflow at all, saving API calls and keeping PR timelines clean.

**Local `claude -p` vs CI invocation**

| Dimension | Local `claude -p` | CI via `claude-code-action` |
|---|---|---|
| Context | Your working tree, full filesystem | Checked-out commit, diff only |
| Auth | Shell env var or browser login | GitHub Actions Secret |
| Output | Printed to stdout | Posted as PR comment via GitHub API |
| Human in the loop | You are right there | Requires explicit approval gate |
| Scope control | You write the prompt | Workflow file + `paths:` filter |

**Reference: action inputs**

| Input | Required | Default | Description |
|---|---|---|---|
| `anthropic_api_key` | Yes | — | API key forwarded to the Claude CLI |
| `model` | No | `claude-opus-4-5` | Which Claude model to use |
| `prompt` | No | Auto-generated from diff | Custom prompt passed to Claude |
| `max_tokens` | No | `4096` | Token budget for Claude's response |
| `timeout_minutes` | No | `10` | Runner timeout for the Claude step |
| `paths` | No | All files | Comma-separated glob patterns to filter reviewed files |

**Adding a human-approval gate**

Posting a review comment is one thing; taking an automated action (committing a fix, merging, labelling) is another. GitHub's environment protection rules let you require a named reviewer to approve before a job runs. Add an `environment:` key to the job and configure that environment in Settings → Environments → Required reviewers. The job waits for approval before Claude posts any write-capable action.

## Check

```bash
./scripts/doctor.sh 028
```

Expected output: `OK lab 028 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before writing any file, name one thing Claude should never do autonomously in CI that is acceptable when you are sitting at the keyboard locally. Write your answer in a scratch note.

   Suggested answer: **a.** approving or merging its own suggestions without human review. In CI, Claude posts suggestions; a human must still approve and merge.

   Verify your answer is recorded:

   ```bash
   echo "predicted: Claude should not approve or merge its own suggestions in CI"
   ```

   Expected: the line prints, confirming you ran this step deliberately.

2. **Run** — confirm that your `.github/workflows/` directory exists (create it if not) and check that git recognises the repository:

   ```bash
   [[ -d .github/workflows ]] || mkdir -p .github/workflows
   ls .github/workflows
   git remote -v | head -2
   ```

   Expected: the directory lists (empty is fine at this point) and at least one remote prints.

3. **Investigate** — plan the workflow before writing it. Your plan must cover:

   - trigger: `pull_request` (default types cover `opened` and `synchronize`)
   - one job with `permissions: contents: read` and `pull-requests: write`
   - a checkout step: `uses: actions/checkout@v4`
   - the review step: `uses: anthropics/claude-code-action@v1`
   - the secret passed as `anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}`

   Verify you can echo the required secret name:

   ```bash
   echo "required secret: ANTHROPIC_API_KEY"
   ```

   Expected: `required secret: ANTHROPIC_API_KEY`

4. **Modify** — create `.github/workflows/claude-review.yml` with the workflow you planned. Use the structure below as your starting point:

   ```yaml
   name: Claude Review

   on:
     pull_request:

   jobs:
     review:
       runs-on: ubuntu-latest
       permissions:
         contents: read
         pull-requests: write
       steps:
         - uses: actions/checkout@v4
         - uses: anthropics/claude-code-action@v1
           with:
             anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
   ```

   Validate the file parses as YAML:

   ```bash
   python3 -c "import yaml; yaml.safe_load(open('.github/workflows/claude-review.yml')); print('YAML valid')"
   ```

   Expected: `YAML valid`

   If the `yaml` module is not available, use this fallback:

   ```bash
   grep -q 'anthropics/claude-code-action' .github/workflows/claude-review.yml && echo "action reference found"
   ```

   Expected: `action reference found`

5. **Make** — commit the workflow to a feature branch. Do not push yet (pushing and triggering the live action is covered in Lab 030):

   ```bash
   git checkout -b feat/claude-review 2>/dev/null || git checkout feat/claude-review
   git add .github/workflows/claude-review.yml
   git commit -m "feat: add claude-review workflow"
   ```

   Verify:

   ```bash
   git log -1 --oneline
   ```

   Expected: output contains `feat: add claude-review workflow`.

## Observe

In one sentence: what would happen if you omitted the `permissions` stanza from the job, and why does that matter for security?

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| Action fails with "ANTHROPIC_API_KEY missing" | Secret not configured in GitHub repo settings | Go to Settings → Secrets and variables → Actions → New repository secret; name it exactly `ANTHROPIC_API_KEY` | https://github.com/anthropics/claude-code-action |
| Action comments on every PR including unrelated ones | Trigger scope too broad | Add a `paths:` filter to the `pull_request` trigger to limit which file changes activate the workflow | https://docs.github.com/en/actions/writing-workflows/choosing-when-your-workflow-runs/triggering-a-workflow |
| Action has write access to the whole repo | `permissions` stanza omitted | Add `permissions: contents: read` and `pull-requests: write` explicitly; omitting it inherits the repo default, which may be `write-all` | https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/controlling-permissions-for-github_token |
| PR comment never appears despite green run | `pull-requests: write` permission missing | Confirm the `permissions` block grants `pull-requests: write` at the job level | https://github.com/anthropics/claude-code-action |

## Tasks

Click the checkbox next to each task to mark it done — your progress is saved locally.

### Task 1 — Add the `opened` type restriction

**Scenario:** The default `pull_request` trigger fires on both `opened` and `synchronize` events, which means Claude re-reviews on every push. You want it to run only when a PR is first opened.

**Hint:** `pull_request` accepts a `types:` key that accepts a list of event subtypes.

??? success "Solution"

    ```yaml
    on:
      pull_request:
        types: [opened]
    ```

    Validate after editing:

    ```bash
    python3 -c "import yaml; y=yaml.safe_load(open('.github/workflows/claude-review.yml')); print(y['on']['pull_request']['types'])"
    ```

    Expected: `['opened']`

### Task 2 — Configure the `ANTHROPIC_API_KEY` secret

**Scenario:** The action fails immediately if the secret is missing. You need to add it to your GitHub repository before pushing the workflow.

**Hint:** GitHub Secrets live under Settings → Secrets and variables → Actions in your repository. The name must match exactly what the workflow references.

??? success "Solution"

    Navigate to your GitHub repository, then:

    1. Click **Settings** → **Secrets and variables** → **Actions**
    2. Click **New repository secret**
    3. Name: `ANTHROPIC_API_KEY`
    4. Value: your Anthropic API key starting with `sk-ant-`
    5. Click **Add secret**

    Verify locally that your key is well-formed (starts with the right prefix):

    ```bash
    echo "$ANTHROPIC_API_KEY" | grep -qE '^sk-ant-' && echo "key format ok" || echo "check key format"
    ```

    Expected: `key format ok`

### Task 3 — Restrict the review to `src/` files

**Scenario:** Your repository has documentation, config, and source files. You only want Claude to review changes under `src/`.

**Hint:** Add a `paths:` list to the `pull_request` trigger.

??? success "Solution"

    ```yaml
    on:
      pull_request:
        paths:
          - 'src/**'
    ```

    Full trigger block after the edit:

    ```yaml
    on:
      pull_request:
        types: [opened]
        paths:
          - 'src/**'
    ```

    Validate:

    ```bash
    python3 -c "import yaml; y=yaml.safe_load(open('.github/workflows/claude-review.yml')); print(y['on']['pull_request'].get('paths'))"
    ```

    Expected: `['src/**']`

### Task 4 — Observe the PR comment shape

**Scenario:** You pushed the branch and opened a PR. Claude ran and posted a comment. You want to understand what the comment contains before deciding whether to act on it.

**Hint:** GitHub Actions comments from `claude-code-action` appear as a comment authored by the GitHub Actions bot. The comment body is Claude's plain-text review, formatted in Markdown.

??? success "Solution"

    After the action completes, open the PR on GitHub and scroll to the **Conversation** tab. The comment will:

    - Be authored by `github-actions[bot]`
    - Contain a Markdown-formatted review with sections such as **Summary**, **Issues found**, and **Suggestions**
    - Thread replies to that comment stay grouped, keeping the review thread tidy

    To inspect the comment text programmatically via the GitHub CLI:

    ```bash
    gh pr view --comments <PR-number> | grep -A 20 'github-actions'
    ```

    Expected: Claude's review text appears after the bot attribution line.

### Task 5 — Add a human-approval gate

**Scenario:** Your team wants Claude to be able to post a comment, but any step that takes a write action (labelling, auto-merging) must wait for a human to approve the run first.

**Hint:** GitHub environment protection rules let you require named reviewers before a job can proceed. Add an `environment:` key to the job and configure that environment in Settings → Environments.

??? success "Solution"

    Update the job definition in your workflow:

    ```yaml
    jobs:
      review:
        runs-on: ubuntu-latest
        environment: require-human-approval
        permissions:
          contents: read
          pull-requests: write
        steps:
          - uses: actions/checkout@v4
          - uses: anthropics/claude-code-action@v1
            with:
              anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
    ```

    Then in GitHub:

    1. Go to Settings → Environments → **New environment**
    2. Name it `require-human-approval`
    3. Enable **Required reviewers** and add yourself or your team

    Validate the workflow still parses:

    ```bash
    python3 -c "import yaml; y=yaml.safe_load(open('.github/workflows/claude-review.yml')); print(y['jobs']['review'].get('environment'))"
    ```

    Expected: `require-human-approval`

### Task 6 — Contrast local and CI invocation with a side-by-side test

**Scenario:** You want to see exactly what Claude produces locally versus what it would produce in CI, using the same prompt.

**Hint:** Run `claude -p` locally with a prompt describing a small diff, then compare the output style to what the action posts on a PR.

??? success "Solution"

    Run locally:

    ```bash
    claude -p "review this one-line change: -console.log('debug'); +// removed debug log" 
    ```

    Expected: Claude prints a short review to stdout and exits.

    In CI the same model and prompt runs inside the runner. The difference is that the output is not printed to a terminal — it is sent to the GitHub API as a PR comment using the `GITHUB_TOKEN` the action receives automatically. The content is the same; the destination and the actor are different.

    Verify you can name the two destinations:

    ```bash
    echo "local: stdout | CI: GitHub PR comment via API"
    ```

    Expected: the line prints.

## Quiz

<div class="ccg-quiz" data-lab="028">
  <div class="ccg-q" data-answer="b">
    <p><strong>Q1.</strong> Which repository secret must be configured for <code>anthropics/claude-code-action</code> to authenticate with the Anthropic API?</p>
    <label><input type="radio" name="028-q1" value="a"> A. <code>CLAUDE_API_KEY</code></label>
    <label><input type="radio" name="028-q1" value="b"> B. <code>ANTHROPIC_API_KEY</code></label>
    <label><input type="radio" name="028-q1" value="c"> C. <code>GITHUB_TOKEN</code></label>
    <label><input type="radio" name="028-q1" value="d"> D. <code>ACTIONS_SECRET</code></label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">The action reads <code>anthropic_api_key</code> from the workflow input and expects it to come from <code>secrets.ANTHROPIC_API_KEY</code>. The name must match exactly — <code>CLAUDE_API_KEY</code> and other variants are not recognised. <code>GITHUB_TOKEN</code> is a separate token the runner uses for GitHub API calls, not for calling Claude.</p>
  </div>
  <div class="ccg-q" data-answer="c">
    <p><strong>Q2.</strong> Which two <code>pull_request</code> event types does the default (no <code>types:</code> key) trigger cover?</p>
    <label><input type="radio" name="028-q2" value="a"> A. <code>labeled</code> and <code>unlabeled</code></label>
    <label><input type="radio" name="028-q2" value="b"> B. <code>opened</code> and <code>closed</code></label>
    <label><input type="radio" name="028-q2" value="c"> C. <code>opened</code> and <code>synchronize</code></label>
    <label><input type="radio" name="028-q2" value="d"> D. <code>review_requested</code> and <code>ready_for_review</code></label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">When <code>pull_request</code> has no <code>types:</code> key GitHub defaults to firing on <code>opened</code>, <code>synchronize</code>, and <code>reopened</code>. For a review action this means Claude runs when the PR is first opened and again each time new commits are pushed — which is usually what you want, but you can restrict it with <code>types: [opened]</code> if you only want the initial pass.</p>
  </div>
  <div class="ccg-q" data-answer="a">
    <p><strong>Q3.</strong> You want Claude's review workflow to skip entirely when only <code>.md</code> files change. Which workflow key achieves this?</p>
    <label><input type="radio" name="028-q3" value="a"> A. A <code>paths:</code> filter on the <code>pull_request</code> trigger</label>
    <label><input type="radio" name="028-q3" value="b"> B. An <code>if:</code> condition on the job referencing <code>github.event.action</code></label>
    <label><input type="radio" name="028-q3" value="c"> C. A <code>concurrency:</code> group that cancels in-progress runs</label>
    <label><input type="radio" name="028-q3" value="d"> D. Setting <code>timeout-minutes: 0</code> on the step</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">A <code>paths:</code> filter on the trigger prevents the workflow from being queued at all when changed files do not match the pattern. This is the most efficient approach — the runner is never allocated. An <code>if:</code> condition on the job still queues the run; it just skips the job after checkout, which still consumes runner minutes.</p>
  </div>
  <div class="ccg-q" data-answer="d">
    <p><strong>Q4.</strong> Why must Claude run in non-interactive (headless) mode inside a GitHub Actions runner?</p>
    <label><input type="radio" name="028-q4" value="a"> A. GitHub Actions runners do not have internet access</label>
    <label><input type="radio" name="028-q4" value="b"> B. The runner does not have Node.js installed by default</label>
    <label><input type="radio" name="028-q4" value="c"> C. Interactive mode requires a Pro plan rather than an API key</label>
    <label><input type="radio" name="028-q4" value="d"> D. There is no terminal attached to the runner, so Claude cannot prompt for input or display an interactive session</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">A CI runner is a headless Linux process. There is no TTY, no keyboard, and no one watching the terminal. Claude's interactive REPL expects a real terminal to render its UI and accept keystrokes. Non-interactive mode (<code>-p</code>) reads a prompt, calls the API, writes the response to stdout, and exits — exactly what a CI step needs. The action handles this by always invoking Claude with <code>-p</code> under the hood.</p>
  </div>
</div>

## Stretch (optional, ~10 min)

Add a `paths-ignore:` filter alongside your `paths:` filter to explicitly exclude changes to `*.md` and `CHANGELOG` files even within `src/`. Validate the YAML after editing, then write one sentence explaining why `paths-ignore:` and `paths:` cannot both appear on the same trigger in some GitHub Actions versions.

## Recall

In Lab 023, what exit code must a PreToolUse hook return to block a tool call?

> Expected: `2`

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://github.com/anthropics/claude-code-action
- https://docs.github.com/en/actions/writing-workflows/choosing-when-your-workflow-runs/triggering-a-workflow
- https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/controlling-permissions-for-github_token
- https://docs.claude.com/en/docs/claude-code/overview

## Next

→ **Lab 029 — PR Review Loop** — configure Claude to iterate on review comments until the PR meets a defined quality bar.
