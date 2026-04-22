# Lab 024 — Skills

⏱ **30 min**   📦 **You'll add**: `quips/.claude/skills/seed-db/SKILL.md`   🔗 **Builds on**: Lab 023   🎯 **Success**: `quips/.claude/skills/seed-db/SKILL.md exists with valid frontmatter and seed.sql contains >=10 INSERT statements`

<!--
  Template contract - do not remove this comment.
  CI (lint-prose + structure linter) enforces:
    1. Header line above (one line, five fields, in this exact order)
    2. Nine sections below (in this exact order, same H2 titles)
    3. Single new concept (a "Concept:" Bloom-tagged line)
    4. Every Do step ends with a verify COMMAND, not a screenshot
  See CONTRIBUTING.md and docs/DESIGN.md §7 for the full author contract.
-->

**Concept**: `Skill invokable via slash command` (Bloom: Create)

---

## Why

Repeatable workflows inside a project should not live only in your head or in long prompts you re-type. A skill packages a workflow as a named, slash-invokable command that Claude loads from a directory in `.claude/skills/`. Once registered, you invoke it with `/skill-name` and Claude follows its instructions every time. This lab builds `seed-db` — a skill that inserts 10 sample quotes into the Quips database for demos and testing.

## Check

```bash
./scripts/doctor.sh 024
```

Expected output: `OK lab 024 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before writing any files, list 3 repeatable workflows in the Quips project that deserve a skill (not a one-off prompt). Think about tasks you would run more than once across sessions. Write the list with `echo`.

   ```bash
   echo "1. seed-db  2. run-tests  3. reset-db"
   ```
   Expected: any three distinct workflow names printed to stdout.

2. **Run** — read the skills documentation to learn the required directory shape and frontmatter keys.

   Visit: https://docs.claude.com/en/docs/claude-code/skills

   Confirm the two required frontmatter keys by running:
   ```bash
   echo "required keys: name, description"
   ```
   Expected: `required keys: name, description`

3. **Investigate** — examine the Quips database schema to decide what a seed insert needs.

   ```bash
   sqlite3 quips/quips.db .schema 2>/dev/null || grep -n 'CREATE' quips/src/db.js
   ```
   Expected: output shows the `quips` table columns (at minimum `id`, `text`, `tag` or similar). Confirm you can write a single-line INSERT statement for this table.

4. **Modify** — create the skill directory with `SKILL.md` and `seed.sql`.

   Create `quips/.claude/skills/seed-db/SKILL.md` with:
   - Frontmatter block (`---` delimiters) containing `name: seed-db` and `description: Insert 10 sample quotes into quips.db for demos`
   - Body that instructs Claude to run `sqlite3 quips.db < seed.sql` from the `quips/` directory and then confirm `SELECT count(*) FROM quips` returns >= 10

   Create `quips/.claude/skills/seed-db/seed.sql` with 10 `INSERT OR IGNORE` statements covering varied tags.

   ```bash
   [[ -s quips/.claude/skills/seed-db/SKILL.md && -s quips/.claude/skills/seed-db/seed.sql ]] && echo ok
   ```
   Expected: `ok`

5. **Make** — launch Claude inside the quips project and invoke the skill.

   ```bash
   cd quips && claude
   ```

   Inside the Claude REPL type:
   > /seed-db

   After the skill runs, verify the database was seeded:
   ```bash
   sqlite3 quips/quips.db "SELECT count(*) FROM quips"
   ```
   Expected: a number >= 10.

## Observe

One sentence — what did the skill body need to say for Claude to actually execute the SQL rather than just describe it?

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| `/seed-db` is not found | Skill directory not in `.claude/skills/` or Claude not restarted | Exit and re-launch `claude`; confirm path is `quips/.claude/skills/seed-db/SKILL.md` | https://docs.claude.com/en/docs/claude-code/skills |
| Skill runs but DB is empty after | `seed.sql` was read but not applied — body described what to do but did not tell Claude to execute it | Body must include an explicit `sqlite3 quips.db < seed.sql` step | https://docs.claude.com/en/docs/claude-code/skills |
| Skill has duplicate rows across invocations | `seed.sql` inserts without checking for duplicates | Use `INSERT OR IGNORE` or prefix with `DELETE FROM quips;` in a non-prod seed | https://github.com/anthropics/anthropic-cookbook |

## Stretch (optional, ~10 min)

Add a second skill called `reset-db` that deletes all rows from the `quips` table and then calls `/seed-db` to repopulate. Verify by running both skills in sequence and checking that the row count is exactly 10 after the reset.

## Recall

In Lab 019, what are the two exit-code behaviors a `verify.sh` script must demonstrate?

> Expected: exit 0 when the feature is present and correct; exit non-zero with a one-line message on stderr when the feature is broken.

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/skills
- https://docs.claude.com/en/docs/claude-code/overview

## Next

→ **Lab 025 — MCP** — connect an external MCP server to Quips and invoke its tools from inside a Claude session.
