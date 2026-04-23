# Lab 020 — Refactor Safely

⏱ **30 min**   📦 **You'll add**: `quips/src/db/connection.js` and `quips/src/db/quips.js`   🔗 **Builds on**: Lab 019   🎯 **Success**: both new files exist and `npm test` exits 0

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
    - You will learn the core insight: a test suite acts as a behavioral invariant — if tests stay green after every move, behavior is preserved by definition.
    - You will split `quips/src/db.js` into two focused modules, running `npm test` after each move.
    - You will practice three smaller refactor moves: inline a single-use helper, extract a repeated pattern, and rename a confusing variable across files.
    - You will use git to undo a refactor and watch tests catch the regression immediately.
    - You will ask Claude to refactor code while explicitly denying it permission to touch test files.

**Concept**: `Refactor under a green test suite` (Bloom: Apply)

---

## Prerequisites

- Lab 019 completed: `quips/src/db.js` and `quips/test/server.test.js` both exist
- `npm test` passes in `quips/` before this lab begins
- Git on PATH (branch creation is part of the workflow)
- A running `claude` CLI (established in Lab 001)

## What You Will Learn

- Why a green test suite is the difference between refactoring and rewriting
- The refactor-with-tests workflow: one move at a time, green after each
- What to refactor (shape, duplication, names) vs what to never touch (test files, public contracts)
- How to use `git revert` as a safety net when a refactor goes wrong
- How to constrain Claude with explicit permission denials during agentic refactoring

## Why

Refactoring without tests is rewriting. You change code and hope the behavior survived. With a green test suite, refactoring is disciplined: run the tests after every move and they tell you immediately whether behavior is preserved. The tests act as an invariant — a promise about what the code does that must hold before and after every change.

This distinction matters because "refactor" is one of the most misused words in software development. It does not mean "rewrite it better." It means "change the structure while leaving the observable behavior identical." Green tests are the only objective proof that behavior is unchanged.

This lab closes Part IV by combining TDD discipline (Lab 016), rescue skills (Lab 017), code review (Lab 018), and verify scripts (Lab 019) into one workflow: split an existing module into two focused modules and apply three smaller moves, keeping tests green at every step.

**Refactor vs rewrite — one-line summary**

| | Tests first? | Behavior guaranteed? |
|---|---|---|
| **Refactor** | Yes — green before and after every move | Yes, by definition |
| **Rewrite** | No — tests come after (or not at all) | Hoped for, not proven |

**What to refactor vs what to never touch**

| Refactor freely | Never touch during a refactor |
|---|---|
| File layout and module boundaries | Test files |
| Function names (with a find-and-replace across callers) | Public API contracts (exported names callers depend on) |
| Repeated patterns extracted into helpers | Behavior (what the code actually does) |
| Confusing variable names | Database schema or migration files |

## Walkthrough

Every refactor move in this lab follows the same three-beat rhythm:

1. **Green baseline** — confirm `npm test` passes before touching anything.
2. **One move** — make exactly one structural change (split a file, inline a helper, rename a variable).
3. **Green check** — run `npm test` again. If it fails, revert the move immediately. Never stack a second move on top of a broken state.

The `quips/src/db.js` module currently does two unrelated things: it manages the SQLite connection (opening the database, providing `resetDb`) and it runs SQL queries (`createQuip`, `getQuip`, `listQuips`). Single-responsibility principle says these belong in separate files. The split is pure structural change — no logic moves, no names change, no SQL changes. The test suite will confirm that nothing broke.

After the split, you will practice three smaller moves that come up constantly in real codebases:

- **Inline** a helper that is only called once — the indirection costs more than it saves.
- **Extract** a repeated pattern into a shared helper — duplication is a maintenance hazard.
- **Rename** a confusing variable across every file that uses it — names are documentation.

Finally, you will undo one of these moves with `git revert` and observe that tests catch the regression before any human review would. That is the safety net in action.

## Check

```bash
./scripts/doctor.sh 020
```

