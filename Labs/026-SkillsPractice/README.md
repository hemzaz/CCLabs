# Lab 026 — Skills Practice

⏱ **20 min**   📦 **You'll add**: `quips/.claude/skills/dump-db/SKILL.md` + dump.sh   🔗 **Builds on**: Checkpoint E   🎯 **Success**: `dump-db skill exists, is executable, and outputs valid JSON with at least 10 rows`

<!--
  Template contract - do not remove this comment.
  CI (lint-prose + structure linter) enforces:
    1. Header line above (one line, five fields, in this exact order)
    2. Nine sections below (in this exact order, same H2 titles)
    3. Single new concept (a "Concept:" Bloom-tagged line)
    4. Every Do step ends with a verify COMMAND, not a screenshot
  See CONTRIBUTING.md and docs/DESIGN.md §7 for the full author contract.
-->

**Concept**: `Compose a second skill that pairs with the first` (Bloom: Create)

---

## Why

One skill is a tool. Two skills that compose is a workflow. The `seed-db` skill from Lab 024 fills the database. `dump-db` empties it back to JSON. Together they form a full seed/dump cycle: seed data, modify it inside Claude, then dump and diff. That cycle is how you test, audit, and migrate data with Claude as the engine. This lab builds the second half of that loop.

## Check

```bash
./scripts/doctor.sh 026
```

Expected output: `OK lab 026 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before writing any code, name one downside of a dump skill that does not filter by tag. Write your answer in a comment or a scratch file.

   Verify:
   ```bash
   echo "prediction captured"
   ```
   Expected: `prediction captured`

2. **Run** — confirm the skills docs are accessible and that Lab 024's artifact is still in place.

   ```bash
   [[ -f quips/.claude/skills/seed-db/SKILL.md ]] && echo "seed-db present" || echo "MISSING — complete Lab 024 first"
   ```
   Expected: `seed-db present`

3. **Investigate** — plan the dump format before writing code. Confirm that `sqlite3` on this machine supports the `-json` flag by running a quick test.

   ```bash
   sqlite3 -json :memory: "SELECT 1 AS n" 2>&1
   ```
   Expected: `[{"n":1}]`

   If that fails, check `sqlite3 --version` — the `-json` flag requires version 3.33 or later. See the "If stuck" table below.

4. **Modify** — create the skill files.

   First, create `quips/.claude/skills/dump-db/SKILL.md`:
   ```
   ---
   name: dump-db
   description: Export all quips to stdout as JSON
   ---
   Run dump.sh to print every row in quips.db as a JSON array.
   Use this after seed-db to inspect or migrate data.
   Pipe the output to a file to save a snapshot.
   ```

   Then create `quips/.claude/skills/dump-db/dump.sh`:
   ```bash
   #!/usr/bin/env bash
   set -euo pipefail
   DB="${QUIPS_DB_PATH:-$(dirname "$0")/../../../quips.db}"
   sqlite3 -json "$DB" "SELECT * FROM quips"
   ```

   Make it executable:
   ```bash
   chmod +x quips/.claude/skills/dump-db/dump.sh
   ```

   Verify both files are in place:
   ```bash
   [[ -s quips/.claude/skills/dump-db/SKILL.md && -x quips/.claude/skills/dump-db/dump.sh ]] && echo ok
   ```
   Expected: `ok`

5. **Make** — compose the two skills inside Claude. Launch the REPL, seed the database, then dump it.

   ```bash
   cd quips && claude
   ```

   Inside the REPL, run in sequence:
   ```
   > /seed-db
   > /dump-db
   ```

   Pipe the dump output to a snapshot file, then validate it parses as JSON with at least 10 rows:
   ```bash
   bash quips/.claude/skills/dump-db/dump.sh | python3 -c "import sys,json; rows=json.load(sys.stdin); assert len(rows)>=10, f'only {len(rows)} rows'; print('json OK')"
   ```
   Expected: `json OK`

## Observe

One sentence — what changed in Claude's behaviour when you ran `/dump-db` versus typing out the full sqlite3 command by hand?

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| `dump.sh` outputs nothing | `sqlite3 -json` requires sqlite3 >= 3.33; older builds lack the flag | Check `sqlite3 --version`; replace `-json` with `.mode json` on a line before the SELECT, or upgrade sqlite3 | https://docs.claude.com/en/docs/claude-code/skills |
| Skill runs twice and produces different output | Quips with unicode cause sqlite3 `-json` to escape differently per call | Pipe through `python3 -m json.tool --sort-keys` to normalise before diffing | https://github.com/anthropics/anthropic-cookbook |
| `/dump-db` is not found in the REPL | `SKILL.md` is missing required frontmatter keys | Compare against `seed-db/SKILL.md`; ensure both `name:` and `description:` are present and the file has two `---` fence lines | https://docs.claude.com/en/docs/claude-code/skills |

## Stretch (optional, ~10 min)

Add a `--tag` flag to `dump.sh` that filters rows by a tag column. If the quips table has no tag column, add one via `ALTER TABLE` first, seed a few tagged rows, then verify that `dump.sh --tag tutorial` returns only those rows.

## Recall

In Lab 021, every subagent SKILL.md requires specific frontmatter fields. What are the two required keys that the runner checks before invoking the skill?

> Expected: `name` and `description`

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/skills
- https://github.com/anthropics/anthropic-cookbook

## Next

→ **Lab 027 — MCP Practice** — connect an MCP server to Claude Code and invoke its tools from inside a session.
