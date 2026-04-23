# Lab 024 — Skills

⏱ **30 min**   📦 **You'll add**: `quips/.claude/skills/seed-db/SKILL.md`, `quips/.claude/skills/seed-db/seed.sh`, `quips/.claude/skills/reset-db/SKILL.md`   🔗 **Builds on**: Lab 023   🎯 **Success**: `/seed-db` runs end-to-end and `quips.db` contains >=10 rows`

<!--
  Template contract - do not remove this comment.
  CI (lint-prose + structure linter) enforces:
    1. Header line above (one line, five fields, in this exact order)
    2. !!! hint "Overview" admonition with >=3 bullets
    3. Concept: line with a Bloom tag
    4. Fourteen H2 sections below in this exact order:
       Prerequisites, What You Will Learn, Why, Walkthrough, Check, Do,
       Observe, If stuck, Tasks, Quiz, Stretch, Recall, References, Next
    5. >=5 Tasks, each with a ??? success "Solution" block
    6. >=3 MCQ questions inside a <div class="ccg-quiz">
  See CONTRIBUTING.md and docs/DESIGN.md §7 for the full author contract.
-->

!!! hint "Overview"
    - You will learn what a Claude Code skill is and how it differs from a subagent or a hook.
    - You will author a skill called `seed-db` that inserts 10 sample quips via a shell script.
    - You will discover how `description` wording changes whether Claude surfaces your skill automatically.
    - By the end you can invoke `/seed-db` in any Claude session inside the `quips/` project and trust it runs correctly every time.

**Concept**: `Skill invokable via slash command` (Bloom: Create)

---

## Prerequisites

- Completed Lab 023 — hooks are in place and `quips/` project directory exists
- `sqlite3` available on PATH (`sqlite3 --version` exits 0)
- A running Claude Code install (`claude --version` exits 0)

## What You Will Learn

- The required directory shape and frontmatter keys for a Claude Code skill (`SKILL.md`)
- How to invoke a skill with `/skill-name` from inside a Claude session
- How `description` wording determines whether Claude auto-suggests a skill
- When to use a skill versus a subagent versus a hook
- How to compose two skills so one triggers the other

## Why

Every team has workflows that get re-typed as long prompts session after session — "seed the demo data", "reset the database", "run the test suite with verbose output". A skill packages one of those workflows as a named, slash-invokable command stored in `.claude/skills/`. Once the file exists, any Claude session opened inside that project can run the workflow with a single `/skill-name` keystroke. This lab introduces O8: authoring a skill and proving it runs end-to-end. The same pattern scales to any repeatable workflow you want to make permanent.

## Walkthrough

**What a skill is.** A skill is a directory under `.claude/skills/<name>/` that contains at least one file: `SKILL.md`. The frontmatter of that file declares two required keys — `name` and `description` — and the body contains the instructions Claude follows when you invoke the skill. Claude reads the file, then executes the instructions as if you had typed them as a prompt, with full access to tools (Bash, Read, Edit, etc.).

```
quips/
└── .claude/
    └── skills/
        └── seed-db/
            ├── SKILL.md   ← required; frontmatter + body
            └── seed.sh    ← optional helper script
```

The frontmatter block uses YAML between `---` delimiters:

```yaml
---
name: seed-db
description: Insert 10 sample quips into quips.db for demos and testing
---
```

**Invoking a skill.** Inside a Claude REPL session that was started from (or below) the directory that contains `.claude/skills/`, type:

```
/seed-db
```

Claude loads `SKILL.md`, reads the body, and acts on it. No restart is needed after you first create the file — Claude discovers skills at invocation time.

**Why description wording matters.** Claude also reads skill descriptions when deciding whether to *proactively* suggest a skill without you typing the slash command. A description that matches the user's intent ("Insert 10 sample quips into quips.db for demos and testing") is more likely to be surfaced than a vague one ("do the db thing"). Concrete, verb-led descriptions work best. You will observe this difference in Task 4.

**Skill vs subagent vs hook — a reference table.**

| Capability needed | Best-fit mechanism | Why |
|---|---|---|
| Repeatable workflow invoked on demand by name | **Skill** (`/slash`) | User controls when it runs; body is the instruction |
| Autonomous parallel worker that returns a result | **Subagent** (`Task` tool) | Runs in its own context; orchestrator waits for output |
| Automatic guard that fires on every tool use | **Hook** (`PreToolUse` / `PostToolUse`) | No user action required; runs transparently |
| One-off prompt you type occasionally | **Inline prompt** | No file needed; not worth packaging |

The rule of thumb: if you find yourself re-typing the same multi-step instruction more than once per day, make it a skill. If you need parallelism or a separate reasoning context, use a subagent. If you need it to run silently on every action, use a hook.

