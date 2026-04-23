# Capstone — Ship a Reviewed Feature End-to-End

⏱ 3-4 hours · 📦 You'll add: `evidence/` directory with pr_url.txt + reflection.md · 🔗 Integrates: Labs 001-030 · 🎯 Success: rubric.md scored ≥3 on all four dimensions

---

!!! hint "Overview"
    - You will plan, build, and ship a real feature to the Quips API using every skill from the bootcamp.
    - You will protect the session with hooks, drive implementation through Claude while reviewing every diff, and run a subagent review pass before merging.
    - You will open a pull request whose body demonstrates the communication norms from Part VI, and let the Lab 028 CI workflow exercise your code.
    - Your evidence folder — a PR URL, a reflection, and key transcript excerpts — is scored against the 4×4 rubric; the pass bar is ≥3 on all four dimensions.

---

## Brief

This is the summative task for the Claude Code curriculum. Unlike the labs and checkpoints, which each focused on a single skill or a bounded cluster of skills, the Capstone asks you to integrate everything you have learned — end to end, on a real codebase, at production quality.

You will deliver a working feature to the Quips API. That means: planning the work in plan mode, writing failing tests first, letting Claude write code while you review every diff, running a subagent review pass before accepting, protecting the workflow with hooks, pushing to a branch, and opening a pull request whose body demonstrates the communication norms from Part VI. The CI workflow you built in Lab 028 will run on that PR.

The evidence you produce — a PR URL, a reflection, and key Claude transcript excerpts — is what gets scored against the rubric in `rubric.md`. No automated pass/fail exists for the quality of your work; `verify.sh` only confirms the artifacts exist. You or an instructor score the rubric. The pass bar is ≥3 on all four dimensions.

---

## Feature scope (pick one)

You must complete exactly one of the following options. All three are equivalent in scope and difficulty.

**Option A — Search endpoint**
Add `GET /quips/search?q=...` to the Quips API. The endpoint returns all quips whose text contains the query string (case-insensitive). Results must be paginated using the same `limit`/`offset` convention already used in the codebase. Return a 400 with a clear error body if `q` is missing or empty.

**Option B — Rate-limited POST**
Enforce a rate limit of 10 requests per minute per IP on `POST /quips`. Requests that exceed the limit must receive a `429 Too Many Requests` response whose JSON body contains `{ "error": "rate limit exceeded", "retry_after_seconds": N }`. The limit resets on a per-minute sliding or fixed window — document your choice.

**Option C — Tag-stats endpoint**
Add `GET /quips/tags` to the Quips API. The response is a JSON array of `{ "tag": "...", "count": N }` objects, ordered by `count` descending. Tags with equal counts are ordered alphabetically. Include only tags that appear on at least one quip.

---

## Outcomes exercised

| Outcome | Phase where demonstrated |
|---|---|
| O1 — Install, authenticate, and update Claude Code | Setup: confirm `claude --version` before starting the session |
| O2 — Hold a productive multi-turn session on a real codebase | Implementation: multi-turn session driving the feature; transcript captured in `evidence/claude-transcript.md` |
| O3 — Select a permission mode appropriate to a task | Planning phase: choose and justify `acceptEdits` or plan mode; documented in reflection |
| O4 — Write a `CLAUDE.md` that reliably steers Claude | Implementation: Quips `CLAUDE.md` rules steer the session; hook enforces at least one rule |
| O5 — Author a subagent with correct frontmatter and model routing | Review phase: invoke the `reviewer` subagent (or equivalent) to critique the diff before merging |
| O6 — Integrate one MCP server and call its tools | Optional enrichment: use an MCP tool (e.g., `fs-scoped` or `git-read`) during the session if it adds value |
| O7 — Write a hook that blocks an unsafe action | Workflow protection: at least one PreToolUse hook active during the capstone session |
| O8 — Author a skill and invoke it via slash | Optional enrichment: invoke a skill (e.g., `dump-db`) during the session if it adds value |
| O9 — Ship a feature via reviewed PR using Claude Code in CI | PR phase: open PR, CI claude-review workflow runs, you respond with `claude -p` |
| O10 — Diagnose a failed Claude run and recover | Reflection: document one point where the session went wrong and how you recovered |

---

## Deliverable structure

