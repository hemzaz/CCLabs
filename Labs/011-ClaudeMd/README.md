# Lab 011 — CLAUDE.md

⏱ **20 min**   📦 **You'll add**: `quips/CLAUDE.md`   🔗 **Builds on**: Checkpoint B   🎯 **Success**: `quips/CLAUDE.md exists, non-empty, contains >= 3 rule lines`

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
    - You will learn what `CLAUDE.md` is and how Claude loads it automatically on every session start.
    - You will write concrete, testable rules for the Quips project and verify that Claude respects them.
    - You will practice the good-rule vs vague-rule distinction using a reference table of patterns.
    - By the end you can give Claude persistent project context without re-explaining rules in every prompt.

**Concept**: `Project memory: CLAUDE.md steers Claude automatically` (Bloom: Create)

---

## Prerequisites

- Completed Checkpoint B (Labs 006–010 green)
- `quips/` submodule initialized (`[[ -d quips ]] && echo ok`)
- `claude --version` exits 0 and `claude -p "ping"` returns output

## What You Will Learn

- What `CLAUDE.md` is and why Claude reads it without being asked
- Where `CLAUDE.md` files can live: project root, user home (`~/.claude/CLAUDE.md`), and nested subdirectories
- How scope merging works when both a project and user `CLAUDE.md` exist
- How to write rules that are testable rather than vague
- How to confirm that Claude actually loads and respects a rule you wrote

## Why

Every project has unwritten rules — which test framework to use, which database helper to call, what coverage threshold counts as green. Without `CLAUDE.md` you re-explain those rules at the start of every session, and Claude still sometimes forgets them mid-conversation. Writing them once in `CLAUDE.md` makes them permanent: Claude reads the file automatically on startup and treats its contents as standing instructions for every turn in that session.

## Walkthrough

### What CLAUDE.md is

`CLAUDE.md` is a plain Markdown file that Claude Code reads automatically when a session starts. You do not need to reference it in your prompt — Claude finds it, reads it, and internalises its contents before your first message arrives. Think of it as a project briefing that every session begins with.

### Where it lives

Claude looks for `CLAUDE.md` files in three places, each with a different scope:

| Location | Scope | Typical contents |
|---|---|---|
| `<project-root>/CLAUDE.md` | All sessions inside that project directory | Test framework, DB helpers, naming conventions, coverage requirements |
| `~/.claude/CLAUDE.md` | Every project on your machine (user-global) | Preferred response language, always-on style rules, personal conventions |
| `<subdirectory>/CLAUDE.md` | Sessions started from that subdirectory | Subsystem-specific rules, e.g. rules only for `src/api/` |

Claude merges all files it finds. When the same topic appears in both a user-global file and a project-level file, the project-level file wins — more specific context takes precedence.

### How Claude auto-loads it

When you run `claude` inside a directory, Claude Code walks up the filesystem from your current working directory to the repository root, collecting every `CLAUDE.md` it encounters. It also reads `~/.claude/CLAUDE.md` if it exists. All found files are concatenated into the session context before the first user turn. No slash command, no `@` mention, no manual step required.

### Rules should be testable, not vague

The most common mistake with `CLAUDE.md` is writing instructions that sound helpful but give Claude nothing to check. Claude is a reasoning model — it can follow concrete rules reliably, but fuzzy preferences produce fuzzy results.

Use this table as a reference before writing any rule:

| Shape | Example | Why it works or fails |
|---|---|---|
| **Testable (good)** | `Always use Vitest, never Jest` | Claude can check every `import` and `require` call against this rule |
| **Testable (good)** | `Never mock better-sqlite3 — use resetDb() from test/helpers.js` | Names the exact alternative; Claude knows what "mocking it" looks like |
| **Testable (good)** | `Every new route needs at least one success test and one error test` | A test file either contains both or it does not — no ambiguity |
| **Vague (bad)** | `Be careful with the database` | "Careful" has no observable meaning; Claude cannot verify compliance |
| **Vague (bad)** | `Write good tests` | "Good" is undefined; offers no constraint Claude can enforce |
| **Vague (bad)** | `Follow best practices` | Every model already believes it follows best practices; this adds nothing |

A useful heuristic: if you cannot write a two-line bash check that verifies the rule, the rule is probably too vague. For example, `grep -r 'console.log' src/ && echo VIOLATION || echo OK` can verify a "no console.log in src/" rule. "Write clean code" cannot be verified that way.

### Splitting rules into files

A single project-root `CLAUDE.md` is the right starting point. If a subsystem has its own team or its own toolchain that conflicts with the project default, create a `CLAUDE.md` inside that subdirectory. Claude picks up both, and the subdirectory file takes precedence for sessions started from there. Lab 015 covers this nested-scope pattern in depth.

## Check

