# Lab 020 — Refactor Safely

⏱ **30 min**   📦 **You'll add**: refactored `quips/src/db.js` with green tests   🔗 **Builds on**: Lab 019   🎯 **Success**: `quips/src/db/connection.js` and `quips/src/db/quips.js` both exist and `npm test` exits 0

<!--
  Template contract - do not remove this comment.
  CI (lint-prose + structure linter) enforces:
    1. Header line above (one line, five fields, in this exact order)
    2. Nine sections below (in this exact order, same H2 titles)
    3. Single new concept (a "Concept:" Bloom-tagged line)
    4. Every Do step ends with a verify COMMAND, not a screenshot
  See CONTRIBUTING.md and docs/DESIGN.md §7 for the full author contract.
-->

**Concept**: `Refactor under a green test suite` (Bloom: Apply)

---

## Why

Refactoring without tests is rewriting. You change code and hope the behavior survived. With a green test suite, refactoring is safe: run the tests after every move and they tell you immediately whether behavior is preserved. This lab closes Part IV by combining TDD discipline (016), rescue skills (017), code review (018), and verify scripts (019) into one workflow: split an existing module into two, keeping tests green at every step.

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

   Expected: all tests pass, exit code 0. Then create a branch to isolate the refactor:

   ```bash
   git checkout -b refactor/db-split
   ```

   Expected: output contains `Switched to a new branch 'refactor/db-split'`.

3. **Investigate** — open `quips/src/db.js` and identify which lines open the database handle (the `better-sqlite3` call and `resetDb`) versus which lines run SQL queries (`createQuip`, `getQuip`, `listQuips`).

   Verify the current file size:
   ```bash
   wc -l quips/src/db.js
   ```
   Expected: a number greater than 0. Note it — after the split, the two new files should account for roughly the same total line count.

4. **Modify** — open Claude Code inside the quips project and issue this prompt:

   ```bash
   cd quips && claude
   ```

   Then type:

   > Split `quips/src/db.js` into two files: `src/db/connection.js` (opens the SQLite handle and exports `resetDb`) and `src/db/quips.js` (exports `createQuip`, `getQuip`, `listQuips`). Preserve all public exports so callers do not break. Run `npm test` after each file move. Do not modify any file under `quips/test/`.

   After Claude finishes, verify tests still pass:
   ```bash
   cd quips && npm test --silent && echo OK
   ```
   Expected: last line printed is `OK`.

5. **Make** — confirm the refactor is complete: both new files exist and the old entry point still works.

   ```bash
   [[ -f quips/src/db/connection.js && -f quips/src/db/quips.js ]] && echo "files present" || echo "files missing"
   ```
   Expected: `files present`.

   Then commit:
   ```bash
   git add quips && git commit -m "refactor: split db.js into db/connection and db/quips"
   ```
   Expected:
   ```bash
   git log -1 --oneline
   ```
   Output contains `refactor: split db.js`.

## Observe

One sentence — if Claude had modified a test file to make tests pass after the split, how would you have detected that?

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| Tests break after split | A function moved but its import path did not update everywhere | `grep -rn "require.*db" quips/src` — update every call site that still points to the old path | https://docs.claude.com/en/docs/claude-code/common-workflows |
| Claude rewrites tests to make them pass | Permission mode allows test edits and Claude took the easy path | Add an explicit instruction: "Do not modify any file under quips/test/" or add a deny rule in `.claude/settings.local.json` | https://docs.claude.com/en/docs/claude-code/settings |
| The refactor grows beyond 2 files | Scope crept during the session | Revert with `git checkout quips/src/` and restart with a tighter prompt that names exactly the two target files | https://docs.claude.com/en/docs/claude-code/overview |

## Stretch (optional, ~10 min)

After the split, ask Claude to add a third module `src/db/index.js` that re-exports everything from both `connection.js` and `quips.js`. Update `server.js` to import from `src/db/index.js` instead of the individual paths. Run `npm test` to confirm nothing changed.

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
