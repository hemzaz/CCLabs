# Lab 018 — Code Review

⏱ **35 min**   📦 **You'll add**: `quips/REVIEW-NOTES.md`   🔗 **Builds on**: Lab 017   🎯 **Success**: `quips/REVIEW-NOTES.md` exists with ≥10 lines and at least one line containing "Challenge"

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
    - You will ask Claude to produce a diff, then pause before accepting it.
    - You will apply a reference checklist to catch edge cases, speculative guards, and naming issues.
    - You will send targeted challenge prompts that force Claude to demonstrate gaps in its own proposal.
    - By the end you will have a written review record that separates what Claude proposed from what you actually accepted.

**Concept**: `Critique your own diff before accepting it` (Bloom: Evaluate)

---

## Prerequisites

- Lab 017 complete and the `quips` project on disk
- `quips/src/server.js` present (`[[ -f quips/src/server.js ]] && echo ok`)
- Git initialised inside `quips/` so `git diff` works

## What You Will Learn

- Why accepting Claude's first diff without review is a systematic risk, not just occasional bad luck
- How to recognise sycophantic responses and replace vague questions with line-level challenges
- How to spot speculative defensive code that adds complexity without a covering test
- How to distinguish comments that aid understanding from comments that restate obvious code
- The accept-first versus review-first workflow, and when each is appropriate

## Why

Claude generates plausible code at speed. Plausible is not the same as correct. A route that works on the happy path can still break on an empty table, a missing tag filter, or a concurrent write. The most reliable way to catch those failures is to pause between "Claude proposes" and "you accept" and apply deliberate scrutiny.

The accept-first workflow (accept → run tests → spot failures) works when the change is trivially small and the test suite is comprehensive. The review-first workflow (read → challenge → revise → accept) pays for itself on anything larger, because rework after a merge costs far more than a five-minute read before one.

This lab practises the review-first workflow. You will see that Claude, when pressed with a specific line from its own diff, surfaces real gaps it did not volunteer the first time.

## Walkthrough

### The accept-first trap

The accept-first trap starts with a sycophancy problem. When you ask "any issues with this code?", Claude typically says "looks good, though you might consider…" and trails into hedged non-answers. That is not useful. The model is pattern-matching to positive-feedback training signals. It takes a concrete, pointed prompt to break through.

Compare these two challenges:

| Weak challenge | Strong challenge |
|---|---|
| "Does this look safe?" | "What input to `getCount()` returns a result inconsistent with the database state?" |
| "Are there edge cases?" | "Write a test that currently fails against your proposed implementation. Show me the assertion." |
| "Is the error handling okay?" | "Line 42: what happens when `db.all()` rejects? Trace the call stack." |

The strong form names a specific line or function and asks for a concrete failing input or a runnable assertion. That framing cannot be answered with a hedge.

### The review checklist

When you receive a diff from Claude, work through this checklist before accepting:

**Correctness**
- Does every new branch have a test that exercises it?
- Can you produce a concrete input that breaks any new function?

**Edge cases**
- Empty collection, zero, null/undefined, unicode, maximum-length string
- Concurrent requests to the new route

**Speculative defensive code**
- Is there error handling for a scenario that cannot actually occur in this codebase?
- Is there a guard that adds a `try/catch` or a null-check without a test to demonstrate the failure?
- If yes: remove it or ask Claude to add the test first.

**Comments**
- Does the comment say something the code does not already say?
- "Increment counter" above `count++` is not useful. "Cap at 1000 to avoid unbounded growth" above `count = Math.min(count + 1, 1000)` is.

**Naming**
- Are new identifiers consistent with the existing naming convention?
- Does the name describe what the thing is, not how it works?

**Security**
- Does new input from a request reach a database call, file-system call, or eval without sanitisation?
- Does a new route expose data that should be restricted?

### Accept-first vs review-first

| Situation | Recommended workflow |
|---|---|
| One-line typo fix, 100% test coverage | Accept-first is fine |
| New route or function, partial test coverage | Review-first |
| Auth, input handling, DB queries | Review-first, then a second pass on security |
| Prototype / throwaway code | Accept-first with a comment marking it temporary |

## Check

```bash
./scripts/doctor.sh 018
```

