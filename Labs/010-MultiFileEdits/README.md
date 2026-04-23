# Lab 010 — Multi-File Edits

⏱ **25 min**   📦 **You'll add**: `author` field in `quips/src/db.js`, `quips/src/server.js`, `quips/test/server.test.js`   🔗 **Builds on**: Lab 009   🎯 **Success**: `npm test` green in quips/ AND 'author' appears in all three files (db.js, server.js, test/server.test.js)

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
    - You will add an optional `author` field end-to-end across the schema, server, and test layers.
    - You will observe what happens when a prompt omits a layer — and learn how to prevent it.
    - You will deliberately introduce a mismatch (schema only) and watch the test suite catch it.
    - By the end you will have a reliable prompt pattern: enumerate every layer up front so Claude coordinates them all in one pass.

**Concept**: `Coordinate edits across schema, routes, and tests in one session` (Bloom: Apply)

---

## Prerequisites

- Lab 009 completed: `quips/.claude/settings.local.json` exists and `npm test` passes in `quips/`
- Claude Code on PATH (`claude --version` exits 0)
- The quips project present (`ls quips/src/db.js` succeeds)

## What You Will Learn

- Why a feature that spans schema, server logic, and tests must be treated as one atomic unit
- How to phrase a prompt so Claude touches every layer in the right order
- What the failure signature looks like when any one layer is skipped
- How to use Claude's self-review to catch mistakes before you accept edits

## Why

Real features rarely live in one file. Adding a field end-to-end — schema, business logic, routes, and tests — means touching several files that must stay consistent with each other. If any layer is missing, tests catch the gap immediately.

The instinct after solo coding is to update one file at a time and run tests between each change. With Claude in the loop, you can describe the full goal once and let it plan the edit order. The trick is giving it a complete picture: if your prompt mentions only the database layer, Claude has no reason to update the tests, and the suite breaks in a way that feels mysterious until you realize the prompt was incomplete.

This lab practices that coordination discipline. You will see three failure modes — omitted layer, deliberate mismatch, and constrained file list — before arriving at the prompt pattern that avoids all three.

## Walkthrough

### Schema, server, and test cohesion

The quips project has three layers that share a contract: `db.js` defines the database schema and query helpers, `server.js` exposes HTTP routes that call those helpers, and `server.test.js` asserts the HTTP behavior. These layers form a dependency chain:

```
db.js  →  server.js  →  server.test.js
```

When you add a column to the schema, the server helpers must also return it, and the tests must assert its presence — otherwise the test suite reports a gap that looks like a server bug but is actually a schema omission, or vice versa.

### Why partial edits break the suite

Suppose you ask Claude to "add `author` to the quips table." Claude edits `db.js` and stops. Now:

- `GET /quips` returns rows without an `author` key (server.js was never updated)
- `server.test.js` has no assertion for `author` (tests were never updated)
- `npm test` passes — but the feature is invisible to callers and untested

The suite went green for the wrong reason. The test never exercised the new field, so the coverage gap is silent.

### How Claude decides edit order

Claude reads the files it has been shown (or the files it discovers by searching the project) and infers the dependency graph. When the prompt names all three layers, Claude sequences its edits from the innermost layer outward: schema first, then the server helper that queries the schema, then the route handler that calls the helper, then the tests that exercise the route. This order matters because each layer depends on the one before it compiling or running correctly.

### The reference pattern: list every layer up front

The most reliable prompt pattern is to enumerate layers explicitly before describing the change:

```
Files to change: src/db.js, src/server.js, test/server.test.js
Change: add an optional `author` TEXT field (nullable, default null).
  - db.js: extend the CREATE TABLE statement and createQuip() signature
  - server.js: accept author in POST body; include author in GET response
  - test/server.test.js: add three cases — with author, without author, retrieve shows null or value
Run npm test after.
```

That enumeration serves two purposes: Claude does not have to guess which files matter, and you can immediately see whether its plan matches your expectation before any write happens.

## Check

```bash
./scripts/doctor.sh 010
```

