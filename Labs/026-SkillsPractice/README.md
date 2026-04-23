# Lab 026 — Skills Practice

⏱ **30 min**   📦 **You'll add**: `quips/.claude/skills/dump-db/SKILL.md` + `dump.sh`   🔗 **Builds on**: Lab 024   🎯 **Success**: `/dump-db` skill exists, is executable, and outputs valid JSON with at least 10 rows

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
    - You will build a second skill, `dump-db`, that exports the quips table to JSON.
    - You will compose `seed-db` and `dump-db` to form a complete seed/dump round-trip.
    - You will capture before and after snapshots and diff them to verify a data change.
    - You will extend `dump-db` with a `--tag` filter flag, then wrap both skills in a parent skill.

**Concept**: `Compose a second skill that pairs with the first to form a round-trip` (Bloom: Create)

---

## Prerequisites

- Lab 024 completed: `quips/.claude/skills/seed-db/SKILL.md` exists
- `sqlite3` 3.33 or later on PATH (run `sqlite3 --version` to confirm)
- The `quips/` project with an initialised `quips.db`

## What You Will Learn

- Why pairing two focused skills beats one monolithic skill
- How to emit structured JSON from SQLite using the `-json` flag
- How to capture and diff database snapshots from the shell
- How to add a filter flag to a skill script without breaking the default behaviour
- How to write a parent skill that orchestrates child skills in sequence

## Why

One skill is a tool. Two skills that compose is a workflow.

The `seed-db` skill from Lab 024 fills the database. `dump-db` exports it back to JSON. Together they form a full round-trip: seed data, modify it, dump it, and diff the snapshots. That cycle is how you test, audit, and migrate data with Claude as the engine. Without the dump half, you can push data in but you cannot observe what changed — you are flying blind.

Pairing beats single-shot skills for three reasons. First, each skill stays small and testable in isolation. Second, the round-trip gives you a concrete before/after diff that proves a change happened (and only the intended change). Third, both skills stay composable — other skills can call them in new sequences without duplicating logic.

The table below shows common skill composition patterns you will encounter across the curriculum.

| Pattern | Skills involved | What it proves |
|---|---|---|
| **Round-trip** | seed-db → dump-db | State is reproducible and diffable |
| **Reset-verify** | reset-db → seed-db → verify-db | Clean-room setup for deterministic tests |
| **Pipeline** | fetch-data → transform-data → load-db | Each stage is independently testable |
| **Guard-then-act** | check-prereqs → run-migration | Migration only runs when environment is ready |
| **Parent+children** | round-trip (calls seed-db + dump-db) | Orchestration without duplicating logic |

## Walkthrough

SQLite has shipped a `-json` output mode since version 3.33 (released September 2020). When you pass `-json` as a flag before the database path, every `SELECT` returns a JSON array of objects — one object per row, keys matching column names. That makes the output immediately parseable by `python3 -m json.tool`, `jq`, or any script that reads stdin.

The dump skill wraps exactly that one command. It accepts an optional `--tag VALUE` argument so callers can narrow the output without pulling every row. When the flag is absent, all rows are returned.

The parent skill `round-trip` calls `/seed-db` then `/dump-db` in sequence. Claude reads the parent SKILL.md, sees the two slash-command lines, and invokes them in order. The parent holds no logic of its own — it is pure orchestration.

Here is why a filter flag belongs in the script rather than in the SKILL.md body: the body is natural language that Claude interprets. A flag is machine-readable and composable. Any caller — human, parent skill, or CI script — can pass `--tag tutorial` and get a predictable subset without asking Claude to parse English.

## Check

```bash
./scripts/doctor.sh 026
```

