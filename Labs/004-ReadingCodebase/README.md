# Lab 004 — Reading a Codebase

⏱ **20 min**   📦 **You'll add**: `Labs/004-ReadingCodebase/summary.md`   🔗 **Builds on**: Lab 003   🎯 **Success**: `summary.md mentions SQLite, Fastify, and at least two of Quips' endpoints`

<!--
  Template contract - do not remove this comment.
  CI (lint-prose + structure linter) enforces:
    1. Header line above (one line, five fields, in this exact order)
    2. Nine sections below (in this exact order, same H2 titles)
    3. Single new concept (a "Concept:" Bloom-tagged line)
    4. Every Do step ends with a verify COMMAND, not a screenshot
  See CONTRIBUTING.md and docs/DESIGN.md §7 for the full author contract.
-->

**Concept**: `Claude reads a codebase and explains it back` (Bloom: Understand)

---

## Why

Reading unfamiliar code is the most common task in real engineering. Practising it with Claude as a guide builds the habit of asking precise questions about structure, storage, and interfaces — skills that scale to any codebase.

## Check

```bash
./scripts/doctor.sh 004
```

Expected output: `OK lab 004 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before opening any file in `quips/`, write your best guess at what "Quips" does. Add it as the first line of `Labs/004-ReadingCodebase/summary.md` prefixed with `Pre-prediction:`. You'll compare it against Claude's answer at the end.

   Verify:
   ```bash
   head -1 Labs/004-ReadingCodebase/summary.md
   ```
   Expected: a line that starts with `Pre-prediction:`.

2. **Run** — open a Claude Code REPL inside the Quips project and ask for a high-level description.

   ```bash
   cd quips && claude
   ```

   In the REPL, ask:
   > What does this repo do? Keep it to 3 sentences.

   Verify: the answer mentions `HTTP` or `API`.

3. **Investigate** — still in the REPL, ask Claude about the database.

   > What database does this repo use, and what's the table schema?

   Verify: the answer mentions `SQLite` and the `quips` table with columns `id`, `text`, and `tags`.

4. **Modify** — ask Claude to enumerate the server's routes.

   > List the HTTP endpoints this server exposes.

   Verify: the answer lists at least 3 of: `POST /quips`, `GET /quips`, `GET /quips/:id`, `DELETE /quips/:id`, `GET /health`.

5. **Make** — synthesize what you've learned. Write `Labs/004-ReadingCodebase/summary.md` with exactly three bullets:
   - **(a)** what Quips is in one line
   - **(b)** its storage (database engine, table name, columns)
   - **(c)** its HTTP endpoints

   Verify:
   ```bash
   ./scripts/verify.sh 004
   ```
   Expected: exits 0 with no error output.

## Observe

Compare Claude's explanation at step 2 with your `Pre-prediction:` line at the top of `summary.md`. Which details did Claude surface that you missed? Write one paragraph in your own words. No answer key — this is metacognition practice.

## If stuck

Exactly three entries. Each cites a source URL from canonical Anthropic docs.

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| Claude doesn't see the files | You're not in the right directory | Run `pwd` to check; if needed exit the REPL and run `cd /path/to/quips && claude` | https://docs.claude.com/en/docs/claude-code/overview |
| Answer mentions the wrong framework | Claude guessed without reading files | Ask it to read `package.json` explicitly: `cat package.json` in the REPL | https://docs.claude.com/en/docs/claude-code/overview |
| Endpoints list is incomplete | Claude didn't grep the source | Ask: `grep route src/server.js` or `grep app\. src/server.js` | https://github.com/anthropics/claude-code |

## Stretch (optional, ~10 min)

Ask Claude to generate an OpenAPI 3.0 spec for Quips and save it:

```bash
# inside the quips REPL
# Ask: "Generate an OpenAPI 3.0 YAML spec for this server"
# Then save the output to:
Labs/004-ReadingCodebase/openapi.yaml
```

No grading — just try. Compare the generated spec against what you saw in `src/server.js`.

## Recall

What slash command clears the session history without exiting the REPL?

> Expected from Lab 003: `/clear`

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/overview
- https://github.com/anthropics/claude-code

## Next

→ **Lab 005 — Writing First Code** — ask Claude to add a new endpoint and watch it write, test, and wire up production code from scratch.