```bash
./scripts/doctor.sh 011
```

Expected output: `OK lab 011 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before writing anything, name three rules you would want Claude to always follow inside the Quips project. Write them down on paper or in a scratch file. For each rule, ask: "Can I write a one-line bash check for this?" If not, rewrite the rule until you can.

   Verify the `quips` directory exists before continuing:

   ```bash
   [[ -d quips ]] && echo "quips present" || echo "missing quips — run: git submodule update --init quips"
   ```

   Expected: `quips present`

2. **Run** — launch Claude Code inside the quips project and ask what `CLAUDE.md` does:

   ```bash
   cd quips && claude -p "What is CLAUDE.md used for in Claude Code? Answer in two sentences."
   ```

   Verify Claude's answer references project memory or auto-loaded context:

   ```bash
   cd quips && claude -p "What is CLAUDE.md used for in Claude Code? Answer in two sentences." | grep -iE 'memory|auto|load|startup|project'
   ```

   Expected: at least one of those words appears in the output.

3. **Investigate** — read the official memory docs to understand the three scopes:

   https://docs.claude.com/en/docs/claude-code/memory

   Verify you can name the three scopes before moving on:

   ```bash
   echo "three scopes: project-root CLAUDE.md, user ~/.claude/CLAUDE.md, nested subdirectory CLAUDE.md"
   ```

   Expected: `echo` exits 0 (this is a self-check step — compare the printed scopes to your notes).

4. **Modify** — create `quips/CLAUDE.md` with your three rules. Use the good-rule shape from the Walkthrough table. Example rules to adapt:

   ```markdown
   # Quips project rules

   - Always use Vitest for tests, never Jest.
   - Never mock better-sqlite3 directly — use resetDb() from test/helpers.js instead.
   - Every new route file must have at least one success test and one error test.
   ```

   Verify the file exists and contains at least three rule lines:

   ```bash
   wc -l quips/CLAUDE.md
   grep -cE '^[-*]|^[0-9]+\.' quips/CLAUDE.md
   ```

   Expected: `wc -l` shows >= 3 lines; `grep -cE` count is >= 3.

5. **Make** — open a fresh Claude Code session in `quips` and ask what rules apply:

   ```bash
   cd quips && claude -p "What rules should I follow in this project? List them."
   ```

   Verify Claude repeats at least one of your rules verbatim or with only minor paraphrasing:

   ```bash
   ./scripts/verify.sh 011
   ```

   Expected: `OK lab 011 verify green`

## Observe

In one sentence, describe when a `CLAUDE.md` rule is worth writing versus leaving implicit. Consider: what is the cost of Claude getting that thing wrong, and how often does it come up?

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| Claude ignores `CLAUDE.md` entirely | File is in the wrong location — must be at the directory root where you start the session | Confirm the file path with `ls quips/CLAUDE.md`; restart Claude from inside the `quips/` directory | https://docs.claude.com/en/docs/claude-code/memory |
| Rules too vague — Claude sometimes complies, sometimes does not | Fuzzy instructions produce inconsistent results; Claude cannot verify compliance | Rewrite each rule so a `grep` or `wc` check could verify it; use the good/bad table in the Walkthrough | https://docs.claude.com/en/docs/claude-code/memory |
| Rules at two scopes contradict each other | Conflicting directives in `~/.claude/CLAUDE.md` and `quips/CLAUDE.md` | Project-level rules take precedence; deduplicate and move shared rules to the project file; nested scope is covered in Lab 015 | https://docs.claude.com/en/docs/claude-code/memory |

## Tasks

Click the checkbox next to each task to mark it done — your progress is saved locally.

### Task 1 — Write three testable rules for Quips

**Scenario:** You are onboarding a new team member and want Claude to help them stay consistent with the project's conventions from day one. You need to write the initial `quips/CLAUDE.md` with at least three rules that Claude can actually enforce.

**Hint:** Each rule should name a specific tool, helper, or numeric threshold — not a vague preference. Use the good/bad shape table in the Walkthrough.

??? success "Solution"

    ```markdown
    # Quips project rules

    - Always use Vitest for tests, never Jest.
    - Never mock better-sqlite3 directly — use resetDb() from test/helpers.js.
    - Every new Express route must have at least one success test and one error-path test.
    - Do not use console.log in src/ — use the logger in src/lib/logger.js instead.
    ```

    Verify:
    ```bash
    grep -cE '^[-*]|^[0-9]+\.' quips/CLAUDE.md
    # Expected: 4 (or however many rules you wrote)
    ```

### Task 2 — Rewrite a vague rule into a testable one

**Scenario:** A colleague added `Be careful with the database` to `quips/CLAUDE.md`. Claude is ignoring it. You need to rewrite it into something Claude can actually enforce.

**Hint:** Identify what "careful with the database" really means in this project (use `resetDb()`, avoid raw SQL, avoid mocking). Then name the specific thing.

??? success "Solution"

    Replace the vague rule with a testable alternative:

    ```markdown
    # Before (vague — Claude cannot check this):
    - Be careful with the database.

    # After (testable — Claude can check every test file):
    - Never mock better-sqlite3 directly. Always call resetDb() from test/helpers.js to reset state between tests.
    ```

    Verify the rewrite appears in the file:
    ```bash
    grep 'resetDb' quips/CLAUDE.md
    # Expected: line containing resetDb()
    ```

### Task 3 — Add a rule forbidding console.log and observe whether Claude respects it

**Scenario:** The `quips` project uses a structured logger (`src/lib/logger.js`). You want to make sure Claude never adds raw `console.log` calls when it writes new code.

**Hint:** Add the rule to `quips/CLAUDE.md`, then start a fresh session and ask Claude to add a debug line to a route. Watch whether it reaches for `console.log` or the logger.

??? success "Solution"

    **a.** Add the rule:
    ```markdown
    - Do not use console.log in src/ — import and use the logger from src/lib/logger.js instead.
    ```

    **b.** Open a fresh session and prompt Claude:
    ```bash
    cd quips && claude -p "Add a debug line to src/routes/random.js that logs 'hit /random' when the route is called."
    ```

    **c.** Inspect the output. Claude should reach for the logger, not `console.log`:
    ```bash
    # Check what Claude generated (paste its output or check the file if it edited it):
    grep 'console.log' src/routes/random.js && echo "VIOLATION — rule not respected" || echo "OK — no console.log"
    ```

    Expected: `OK — no console.log`

    If Claude did use `console.log`, the rule phrasing may need strengthening. Try: `Never call console.log anywhere in the src/ directory.`

### Task 4 — Create a user-global CLAUDE.md with an always-rule

**Scenario:** You want every Claude Code session on your machine — regardless of which project you are in — to respond in a consistent style: concise answers, no preamble, no sign-off phrases.

**Hint:** The user-global file lives at `~/.claude/CLAUDE.md`. Rules there apply to every project unless overridden at the project level.

??? success "Solution"

    ```bash
    mkdir -p ~/.claude
    cat >> ~/.claude/CLAUDE.md << 'EOF'

    # Always-on personal rules
    - Respond concisely. No preamble, no sign-off phrases.
    - Do not start answers with "Certainly", "Sure", or "Of course".
    EOF
    ```

    Verify the file exists and contains the rule:
    ```bash
    grep -c 'preamble' ~/.claude/CLAUDE.md
    # Expected: 1
    ```

    Test it in any project:
    ```bash
    claude -p "What is 2 + 2?"
    # Expected: a direct answer, no "Certainly! The answer is..."
    ```

### Task 5 — Observe scope merging at project vs user level

**Scenario:** You have both `~/.claude/CLAUDE.md` (user-global) and `quips/CLAUDE.md` (project-level). You want to understand which rules are active in a session started from `quips/`, and what happens when the two files say different things about the same topic.

**Hint:** Add a rule to `~/.claude/CLAUDE.md` that conflicts with a rule in `quips/CLAUDE.md`, then ask Claude what rules apply. The project-level rule should win.

??? success "Solution"

    **a.** Add a conflicting rule to the user-global file:
    ```bash
    echo "- Prefer Jest for JavaScript tests." >> ~/.claude/CLAUDE.md
    ```

    **b.** `quips/CLAUDE.md` already says: `Always use Vitest, never Jest.`

    **c.** Ask Claude which testing framework to use:
    ```bash
    cd quips && claude -p "Which test framework should I use in this project, and why?"
    ```

    Expected: Claude answers Vitest, citing the project rule. The project-level rule takes precedence over the user-global one.

    **d.** Clean up the conflicting global rule:
    ```bash
    # Remove the Jest line from ~/.claude/CLAUDE.md
    grep -v 'Prefer Jest' ~/.claude/CLAUDE.md > /tmp/cmc.tmp && mv /tmp/cmc.tmp ~/.claude/CLAUDE.md
    ```

### Task 6 — Write a rule that references the test framework and test helper choice

**Scenario:** You want a single rule in `quips/CLAUDE.md` that captures both the testing tool (Vitest) and the database reset helper (`resetDb()`) so Claude connects them: when it writes a test, it knows both which runner to use and how to set up a clean database state.

**Hint:** A rule can name two things in one sentence if they are always used together. Combining related rules reduces the chance Claude forgets one half of a pair.

??? success "Solution"

    ```markdown
    - Write all tests with Vitest; before each test that touches the database, call resetDb() from test/helpers.js to reset state — never mock better-sqlite3 directly.
    ```

    This single rule ties the framework choice to the database helper so they travel together. Verify it is in the file:
    ```bash
    grep 'Vitest' quips/CLAUDE.md | grep 'resetDb'
    # Expected: one line containing both terms
    ```

## Quiz

<div class="ccg-quiz" data-lab="011">
  <div class="ccg-q" data-answer="b">
    <p><strong>Q1.</strong> Where must a project-level <code>CLAUDE.md</code> live for Claude Code to pick it up automatically?</p>
    <label><input type="radio" name="011-q1" value="a"> A. Inside the <code>.claude/</code> hidden directory at the project root</label>
    <label><input type="radio" name="011-q1" value="b"> B. At the project root directory (same level as <code>package.json</code> or the top-level source files)</label>
    <label><input type="radio" name="011-q1" value="c"> C. Inside <code>~/.claude/projects/</code> with a name matching the project</label>
    <label><input type="radio" name="011-q1" value="d"> D. Anywhere in the repository — Claude searches all subdirectories recursively</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Claude Code looks for <code>CLAUDE.md</code> starting from your current working directory and walking up toward the filesystem root. Placing the file at the project root ensures it is found whenever you start a session from any subdirectory of that project.</p>
  </div>
  <div class="ccg-q" data-answer="c">
    <p><strong>Q2.</strong> You have a rule in <code>~/.claude/CLAUDE.md</code> that says "prefer Jest" and a rule in <code>quips/CLAUDE.md</code> that says "always use Vitest". Which rule does Claude follow when you start a session from inside <code>quips/</code>?</p>
    <label><input type="radio" name="011-q2" value="a"> A. The user-global rule wins because it was loaded first</label>
    <label><input type="radio" name="011-q2" value="b"> B. Claude picks whichever rule appears later in the merged context</label>
    <label><input type="radio" name="011-q2" value="c"> C. The project-level rule wins because more specific context takes precedence</label>
    <label><input type="radio" name="011-q2" value="d"> D. Claude asks you which rule to follow at the start of the session</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">When rules conflict, the more specific scope wins. A project-level <code>CLAUDE.md</code> is more specific than the user-global one, so <code>quips/CLAUDE.md</code> takes precedence for any session started inside <code>quips/</code>.</p>
  </div>
  <div class="ccg-q" data-answer="a">
    <p><strong>Q3.</strong> Which of the following is an example of a well-shaped, testable <code>CLAUDE.md</code> rule?</p>
    <label><input type="radio" name="011-q3" value="a"> A. <code>Never call console.log in src/ — use the logger from src/lib/logger.js instead.</code></label>
    <label><input type="radio" name="011-q3" value="b"> B. <code>Write clean, maintainable code.</code></label>
    <label><input type="radio" name="011-q3" value="c"> C. <code>Be careful with database operations.</code></label>
    <label><input type="radio" name="011-q3" value="d"> D. <code>Follow best practices for testing.</code></label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Option A names a specific thing to avoid (<code>console.log</code>), a specific scope (<code>src/</code>), and a specific alternative (<code>src/lib/logger.js</code>). You can verify compliance with a single <code>grep</code>. The other options are vague preferences that Claude cannot check or enforce reliably.</p>
  </div>
  <div class="ccg-q" data-answer="d">
    <p><strong>Q4.</strong> When should you split a single large <code>CLAUDE.md</code> into multiple files in different directories?</p>
    <label><input type="radio" name="011-q4" value="a"> A. Always — one rule per file is the recommended practice</label>
    <label><input type="radio" name="011-q4" value="b"> B. Never — Claude only reads one <code>CLAUDE.md</code> per session</label>
    <label><input type="radio" name="011-q4" value="c"> C. When the file exceeds 50 lines</label>
    <label><input type="radio" name="011-q4" value="d"> D. When a subdirectory has rules that conflict with or extend the project-level defaults for that subsystem only</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">A project-root <code>CLAUDE.md</code> is the right starting point. You add a subdirectory-level file only when that subsystem genuinely needs rules that differ from the project defaults — for example, a <code>src/api/</code> directory that uses a different auth helper than the rest of the project. Line count alone is not a reason to split.</p>
  </div>
</div>

## Stretch (optional, ~10 min)

Add a rule to `quips/CLAUDE.md` that specifies a minimum test coverage threshold: for example, `Every module in src/ must have test coverage >= 80% as measured by Vitest's --coverage flag`. Then ask Claude to generate a new utility module and its tests. Does Claude mention coverage in its plan, or does it skip straight to the implementation? Observe whether the rule changes how Claude frames the task.

## Recall

What Part I lab produced Quips' `/random` endpoint?

> Expected: Lab 005

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/memory
- https://docs.claude.com/en/docs/claude-code/overview

## Next

→ **Lab 012 — @ Mentions** — target specific files and docs without copy-pasting context
