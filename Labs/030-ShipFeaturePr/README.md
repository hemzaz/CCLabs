# Lab 030 — Ship Feature PR

⏱ **40 min**   📦 **You'll add**: `feat/quips-by-tag` branch merged, PR URL in `quips/SHIPPED.md`   🔗 **Builds on**: Lab 029   🎯 **Success**: `feat/quips-by-tag` merged to main with CI green and PR URL recorded in `quips/SHIPPED.md`

<!--
  Template contract - do not remove this comment.
  CI (lint-prose + structure linter) enforces:
    1. Header line above (one line, five fields, in this exact order)
    2. Fourteen sections below (in this exact order, same H2 titles)
    3. Single new concept (a "Concept:" Bloom-tagged line)
    4. Every Do step ends with a verify COMMAND, not a screenshot
  See CONTRIBUTING.md and docs/DESIGN.md §7 for the full author contract.
-->

!!! hint "Overview"
    - You will plan a new API route in Claude plan mode before writing a single line of code.
    - You will create a feature branch and write a failing test first (TDD red phase).
    - You will let Claude build the implementation, then run a reviewer subagent to audit the diff.
    - You will open a real pull request, watch CI review it, respond to any comments, and merge.
    - By the end the full ship cycle — plan, branch, TDD, review, CI, merge — will be a practised workflow, not just a concept.

**Concept**: `Ship a feature end-to-end via reviewed pull request` (Bloom: Create)

---

## Prerequisites

- Lab 028 (Claude-in-CI workflow) and Lab 029 (PR review loop) completed
- `gh` CLI authenticated (`gh auth status` exits 0)
- The `quips` project with its `reviewer` subagent from Lab 021 in place
- Node.js 20 or newer and `npm test` passing on the quips main branch

## What You Will Learn

- How to use Claude plan mode as a design tool before touching code
- Why writing the failing test first bounds what Claude will build
- When a reviewer subagent gives you more reliable feedback than self-review
- How CI picks up things that local `verify.sh` does not
- The complete branch → TDD → review → PR → merge cycle as a repeatable unit

## Why

Every lab so far contributed one piece: prompting discipline, CLAUDE.md, verify scripts, subagents, hooks, skills, MCP, CI review, and the PR loop. Lab 030 connects all of them. You will ship one small, real feature — `GET /quips/by-tag/:tag` — through the complete cycle without skipping any step. That cycle is the job. Practising it on a contained feature builds the muscle memory for larger ones.

The contrast with earlier one-shot labs is intentional. In Labs 001–020 you typically ran a single command or edited a single file and the lab was done. From Lab 021 onward the labs have been process-oriented: subagents, hooks, CI, and PR loops. Lab 030 is the culmination — you run the whole process, start to finish, on a deliverable that ships.

```
Plan mode              ┌─────────────────────────────────────────────────┐
(design the contract)  │  claude --plan "design GET /quips/by-tag/:tag"  │
                       └───────────────────┬─────────────────────────────┘
                                           │
Feature branch         ┌───────────────────▼──────────────────────────┐
                       │  git checkout -b feat/quips-by-tag           │
                       └───────────────────┬──────────────────────────┘
                                           │
Failing test (TDD red) ┌───────────────────▼──────────────────────────┐
                       │  write test → npm test → watch it fail       │
                       └───────────────────┬──────────────────────────┘
                                           │
Claude builds          ┌───────────────────▼──────────────────────────┐
                       │  claude: "build the route; tests must pass"  │
                       └───────────────────┬──────────────────────────┘
                                           │
Reviewer subagent      ┌───────────────────▼──────────────────────────┐
                       │  /agent reviewer → PASS/WARN/FAIL report     │
                       └───────────────────┬──────────────────────────┘
                                           │
PR + CI review         ┌───────────────────▼──────────────────────────┐
                       │  gh pr create → CI workflow runs → comments  │
                       └───────────────────┬──────────────────────────┘
                                           │
Merge + record         ┌───────────────────▼──────────────────────────┐
                       │  gh pr merge → echo "PR: <url>" >> SHIPPED   │
                       └─────────────────────────────────────────────┘
```