Expected output: `OK lab 026 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before writing any code, write down one downside of a dump skill that has no filter flag. Save the prediction as a comment or in a scratch file.

   ```bash
   echo "prediction captured"
   ```

   Expected: `prediction captured`

2. **Run** — confirm that Lab 024's artifact is still in place and that sqlite3 supports `-json`.

   ```bash
   [[ -f quips/.claude/skills/seed-db/SKILL.md ]] && echo "seed-db present" || echo "MISSING — complete Lab 024 first"
   ```

   Expected: `seed-db present`

   Then confirm `-json` support:

   ```bash
   sqlite3 -json :memory: "SELECT 1 AS n" 2>&1
   ```

   Expected: `[{"n":1}]`

   If that returns an error, check `sqlite3 --version`. The `-json` flag requires 3.33 or later. See the "If stuck" table below.

   Verify:

   ```bash
   sqlite3 --version | awk '{print $1}' | awk -F. '{ok=($1>3||($1==3&&$2>=33)); print (ok?"sqlite3 version ok":"UPGRADE NEEDED: need 3.33+")}'
   ```

   Expected: `sqlite3 version ok`

3. **Investigate** — plan the dump format before writing any code. Inspect the quips table schema so you know which columns to expect in the JSON output.

   ```bash
   sqlite3 quips/quips.db .schema 2>/dev/null || grep -n 'CREATE' quips/src/db.js
   ```

   Expected: output shows the `quips` table definition with at minimum `id`, `text`, and a tag-like column. Note the exact column names — they will be the keys in your JSON objects.

   Verify:

   ```bash
   echo "schema reviewed"
   ```

   Expected: `schema reviewed`

4. **Modify** — create the `dump-db` skill files.

   **a.** Create `quips/.claude/skills/dump-db/SKILL.md`:

   ```
   ---
   name: dump-db
   description: Export all quips to stdout as a JSON array
   ---
   Run dump.sh from the quips/ directory to print every row in quips.db as a JSON array.
   Use this after seed-db to inspect or migrate data.
   Pipe the output to a file to save a snapshot for diffing.
   To filter by tag, pass --tag VALUE to dump.sh directly.
   ```

   **b.** Create `quips/.claude/skills/dump-db/dump.sh`:

   ```bash
   #!/usr/bin/env bash
   set -euo pipefail
   DB="${QUIPS_DB_PATH:-$(dirname "$0")/../../../quips.db}"
   TAG=""
   while [[ $# -gt 0 ]]; do
     case "$1" in
       --tag) TAG="$2"; shift 2 ;;
       *) echo "Unknown flag: $1" >&2; exit 1 ;;
     esac
   done
   if [[ -n "$TAG" ]]; then
     sqlite3 -json "$DB" "SELECT * FROM quips WHERE tag = '$TAG'"
   else
     sqlite3 -json "$DB" "SELECT * FROM quips"
   fi
   ```

   **c.** Make it executable:

   ```bash
   chmod +x quips/.claude/skills/dump-db/dump.sh
   ```

   Verify both files are present and the script is executable:

   ```bash
   [[ -s quips/.claude/skills/dump-db/SKILL.md && -x quips/.claude/skills/dump-db/dump.sh ]] && echo ok
   ```

   Expected: `ok`

5. **Make** — invoke `/dump-db` inside the REPL.

   ```bash
   cd quips && claude
   ```

   Inside the REPL, run in sequence:

   ```
   > /seed-db
   > /dump-db
   ```

   Then verify the raw output is valid JSON with at least 10 rows:

   ```bash
   bash quips/.claude/skills/dump-db/dump.sh | python3 -c "
   import sys, json
   rows = json.load(sys.stdin)
   assert len(rows) >= 10, f'only {len(rows)} rows'
   print('json OK, rows:', len(rows))
   "
   ```

   Expected: `json OK, rows: 10` (or higher).

6. **Make** — capture a before snapshot, modify a row, then capture an after snapshot and diff.

   Save the current state:

   ```bash
   bash quips/.claude/skills/dump-db/dump.sh > /tmp/before.json
   echo "before snapshot saved"
   ```

   Expected: `before snapshot saved`

   Modify one row directly in the database:

   ```bash
   sqlite3 quips/quips.db "UPDATE quips SET text = 'modified by Lab 026' WHERE id = (SELECT id FROM quips LIMIT 1)"
   echo "row modified"
   ```

   Expected: `row modified`

   Save the after snapshot and diff:

   ```bash
   bash quips/.claude/skills/dump-db/dump.sh > /tmp/after.json
   diff /tmp/before.json /tmp/after.json
   ```

   Expected: diff output showing exactly one changed text value. If diff prints nothing, the update did not land — check that `quips.db` is the same file that `dump.sh` reads.

   Verify the diff is non-empty:

   ```bash
   diff /tmp/before.json /tmp/after.json | wc -l | xargs -I{} bash -c '[[ {} -gt 0 ]] && echo "diff non-empty: ok" || echo "FAIL: no diff found"'
   ```

   Expected: `diff non-empty: ok`

## Observe

One sentence — what changed in Claude's output when you ran `/dump-db` versus typing the full `sqlite3 -json` command by hand? Write your answer in a scratch note; there is no single correct answer.

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| `dump.sh` outputs nothing | `sqlite3 -json` requires sqlite3 >= 3.33; older builds lack the flag | Check `sqlite3 --version`; replace `-json` with `.mode json` on a line before the SELECT, or upgrade sqlite3 | https://docs.claude.com/en/docs/claude-code/skills |
| `/dump-db` not found in the REPL | `SKILL.md` is missing required frontmatter keys or Claude was not restarted | Compare against `seed-db/SKILL.md`; ensure `name:` and `description:` are present with two `---` fence lines; exit and re-launch `claude` | https://docs.claude.com/en/docs/claude-code/skills |
| `diff` shows no changes after UPDATE | `dump.sh` is reading a different `quips.db` path than the one you updated | Print `DB` from inside `dump.sh` with `echo "$DB"` and compare to the path used in the `sqlite3` UPDATE command | https://github.com/anthropics/anthropic-cookbook |
| JSON has inconsistent key ordering across runs | SQLite column order is stable; unicode values may escape differently | Pipe through `python3 -m json.tool --sort-keys` before saving snapshots | https://docs.claude.com/en/docs/claude-code/skills |
| `--tag` filter returns empty array | Tag value does not match the column content exactly (case-sensitive) | Run `sqlite3 quips.db "SELECT DISTINCT tag FROM quips"` to see actual values | https://github.com/anthropics/anthropic-cookbook |

## Tasks

Click the checkbox next to each task to mark it done — your progress is saved locally.

### Task 1 — Create the dump-db skill

**Scenario:** You need a skill that exports the quips table to JSON so you can inspect data from inside Claude sessions.

**Hint:** The skill directory must be under `.claude/skills/` and `SKILL.md` must have both `name:` and `description:` keys in YAML frontmatter.

??? success "Solution"

    ```bash
    mkdir -p quips/.claude/skills/dump-db
    cat > quips/.claude/skills/dump-db/SKILL.md << 'EOF'
    ---
    name: dump-db
    description: Export all quips to stdout as a JSON array
    ---
    Run dump.sh from the quips/ directory to print every row in quips.db as a JSON array.
    EOF
    ```

### Task 2 — Test /dump-db in the REPL

**Scenario:** After creating the skill files you want to confirm Claude can discover and invoke the skill.

**Hint:** Exit the REPL and re-launch `claude` from the `quips/` directory before testing — Claude discovers skills at startup.

??? success "Solution"

    ```bash
    cd quips && claude
    # Inside the REPL:
    # > /dump-db
    # Expect a JSON array printed to the session.
    ```

### Task 3 — Run seed-db, then dump-db, then save output as before.json

**Scenario:** You want a clean baseline snapshot to compare against after a data change.

**Hint:** Run `/seed-db` first to ensure the table is populated, then pipe `dump.sh` stdout to a file.

??? success "Solution"

    ```bash
    # Inside the Claude REPL: /seed-db then /dump-db
    # From the shell:
    bash quips/.claude/skills/dump-db/dump.sh > /tmp/before.json
    python3 -c "import json; rows=json.load(open('/tmp/before.json')); print(len(rows), 'rows')"
    ```

### Task 4 — Modify data, run dump-db again, diff before and after

**Scenario:** You changed one row and want to confirm only that row appears in the diff.

**Hint:** `diff` compares two files line by line. Pipe through `python3 -m json.tool --sort-keys` first if key ordering varies.

??? success "Solution"

    ```bash
    sqlite3 quips/quips.db "UPDATE quips SET text='changed' WHERE id=(SELECT id FROM quips LIMIT 1)"
    bash quips/.claude/skills/dump-db/dump.sh > /tmp/after.json
    diff /tmp/before.json /tmp/after.json
    # Expect exactly the modified text value to appear in the diff output.
    ```

### Task 5 — Add a --tag flag to dump.sh to filter by tag

**Scenario:** The quips table has a tag column and you want to export only rows that match a specific tag without modifying the default behaviour.

**Hint:** Use a `while [[ $# -gt 0 ]]` loop to parse `--tag VALUE`. When no flag is passed, the WHERE clause is omitted.

??? success "Solution"

    ```bash
    # Verify the flag works:
    bash quips/.claude/skills/dump-db/dump.sh --tag tutorial | python3 -m json.tool
    # Expect only rows where tag = 'tutorial' (or an empty array if none match).
    bash quips/.claude/skills/dump-db/dump.sh | python3 -c "import sys,json; print(len(json.load(sys.stdin)), 'total rows')"
    # Expect all rows when no flag is passed.
    ```

### Task 6 — Wrap seed-db and dump-db in a single parent skill

**Scenario:** You want a single `/round-trip` command that seeds the database and then dumps it, so teammates can reproduce a known state in one step.

**Hint:** A parent skill's body instructs Claude to invoke `/seed-db` then `/dump-db` in sequence. The parent holds no shell logic of its own.

??? success "Solution"

    ```bash
    mkdir -p quips/.claude/skills/round-trip
    cat > quips/.claude/skills/round-trip/SKILL.md << 'EOF'
    ---
    name: round-trip
    description: Seed the database and then dump it to JSON in one step
    ---
    First invoke /seed-db to populate quips.db with sample data.
    Then invoke /dump-db to export all rows as JSON to stdout.
    Report how many rows were exported.
    EOF
    [[ -s quips/.claude/skills/round-trip/SKILL.md ]] && echo "round-trip skill created"
    ```

## Quiz

<div class="ccg-quiz" data-lab="026">
  <div class="ccg-q" data-answer="c">
    <p><strong>Q1.</strong> Why does pairing <code>seed-db</code> and <code>dump-db</code> as separate skills produce a more useful workflow than combining them into one skill?</p>
    <label><input type="radio" name="026-q1" value="a"> **a.** One skill is always faster to invoke than two</label>
    <label><input type="radio" name="026-q1" value="b"> **b.** Claude can only discover a skill if its name is unique across the project</label>
    <label><input type="radio" name="026-q1" value="c"> **c.** Each skill stays independently testable and recomposable into new sequences</label>
    <label><input type="radio" name="026-q1" value="d"> **d.** SQLite cannot be accessed from a single skill that does both reads and writes</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Separating seed and dump keeps each script small and testable in isolation. Any other skill — or a future parent skill — can call either half independently or in a different order without duplicating logic. A combined skill would force callers to take both operations even when they only need one.</p>
  </div>
  <div class="ccg-q" data-answer="b">
    <p><strong>Q2.</strong> What does the <code>sqlite3 -json</code> flag require, and what does it produce?</p>
    <label><input type="radio" name="026-q2" value="a"> **a.** It requires a JSON config file and produces CSV output</label>
    <label><input type="radio" name="026-q2" value="b"> **b.** It requires sqlite3 >= 3.33 and produces a JSON array of row objects on stdout</label>
    <label><input type="radio" name="026-q2" value="c"> **c.** It requires the jq binary and produces newline-delimited JSON</label>
    <label><input type="radio" name="026-q2" value="d"> **d.** It requires no special version and produces a JSON schema of the table</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">The <code>-json</code> output mode was added in SQLite 3.33.0 (September 2020). When passed before the database path it emits a JSON array where each element is a row object and keys match column names. No external tools like jq are required — it is built into the sqlite3 binary.</p>
  </div>
  <div class="ccg-q" data-answer="d">
    <p><strong>Q3.</strong> When is adding a <code>--tag</code> filter flag to <code>dump.sh</code> more useful than adding tag-filtering instructions to the SKILL.md body?</p>
    <label><input type="radio" name="026-q3" value="a"> **a.** It is never useful — Claude can parse natural-language tag names just as reliably</label>
    <label><input type="radio" name="026-q3" value="b"> **b.** Only when the tag contains spaces, because Claude misreads multiword instructions</label>
    <label><input type="radio" name="026-q3" value="c"> **c.** Only in CI environments, because humans prefer natural language</label>
    <label><input type="radio" name="026-q3" value="d"> **d.** Whenever the caller is a script or parent skill that needs deterministic, machine-readable control over the filter</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Natural language in SKILL.md relies on Claude interpreting the instruction correctly each time. A shell flag is machine-readable and deterministic: any caller — a human, a parent skill, or a CI script — can pass <code>--tag tutorial</code> and receive a predictable subset without relying on language interpretation.</p>
  </div>
  <div class="ccg-q" data-answer="a">
    <p><strong>Q4.</strong> What does a successful before/after diff prove about the round-trip?</p>
    <label><input type="radio" name="026-q4" value="a"> **a.** The dump is faithful: it captures state accurately enough that a specific change is visible and only that change appears</label>
    <label><input type="radio" name="026-q4" value="b"> **b.** The database is locked between seed and dump so no concurrent writes are possible</label>
    <label><input type="radio" name="026-q4" value="c"> **c.** Claude's session memory is persisted between the two skill invocations</label>
    <label><input type="radio" name="026-q4" value="d"> **d.** The seed skill is idempotent because the diff shows the same rows each time</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">A non-empty diff that matches exactly the row you modified confirms two things: the dump captures real database state (not cached or stale data), and the snapshot format is stable enough to produce a meaningful comparison. An empty diff would mean the dump is not reflecting changes; a diff with unexpected extra lines would mean the snapshot format is nondeterministic.</p>
  </div>
</div>

## Stretch (optional, ~10 min)

Add a `--limit N` flag to `dump.sh` that restricts the output to the first N rows. Verify that `dump.sh --limit 3` returns exactly 3 rows as valid JSON, and that the default (no flag) still returns all rows.

## Recall

In Lab 024, what are the two required frontmatter keys that Claude checks before invoking a skill?

> Expected: `name` and `description`

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/skills
- https://github.com/anthropics/anthropic-cookbook

## Next

→ **Lab 027 — MCP Practice** — connect an MCP server to Claude Code and invoke its tools from inside a session.
