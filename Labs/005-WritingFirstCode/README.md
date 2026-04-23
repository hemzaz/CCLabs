# Lab 005 — Writing First Code

⏱ **25 min**   📦 **You'll add**: `GET /random` route in `quips/src/server.js` with a passing Vitest test   🔗 **Builds on**: Lab 004   🎯 **Success**: `npm test` passes and `grep -qi "random" quips/src/server.js` matches

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
    - You will write a structured implementation prompt that includes test requirements, error paths, and style constraints.
    - You will follow the prompt → diff → review → accept cycle to add `GET /random` to the Quips API.
    - You will ask Claude to explain its SQL choice and then ask it to add test coverage before accepting any code.
    - By the end the full Vitest suite will pass, giving you a repeatable workflow for every feature you add in future labs.

**Concept**: `Ask Claude to write code that passes a test` (Bloom: Apply)

---

## Prerequisites

- Completed Lab 004 (you have a running Quips project and understand its file layout)
- `quips/` directory with `src/server.js`, `src/db.js`, and `test/server.test.js` present
- Node.js 20 or newer and `npm` on PATH

## What You Will Learn

- How to write an implementation prompt that includes success criteria and test requirements upfront
- The prompt → diff → review → accept cycle and when each step matters
- When to let Claude choose an approach vs when to constrain it explicitly
- How to ask Claude to self-review its own diff before you accept it

## Why

Reading code tells you what already exists. Writing code tells you whether you can direct an AI to extend it correctly. This lab closes that loop: you give Claude a precise spec, it writes the SQL and the route, and you verify the result by running the test suite — not by eyeballing output.

Prompting well matters more than prompting fast. A vague prompt ("add a random route") produces code that may work but drift from the codebase's existing style, miss the 404 case, or skip tests entirely. A specific prompt front-loads your requirements so Claude writes the right thing the first time rather than you iterating around its first draft.

## Walkthrough

### The prompt → diff → review → accept cycle

When you ask Claude to write code inside an existing project, it goes through four observable stages:

1. **Prompt** — Claude reads your request and the relevant files, then plans the change.
2. **Diff** — Claude proposes edits. You see a diff, not executed code, so nothing has changed on disk yet.
3. **Review** — you (and optionally Claude itself) inspect the diff for correctness, style consistency, and missing cases.
4. **Accept** — you approve. Claude writes the files and the change takes effect.

The separation between diff and accept is deliberate: it means you can push back, ask for changes, or reject entirely without any cleanup work. Use that window.

### Vague vs specific prompts

Compare two prompts for the same task:

**Vague:**
> add random

Claude might add a route. It might skip the 404 case. It might inline SQL instead of using the `db.js` helper pattern. You'll spend the review step asking for fixes.

**Specific:**
> Add `GET /random` that returns a random row from the quips table: 200 with the quip object, or 404 with `{"error": "no quips"}` when the table is empty. Use `ORDER BY RANDOM() LIMIT 1` in SQLite. Follow the existing `getQuip` / `listQuips` pattern in `src/db.js` — extract a `randomQuip()` helper there rather than inlining SQL in the route. Then add a Vitest test in `test/server.test.js` covering both the 200 case and the 404 case. Use `resetDb()` between cases.

The second prompt is longer, but it costs you 30 seconds and saves multiple back-and-forth rounds. It specifies the status codes, the error payload shape, the SQL idiom, the file where the helper should live, and the test requirement. Claude doesn't need to guess.

### When to constrain vs when to let Claude choose

You should constrain when:
- The codebase has an established pattern you want Claude to match (style, error handling, file organization).
- There are multiple technically-valid choices and you care which one is used (e.g., inline SQL vs extracted helper).
- Security or correctness is on the line (parameterized queries, null checks, status codes).

You can let Claude choose when:
- The detail is genuinely cosmetic (variable name within a private function).
- You are exploring and want to see what it proposes before deciding.
- The pattern doesn't exist yet and you want Claude's opinion on what to establish.

For this lab, constrain the key decisions (helper location, SQL idiom, test structure). Let Claude choose the internal variable names.