Create an `evidence/` directory inside `Labs/_CAPSTONE/` and populate it before running `verify.sh`.

```
Labs/_CAPSTONE/evidence/
├── pr_url.txt              # required
├── reflection.md           # required
├── claude-transcript.md    # required
└── architecture.md         # optional
```

**`pr_url.txt`** — A single line containing the full URL of your PR (merged or open for review). Example:
```
https://github.com/your-org/CCLabs/pull/42
```

**`reflection.md`** — At least 500 words. Address all four rubric dimensions:
- *Plan quality*: How did you plan? Did you revise the plan mid-session? What evidence do you have that plan mode shaped the output?
- *Safety*: Which permission mode did you use and why? What deny rules or hooks were active? Where did a safety choice change what Claude did?
- *Verification*: What tests did you write? Did you run the review subagent? Did CI catch anything? How did you close the loop?
- *Communication*: What is in your PR body? Did you use `claude -p` to respond to a review comment? Paste an example exchange.

**`claude-transcript.md`** — Key excerpts (not the full raw log) from the Claude sessions that shaped the solution. Include at minimum: the planning exchange, the first test-implementation loop, and the review subagent output. Annotate each excerpt with one sentence explaining why it was significant.

**`architecture.md`** (optional) — If your feature involved non-trivial design decisions (e.g., rate-limit storage strategy, pagination cursor vs. offset), document them here. Describe the tradeoffs you considered and the choice you made.

---

## Workflow (suggested)

1. **Plan with Claude in plan mode.** Open a session on the Quips codebase with `claude` and immediately engage plan mode. State which option you chose and ask Claude to produce a step-by-step plan including tests. Capture this exchange for your transcript.

2. **Create a feature branch.** `git checkout -b capstone-<option-letter>` before any code changes.

3. **Write failing tests first.** Ask Claude to write the tests before any code. Run them; confirm they fail. This is your RED phase.

4. **Let Claude write code. Review every diff.** Use the `reviewer` subagent (or `claude -p "review this diff as a senior engineer"`) to critique each non-trivial change before accepting. Do not accept diffs you cannot explain.

5. **Run `verify.sh` and all Quips tests.** Confirm green. Fix any failures in production code, not by adjusting tests.

6. **Open a PR.** Write a meaningful PR body: what the feature does, how it was tested, what safety choices were made. Run `claude -p` with the PR URL to generate or refine the body if useful.

7. **Let the Lab 028 CI workflow run.** If it posts a review comment, respond to it using `claude -p "here is the review comment: ... draft a reply"`. Include this exchange in your transcript.

8. **Tag the final commit.** `git tag capstone-complete` (local tag is sufficient).

9. **Write `evidence/reflection.md`** against the four rubric dimensions. Be specific — vague claims score lower than concrete evidence.

---

## Scoring

See `rubric.md` for the full 4×4 rubric. Score yourself honestly against each dimension.

The pass bar is **≥3 on all four dimensions**. A score of 2 or below on any single dimension means the Capstone is not yet complete — revise the artifact and re-score.

If you are working with an instructor, share `evidence/reflection.md` and your PR URL. The instructor scores independently; discrepancies of more than one level on any dimension trigger a calibration conversation.

---

## Tasks

These five drills are practice runs you complete **before** submitting your evidence folder. Each one exercises a specific rubric dimension at full intensity. Work through them in order — they build on each other.

### Task 1 — Stress-test your feature with unexpected inputs

**Scenario:** Before opening the PR, you want confidence that your feature handles adversarial inputs gracefully — empty strings, very long query params, Unicode, boundary values at the pagination limit.

**Hint:** Ask Claude to generate a fuzz-style test suite: `claude -p "generate a test suite that sends unexpected inputs to my endpoint and asserts the response codes and bodies"`. Run it and triage any failures.

??? success "Solution"

    ```bash
    # Inside your Quips project directory, with Claude Code active:
    claude -p "generate 10 adversarial test cases for my endpoint covering:
      empty string inputs, whitespace-only values, Unicode in query params,
      offset/limit at max integer, and missing required fields.
      Write them as pytest/jest tests matching the existing test style."
    # Run the generated tests and fix any failures in production code — not the tests.
    ```

    What to look for: unexpected 500s (should be 400s), missing error bodies, crashes on Unicode. Each failure is a rubric point waiting to be earned under Verification.

