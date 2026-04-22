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

**Concept**: `claude-code-action runs Claude in a GitHub workflow` (Bloom: Create)

---

## Why

Claude Code runs locally in your terminal. The same Claude also runs headless — inside a GitHub Action, triggered by a pull request, with no human at the keyboard. This lab introduces that mode. You write a workflow file that calls `anthropics/claude-code-action`, supplies an API key secret, and scopes the permissions correctly. When a PR opens, Claude reviews the diff and posts a comment. Every team member sees the feedback without running anything locally.

The key difference from local Claude is accountability: in CI, Claude cannot ask for clarification or wait for input. The workflow must be explicit about what Claude can and cannot do.

## Check

```bash
./scripts/doctor.sh 028
```

Expected output: `OK lab 028 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before writing any file, name one thing Claude should never do in CI that is acceptable locally. Write your answer in a comment or scratch note.

   Suggested answer: approving its own edits without human review. In CI, Claude posts suggestions; a human must still approve and merge.

   Verify your answer is recorded:
   ```bash
   echo "predicted: Claude should not approve or merge its own suggestions in CI"
   ```
   Expected: the line prints (confirming you ran this step deliberately).

2. **Run** — read the action's README at https://github.com/anthropics/claude-code-action to find the required inputs and the name of the API key secret. You need to know: the `uses:` reference, the required secret name, and what permissions the job needs.

   Verify the `.github/workflows/` directory exists (create it if not):
   ```bash
   [[ -d .github/workflows ]] || mkdir -p .github/workflows; ls .github/workflows
   ```
   Expected: the directory lists (empty is fine at this point).

3. **Investigate** — plan the workflow before writing it. Your plan must cover:
   - trigger: `pull_request`
   - one job with `permissions: contents: read` and `pull-requests: write`
   - one step: `uses: anthropics/claude-code-action@v1`
   - secret passed as `anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}`

   Verify you can name the required secret:
   ```bash
   echo "required secret: ANTHROPIC_API_KEY"
   ```
   Expected: `required secret: ANTHROPIC_API_KEY`

4. **Modify** — create `.github/workflows/claude-review.yml` with the workflow you planned. Use the structure below as a starting point, then adjust based on what you read in step 2:

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

   If the `yaml` module is not available, use this fallback check:
   ```bash
   grep -q 'anthropics/claude-code-action' .github/workflows/claude-review.yml && echo "action reference found"
   ```
   Expected: `action reference found`

5. **Make** — commit the workflow to a feature branch. Do not push yet (pushing and triggering the live action is covered in Lab 030).

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

In one sentence: what would happen if you omitted the `permissions` stanza from the job — and why does that matter for security?

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| Action fails with "ANTHROPIC_API_KEY missing" | Secret not configured in GitHub repo settings | Go to Settings → Secrets and variables → Actions → New repository secret; name it exactly `ANTHROPIC_API_KEY` | https://github.com/anthropics/claude-code-action |
| Action comments on every PR including unrelated ones | Trigger scope too broad | Narrow the trigger: add `paths:` filter or use a label-gated `if:` condition on the job | https://docs.claude.com/en/docs/claude-code/overview |
| Action has write access to the repo by default | `permissions` stanza omitted | Add `permissions: contents: read` and `pull-requests: write` explicitly; omitting it inherits the repo default, which may be `write-all` | https://github.com/anthropics/claude-code-action |

## Stretch (optional, ~10 min)

Add a `paths:` filter to the `pull_request` trigger so the action only runs when files under `src/` change. Validate the YAML again after editing.

## Recall

In Lab 023, what exit code must a PreToolUse hook return to block a tool call?

> Expected: `2`

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://github.com/anthropics/claude-code-action
- https://docs.claude.com/en/docs/claude-code/overview

## Next

→ **Lab 029 — PR Review Loop** — configure Claude to iterate on review comments until the PR meets a defined quality bar.
