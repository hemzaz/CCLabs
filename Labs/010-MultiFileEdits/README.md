# Lab 010 — Multi-File Edits

⏱ **25 min**   📦 **You'll add**: `author` field in `quips/src/db.js`, `quips/src/server.js`, `quips/test/server.test.js`   🔗 **Builds on**: Lab 009   🎯 **Success**: `` `npm test` green in quips/ AND 'author' appears in all three files (db.js, server.js, test/server.test.js) ``

<!--
  Template contract - do not remove this comment.
  CI (lint-prose + structure linter) enforces:
    1. Header line above (one line, five fields, in this exact order)
    2. Nine sections below (in this exact order, same H2 titles)
    3. Single new concept (a "Concept:" Bloom-tagged line)
    4. Every Do step ends with a verify COMMAND, not a screenshot
  See CONTRIBUTING.md and docs/DESIGN.md §7 for the full author contract.
-->

**Concept**: `Coordinate edits across schema, routes, and tests in one session` (Bloom: Apply)

---

## Why

Real features rarely live in one file. Adding a field end-to-end — schema, business logic, routes, and tests — means touching several files that must stay consistent with each other. If any layer is missing, tests catch the gap immediately. This lab practices exactly that coordination: you give Claude one clear goal and watch it walk the full stack, keeping every layer in sync.

## Check

```bash
./scripts/doctor.sh 010
```

Expected output: `OK lab 010 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before opening any file, write down the three files that must change to add an `author` field end-to-end (schema → server → tests). Add a sentence explaining why skipping any one of them would leave the feature incomplete.

   Verify all three source files exist before continuing:
   ```bash
   [[ -f quips/src/db.js && -f quips/src/server.js && -f quips/test/server.test.js ]] && echo "all present" || echo "missing files"
   ```
   Expected: `all present`

2. **Run** — from the repo root, launch Claude Code inside the quips project and issue one coordinated prompt:

   ```bash
   cd quips && claude
   ```

   Then type this prompt inside the REPL:

   > Add an optional `author` TEXT column to the quips table. Update `createQuip()` to accept an `author` field (default null). Update POST /quips to accept it in the body. Update GET responses to include it. Add tests covering three cases: create with author, create without author, and retrieve shows null or value correctly. Run `npm test` after. Coordinate all edits.

   Verify that Claude proposes or applies edits touching all three files — confirm by checking each is mentioned in Claude's output before you accept any writes.

   ```bash
   echo "confirm Claude's plan/output references db.js, server.js, and server.test.js"
   ```

3. **Investigate** — read the changes Claude made to `quips/src/db.js`. Look specifically at how the schema is updated: does it use `ALTER TABLE` (adds a column to an existing table), or does it rewrite the `CREATE TABLE` statement to include `author`?

   In-memory SQLite (used when `QUIPS_DB_PATH` is not set) is re-created fresh for every test run via `resetDb()`, so either approach works. Note which one Claude chose.

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
| Edit blocked by permissions | Lab 009's `settings.local.json` may restrict writes | Switch to `--permission-mode acceptEdits` (as set up in Lab 009) or verify `quips/.claude/settings.local.json` permits file edits | https://docs.claude.com/en/docs/claude-code/settings |

## Stretch (optional, ~10 min)

Add a Vitest test that asserts `author` is never an empty string — it must be either `null` or a non-empty string. Hint: try `POST /quips` with `{ text: "hi", author: "" }` and decide whether the server should reject it or coerce it to `null`.

## Recall

What file did you create in Lab 009 to control Claude's permissions?

> Expected: `quips/.claude/settings.local.json`

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/overview
- https://docs.claude.com/en/docs/claude-code/settings

## Next

→ **Checkpoint A** — end of Part I retrospective + integration task: review everything from Labs 001–010 and apply the patterns to a small feature of your own choosing.