Expected output: `OK lab 018 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before asking Claude for any code, write down three review criteria you would apply to a new API route. Examples: correctness, edge cases, error handling, security, naming. Record your three criteria now, before continuing.

   Verify the quips project is present:
   ```bash
   [[ -f quips/src/server.js ]] && echo "ready" || echo "missing quips/src/server.js"
   ```
   Expected: `ready`

2. **Run** — open Claude inside the quips project and request a new route. Do not accept the diff yet.

   ```bash
   cd quips && claude
   ```

   Inside the REPL, type:

   > Add a GET /quips/count route that returns the total row count as JSON: `{ "count": N }`. Propose the diff but do not apply it yet.

   Copy Claude's proposed diff into a scratch file called `quips/diff1.txt`. Then verify you have captured it:
   ```bash
   [[ -f quips/diff1.txt ]] && echo "diff captured" || echo "create quips/diff1.txt first"
   ```
   Expected: `diff captured`

3. **Investigate** — apply the review checklist from the Walkthrough to Claude's proposed diff. Then, in the same REPL session, send these two challenges as separate messages:

   - "What concrete input to the count route returns an incorrect result? Show the SQL or JS expression that breaks."
   - "Write three tests for this route. At least one test must currently fail against your proposed implementation."

   Read both responses carefully. Identify at least one gap (examples: empty table returns wrong value, tag-filtered count not supported, DB error not handled). Then verify you have a response to inspect:
   ```bash
   echo "challenge responses read"
   ```
   Expected: `challenge responses read`

4. **Modify** — look at Claude's tests from step 3. Check whether they actually exercise the new code path or merely describe it. Then send this prompt:

   > Update the implementation to fix the gap you identified. Then show me the final diff with `git diff`.

   After Claude applies the edits, capture the final diff:
   ```bash
   git -C quips diff src/
   ```
   Expected: at least one line beginning with `+` in the output.

5. **Make** — write `quips/REVIEW-NOTES.md` with exactly three sections: `## Diff 1` (what Claude first proposed and which checklist items it failed), `## Challenge prompts` (the two questions you sent and the gap Claude named or demonstrated), and `## Diff 2` (what changed between the first and second proposal, and why the gap mattered).

   Verify the file meets the minimum size:
   ```bash
   wc -l quips/REVIEW-NOTES.md
   ```
   Expected: a number ≥ 10.

## Observe

One sentence: which item on the review checklist did Claude's first diff fail, and what exact prompt forced it to acknowledge that?

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| Claude agrees with every challenge immediately | Sycophantic response to a broad question | Quote a specific line from the diff: "Line 12: what input makes `db.all()` return incorrect data?" | https://docs.claude.com/en/docs/claude-code/overview |
| Challenges uncover no gaps | Prompt was too vague and Claude hedged safely | Ask for a pathological input: empty string, null, 10 000-character string, concurrent requests | https://github.com/anthropics/anthropic-cookbook |
| Second diff is worse than the first | Claude over-corrected with speculative guards | Compare both diffs; remove any `try/catch` or null-check that has no corresponding test | https://docs.claude.com/en/docs/claude-code/common-workflows |
| Tests from step 3 all pass immediately | Claude wrote tests that match its own code, not the requirement | Ask: "Run these tests against the code before your changes. Do any fail?" | https://docs.claude.com/en/docs/claude-code/overview |

## Tasks

Click the checkbox next to each task to mark it done — your progress is saved locally.

### Task 1 — Ask Claude to self-critique a diff it just produced

**Scenario:** Claude has proposed the `/quips/count` diff. Before accepting, you want it to review its own work against the checklist.

**Hint:** Ask it to evaluate correctness, edge cases, and security — but name specific lines, not general categories.

??? success "Solution"

    In the REPL, after Claude proposes the diff, send:

    > Review the diff you just proposed. For each function you added, name one concrete input that would return a wrong result or throw an unhandled error. Be specific — cite the line number and the input value.

    Claude should identify at least one gap. If it says "this looks correct", push back:

    > Line [N]: trace what happens when `db.all()` rejects. Where does the error go?

### Task 2 — Provide a concrete failing input for each function in the diff

**Scenario:** You want to know whether Claude's proposed implementation is actually correct, not just plausible-looking.

**Hint:** For each new function or route handler in the diff, construct an input that exercises a boundary: empty table, null tag, non-integer row ID.