**Composing skills.** A skill body can reference another skill. If `reset-db` ends with the instruction "then run `/seed-db`", Claude will invoke the `seed-db` skill as a follow-up step. This lets you build small, focused skills and compose them rather than writing one monolithic body.

## Check

```bash
./scripts/doctor.sh 024
```

Expected output: `OK lab 024 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before writing any files, list two things you think the skill body must say for Claude to actually run the shell script rather than just describe it. Write your predictions with `echo`.

   ```bash
   echo "prediction 1: ... prediction 2: ..."
   ```

   Expected: any two non-empty predictions printed to stdout.

2. **Run** — create the skill directory and a minimal `SKILL.md` to confirm the structure is accepted.

   ```bash
   mkdir -p quips/.claude/skills/seed-db
   ```

   Create `quips/.claude/skills/seed-db/SKILL.md` with the following content (exact frontmatter required):

   ```markdown
   ---
   name: seed-db
   description: Insert 10 sample quips into quips.db for demos and testing
   ---

   Run `bash seed.sh` from the `quips/` directory, then verify the row count:

   ```bash
   sqlite3 quips.db "SELECT count(*) FROM quips;"
   ```

   The count should be >= 10. Report the final count.
   ```

   Verify the file exists and is non-empty:

   ```bash
   [[ -s quips/.claude/skills/seed-db/SKILL.md ]] && echo ok
   ```

   Expected: `ok`

3. **Investigate** — examine the Quips schema to write the correct INSERT statements.

   ```bash
   sqlite3 quips/quips.db .schema 2>/dev/null || grep -n 'CREATE\|column' quips/src/db.js | head -20
   ```

   Verify: output shows the `quips` table columns. Confirm you can write a single-row INSERT for the table before moving on.

4. **Modify** — create `quips/.claude/skills/seed-db/seed.sh` with 10 INSERT statements.

   The script should:
   - Change into the `quips/` directory relative to the script location
   - Run 10 `INSERT OR IGNORE INTO quips` statements covering at least three different tags
   - Print `seeded 10 quips` on success

   A minimal structure:

   ```bash
   #!/usr/bin/env bash
   set -euo pipefail
   cd "$(dirname "$0")/../../../"   # reaches quips/ from skills/seed-db/
   sqlite3 quips.db <<'SQL'
   INSERT OR IGNORE INTO quips (text, tag) VALUES ('The best tool is the one you understand.', 'craft');
   INSERT OR IGNORE INTO quips (text, tag) VALUES ('Readable code is a gift to your future self.', 'craft');
   INSERT OR IGNORE INTO quips (text, tag) VALUES ('Optimize for understanding first.', 'craft');
   INSERT OR IGNORE INTO quips (text, tag) VALUES ('A test that never fails is not a test.', 'testing');
   INSERT OR IGNORE INTO quips (text, tag) VALUES ('Tests document intent better than comments.', 'testing');
   INSERT OR IGNORE INTO quips (text, tag) VALUES ('Green does not mean correct.', 'testing');
   INSERT OR IGNORE INTO quips (text, tag) VALUES ('Ship small, learn fast.', 'process');
   INSERT OR IGNORE INTO quips (text, tag) VALUES ('Automation compounds over time.', 'process');
   INSERT OR IGNORE INTO quips (text, tag) VALUES ('The diff is the review.', 'process');
   INSERT OR IGNORE INTO quips (text, tag) VALUES ('Naming is design.', 'craft');
   SQL
   echo "seeded 10 quips"
   ```

   Make the script executable and verify both files exist:

   ```bash
   chmod +x quips/.claude/skills/seed-db/seed.sh
   [[ -s quips/.claude/skills/seed-db/SKILL.md && -s quips/.claude/skills/seed-db/seed.sh ]] && echo ok
   ```

   Expected: `ok`

5. **Make** — launch Claude inside the quips project and invoke the skill.

   ```bash
   cd quips && claude
   ```

   Inside the Claude REPL type:

   ```
   /seed-db
   ```

   After the skill runs, verify the database was seeded (run from your original shell):

   ```bash
   sqlite3 quips/quips.db "SELECT count(*) FROM quips;"
   ```

   Expected: a number >= 10.

## Observe

Write one sentence: what did the skill body need to say for Claude to run the shell script rather than only describe what the script does? Compare this against your predictions from step 1.

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| `/seed-db` is not recognized inside the REPL | Skill directory not under `.claude/skills/` or the directory is misnamed | Confirm the path is exactly `quips/.claude/skills/seed-db/SKILL.md`; restart `claude` if you created the file after starting the session | https://docs.claude.com/en/docs/claude-code/skills |
| Skill runs but the database is still empty | `SKILL.md` body describes the script but does not instruct Claude to execute it | The body must contain an explicit instruction such as "Run `bash seed.sh`"; description alone is not enough | https://docs.claude.com/en/docs/claude-code/skills |
| `seed.sh` exits with a path error | The `cd` in the script resolves to the wrong directory | Print `pwd` inside the script to confirm the working directory; adjust the relative `cd` path until `quips.db` is reachable | https://github.com/anthropics/claude-code |
| Duplicate rows accumulate across invocations | `INSERT` without conflict handling allows repeats | Use `INSERT OR IGNORE` and add a `UNIQUE` constraint on the `text` column, or prefix the script with `DELETE FROM quips;` in non-production environments | https://docs.claude.com/en/docs/claude-code/skills |

## Tasks

Click the checkbox next to each task to mark it done — your progress is saved locally.

### Task 1 — Confirm the required frontmatter keys

**Scenario:** A teammate claims that `title` is a valid frontmatter key for a skill. You want to confirm which keys are actually required.

**Hint:** The two required keys are present in every working `SKILL.md` you have seen in this lab. Check the frontmatter you wrote in step 2.

??? success "Solution"

    The only two required frontmatter keys are `name` and `description`:

    ```yaml
    ---
    name: seed-db
    description: Insert 10 sample quips into quips.db for demos and testing
    ---
    ```

    `title` is not a recognized key. Claude reads `name` to map the slash command and `description` for auto-suggestion. Any other keys are ignored. Verify yours:

    ```bash
    head -5 quips/.claude/skills/seed-db/SKILL.md
    ```

    Expected: the first three lines are `---`, `name: seed-db`, `description: ...`.

### Task 2 — Run seed-db and confirm the row count

**Scenario:** You want to confirm that the skill actually inserted rows, not just printed a success message.

**Hint:** `sqlite3` can run a single query non-interactively with a quoted SQL string as the second argument.

??? success "Solution"

    After invoking `/seed-db` in a Claude session, query the row count directly:

    ```bash
    sqlite3 quips/quips.db "SELECT count(*) FROM quips;"
    ```

    Expected: a number >= 10. If the count is 0, the skill body did not instruct Claude to execute `seed.sh`. Open `SKILL.md` and confirm the body contains an explicit run instruction, not just a description.

### Task 3 — Observe what description wording changes

**Scenario:** You want to understand when Claude surfaces a skill without you typing the slash command.

**Hint:** Open a Claude session and type a natural-language request that matches the skill's description wording closely, then try a vague request ("do the db thing") and compare.

??? success "Solution"

    Start a session:

    ```bash
    cd quips && claude
    ```

    Type a request that matches the description:

    ```
    Insert 10 sample quips into the database for a demo
    ```

    Claude is likely to suggest or invoke `/seed-db` because the description matches. Now try:

    ```
    do the db thing
    ```

    Claude will not recognize this as related to the skill because the description provides no matching signal. Concrete, verb-led descriptions ("Insert 10 sample quips...") are surfaced; vague ones are not. The description is Claude's only signal for auto-suggestion.

### Task 4 — Add a reset-db skill that calls seed-db

**Scenario:** Before each demo you want to wipe all rows and re-seed exactly 10 quips. You want a single `/reset-db` command that does both steps.

**Hint:** The `reset-db` skill body can contain an instruction to invoke `/seed-db` as the final step.

??? success "Solution"

    ```bash
    mkdir -p quips/.claude/skills/reset-db
    ```

    Create `quips/.claude/skills/reset-db/SKILL.md`:

    ```markdown
    ---
    name: reset-db
    description: Delete all quips and re-seed with 10 fresh demo rows
    ---

    Run the following command to delete all rows:

    ```bash
    sqlite3 quips.db "DELETE FROM quips;"
    ```

    Then invoke `/seed-db` to re-populate with 10 sample quips. Report the final row count.
    ```

    Verify the file exists:

    ```bash
    [[ -s quips/.claude/skills/reset-db/SKILL.md ]] && echo ok
    ```

    Expected: `ok`

### Task 5 — Compose /seed-db then /reset-db in sequence

**Scenario:** You want to confirm that running `/reset-db` after `/seed-db` leaves exactly 10 rows — no duplicates from the prior seed.

**Hint:** Run `/seed-db` first, then `/reset-db`, and check the final count.

??? success "Solution"

    Inside a `claude` session in the `quips/` directory:

    ```
    /seed-db
    ```

    Wait for completion, then:

    ```
    /reset-db
    ```

    After both finish, check the row count from a separate shell:

    ```bash
    sqlite3 quips/quips.db "SELECT count(*) FROM quips;"
    ```

    Expected: exactly 10 — `reset-db` deleted all rows including any from the earlier `/seed-db` run, then re-seeded exactly 10 via the `/seed-db` invocation in its body.

### Task 6 — Verify the skill files with verify.sh

**Scenario:** You want to confirm your skill files pass the lab's automated checks before moving on.

**Hint:** The lab provides a `verify.sh` script that exits 0 on success and non-zero with a message on stderr on failure.

??? success "Solution"

    ```bash
    ./scripts/verify.sh 024
    ```

    Expected: exits 0 and prints a confirmation message. If the script exits non-zero, read the stderr message — it will name the missing file or condition. Common causes: `SKILL.md` frontmatter missing a required key, `seed.sh` not executable, or `quips.db` row count below 10.

## Quiz

<div class="ccg-quiz" data-lab="024">
  <div class="ccg-q" data-answer="b">
    <p><strong>Q1.</strong> Which two keys are required in a <code>SKILL.md</code> frontmatter block?</p>
    <label><input type="radio" name="024-q1" value="a"> A. <code>title</code> and <code>body</code></label>
    <label><input type="radio" name="024-q1" value="b"> B. <code>name</code> and <code>description</code></label>
    <label><input type="radio" name="024-q1" value="c"> C. <code>slug</code> and <code>instructions</code></label>
    <label><input type="radio" name="024-q1" value="d"> D. <code>name</code> and <code>version</code></label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain"><code>name</code> maps the slash command (e.g. <code>/seed-db</code>) and <code>description</code> is the signal Claude uses for auto-suggestion. Both are required; any other keys are silently ignored.</p>
  </div>
  <div class="ccg-q" data-answer="c">
    <p><strong>Q2.</strong> You are inside a Claude session started from the <code>quips/</code> directory. The skill directory <code>quips/.claude/skills/seed-db/</code> exists with a valid <code>SKILL.md</code>. How do you invoke the skill?</p>
    <label><input type="radio" name="024-q2" value="a"> A. Type <code>run seed-db</code> at the prompt</label>
    <label><input type="radio" name="024-q2" value="b"> B. Type <code>claude skill seed-db</code> in a new terminal</label>
    <label><input type="radio" name="024-q2" value="c"> C. Type <code>/seed-db</code> at the Claude prompt</label>
    <label><input type="radio" name="024-q2" value="d"> D. Type <code>@seed-db</code> at the Claude prompt</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Skills are invoked with a leading slash matching the <code>name</code> key in frontmatter. Claude discovers skill directories at invocation time — no restart required after creating the file.</p>
  </div>
  <div class="ccg-q" data-answer="a">
    <p><strong>Q3.</strong> A colleague needs a worker that runs in a separate reasoning context and returns a result to an orchestrator. Which mechanism is the right fit?</p>
    <label><input type="radio" name="024-q3" value="a"> A. Subagent (launched via the <code>Task</code> tool)</label>
    <label><input type="radio" name="024-q3" value="b"> B. Skill (<code>/slash</code> command)</label>
    <label><input type="radio" name="024-q3" value="c"> C. Hook (<code>PreToolUse</code>)</label>
    <label><input type="radio" name="024-q3" value="d"> D. A long inline prompt</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Subagents run in their own context and return output to the orchestrator — ideal for parallelism and isolation. Skills run inline in the current session context. Hooks fire automatically on every matching tool use. Inline prompts leave no reusable artifact.</p>
  </div>
  <div class="ccg-q" data-answer="d">
    <p><strong>Q4.</strong> Your <code>seed.sh</code> script needs to be invoked by Claude via the skill body. What permission does the file require?</p>
    <label><input type="radio" name="024-q4" value="a"> A. No special permission — Claude can run any file in the project</label>
    <label><input type="radio" name="024-q4" value="b"> B. Read permission (<code>chmod 444</code>)</label>
    <label><input type="radio" name="024-q4" value="c"> C. Write permission so Claude can edit it before running</label>
    <label><input type="radio" name="024-q4" value="d"> D. Execute permission (<code>chmod +x</code>)</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Claude runs <code>seed.sh</code> via the Bash tool, which calls the OS to execute the file. The OS requires the execute bit to be set. Without <code>chmod +x</code> the shell returns <code>Permission denied</code> even if the file content is correct.</p>
  </div>
</div>

## Stretch (optional, ~10 min)

Add a third skill called `check-db` that runs `SELECT count(*), tag FROM quips GROUP BY tag ORDER BY count(*) DESC;` and formats the output as a Markdown table in its reply. Then compose all three: `/seed-db`, `/reset-db`, `/check-db`. Observe how the description you give `check-db` affects whether Claude suggests it when you ask "how many quips do we have per tag?".

## Recall

In Lab 019, what are the two exit-code behaviours a `verify.sh` script must demonstrate?

> Expected: exit 0 when the feature is present and correct; exit non-zero with a one-line message on stderr when the feature is broken or missing.

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/skills
- https://docs.claude.com/en/docs/claude-code/overview
- https://github.com/anthropics/claude-code

## Next

→ **Lab 025 — MCP** — connect an external MCP server to Quips and invoke its tools from inside a Claude session.