Expected output: `OK lab 010 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before opening any file, write down the three files that must change to add an `author` field end-to-end: schema, server, and tests. Add one sentence explaining why skipping any one of them would leave the feature incomplete.

   Verify all three source files exist before continuing:
   ```bash
   [[ -f quips/src/db.js && -f quips/src/server.js && -f quips/test/server.test.js ]] && echo "all present" || echo "missing files"
   ```
   Expected: `all present`

2. **Run** — from the repo root, launch Claude Code inside the quips project and issue one coordinated prompt that names all three layers up front.

   ```bash
   cd quips && claude
   ```

   Inside the REPL type this prompt (copy it exactly, including the file list at the top):

   > Files to change: src/db.js, src/server.js, test/server.test.js. Add an optional `author` TEXT column (nullable, default null) to the quips table. Update `createQuip()` to accept an `author` field defaulting to null. Update POST /quips to accept it in the body. Update GET responses to include it. Add tests covering three cases: create with author, create without author, and retrieve shows null or value correctly. Run `npm test` after. Coordinate all edits.

   Verify that Claude's output references all three files before you accept any writes:

   ```bash
   echo "confirm Claude's plan or output mentions db.js, server.js, and server.test.js"
   ```

3. **Investigate** — read the changes Claude made to `quips/src/db.js`. Look at how the schema is updated: does it use `ALTER TABLE` (adds a column to an existing table) or does it rewrite the `CREATE TABLE` statement to include `author`?

   In-memory SQLite (used when `QUIPS_DB_PATH` is not set) is re-created fresh for every test run via `resetDb()`, so either approach works. Note which one Claude chose and why it is valid here.

   Verify you can identify the approach:
   ```bash
   grep -n 'author\|ALTER' quips/src/db.js
   ```
   Expected: at least one line mentioning `author`.

4. **Modify** — accept all edits if you have not already. Run the tests manually:

   ```bash
   (cd quips && npm test --silent; echo $?)
   ```
   Expected: final line is `0` (all tests pass).

5. **Make** — commit the change locally:

   ```bash
   git add quips && git commit -m "feat: add author field"
   ```

   Verify:
   ```bash
   git log -1 --oneline
   ```
   Expected: output contains `feat: add author field`.

## Observe

One sentence — where was Claude's change most likely to break other tests, and how did it handle that?

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| `ALTER TABLE` fails or errors in tests | DB is in-memory and re-created per test; `ALTER TABLE` on a fresh schema has nothing to alter | Restart the tests — `resetDb()` drops and re-creates the DB, so the `CREATE TABLE` path runs fresh each time; or change to a `CREATE TABLE` statement that includes the `author` column from the start | https://docs.claude.com/en/docs/claude-code/overview |
| Tests fail because existing rows lack `author` | Column was added without a default | Make the column nullable (`author TEXT`) or add `DEFAULT NULL` — existing rows then return `null` automatically | https://github.com/anthropics/anthropic-cookbook |
| Edit blocked by permissions | Lab 009's `settings.local.json` may restrict writes | Switch to `--permission-mode acceptEdits` or verify `quips/.claude/settings.local.json` permits file edits in both `src/` and `test/` | https://docs.claude.com/en/docs/claude-code/settings |

## Tasks

Click the checkbox next to each task to mark it done — your progress is saved locally.

### Task 1 — Add the author field with all layers named

**Scenario:** You want Claude to add `author` end-to-end in one prompt with no follow-up repairs.

**Hint:** Use the reference pattern from the Walkthrough: list `src/db.js`, `src/server.js`, and `test/server.test.js` at the top of your prompt before describing the change.

??? success "Solution"

    ```
    Files to change: src/db.js, src/server.js, test/server.test.js.
    Add an optional author TEXT column (nullable, default null) to the quips table.
    Update createQuip() to accept author (default null).
    Update POST /quips to accept author in the request body.
    Update GET /quips and GET /quips/:id to include author in responses.
    Add tests: create with author, create without author, retrieve shows null or value.
    Run npm test after coordinating all edits.
    ```

    After Claude finishes: `(cd quips && npm test --silent; echo $?)`
    Expected: `0`

### Task 2 — Observe what happens when tests are omitted from the prompt

**Scenario:** You want to see the gap that appears when a prompt describes the schema and server changes but says nothing about tests.

**Hint:** Roll back the previous commit first (`git revert HEAD --no-edit`), then issue a shorter prompt that mentions only `src/db.js` and `src/server.js`. Accept the edits and run `npm test`.

??? success "Solution"

    ```bash
    git revert HEAD --no-edit   # undo the author commit
    cd quips && claude
    ```

    Prompt inside the REPL:

    > Add an optional author TEXT column to the quips table in src/db.js. Update createQuip() and the POST /quips route in src/server.js to accept it. Run npm test after.

    When Claude finishes, check whether `test/server.test.js` was touched:
    ```bash
    grep -c 'author' quips/test/server.test.js || echo "0 — test file not updated"
    ```

    The test suite either passes silently (no assertion for `author` means no failure — but the field is untested) or fails if the server response shape changed enough to break an existing assertion. Either outcome shows the gap: the feature exists in the code but is invisible to the test suite.

### Task 3 — Introduce a mismatch on purpose and watch tests fail

**Scenario:** You add `author` to `db.js` only, leaving `server.js` and the tests untouched — then run the suite to observe the failure message.

**Hint:** Edit `db.js` by hand (or with a targeted Claude prompt), then run `npm test` without touching the other files.

??? success "Solution"

    ```bash
    # In quips/src/db.js, add author TEXT to the CREATE TABLE statement only.
    # Leave server.js and server.test.js exactly as they are.
    (cd quips && npm test 2>&1 | head -30)
    ```

    Three cases appear: the schema update alone, the schema-plus-server update alone, and the full three-layer update. The failure message points at the layer that was skipped: either the route returns no `author` key (server not updated) or the test never asserts it (test not updated). Reading that message tells you exactly which file was left out.

### Task 4 — Constrain Claude to two files and observe the pushback

**Scenario:** You deliberately tell Claude it may only touch `src/db.js` and `src/server.js`, and you want to see whether it warns you that tests will be out of sync.

**Hint:** Add an explicit constraint to the prompt: "Do not modify any file in test/."

??? success "Solution"

    Inside the Claude REPL:

    > Add an optional author TEXT column end-to-end. Only modify src/db.js and src/server.js. Do not modify any file in test/.

    Claude will typically note that the test file will need updating and may ask whether to proceed with the two-file constraint or relax it. That warning is the signal: Claude has read the dependency graph and is surfacing the gap before writing anything. You can then decide whether to lift the constraint or accept the incomplete change knowingly.

    Verify the test file was not changed:
    ```bash
    git diff quips/test/server.test.js
    ```
    Expected: empty (no diff).

### Task 5 — Ask Claude to self-review the diff before you accept

**Scenario:** Before accepting any writes, you want Claude to explain what it changed and flag any potential problems.

**Hint:** After Claude proposes its edits, type a follow-up: "Before I accept, summarize every file you touched and flag any risk."

??? success "Solution"

    After Claude proposes the three-file edit, type into the REPL:

    > Before I accept these edits, summarize every file you changed, what you changed, and any risk I should check.

    Claude will list the three files, describe each change (column type, default, helper signature, route handler, test cases), and may flag things like "existing rows will have null for author — confirm that is acceptable." Review the summary, then accept if it matches the Walkthrough's reference pattern.

### Task 6 — Rollback and apply again with the reference prompt

**Scenario:** You want to practice the clean rollback-and-redo cycle: undo a partial edit and apply the full coordinated prompt to arrive at a green suite cleanly.

**Hint:** `git revert HEAD --no-edit` undoes the last commit without deleting history. After reverting, apply the full reference prompt from Task 1.

??? success "Solution"

    ```bash
    git revert HEAD --no-edit
    git log --oneline -3   # confirm the revert commit appears
    ```

    Then, inside the REPL, use the full reference prompt:

    > Files to change: src/db.js, src/server.js, test/server.test.js. Add optional author TEXT (nullable, default null). Update createQuip(), POST /quips body, GET responses, and tests (three cases: with author, without author, retrieve shows null or value). Run npm test after.

    After accepting:
    ```bash
    (cd quips && npm test --silent; echo $?)
    ```
    Expected: `0`

    Compare the diff from this run with the partial edits from Tasks 2 and 3. The reference prompt produces a clean, complete diff; the partial prompts produce a diff that requires follow-up.

## Quiz

<div class="ccg-quiz" data-lab="010">
  <div class="ccg-q" data-answer="b">
    <p><strong>Q1.</strong> When does Claude choose <code>ALTER TABLE</code> to add a column rather than rewriting the <code>CREATE TABLE</code> statement?</p>
    <label><input type="radio" name="010-q1" value="a"> A. Always — ALTER TABLE is the only safe option for adding columns</label>
    <label><input type="radio" name="010-q1" value="b"> B. When the database is persistent and the table already exists at migration time</label>
    <label><input type="radio" name="010-q1" value="c"> C. When the test suite uses an in-memory SQLite database re-created each run</label>
    <label><input type="radio" name="010-q1" value="d"> D. Only when the prompt explicitly says "use ALTER TABLE"</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain"><code>ALTER TABLE</code> is appropriate when the database file persists across runs and already has the table — adding a column in-place avoids data loss. For an in-memory SQLite DB that is dropped and re-created on every test run, rewriting the <code>CREATE TABLE</code> statement is equally valid because the schema is always built from scratch. Claude picks based on whether it detects a persistent DB path or an in-memory setup.</p>
  </div>
  <div class="ccg-q" data-answer="c">
    <p><strong>Q2.</strong> Your prompt asks Claude to add a field to <code>db.js</code> and <code>server.js</code> but says nothing about tests. After accepting the edits, <code>npm test</code> passes. What does that result tell you?</p>
    <label><input type="radio" name="010-q2" value="a"> A. The change is complete — a passing suite means nothing was broken</label>
    <label><input type="radio" name="010-q2" value="b"> B. Claude must have updated the tests automatically even though you did not ask</label>
    <label><input type="radio" name="010-q2" value="c"> C. The test suite passed without exercising the new field — coverage is missing, not coverage is complete</label>
    <label><input type="radio" name="010-q2" value="d"> D. The field was not actually added because there were no test failures</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">A green suite only proves that existing assertions were not broken. If no test asserts the new field, the field can be present, absent, or malformed — the suite cannot distinguish. Passing tests after a partial prompt means the test layer was never updated, so the new behavior is unverified. This is the silent coverage gap that the reference prompt prevents.</p>
  </div>
  <div class="ccg-q" data-answer="a">
    <p><strong>Q3.</strong> You add <code>author</code> to the <code>CREATE TABLE</code> statement in <code>db.js</code> but do not update <code>server.js</code>. Which layer breaks first when you run <code>npm test</code>?</p>
    <label><input type="radio" name="010-q3" value="a"> A. The server layer — routes that query the DB return rows without <code>author</code>, causing assertion failures in tests that check response shape</label>
    <label><input type="radio" name="010-q3" value="b"> B. The schema layer — SQLite rejects the new column because it conflicts with existing rows</label>
    <label><input type="radio" name="010-q3" value="c"> C. The test layer — tests fail because they try to set <code>author</code> on an object that does not have it</label>
    <label><input type="radio" name="010-q3" value="d"> D. Nothing breaks — the schema change is backward-compatible so the suite stays green</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">When <code>db.js</code> adds <code>author</code> to the schema but <code>server.js</code> does not yet include it in query results or the POST handler, any test that inspects the response body will either find the field missing (if the test was written to expect it) or the test will not know to check. The failure message will point at the route layer — the field exists in the DB but is invisible at the HTTP boundary.</p>
  </div>
  <div class="ccg-q" data-answer="d">
    <p><strong>Q4.</strong> Why does listing every file layer at the top of a prompt help Claude produce a correct multi-file edit?</p>
    <label><input type="radio" name="010-q4" value="a"> A. It tells Claude which files it is allowed to read, reducing token usage</label>
    <label><input type="radio" name="010-q4" value="b"> B. It prevents Claude from creating new files that were not requested</label>
    <label><input type="radio" name="010-q4" value="c"> C. It forces Claude to edit files in alphabetical order, which avoids merge conflicts</label>
    <label><input type="radio" name="010-q4" value="d"> D. It removes ambiguity about scope so Claude plans all edits before writing any single file, keeping every layer consistent</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">When the prompt names all target files upfront, Claude can read the dependency graph across all of them before it writes a single byte. That full context lets it sequence the edits correctly and ensures no layer is omitted. Without the enumeration, Claude stops when it believes the explicitly mentioned work is done — and any unmentioned layer stays out of scope.</p>
  </div>
</div>

## Stretch (optional, ~10 min)

Add a Vitest test that asserts `author` is never an empty string — it must be either `null` or a non-empty string. Try `POST /quips` with `{ text: "hi", author: "" }` and decide whether the server should reject it (return 4xx) or coerce it to `null`. Write the test first, confirm it fails, then give Claude the failing test and the constraint "only modify src/server.js."

## Recall

What file did you create in Lab 009 to control Claude's permissions?

> Expected: `quips/.claude/settings.local.json`

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/overview
- https://docs.claude.com/en/docs/claude-code/settings

## Next

→ **Checkpoint A** — end of Part I retrospective + integration task: review everything from Labs 001–010 and apply the patterns to a small feature of your own choosing.