### Task 2 — Draft your PR body in plan mode

**Scenario:** A strong PR body is the primary artifact for the Communication dimension. Before you open the PR, draft it with Claude in plan mode so you can review and refine it without triggering any file writes.

**Hint:** Enter plan mode (type `/plan` in the REPL or start the session with plan mode active), then describe your feature and ask Claude to draft a PR body that covers: what the feature does, how it was tested, what safety choices were made, and any open questions for reviewers.

??? success "Solution"

    ```bash
    # Start a plan-mode session or use headless mode for a one-shot draft:
    claude -p "draft a GitHub PR body for the following feature: [paste your feature summary].
      The body should cover: problem statement, solution approach, test coverage,
      safety and permission choices, and any open questions.
      Use markdown with ## headers. Do not write any files."
    # Copy the output into your PR description. Revise until it earns a Proficient (3) rating
    # on the Communication rubric row.
    ```

    Save the draft in a scratch file so you can paste it into the GitHub PR form. The PR body is what the CI reviewer and your instructor read first.

### Task 3 — Run the reviewer subagent on your own diff

**Scenario:** The Verification rubric row requires a review subagent pass. Run it now, before the PR is open, so you can address findings while they are still cheap to fix.

**Hint:** Produce the diff with `git diff main...HEAD`, then pipe it to `claude -p` with a reviewer persona prompt. Alternatively, invoke your `reviewer` subagent directly if you wrote one in Lab 022 or Lab 023.

??? success "Solution"

    ```bash
    # Option A: headless reviewer pass
    git diff main...HEAD | claude -p "you are a senior engineer reviewing this diff.
      Flag any: missing error handling, untested code paths, security issues,
      naming inconsistencies, or violations of the existing code style.
      Be specific: file name and line number for each finding."

    # Option B: invoke your subagent directly (if available)
    claude -p --agent reviewer "$(git diff main...HEAD)"
    ```

    Address every HIGH-severity finding before opening the PR. Save the reviewer output — paste a key excerpt into `claude-transcript.md` to satisfy the Verification dimension.

### Task 4 — Negotiate a CI review pushback

**Scenario:** After the PR is open, the Lab 028 CI workflow will post a review comment. Practice responding to a pushback before it happens, so you are ready when the real comment arrives.

**Hint:** Invent a plausible review comment (e.g., "this endpoint lacks rate limiting" or "the error body doesn't follow the existing convention") and use `claude -p` to draft a reply that either agrees and proposes a fix, or disagrees and defends your approach with evidence.

??? success "Solution"

    ```bash
    claude -p "draft a reply to this code review comment:
      '${REVIEW_COMMENT}'
      My PR adds [feature summary]. The comment raises [concern].
      Write a reply that: acknowledges the concern, explains my current approach,
      and either commits to a fix with a specific plan or defends the current choice
      with evidence from the codebase."
    ```

    A back-and-forth reply loop like this is what earns a 4 (Expert) on the Communication dimension. Save the exchange for your transcript.

### Task 5 — Write the reflection.md first draft

**Scenario:** The reflection is the primary evidence artifact. Writing a rough draft now — before the session is cold — means you capture details you would otherwise forget. You will polish it after the PR is merged.

**Hint:** Open `evidence/reflection.md` and write at least two sentences per rubric dimension while the session is fresh. Do not wait until everything is finished; partial drafts are easier to complete than blank files.

??? success "Solution"

    ```bash
    # Scaffold the four sections so nothing gets forgotten:
    cat > Labs/_CAPSTONE/evidence/reflection.md << 'EOF'
    # Capstone Reflection

    ## Plan quality

    <!-- How did you plan? Did you revise mid-session? What evidence shows plan mode shaped the output? -->

    ## Safety

    <!-- Which permission mode and why? What deny rules or hooks were active? -->

    ## Verification

    <!-- What tests did you write? Did you run the review subagent? Did CI catch anything? -->

    ## Communication

    <!-- What is in your PR body? Did you use claude -p to respond to a review comment? -->
    EOF
    ```

    Fill in each section immediately after the relevant phase of your session. 500 words minimum total. Concrete evidence (specific hook names, specific test counts, pasted exchanges) scores higher than general claims.