Expected output: `OK lab 020 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before touching any file, write down which four public functions from `quips/src/db.js` the test suite calls. Predict which belong to "connection" concerns and which belong to "query" concerns.

   Verify by searching the test file:

   ```bash
   grep -nE 'createQuip|getQuip|listQuips|resetDb' quips/test/server.test.js
   ```

   Expected: at least one matching line for each of the four function names.

2. **Run** — establish a green baseline and create an isolation branch:

   ```bash
   cd quips && npm test
   ```

   Expected: all tests pass, exit code 0. Then create a branch:

   ```bash
   git checkout -b refactor/db-split
   ```

   Expected: output contains `Switched to a new branch 'refactor/db-split'`.

3. **Investigate** — open `quips/src/db.js` and identify which lines open the database handle (`better-sqlite3` call and `resetDb`) versus which lines run SQL queries (`createQuip`, `getQuip`, `listQuips`).

   Verify the current line count:

   ```bash
   wc -l quips/src/db.js
   ```

   Expected: a number greater than 0. Note it — the two new files should account for roughly the same total.

4. **Modify** — open Claude Code inside the quips project and issue a constrained prompt:

   ```bash
   cd quips && claude
   ```

   Then type:

   > Split `src/db.js` into two files: `src/db/connection.js` (opens the SQLite handle and exports `resetDb`) and `src/db/quips.js` (exports `createQuip`, `getQuip`, `listQuips`). Preserve all public exports so callers do not break. Run `npm test` after each file move. Do not modify any file under `test/`.

   After Claude finishes, verify tests still pass:

   ```bash
   npm test --silent && echo OK
   ```

   Expected: last line printed is `OK`.

5. **Make** — confirm both new files exist:

   ```bash
   [[ -f quips/src/db/connection.js && -f quips/src/db/quips.js ]] && echo "files present" || echo "files missing"
   ```

   Expected: `files present`. Then commit:

   ```bash
   git add quips && git commit -m "refactor: split db.js into db/connection and db/quips"
   ```

   Verify the commit landed:

   ```bash
   git log -1 --oneline
   ```

   Expected: output contains `refactor: split db.js`.

## Observe

If Claude had modified a test file to make tests pass after the split, how would you have detected it? Write one sentence. Consider what `git diff quips/test/` would have shown you.

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| Tests break after split | A function moved but its import path did not update everywhere | `grep -rn "require.*db" quips/src` — update every call site still pointing to the old path | https://docs.claude.com/en/docs/claude-code/common-workflows |
| Claude rewrites tests to make them pass | Permission mode allows test edits and Claude took the easy path | Add an explicit deny rule in `.claude/settings.local.json` under `"denyTools"` or re-run with "do not modify any file under test/" in the prompt | https://docs.claude.com/en/docs/claude-code/settings |
| The refactor grows beyond two files | Scope crept during the session | Revert with `git checkout quips/src/` and restart with a prompt that names exactly the two target files | https://docs.claude.com/en/docs/claude-code/overview |
| `resetDb` not found after split | It stayed in the old `db.js` instead of moving to `connection.js` | Check `grep -rn "resetDb" quips/src/` — move it manually and re-run `npm test` | https://docs.claude.com/en/docs/claude-code/common-workflows |

## Tasks

Click the checkbox next to each task to mark it done — your progress is saved locally.

### Task 1 — Split db.js, keep tests green throughout

**Scenario:** `quips/src/db.js` does two unrelated things. Your job is to split it into `src/db/connection.js` and `src/db/quips.js` without ever letting `npm test` go red.

**Hint:** Run `npm test` after moving each function, not just at the end. That way you know exactly which move broke things if something fails.

??? success "Solution"

    ```bash
    mkdir -p quips/src/db

    # Move connection logic first, re-run tests
    # quips/src/db/connection.js — contains: open db, resetDb, module.exports
    npm test --silent && echo "connection.js: green"

    # Move query logic second, re-run tests
    # quips/src/db/quips.js — contains: createQuip, getQuip, listQuips, module.exports
    npm test --silent && echo "quips.js: green"

    # Update any caller that imports from the old path
    grep -rn "require.*db'" quips/src/server.js
    # Update the require path, then:
    npm test --silent && echo "callers updated: green"
    ```

### Task 2 — Inline a single-use helper

**Scenario:** After the split, you notice `quips/src/db/quips.js` has a small private helper function that is called in exactly one place. Inline it — the indirection costs more than it saves.

**Hint:** A helper called in only one place adds a layer of naming indirection without adding reusability. Paste its body directly into the call site, then delete the helper definition.

??? success "Solution"

    ```bash
    # Identify single-use helpers
    grep -n "function " quips/src/db/quips.js

    # For a helper like `function buildRow(quip) { ... }` used once:
    # 1. Copy the body of buildRow
    # 2. Paste it inline at the one call site
    # 3. Delete the buildRow definition
    # 4. Verify:
    npm test --silent && echo "inline: green"
    git add quips/src/db/quips.js
    git commit -m "refactor: inline single-use buildRow helper"
    ```

### Task 3 — Extract a repeated pattern into a helper

**Scenario:** You notice the same two-line pattern (validate input, throw if missing) appears in both `createQuip` and `getQuip`. Extract it into a shared `assertPresent(value, name)` helper at the top of the file.

**Hint:** When the same pattern appears three or more times, extract it. Two times is a judgment call. One time is definitely not worth extracting.

??? success "Solution"

    ```bash
    # Add at the top of quips/src/db/quips.js:
    # function assertPresent(value, name) {
    #   if (!value) throw new Error(`${name} is required`);
    # }

    # Replace the repeated pattern in createQuip and getQuip with:
    # assertPresent(text, 'text');
    # assertPresent(id, 'id');

    npm test --silent && echo "extract: green"
    git add quips/src/db/quips.js
    git commit -m "refactor: extract assertPresent helper from createQuip and getQuip"
    ```

### Task 4 — Rename a confusing variable across files

**Scenario:** The variable `db` is used in both `connection.js` and `quips.js` but refers to different things in each — one is the connection handle, one is a query result set. Rename the query result to `rows` everywhere it appears.

**Hint:** Use `sed -i` or your editor's find-and-replace, then run `npm test` to confirm every reference updated correctly.

??? success "Solution"

    ```bash
    # In quips/src/db/quips.js, rename result variable 'db' → 'rows'
    # Use find-and-replace scoped to quips.js only (not connection.js)
    sed -i 's/const db = stmt\.all/const rows = stmt.all/g' quips/src/db/quips.js
    sed -i 's/return db;/return rows;/g' quips/src/db/quips.js

    npm test --silent && echo "rename: green"
    git add quips/src/db/quips.js
    git commit -m "refactor: rename ambiguous db variable to rows in quips.js"
    ```

### Task 5 — Undo one refactor using git, observe tests catch the regression

**Scenario:** The `assertPresent` helper you extracted in Task 3 is getting pushback in code review — the team prefers explicit inline validation for clarity. Revert that commit and observe that tests still pass (because the original code was correct too).

**Hint:** `git revert <hash>` creates a new commit that undoes a previous one. It does not delete history. Run `npm test` before and after to see the test suite confirm both states are valid.

??? success "Solution"

    ```bash
    # Find the commit hash for the assertPresent extraction
    git log --oneline | grep "assertPresent"
    # e.g. a1b2c3d refactor: extract assertPresent helper...

    # Revert it (creates a new "undo" commit)
    git revert a1b2c3d --no-edit

    # Tests must still be green — both states (extracted and inlined) are behaviorally identical
    npm test --silent && echo "revert: green"

    # If tests had gone red here, it would mean the original inline code had a bug
    # the refactor accidentally fixed — a signal to investigate, not to re-apply blindly
    ```

### Task 6 — Ask Claude to refactor, deny it permission to touch test files

**Scenario:** You want Claude to rename `createQuip` to `addQuip` across the source files, but you do not want it touching `quips/test/` — test files are the ground truth and must be changed only by humans.

**Hint:** Claude Code respects `"denyTools"` entries and explicit prompt-level restrictions. Use both: add a `settings.local.json` deny rule and reinforce it in the prompt.

??? success "Solution"

    ```bash
    # Create or update quips/.claude/settings.local.json:
    # {
    #   "permissions": {
    #     "deny": ["Write(quips/test/**)", "Edit(quips/test/**)"]
    #   }
    # }

    cd quips && claude
    ```

    Then type:

    > Rename `createQuip` to `addQuip` in all source files under `src/`. Update every call site in `src/`. Do not touch any file under `test/`. Run `npm test` after the rename.

    After Claude finishes:

    ```bash
    # Confirm test files were not touched
    git diff quips/test/
    # Expected: empty output (no changes)

    npm test --silent && echo "rename: green"
    ```

    If Claude bypassed the deny rule, the test file diff would have shown edits — and the settings.local.json restriction would have prevented the Write tool from succeeding.

## Quiz

<div class="ccg-quiz" data-lab="020">
  <div class="ccg-q" data-answer="b">
    <p><strong>Q1.</strong> Why must tests be green <em>before</em> you start a refactor, not just after?</p>
    <label><input type="radio" name="020-q1" value="a"> <strong>a.</strong> So you have a backup in case git revert fails</label>
    <label><input type="radio" name="020-q1" value="b"> <strong>b.</strong> So a newly failing test signals a problem your refactor introduced, not a pre-existing bug</label>
    <label><input type="radio" name="020-q1" value="c"> <strong>c.</strong> Because CI pipelines require a green state before branching</label>
    <label><input type="radio" name="020-q1" value="d"> <strong>d.</strong> To satisfy the linter before the first commit</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">If tests are red before you start, any new failure during the refactor is ambiguous — you cannot tell whether your move broke something or whether the test was already broken. A green baseline makes every red test a clear signal that points directly at your last move.</p>
  </div>
  <div class="ccg-q" data-answer="d">
    <p><strong>Q2.</strong> Which of these should you never modify during a refactor?</p>
    <label><input type="radio" name="020-q2" value="a"> <strong>a.</strong> Variable names inside private functions</label>
    <label><input type="radio" name="020-q2" value="b"> <strong>b.</strong> File layout and module boundaries</label>
    <label><input type="radio" name="020-q2" value="c"> <strong>c.</strong> Repeated patterns that can be extracted into a helper</label>
    <label><input type="radio" name="020-q2" value="d"> <strong>d.</strong> Test files and the public API contracts that callers depend on</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Test files are the behavioral ground truth — modifying them to make tests pass is not a refactor, it is changing what you promised to deliver. Public API contracts (exported names) are equally off-limits: changing them silently breaks callers in ways tests may not cover.</p>
  </div>
  <div class="ccg-q" data-answer="c">
    <p><strong>Q3.</strong> When is extracting a repeated pattern into a helper the right move?</p>
    <label><input type="radio" name="020-q3" value="a"> <strong>a.</strong> Whenever a function is longer than ten lines</label>
    <label><input type="radio" name="020-q3" value="b"> <strong>b.</strong> Only when the pattern appears in more than five files</label>
    <label><input type="radio" name="020-q3" value="c"> <strong>c.</strong> When the same logic appears in two or more places and changing it would require updating each copy independently</label>
    <label><input type="radio" name="020-q3" value="d"> <strong>d.</strong> Whenever a code reviewer suggests it</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">The signal for extraction is duplication that creates a maintenance hazard: if you need to change the logic, you must remember every copy. Two or more copies of the same pattern is the threshold most style guides use. One copy is rarely worth extracting — the indirection costs more than it saves.</p>
  </div>
  <div class="ccg-q" data-answer="a">
    <p><strong>Q4.</strong> How do you prove that a refactor left behavior unchanged?</p>
    <label><input type="radio" name="020-q4" value="a"> <strong>a.</strong> Run the same test suite before and after — green both times means behavior is identical by definition</label>
    <label><input type="radio" name="020-q4" value="b"> <strong>b.</strong> Read through the diff carefully and confirm no logic changed</label>
    <label><input type="radio" name="020-q4" value="c"> <strong>c.</strong> Ask a colleague to review the pull request</label>
    <label><input type="radio" name="020-q4" value="d"> <strong>d.</strong> Run the app manually and check that it still works</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Human code review and manual testing are valuable but not proof — they depend on what reviewers notice and what scenarios a tester thinks to try. A test suite that was green before and green after is the only objective, repeatable evidence that observable behavior is unchanged.</p>
  </div>
</div>

## Stretch (optional, ~10 min)

After the split, ask Claude to add `src/db/index.js` that re-exports everything from both `connection.js` and `quips.js`. Update `server.js` to import from `src/db/index.js` instead of the individual paths. Run `npm test` to confirm nothing changed. This is the barrel-file pattern — a single entry point that hides internal module structure from callers.

## Recall

In Lab 015, you placed a `CLAUDE.md` file inside a subdirectory so it applied only to prompts run in that folder. What is the term for this scoping behavior?

> Expected: nested (or directory-scoped) `CLAUDE.md` — inner files override outer files for sessions started inside that directory.

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/overview
- https://docs.claude.com/en/docs/claude-code/settings
- https://docs.claude.com/en/docs/claude-code/common-workflows

## Next

→ **Checkpoint D** — end of Part IV (Quality Gates)