??? success "Solution"

    For the `GET /quips/count` route, test these inputs manually or ask Claude to trace them:

    ```bash
    # Empty table
    curl -s http://localhost:3000/quips/count
    # Expected: { "count": 0 } — does Claude's SQL handle an empty result set?

    # After inserting one row
    curl -s -X POST http://localhost:3000/quips \
      -H "Content-Type: application/json" \
      -d '{"text":"hello","author":"a"}'
    curl -s http://localhost:3000/quips/count
    # Expected: { "count": 1 }
    ```

    Ask Claude: "What does `SELECT COUNT(*) FROM quips` return when the table is empty? Does your route handle that correctly?"

### Task 3 — Spot speculative defensive code and remove it

**Scenario:** Claude's second diff includes a `try/catch` block around the SQL call, but no test demonstrates that the catch branch is reachable.

**Hint:** Speculative defensive code is code that handles a failure mode that cannot be triggered by any test in the project. It adds noise without adding safety.

??? success "Solution"

    In the REPL, send:

    > You added a try/catch on line [N]. Show me the test that makes the catch branch execute. If no such test exists, remove the try/catch — or write the test first.

    If Claude writes a test that exercises the error path, keep both the test and the guard. If it cannot write such a test, remove the guard and accept the simpler implementation. Simpler code with a test beats defensive code without one.

### Task 4 — Identify unhelpful new comments

**Scenario:** Claude added two comments to the route handler. You want to decide whether they aid understanding or restate the obvious.

**Hint:** A useful comment explains *why*, not *what*. "Count all rows" above `SELECT COUNT(*) FROM quips` adds nothing the SQL does not already say.

??? success "Solution"

    Read each comment Claude added. For each one, ask: "Would a reader unfamiliar with this codebase understand something new from this comment that they could not get from reading the line itself?"

    If the answer is no, delete the comment. In the REPL:

    > Remove any comments that restate what the code already says. Keep only comments that explain a non-obvious constraint or decision.

    After Claude applies the change, verify the comment count dropped:
    ```bash
    git -C quips diff src/ | grep '^+.*\/\/' | wc -l
    ```

### Task 5 — Verify tests actually exercise the new code path

**Scenario:** Claude produced three tests in step 3. You want to confirm they exercise the new route handler, not just a mock or a no-op.

**Hint:** A test that mocks the database and asserts the mock was called does not prove the route returns the right response. Look for assertions on the HTTP response body.

??? success "Solution"

    Read each test Claude wrote. For each test, answer:
    - Does it make an HTTP request to `/quips/count`?
    - Does it assert on `response.body.count`, not just on `response.status`?
    - Does at least one test set up a known number of rows and assert that exact count is returned?

    If a test only checks `response.status === 200`, add a body assertion:

    ```javascript
    // Inside the test, after the request:
    expect(response.body.count).toBe(expectedRowCount);
    ```

    Then run the suite to confirm the assertion catches a real failure if the count is wrong:
    ```bash
    (cd quips && npm test --silent; echo "exit:$?")
    ```
    Expected: `exit:0` after Claude's implementation satisfies all three assertions.

### Task 6 — Write REVIEW-NOTES.md summarising the pass

**Scenario:** You want a written record of the review so you can refer to it later and share it with a collaborator.

**Hint:** Three sections: what Claude first proposed, what the challenges uncovered, and what changed in the final diff.

??? success "Solution"

    Create `quips/REVIEW-NOTES.md` with this structure:

    ```markdown
    ## Diff 1

    Claude proposed a GET /quips/count route. The implementation used a raw
    `SELECT COUNT(*)` with no error handling and no test for the empty-table case.
    Checklist items failed: edge cases (empty table), test coverage (no failing test).

    ## Challenge prompts

    Challenge 1: "What concrete input returns an incorrect result?"
    → Claude identified: empty table returns `undefined` rather than `{ "count": 0 }`.

    Challenge 2: "Write three tests. At least one must currently fail."
    → Claude wrote a test asserting count equals 0 on empty table. It failed against Diff 1.

    ## Diff 2

    Claude fixed the empty-table case by coalescing the SQL result.
    Removed speculative try/catch that had no covering test.
    Final implementation: 8 lines, one test green, one previously-failing test now green.
    ```

    Verify the file has at least 10 lines:
    ```bash
    wc -l quips/REVIEW-NOTES.md
    ```
    Expected: a number ≥ 10.

## Quiz