## Walkthrough

### The full-cycle discipline

One-shot labs are useful for learning individual tools. They are not enough preparation for real work, where every change touches design, code, tests, review, and integration simultaneously. The discipline this lab teaches is sequencing those phases in the right order and not skipping any of them.

Plan mode forces you to decide the API contract before writing code, which means Claude's implementation has a specification to match. Writing the failing test before invoking Claude bounds the scope: Claude cannot wander beyond what the test exercises. The reviewer subagent gives you a second-opinion diff audit without the conflict of self-review. CI catches the environment-sensitive issues — missing dependencies, path assumptions, environment variables — that pass locally. Recording the PR URL in `SHIPPED.md` closes the loop with a verifiable artifact.

### TDD before Claude builds

The red-phase test is not optional. Without it, Claude has no success criterion beyond "the code runs." With it, Claude has a concrete target: make the failing test green without breaking the existing suite. This constraint produces smaller, more focused diffs than open-ended prompts like "add the route."

The test also documents intent. When a reviewer reads `expect(res.body).toEqual([])` for a no-match case, they understand the contract immediately. Comments and documentation can fall out of sync; a test cannot.

### Reviewer subagent vs self-review

Claude wrote the implementation. Asking the same context to review its own output is self-review — it will tend to agree with its own choices. The `reviewer` subagent from Lab 021 is a separate process with its own system prompt and read-only tool access. It reads the diff with fresh context and flags issues the author context normalised away. Use it before opening the PR, not after.

### What CI adds

Your local `verify.sh` runs in your environment: your Node version, your PATH, your installed globals. CI runs in a clean container with only what the workflow installs. CI therefore catches: missing `package.json` entries, assumptions about globally installed tools, files accidentally ignored by `.gitignore`, and timing issues that disappear under local watch modes. A PR that passes local verify and fails CI is one of the most common friction points on real teams. Lab 028 set up the workflow; Lab 030 exercises it under real conditions.

## Check

```bash
./scripts/doctor.sh 030
```