---

## Quiz

<div class="ccg-quiz" data-lab="capstone">
  <div class="ccg-q" data-answer="b">
    <p><strong>Q1.</strong> What does plan mode primarily prevent during a Claude Code session?</p>
    <label><input type="radio" name="capstone-q1" value="a"> **a.** Claude reading files it does not have permission to access</label>
    <label><input type="radio" name="capstone-q1" value="b"> **b.** Claude writing or executing anything before you approve the plan</label>
    <label><input type="radio" name="capstone-q1" value="c"> **c.** Claude invoking subagents without your knowledge</label>
    <label><input type="radio" name="capstone-q1" value="d"> **d.** Claude using a model tier above the one you configured</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Plan mode holds Claude in a read-and-reason loop — it can explore the codebase and produce a plan, but it will not write files or run commands until you exit plan mode and confirm. This is what earns a 3 (Proficient) on the Plan quality dimension: you have evidence that plan mode shaped the output before any code was written.</p>
  </div>
  <div class="ccg-q" data-answer="d">
    <p><strong>Q2.</strong> Which rubric tier requires a subagent review pass as part of Verification?</p>
    <label><input type="radio" name="capstone-q2" value="a"> **a.** 1 — Novice</label>
    <label><input type="radio" name="capstone-q2" value="b"> **b.** 2 — Developing</label>
    <label><input type="radio" name="capstone-q2" value="c"> **c.** 3 — Proficient</label>
    <label><input type="radio" name="capstone-q2" value="d"> **d.** 3 — Proficient (tests + review subagent)</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">The Verification row of the rubric reads: 1 = No tests, 2 = Tests, 3 = Tests + review subagent, 4 = Tests + review + security + CI. Running the reviewer subagent on your diff is the step that moves you from a 2 to a 3. Without it, you are capped at Developing regardless of how thorough your unit tests are.</p>
  </div>
  <div class="ccg-q" data-answer="c">
    <p><strong>Q3.</strong> Why does the PR body matter for the Communication dimension specifically?</p>
    <label><input type="radio" name="capstone-q3" value="a"> **a.** GitHub requires a non-empty body to enable the merge button</label>
    <label><input type="radio" name="capstone-q3" value="b"> **b.** The CI workflow reads the body to decide which tests to run</label>
    <label><input type="radio" name="capstone-q3" value="c"> **c.** It is the primary artifact that shows you can explain your own work in conventional engineering prose</label>
    <label><input type="radio" name="capstone-q3" value="d"> **d.** A long body increases the rubric score proportionally to its word count</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">The Communication rubric row measures whether you can hand off context to another engineer (or reviewer) without a synchronous conversation. A well-structured PR body — covering what the feature does, how it was tested, and what safety choices were made — is evidence of that skill. The Proficient level requires a conventional body; the Expert level adds a `claude -p`-assisted review reply loop.</p>
  </div>
  <div class="ccg-q" data-answer="a">
    <p><strong>Q4.</strong> How do hooks and permission settings together map to the Safety rubric tier?</p>
    <label><input type="radio" name="capstone-q4" value="a"> **a.** Using both plan mode and at least one PreToolUse hook with deny rules earns a 4 (Expert) on Safety</label>
    <label><input type="radio" name="capstone-q4" value="b"> **b.** Having any hook at all earns a 4 (Expert), regardless of permission mode</label>
    <label><input type="radio" name="capstone-q4" value="c"> **c.** Hooks are not evaluated on the Safety dimension; only permission mode matters</label>
    <label><input type="radio" name="capstone-q4" value="d"> **d.** The Safety dimension only applies when you use `bypass` mode</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">The Safety rubric row reads: 1 = bypass mode used, 2 = default permissions, 3 = acceptEdits + deny rules, 4 = Plan + hooks + permission layering. Reaching Expert requires all three layers working together: plan mode to constrain initial writes, deny rules to block specific tool calls, and at least one PreToolUse hook that actively enforces a policy during the session.</p>
  </div>
</div>

---

## References

- Claude Code documentation: <https://docs.claude.com/en/docs/claude-code/overview>
- Claude Code Action (CI integration): <https://github.com/anthropics/claude-code-action>
- Quips codebase: `quips/` in this repository