### Asking Claude to self-review

After Claude proposes a diff, you can ask it to review its own work before you accept:

> Before I accept, review your diff. Does the 404 path get triggered correctly when the table is empty? Is the SQL idiom you used the correct SQLite syntax for random row selection?

This is a lightweight way to catch obvious misses. Claude will sometimes catch its own errors when prompted to look. It is not a substitute for running the tests, but it often surfaces issues before you even hit `npm test`.

## Check

```bash
./scripts/doctor.sh 005
```

Expected output: `OK lab 005 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — given what you learned in Lab 004 about Quips' shape, which files will need to change to add `GET /random`? Write your answer before touching any code.

   Expected answer: `quips/src/server.js` (new route handler) and `quips/test/server.test.js` (new test cases). The database helper in `quips/src/db.js` may or may not change — that depends on Claude's style choice.

   Verify:
   ```bash
   grep -c "app\." quips/src/server.js
   ```
   Expected: the number of existing route registrations (5). Nothing changes yet — this is your baseline.

2. **Run** — open Claude Code inside the Quips project and ask it to add the route.

   ```bash
   cd quips && claude
   ```

   In the REPL, ask:

   > Add a new route `GET /random` that returns a random row from the quips table, with status 200 and the quip object, or 404 with `{"error": "no quips"}` if the table is empty. Follow the existing style in `src/server.js`.

   Verify: Claude proposes a diff touching at least `src/server.js`.

   ```bash
   grep -qi "random" quips/src/server.js && echo "route present" || echo "route missing"
   ```
   Expected: `route present`

3. **Investigate** — before accepting, ask Claude to explain its SQL choice.

   > What's the SQLite syntax you're using to pick a random row?

   Verify: the answer includes `ORDER BY RANDOM() LIMIT 1` or an equivalent explanation of how SQLite random sampling works. That is a real SQLite idiom — confirm it matches.

   ```bash
   grep -i "RANDOM\|random" quips/src/server.js quips/src/db.js 2>/dev/null | head -5
   ```
   Expected: at least one line showing the random-selection SQL.

4. **Modify** — still in the REPL, ask Claude to add the test coverage.

   > Add a Vitest test for `GET /random` covering both the 200 case (a row exists) and the 404 case (empty table). Use `resetDb()` between cases.

   Verify: Claude edits `test/server.test.js` and adds a `describe('GET /random', ...)` block.

   ```bash
   grep -c "random" quips/test/server.test.js
   ```
   Expected: at least 1 (the describe/test lines referencing `/random`).

5. **Make** — run the full test suite.

   ```bash
   cd quips && npm test
   ```

   Verify: ALL tests pass, including the new ones for `/random`.

   ```bash
   ./scripts/verify.sh 005
   ```
   Expected: exits 0 with no error output.

## Observe

Did Claude write the SQL inside the route handler in `src/server.js`, or did it extract a helper into `src/db.js`? Compare the shape of the existing `getQuip` and `listQuips` functions in `db.js` against what Claude produced. Which approach is more consistent with the existing code, and why does that consistency matter when a team of engineers maintains the same file? Write one paragraph in your own words. No answer key — this is metacognition practice.

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| Claude's change breaks existing tests | Tests assumed a specific row-insertion order; the new route disturbs that | Add `resetDb()` in a `beforeEach` block OR seed deterministic data per test | https://docs.claude.com/en/docs/claude-code/overview |
| Route added but 404 not returned on empty table | Missing null-check before sending the response | Ask Claude: "add `if (!row) return reply.code(404).send({error: 'no quips'})` before the return" | https://github.com/anthropics/claude-code |
| `ORDER BY RANDOM()` works but feels slow | Fine for this lab's scale; flag as a future concern | For production use an offset-based approach — mention it to Claude as a stretch; covered in Lab 020 (performance) | https://github.com/anthropics/anthropic-cookbook |

## Tasks

Click the checkbox next to each task to mark it done — your progress is saved locally.

### Task 1 — Draft a prompt with test requirements upfront

**Scenario:** You want Claude to add `GET /random` and you want the test cases included in the same request rather than as a follow-up. Write the full prompt you would send.

**Hint:** Include the route signature, both status codes, the error payload shape, the SQL idiom, and the test file name in a single message.

??? success "Solution"

    ```
    Add GET /random to src/server.js. It should:
    - Query a random row with ORDER BY RANDOM() LIMIT 1 using a helper in src/db.js (name it randomQuip).
    - Return 200 with the quip object when a row exists.
    - Return 404 with {"error": "no quips"} when the table is empty.
    - Follow the same handler style as GET /quips.

    Also add a Vitest describe block in test/server.test.js:
    - One test for the 200 case (seed one row first).
    - One test for the 404 case (call resetDb() first).
    ```

### Task 2 — Ask Claude to self-review its diff

**Scenario:** Claude has proposed a diff for `GET /random` but you want it to check the 404 path before you accept.

**Hint:** Ask Claude a pointed question about the condition it uses to detect an empty result.

??? success "Solution"

    Ask in the REPL before accepting:

    ```
    Before I accept: review your diff. Does the 404 path fire correctly
    when the DB is empty? Show me the null-check line and confirm it's
    reached when RANDOM() returns no rows.
    ```

    Claude will locate the null-check in the diff and confirm or correct it. Only accept after it confirms.

### Task 3 — Iterate on an initial implementation

**Scenario:** You accepted Claude's first draft but the SQL is inlined in the route handler instead of extracted to `db.js`. Refine without rewriting from scratch.

**Hint:** Ask Claude a targeted follow-up that references the existing `getQuip` pattern.

??? success "Solution"

    ```
    The SQL is inlined in the handler. Extract it to a randomQuip() helper
    in src/db.js, following the same shape as getQuip(). Update the handler
    to call db.randomQuip() instead.
    ```

    Review the diff to confirm `server.js` no longer contains SQL and `db.js` has the new helper.

### Task 4 — Add a query parameter to the route

**Scenario:** A teammate wants `GET /random?n=3` to return up to 3 random quips. Ask Claude to extend the route.

**Hint:** Reference the existing `?tag` query-param pattern in `GET /quips` so Claude matches the project's style.

??? success "Solution"

    ```
    Extend GET /random to accept an optional ?n query parameter (default 1,
    max 10). Return an array of n random rows. If n is outside 1–10 return
    400 with {"error": "n must be between 1 and 10"}.
    Follow the same query-param validation style used in GET /quips for ?tag.
    ```

    Verify:
    ```bash
    grep -i "query\|n=" quips/src/server.js | head -5
    ```

### Task 5 — Handle the error path explicitly

**Scenario:** The DB call in `randomQuip()` could throw if SQLite itself errors (disk full, corrupt file). Ask Claude to wrap it.

**Hint:** Look at how existing handlers treat DB errors before asking Claude to add the same pattern.

??? success "Solution"

    First, inspect the existing error handling:
    ```bash
    grep -A5 "catch\|try" quips/src/server.js | head -20
    ```

    Then ask Claude:
    ```
    Add a try/catch around the db.randomQuip() call in the handler.
    On error, log the error and return 500 with {"error": "internal server error"}.
    Follow the same pattern used by the existing error handlers in server.js.
    ```

### Task 6 — Re-run tests after accepting all changes

**Scenario:** You have accepted multiple rounds of edits. Run the full suite to confirm nothing regressed.

**Hint:** Run `npm test` from the `quips/` directory, then use `verify.sh` for the structured check.

??? success "Solution"

    ```bash
    cd quips && npm test
    ```

    Expected: all tests pass with no failures. Then:

    ```bash
    cd .. && ./scripts/verify.sh 005
    ```

    Expected: exits 0. If any test fails, ask Claude: "One test is failing — show me the failing test output and fix the root cause."

## Quiz

<div class="ccg-quiz" data-lab="005">
  <div class="ccg-q" data-answer="c">
    <p><strong>Q1.</strong> What is the most important thing to include in an implementation prompt so Claude writes the right code the first time?</p>
    <label><input type="radio" name="005-q1" value="a"> A. A description of the project's history and goals</label>
    <label><input type="radio" name="005-q1" value="b"> B. The names of the engineers who wrote the existing code</label>
    <label><input type="radio" name="005-q1" value="c"> C. Success criteria: expected status codes, error payloads, SQL idiom, and test requirements</label>
    <label><input type="radio" name="005-q1" value="d"> D. A request to keep the implementation short</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">A good implementation prompt specifies what "done" looks like: which status codes the route returns, what the error payload shape is, which SQL idiom to use, and whether tests should be included. Without these details Claude has to guess, and guesses require correction rounds.</p>
  </div>
  <div class="ccg-q" data-answer="b">
    <p><strong>Q2.</strong> Claude proposes a diff for <code>GET /random</code> but you notice the 404 case is missing. What should you do before accepting?</p>
    <label><input type="radio" name="005-q2" value="a"> A. Accept the diff and fix the 404 case by hand afterward</label>
    <label><input type="radio" name="005-q2" value="b"> B. Ask Claude to review its own diff and add the missing null-check before accepting</label>
    <label><input type="radio" name="005-q2" value="c"> C. Reject the diff and start over with a new Claude session</label>
    <label><input type="radio" name="005-q2" value="d"> D. Accept and write a separate test that skips the 404 case</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">The review step exists so you can push back before anything changes on disk. Ask Claude to address the gap while still in the diff stage — it's far cheaper than accepting broken code and then debugging after the fact.</p>
  </div>
  <div class="ccg-q" data-answer="a">
    <p><strong>Q3.</strong> When should you include test requirements in the same prompt as the implementation request?</p>
    <label><input type="radio" name="005-q3" value="a"> A. Always — front-loading test requirements ensures tests are written for the code Claude just produced, not added as an afterthought</label>
    <label><input type="radio" name="005-q3" value="b"> B. Only when the feature is complex</label>
    <label><input type="radio" name="005-q3" value="c"> C. Only after the implementation is accepted and working</label>
    <label><input type="radio" name="005-q3" value="d"> D. Only when you are sure the implementation will be correct</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Asking for tests in the same prompt means Claude writes them to match the implementation it just produced. Adding tests as a follow-up increases the chance that the tests cover the happy path only, or that they test assumptions rather than the actual behavior.</p>
  </div>
  <div class="ccg-q" data-answer="d">
    <p><strong>Q4.</strong> Where should the <code>randomQuip()</code> database helper live in the Quips project?</p>
    <label><input type="radio" name="005-q4" value="a"> A. Inline inside the route handler in <code>src/server.js</code></label>
    <label><input type="radio" name="005-q4" value="b"> B. In a new file <code>src/random.js</code></label>
    <label><input type="radio" name="005-q4" value="c"> C. In the test file alongside the test cases</label>
    <label><input type="radio" name="005-q4" value="d"> D. In <code>src/db.js</code>, following the same pattern as <code>getQuip</code> and <code>listQuips</code></label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">The Quips project keeps all SQL in <code>src/db.js</code>. Adding <code>randomQuip()</code> there keeps the separation of concerns intact and matches the pattern a future engineer would expect to find when searching for database access code.</p>
  </div>
</div>

## Stretch (optional, ~10 min)

Ask Claude to add a route that returns N random quips:

> Add `GET /random?n=3` where `n` defaults to 1, max is 10, and `n` outside that range returns 400 with `{"error": "n must be between 1 and 10"}`.

No grading — compare how Claude handles the query-param validation against the existing `?tag` pattern in `GET /quips`.

## Recall

What's the schema of the `quips` table?

> Expected from Lab 004: columns `id` (INTEGER PRIMARY KEY), `text` (TEXT NOT NULL), and `tags` (TEXT NOT NULL DEFAULT '[]') — `tags` is stored as a JSON string and parsed back to an array by `rowToQuip` in `src/db.js`.

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/overview
- https://docs.claude.com/en/docs/claude-code/common-workflows
- https://github.com/anthropics/claude-code

## Next

→ **Lab 006 — Prompting (Part II)** — learn to write precise prompts that constrain Claude's output style, tone, and scope.