Expected output: `OK lab 030 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Adjust → Make). Each step ends with a verify command.

1. **Predict** — before writing any code, write down one thing you expect the CI reviewer to flag on a careless first diff. Think about missing test coverage, error handling gaps, or undeclared dependencies.

   ```bash
   echo "My prediction: <your one-line prediction here>"
   ```

   Expected: the command echoes your prediction without error.

2. **Run** — use Claude plan mode to design the `GET /quips/by-tag/:tag` contract before branching.

   ```bash
   cd quips && claude --plan
   ```

   Inside plan mode, prompt Claude with:

   > Design the contract for `GET /quips/by-tag/:tag`. Specify: path parameter name, response shape (always a JSON array), status codes, and behaviour when no quip matches the tag. Output the contract as three bullet points.

   When Claude presents the plan, confirm it matches these three rules:
   - Path parameter is `:tag`
   - Response is always a JSON array with status 200
   - Empty array returned when no quip matches

   Exit plan mode, then write those three rules into `quips/SHIPPED.md`:

   ```bash
   printf '- Path param: :tag\n- Response: JSON array, status 200\n- No match: empty array []\n' > quips/SHIPPED.md
   ```

   Verify the contract is recorded:

   ```bash
   wc -l < quips/SHIPPED.md
   ```

   Expected: `3` or higher.

3. **Investigate** — create the feature branch and read the existing route file to understand the naming and structural patterns before writing any test.

   ```bash
   cd quips && git checkout -b feat/quips-by-tag
   git branch --show-current
   ```

   Expected: `feat/quips-by-tag`

   Read the existing routes to understand naming:

   ```bash
   ls quips/routes/ 2>/dev/null || ls quips/src/ 2>/dev/null || find quips -name '*.js' -not -path '*/node_modules/*' | head -10
   ```

   Expected: a list of existing source or route files.

4. **Adjust** — write the failing test first. Create a new test file (or add to the existing test file) with three cases: one match, one no-match, one multiple-match.

   Open Claude interactively:

   ```bash
   cd quips && claude
   ```

   Prompt Claude with:

   > Write a failing test for `GET /quips/by-tag/:tag`. Add three test cases to the appropriate test file: one where the tag exists and one quip matches, one where no quip matches (expect empty array), and one where multiple quips match. Do not build the route yet — only write the test. Run `npm test` to confirm the new tests fail.

   After Claude finishes, verify the tests are in a red state:

   ```bash
   (cd quips && npm test --silent 2>&1) | grep -E 'failing|fail|✗|×|FAIL' | head -5
   ```

   Expected: at least one failing test line visible.

5. **Make (build)** — let Claude build the route implementation so the failing tests turn green.

   Still inside the Claude session (or re-open it), prompt:

   > Now build `GET /quips/by-tag/:tag` to make those failing tests pass. Wire the route into the app, return all quips whose tags array includes the `:tag` value, always respond with status 200 and a JSON array. Run `npm test` after and confirm all tests pass.

   When Claude finishes, verify the full suite is green:

   ```bash
   (cd quips && npm test --silent) && echo "all tests green"
   ```

   Expected: `all tests green`

6. **Make (ship)** — run the reviewer subagent, then commit, push, open the PR, respond to CI, and record the URL.

   Inside the Claude session, invoke the reviewer subagent:

   > Run the reviewer subagent on the current git diff and report its findings.

   Review the PASS/WARN/FAIL output. Address any FAIL items before continuing.

   Commit and push:

   ```bash
   cd quips && git add -A && git commit -m "feat: add GET /quips/by-tag/:tag" && git push -u origin feat/quips-by-tag
   ```

   Open the PR:

   ```bash
   gh pr create --title "feat: add GET /quips/by-tag/:tag" --body "Adds a new route that returns all quips matching a given tag as a JSON array. Always returns 200; empty array when no match. Tests cover one-match, no-match, and multiple-match cases."
   ```

   Watch CI run and address any comments. When CI is green, merge:

   ```bash
   gh pr merge --squash --delete-branch
   ```

   Record the PR URL in `quips/SHIPPED.md`:

   ```bash
   echo "PR: $(gh pr list --state merged --limit 1 --json url --jq '.[0].url')" >> quips/SHIPPED.md
   ```

   Verify the URL is recorded:

   ```bash
   grep -q '^PR: ' quips/SHIPPED.md && echo "recorded"
   ```

   Expected: `recorded`

## Observe

Look at the CI review comment on the PR. Name one specific change it suggested. Then write one sentence comparing the CI comment with what the reviewer subagent flagged — did they catch the same thing, or did each find something different?

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| `gh pr create` fails with "no upstream" | Branch pushed without `-u` flag | Run `git push -u origin feat/quips-by-tag` then retry `gh pr create` | https://docs.claude.com/en/docs/claude-code/common-workflows |
| CI review workflow does not trigger on the PR | `pull_request` trigger or path filter missing in the workflow | Open `.github/workflows/claude-review.yml` and confirm `on: pull_request` is present and the changed paths are not excluded | https://github.com/anthropics/claude-code-action |
| Reviewer subagent is not found | `quips/.claude/agents/reviewer.md` missing or Claude not restarted after creation | Complete Lab 021 first, then exit and re-open `claude` in the quips directory | https://docs.claude.com/en/docs/claude-code/sub-agents |
| `npm test` stays green even before the route exists | Test was not properly wired to the app entry point | Ask Claude to re-read the test and confirm it sends a real HTTP request to the running app; check the import path | https://docs.claude.com/en/docs/claude-code/overview |

## Tasks

Click the checkbox next to each task to mark it done — your progress is saved locally.

### Task 1 — Confirm the plan-mode contract matches the spec

**Scenario:** You used plan mode to design the route. Now confirm the three contract rules you recorded in `SHIPPED.md` match the spec exactly.

**Hint:** `cat` the file and read each bullet against the three rules: `:tag` parameter, JSON array response, status 200 with empty array fallback.

??? success "Solution"

    ```bash
    cat quips/SHIPPED.md
    # Expect:
    # - Path param: :tag
    # - Response: JSON array, status 200
    # - No match: empty array []
    ```

### Task 2 — Verify the branch name matches the PR convention

**Scenario:** Your team uses the prefix `feat/` for feature branches. Confirm your branch matches that convention before pushing.

**Hint:** `git branch --show-current` prints the active branch name.

??? success "Solution"

    ```bash
    git -C quips branch --show-current
    # Expected: feat/quips-by-tag
    [[ "$(git -C quips branch --show-current)" == feat/* ]] && echo "convention ok" || echo "rename with git branch -m"
    ```

### Task 3 — Confirm the tests were red before Claude built the route

**Scenario:** TDD discipline requires the test to fail before the production code exists. Check your git log to confirm the test commit precedes the implementation commit.

**Hint:** `git log --oneline` shows commits in reverse-chronological order; the test-only commit should appear after the implementation commit in the log (meaning it was committed earlier).

??? success "Solution"

    ```bash
    git -C quips log --oneline -5
    # The commit that added only the test should appear before the commit that
    # added the route implementation. If they are in one commit, note that for
    # future work — separate commits make the red phase verifiable.
    ```

### Task 4 — Read the reviewer subagent's FAIL items

**Scenario:** The reviewer subagent reports findings as PASS, WARN, or FAIL. Locate any FAIL items and confirm you addressed them before opening the PR.

**Hint:** Re-invoke the reviewer subagent if you did not capture the output: inside `claude` in the quips directory, type "Run the reviewer subagent on the current git diff."

??? success "Solution"

    ```bash
    # If you saved reviewer output to a file:
    grep 'FAIL' quips/reviewer-report.md 2>/dev/null || echo "no saved report; re-run subagent inside claude"
    # Alternatively, re-run inside the claude session:
    # > Run the reviewer subagent on the current git diff and report its findings.
    ```

### Task 5 — Verify CI passed before merging

**Scenario:** You want to confirm the CI review workflow ran and produced a green status before the merge happened.

**Hint:** `gh pr view` shows the PR status and checks summary even after merge when you pass the PR number.

??? success "Solution"

    ```bash
    # Replace <PR-NUMBER> with the number from your SHIPPED.md URL
    gh pr view <PR-NUMBER> --json statusCheckRollup --jq '.statusCheckRollup[] | "\(.name): \(.conclusion)"'
    # Expected: each check shows "SUCCESS" or "NEUTRAL"
    ```

### Task 6 — Confirm the merged PR URL is in SHIPPED.md

**Scenario:** The lab artifact is the URL recorded in `quips/SHIPPED.md`. Confirm it points to a merged PR, not a draft or open one.

**Hint:** `grep` the file for the `PR: ` prefix, then pass the URL to `gh pr view` to read its state.

??? success "Solution"

    ```bash
    pr_url=$(grep '^PR: ' quips/SHIPPED.md | head -1 | cut -d' ' -f2)
    echo "Recorded URL: $pr_url"
    gh pr view "$pr_url" --json state --jq '.state'
    # Expected: MERGED
    ```

## Quiz

<div class="ccg-quiz" data-lab="030">
  <div class="ccg-q" data-answer="b">
    <p><strong>Q1.</strong> Why write the failing test before letting Claude build the route implementation?</p>
    <label><input type="radio" name="030-q1" value="a"> <strong>a.</strong> Tests are required by the GitHub Actions workflow before a PR can open.</label>
    <label><input type="radio" name="030-q1" value="b"> <strong>b.</strong> The failing test gives Claude a concrete, verifiable success criterion that bounds the scope of the implementation.</label>
    <label><input type="radio" name="030-q1" value="c"> <strong>c.</strong> Claude cannot write a route file unless a test file already exists in the same directory.</label>
    <label><input type="radio" name="030-q1" value="d"> <strong>d.</strong> Writing the test first generates a spec that gets auto-uploaded to the CI system.</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">A failing test defines exactly what "done" means. Claude can target green on that specific test rather than guessing scope. Without the test, prompts like "add the route" produce working-but-over-engineered diffs; with it, Claude writes the minimum code needed to satisfy the assertion.</p>
  </div>
  <div class="ccg-q" data-answer="c">
    <p><strong>Q2.</strong> When does a reviewer subagent give you more reliable feedback than asking Claude to self-review its own diff?</p>
    <label><input type="radio" name="030-q2" value="a"> <strong>a.</strong> When the diff is larger than 100 lines, because the subagent has a bigger context window.</label>
    <label><input type="radio" name="030-q2" value="b"> <strong>b.</strong> Only when the subagent is running a different model version than the main session.</label>
    <label><input type="radio" name="030-q2" value="c"> <strong>c.</strong> Always — the subagent starts with a fresh system prompt and no memory of the authoring decisions, so it reads the diff the way a human reviewer would.</label>
    <label><input type="radio" name="030-q2" value="d"> <strong>d.</strong> Only when the main Claude session has run out of context window space.</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Self-review in the same context is biased: the model remembers why it made each choice and will tend to justify rather than question those choices. A subagent spins up with only its system prompt and the diff — no authoring history — so it evaluates the code as written, not as intended.</p>
  </div>
  <div class="ccg-q" data-answer="d">
    <p><strong>Q3.</strong> Which of the following is something CI review catches that a local <code>verify.sh</code> typically misses?</p>
    <label><input type="radio" name="030-q3" value="a"> <strong>a.</strong> Syntax errors in JavaScript files.</label>
    <label><input type="radio" name="030-q3" value="b"> <strong>b.</strong> Failing unit tests for the new route.</label>
    <label><input type="radio" name="030-q3" value="c"> <strong>c.</strong> Incorrect HTTP status codes returned by the route handler.</label>
    <label><input type="radio" name="030-q3" value="d"> <strong>d.</strong> Dependencies that are used in code but absent from <code>package.json</code>, because CI installs from scratch.</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Local environments accumulate globally installed packages and environment variables that CI does not have. A missing <code>package.json</code> entry for a dependency can pass locally (the package is already in <code>node_modules</code> or globally installed) and fail in CI's clean container. This is one of the most common "works on my machine" failure modes.</p>
  </div>
  <div class="ccg-q" data-answer="a">
    <p><strong>Q4.</strong> What belongs in a PR body to make CI review and human reviewers most useful?</p>
    <label><input type="radio" name="030-q4" value="a"> <strong>a.</strong> The contract the PR satisfies, the test cases added, and any known limitations or follow-up work.</label>
    <label><input type="radio" name="030-q4" value="b"> <strong>b.</strong> A link to the task tracker ticket number and nothing else, since the diff speaks for itself.</label>
    <label><input type="radio" name="030-q4" value="c"> <strong>c.</strong> The exact git commands used to create the branch and commit the changes.</label>
    <label><input type="radio" name="030-q4" value="d"> <strong>d.</strong> A full copy of the test output pasted as plain text.</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">A good PR body tells reviewers what problem is solved and how the solution was validated — the contract, the test coverage, and any caveats. This lets the CI reviewer model and human reviewers focus on correctness and edge cases rather than first figuring out what the PR is trying to do.</p>
  </div>
</div>

## Stretch (optional, ~10 min)

Add a `?limit=N` query parameter to `GET /quips/by-tag/:tag` that caps the number of results returned. Choose a sensible default (20 is a good starting point) and write a test that verifies the limit boundary. Use plan mode to design the parameter contract first, then follow the same TDD cycle from this lab.

## Recall

In Lab 023, you configured a pre-commit hook that ran a verify script before every commit. What is the `hookType` value used in `settings.json` for a hook that runs before a tool executes?

> Expected: `PreToolUse`

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://github.com/anthropics/claude-code-action
- https://docs.claude.com/en/docs/claude-code/common-workflows
- https://docs.claude.com/en/docs/claude-code/sub-agents
- https://docs.claude.com/en/docs/claude-code/sdk

## Next

→ **Capstone** — the summative task that scores you on the 4x4 rubric.
