# Lab 005 — Writing First Code

⏱ **25 min**   📦 **You'll add**: `GET /random` route in `quips/src/server.js` with a passing Vitest test   🔗 **Builds on**: Lab 004   🎯 **Success**: `npm test` in `quips/` passes AND `grep -qi "random" quips/src/server.js` matches

<!--
  Template contract - do not remove this comment.
  CI (lint-prose + structure linter) enforces:
    1. Header line above (one line, five fields, in this exact order)
    2. Nine sections below (in this exact order, same H2 titles)
    3. Single new concept (a "Concept:" Bloom-tagged line)
    4. Every Do step ends with a verify COMMAND, not a screenshot
  See CONTRIBUTING.md and docs/DESIGN.md §7 for the full author contract.
-->

**Concept**: `Ask Claude to write code that passes a test` (Bloom: Apply)

---

## Why

Reading code tells you what already exists. Writing code tells you whether you can direct an AI to extend it correctly. This lab closes that loop: you give Claude a precise spec, it writes the SQL and the route, and you verify the result by running the test suite — not by eyeballing output.

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

Exactly three entries. Each cites a source URL from canonical Anthropic docs.

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| Claude's change breaks existing tests | Tests assumed a specific row-insertion order; the new route disturbs that | Add `resetDb()` in a `beforeEach` block OR seed deterministic data per test | https://docs.claude.com/en/docs/claude-code/overview |
| Route added but 404 not returned on empty table | Missing null-check before sending the response | Ask Claude: "add `if (!row) return reply.code(404).send({error: 'no quips'})` before the return" | https://github.com/anthropics/claude-code |
| `ORDER BY RANDOM()` works but feels slow | Fine for this lab's scale; flag as a future concern | For production use an offset-based approach — mention it to Claude as a stretch; covered in Lab 020 (performance) | https://github.com/anthropics/anthropic-cookbook |

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