<div class="ccg-quiz" data-lab="018">
  <div class="ccg-q" data-answer="b">
    <p><strong>Q1.</strong> You ask Claude "does this route look safe?" and it replies "yes, looks good, though you might consider adding a rate limiter." What best describes this response?</p>
    <label><input type="radio" name="018-q1" value="a"> A. A thorough security review</label>
    <label><input type="radio" name="018-q1" value="b"> B. A sycophantic hedge that avoids naming a specific problem</label>
    <label><input type="radio" name="018-q1" value="c"> C. Proof the route is safe</label>
    <label><input type="radio" name="018-q1" value="d"> D. A sign you should accept the diff without further questions</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">The response is a sycophantic hedge. It agrees with your implicit positive framing and appends a vague suggestion instead of naming a concrete problem. To break the pattern, ask for a specific line number and a specific input that breaks it — a hedged answer is no longer possible.</p>
  </div>
  <div class="ccg-q" data-answer="c">
    <p><strong>Q2.</strong> Which challenge prompt is most likely to surface a real bug in Claude's proposed route handler?</p>
    <label><input type="radio" name="018-q2" value="a"> A. "Are there any edge cases I should know about?"</label>
    <label><input type="radio" name="018-q2" value="b"> B. "Is the error handling sufficient?"</label>
    <label><input type="radio" name="018-q2" value="c"> C. "Write a test that currently fails against your implementation. Show the assertion and the failure output."</label>
    <label><input type="radio" name="018-q2" value="d"> D. "Does this look correct to you?"</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Option C demands a runnable artifact — a test with an assertion and a failure output. That cannot be answered with a hedge. Options A, B, and D are open-ended enough that Claude can respond with general observations that do not expose any real gap.</p>
  </div>
  <div class="ccg-q" data-answer="d">
    <p><strong>Q3.</strong> Claude's second diff adds a <code>try/catch</code> around a database call, but no test in the project can trigger the catch branch. What should you do?</p>
    <label><input type="radio" name="018-q3" value="a"> A. Keep it — defensive code is always better than no defensive code</label>
    <label><input type="radio" name="018-q3" value="b"> B. Keep it — Claude must have had a reason</label>
    <label><input type="radio" name="018-q3" value="c"> C. Rewrite the entire route from scratch</label>
    <label><input type="radio" name="018-q3" value="d"> D. Ask Claude to either write a test that triggers the catch or remove the guard</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Speculative defensive code adds complexity without adding verified safety. The right response is to make the guard earn its place: either Claude writes a test that triggers the catch branch (making the guard justified), or it removes the guard and keeps the code simple. Untested guards are not documentation — they are noise.</p>
  </div>
  <div class="ccg-q" data-answer="a">
    <p><strong>Q4.</strong> A route handler has exactly one line of new logic: it adds 1 to a counter and writes it back. The test suite has 95% branch coverage. Which workflow is appropriate?</p>
    <label><input type="radio" name="018-q4" value="a"> A. Accept-first — the change is trivially small and coverage is comprehensive</label>
    <label><input type="radio" name="018-q4" value="b"> B. Review-first — all diffs require a full checklist pass</label>
    <label><input type="radio" name="018-q4" value="c"> C. Reject the diff — Claude should not write single-line changes</label>
    <label><input type="radio" name="018-q4" value="d"> D. Review-first because 95% coverage means 5% is untested</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">The review-first workflow pays for itself on changes large enough that a test suite will not catch everything at a glance. A one-line change with high coverage is the canonical case where accept-first is appropriate. Applying the full checklist to every trivial edit is overhead that makes review feel like a burden rather than a discipline.</p>
  </div>
</div>

## Stretch (optional, ~10 min)

Add a fourth section to `quips/REVIEW-NOTES.md` called `## Diff 3`. Ask Claude to extend the count route with an optional `?tag=` query parameter that filters by tag. Run the same two challenge prompts from step 3. Note whether the gap Claude finds this time is different from the first round, and whether its self-critique improves when it already knows you will ask for a failing test.

## Recall

In Lab 013, settings are read from three scopes. Which scope wins when the same key appears in both the project `settings.json` and the user `~/.claude/settings.json`?

> Expected: project scope (`settings.json` checked into the repo) wins over user scope for that key, because more-specific scopes override less-specific ones.

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/overview
- https://docs.claude.com/en/docs/claude-code/common-workflows

## Next

→ **Lab 019 — Verify Scripts** — write a `verify.sh` that asserts your own lab outputs meet acceptance criteria, closing the loop between authoring and automated checking.
