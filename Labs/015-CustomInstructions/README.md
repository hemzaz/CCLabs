# Lab 015 — Custom Instructions

⏱ **25 min**   📦 **You'll add**: `quips/src/CLAUDE.md`, `quips/test/CLAUDE.md`   🔗 **Builds on**: Lab 014   🎯 **Success**: `quips/src/CLAUDE.md and quips/test/CLAUDE.md exist, each with rules distinct from the root file`

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
    - You will learn how Claude merges multiple `CLAUDE.md` files from your current working directory up through the project root.
    - You will create a `src`-specific `CLAUDE.md` with rules that only apply inside the source tree.
    - You will create a `test`-specific `CLAUDE.md` and observe that it stays invisible in other subdirectories.
    - By the end you can confidently place the right rule in the right file and know exactly when Claude will see it.

**Concept**: `Nested CLAUDE.md for subdirectory-scoped rules` (Bloom: Create)

---

## Prerequisites

- Completed [Lab 014 — Compaction](../014-Compaction/README.md)
- `quips/CLAUDE.md` exists and is non-empty (created in Lab 011)
- `quips/src/` directory present from the Quips project structure

## What You Will Learn

- How Claude discovers and merges multiple `CLAUDE.md` files along the directory ancestry
- The "innermost wins" rule for conflicting instructions across scopes
- How the directory Claude is launched from determines which nested files are in scope
- A practical framework for deciding which rule belongs in which file

## Why

A project-root `CLAUDE.md` covers the whole codebase, but some rules are only meaningful inside a specific subtree. Placing a second `CLAUDE.md` inside `src/` lets you scope stricter rules — such as "no `console.log`" or "every route handler needs a JSDoc comment" — exactly where they apply without cluttering the project-wide file. Claude merges both files when you work in `src/`, and the nested file plays no role when you work elsewhere in the project.

## Walkthrough

### How Claude discovers CLAUDE.md files

When you launch Claude Code from a directory, it walks upward through every ancestor directory until it reaches the project root (the directory containing a `.git` folder). Every `CLAUDE.md` it finds along the way is loaded and concatenated into the effective instruction set for that session.

For a session started from `quips/src/`:

```
quips/src/CLAUDE.md        ← loaded (innermost)
quips/CLAUDE.md            ← loaded (project root)
```

For a session started from `quips/test/`:

```
quips/test/CLAUDE.md       ← loaded (innermost)
quips/CLAUDE.md            ← loaded (project root)
```

For a session started from `quips/`:

```
quips/CLAUDE.md            ← loaded only
```

The `src/` and `test/` files are **not** activated when Claude is launched from the project root. This is the single most common misconception with nested `CLAUDE.md` files: the launch directory determines the scope, not the files you have open.

### Merge behavior and the "innermost wins" rule

Claude concatenates all discovered files into a single effective context. When the same topic appears in more than one file, the instruction closest to the current working directory takes precedence. This lets you override a project-wide default for a specific subtree:

| File | Rule |
|---|---|
| `quips/CLAUDE.md` | `Log all errors with the project logger` |
| `quips/src/CLAUDE.md` | `Never call console.log — use logger.error() and logger.info() instead` |

The `src/` rule narrows the project-wide rule to a specific API. Claude respects the more specific form when working inside `src/`.

### Reference table: which file for which rule

| Rule kind | Where to put it | Example |
|---|---|---|
| Framework or toolchain choice | Project root | `Always use Vitest, never Jest` |
| Repository-wide naming convention | Project root | `Use camelCase for variables, PascalCase for classes` |
| Source-code-specific constraints | `src/CLAUDE.md` | `No console.log — use the logger module` |
| Source-code API requirements | `src/CLAUDE.md` | `Every route handler must have a JSDoc @param and @returns` |
| Test authoring standards | `test/CLAUDE.md` | `Every test file needs a top-level describe block named after the module` |
| Test fixture conventions | `test/CLAUDE.md` | `Use resetDb() from test/helpers.js — never drop tables manually` |
| CI or script behavior | Project root | `Always run npm test before committing` |

### Project-wide vs src-specific: a concrete contrast

**Project-wide** (`quips/CLAUDE.md`):

```
Always use Vitest, never Jest.
```

This applies everywhere in the project — routes, utilities, tests — because it is a toolchain choice that must be consistent across every file.

**src-specific** (`quips/src/CLAUDE.md`):

```
No console.log in src/ — use logger.info() or logger.error() instead.
All route handlers must have a JSDoc comment with @param and @returns.
```

These rules would be noise in the test directory (tests rarely export route handlers) and irrelevant at the project root. Scoping them to `src/` keeps each file focused on its own context.

### How many files is too many

Two to three `CLAUDE.md` files is the sweet spot for most projects. Every additional file adds cognitive overhead: you have to remember which file holds which rule, and Claude has to load more context per session. A good rule of thumb: if you are writing a rule, ask whether it applies everywhere. If yes, put it in the root file. If it only matters in one subtree, put it there. If you find yourself writing more than three files, consolidate — the maintenance cost outweighs the scoping benefit.

## Check

```bash
./scripts/doctor.sh 015
```

Expected output: `OK lab 015 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before writing anything, decide which category each of these rules belongs in. Write your answers down before checking:
   - "Always use Vitest" — project root or `src/`?
   - "No `console.log`" — project root or `src/`?
   - "Every test file has a top-level `describe` block" — `src/` or `test/`?

   Then verify that `quips/CLAUDE.md` already exists from Lab 011:

   ```bash
   [[ -f quips/CLAUDE.md ]] && echo "quips/CLAUDE.md present" || echo "missing — complete Lab 011 first"
   ```

   Expected: `quips/CLAUDE.md present`

2. **Run** — read the official memory documentation to confirm how the discovery walk works:

   https://docs.claude.com/en/docs/claude-code/memory

   Then verify you can state the merge order in one sentence:

   ```bash
   echo "confirm: Claude loads CLAUDE.md files from cwd upward to the project root; innermost wins on conflicts"
   ```

3. **Investigate** — examine your existing root file to understand what is already covered, so the new files add only what is missing:

   ```bash
   cat quips/CLAUDE.md
   ```

   Verify the root file contains at least one rule you consider project-wide:

   ```bash
   grep -cE '^[-*]|^[0-9]+\.' quips/CLAUDE.md
   ```

   Expected: a number >= 1.

4. **Modify** — create `quips/src/CLAUDE.md` with at least two src-specific rules, then verify it exists, is non-empty, and differs from the root file:

   ```bash
   [[ -s quips/src/CLAUDE.md ]] && echo "src/CLAUDE.md present and non-empty" || echo "missing or empty"
   diff -q quips/CLAUDE.md quips/src/CLAUDE.md && echo "ERROR: files are identical" || echo "files differ — good"
   ```

   Expected: `src/CLAUDE.md present and non-empty` and `files differ — good`.

5. **Make** — launch a Claude Code session from inside `quips/src/` and ask what rules apply, then confirm Claude cites both the project-wide and src-specific rules:

   ```bash
   cd quips/src && claude -p "What rules apply in this directory? List them."
   ```

   Verify Claude's answer mentions rules from both `quips/CLAUDE.md` and `quips/src/CLAUDE.md`:

   ```bash
   echo "confirm: Claude's answer includes at least one rule from the project root AND at least one src-specific rule"
   ```

## Observe

In one paragraph: Claude cited both files when launched from `quips/src/`. What would change — and why — if you launched from `quips/` instead of from `quips/src/`? Write the answer in your own words before the Tasks section tests it.

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| Nested `CLAUDE.md` is ignored | Claude only loads files found in the cwd-to-root walk; launching from `quips/` does not activate `quips/src/CLAUDE.md` | `cd quips/src` before starting Claude so the nested file falls on the walk | https://docs.claude.com/en/docs/claude-code/memory |
| Two rules conflict and Claude picks the wrong one | Outer file's rule is more specific than the inner file's rule, so the merge is ambiguous | Make the inner rule more explicit and add a comment like `# overrides project-wide rule` | https://docs.claude.com/en/docs/claude-code/memory |
| Maintaining five or more CLAUDE.md files feels fragile | Too many files splits context across too many scopes | Consolidate: keep project root + one per major subtree (`src/`, `test/`) and no deeper | https://docs.claude.com/en/docs/claude-code/memory |

## Tasks

Click the checkbox next to each task to mark it done — your progress is saved locally.

### Task 1 — Write a src-specific CLAUDE.md with two distinct rules

**Scenario:** Your Quips project logs debug output with `console.log`. You want Claude to stop suggesting `console.log` calls inside `src/` and to require JSDoc comments on every exported function. The project root already says "use Vitest" — these two rules belong in a narrower scope.

**Hint:** Create `quips/src/CLAUDE.md` and write exactly two rules as bullet points. Make each rule specific enough that Claude could verify compliance on a given file.

??? success "Solution"

    ```bash
    mkdir -p quips/src
    cat > quips/src/CLAUDE.md << 'EOF'
    # src-specific rules

    - No console.log in src/ — use logger.info() or logger.error() from lib/logger.js instead.
    - Every exported function must have a JSDoc comment with at least one @param and one @returns tag.
    EOF

    # Verify
    cat quips/src/CLAUDE.md
    diff -q quips/CLAUDE.md quips/src/CLAUDE.md && echo "ERROR: identical" || echo "files differ — good"
    ```

### Task 2 — Create a test-specific CLAUDE.md with one rule

**Scenario:** Test files in `quips/test/` are inconsistently structured — some have a top-level `describe` block, some do not. You want Claude to enforce this convention only inside the test directory, not in `src/`.

**Hint:** Create `quips/test/CLAUDE.md` with a single, specific rule about `describe` block structure.

??? success "Solution"

    ```bash
    mkdir -p quips/test
    cat > quips/test/CLAUDE.md << 'EOF'
    # test-specific rules

    - Every test file must have exactly one top-level describe() block named after the module under test (e.g. describe('routes/random', () => { ... })).
    EOF

    # Verify
    [[ -s quips/test/CLAUDE.md ]] && echo "test/CLAUDE.md present and non-empty" || echo "missing or empty"
    ```

### Task 3 — Verify Claude cites both files when launched from a subdirectory

**Scenario:** You have written `quips/src/CLAUDE.md` and want to confirm Claude actually loads both the project-root file and the src-specific file during a session started from `quips/src/`.

**Hint:** Launch Claude from inside `quips/src/` using `-p` and ask it to list all rules it is aware of. Look for rules that could only have come from each file.

??? success "Solution"

    ```bash
    cd quips/src && claude -p "List every rule you have been given. For each rule, indicate whether it is project-wide or src-specific."
    # Confirm output includes:
    #   - At least one rule from quips/CLAUDE.md (e.g. "use Vitest")
    #   - At least one rule from quips/src/CLAUDE.md (e.g. "no console.log")
    ```

### Task 4 — Intentionally conflict two rules and observe which wins

**Scenario:** `quips/CLAUDE.md` says `Log errors with console.error for now`. `quips/src/CLAUDE.md` says `Never call console.log or console.error — use logger.error() instead`. You want to see which instruction Claude follows inside `src/`.

**Hint:** Add the conflicting rule to `quips/CLAUDE.md`, then ask Claude from inside `quips/src/` how it should log an error. The inner file should win.

??? success "Solution"

    ```bash
    # 1. Add a conflicting rule to the project root
    echo "- Log errors with console.error for now." >> quips/CLAUDE.md

    # 2. Confirm the inner file already has the stricter rule
    grep "logger" quips/src/CLAUDE.md

    # 3. Ask Claude from inside src/ which form to use
    cd quips/src && claude -p "I need to log an error in a route handler. Which logging approach should I use?"
    # Expected: Claude recommends logger.error(), citing the src-specific rule as the active instruction.

    # 4. Clean up the artificial conflict before moving on
    # Edit quips/CLAUDE.md and remove the line you added.
    ```

### Task 5 — Consolidate five files to two and explain why

**Scenario:** A teammate has scattered rules across five `CLAUDE.md` files: `quips/CLAUDE.md`, `quips/src/CLAUDE.md`, `quips/src/routes/CLAUDE.md`, `quips/src/lib/CLAUDE.md`, and `quips/test/CLAUDE.md`. You are asked to reduce this to two files without losing any rules.

**Hint:** Audit each file's rules. Rules that only restrict one sub-subdirectory are usually specific enough to belong in `src/CLAUDE.md` rather than a deeper file. Merge upward.

??? success "Solution"

    ```bash
    # Audit — read each file
    for f in quips/CLAUDE.md quips/src/CLAUDE.md quips/src/routes/CLAUDE.md quips/src/lib/CLAUDE.md quips/test/CLAUDE.md; do
      echo "=== $f ===" && cat "$f" 2>/dev/null || echo "(not found)"
    done

    # Merge src/routes/ and src/lib/ rules into src/CLAUDE.md, then remove them
    # cat quips/src/routes/CLAUDE.md >> quips/src/CLAUDE.md
    # cat quips/src/lib/CLAUDE.md   >> quips/src/CLAUDE.md
    # rm quips/src/routes/CLAUDE.md quips/src/lib/CLAUDE.md

    # Result: two files — quips/CLAUDE.md and quips/src/CLAUDE.md
    # (quips/test/CLAUDE.md counts as the third; merge into src/ if test rules are minimal)

    echo "Consolidated. Two active CLAUDE.md files keep context predictable and maintenance low."
    ```

### Task 6 — Observe what happens when Claude is launched from the project root

**Scenario:** You launch Claude from `quips/` (the project root) instead of from `quips/src/`. You want to confirm that the `src/`-specific rules are not in scope.

**Hint:** Ask the same "list all rules" question you asked in Task 3, but this time from the project root. Compare the output.

??? success "Solution"

    ```bash
    cd quips && claude -p "List every rule you have been given."
    # Expected: output contains only rules from quips/CLAUDE.md.
    # Rules from quips/src/CLAUDE.md should NOT appear because the cwd-to-root
    # walk never descends into src/ — it only walks upward, not downward.
    ```

## Quiz

<div class="ccg-quiz" data-lab="015">
  <div class="ccg-q" data-answer="b">
    <p><strong>Q1.</strong> Claude is launched from <code>quips/src/</code>. Which files does it load, in order from outermost to innermost?</p>
    <label><input type="radio" name="015-q1" value="a"> A. <code>quips/src/CLAUDE.md</code> only</label>
    <label><input type="radio" name="015-q1" value="b"> B. <code>quips/CLAUDE.md</code>, then <code>quips/src/CLAUDE.md</code></label>
    <label><input type="radio" name="015-q1" value="c"> C. All <code>CLAUDE.md</code> files anywhere in the repository</label>
    <label><input type="radio" name="015-q1" value="d"> D. <code>~/.claude/CLAUDE.md</code> and <code>quips/CLAUDE.md</code> only</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Claude walks upward from the current working directory to the project root, loading every <code>CLAUDE.md</code> it encounters. Launched from <code>quips/src/</code>, it loads the project-root file and then the src-specific file. Files in sibling or child directories are never part of the walk.</p>
  </div>
  <div class="ccg-q" data-answer="c">
    <p><strong>Q2.</strong> <code>quips/CLAUDE.md</code> says <code>Log with console.error</code>. <code>quips/src/CLAUDE.md</code> says <code>Never use console — use logger.error()</code>. Which instruction does Claude follow inside <code>quips/src/</code>?</p>
    <label><input type="radio" name="015-q2" value="a"> A. The project-root rule, because it was loaded first</label>
    <label><input type="radio" name="015-q2" value="b"> B. Both equally — Claude averages them</label>
    <label><input type="radio" name="015-q2" value="c"> C. The src-specific rule, because the innermost file wins on conflicts</label>
    <label><input type="radio" name="015-q2" value="d"> D. Neither — conflicting rules cause Claude to ask for clarification</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">When two files define conflicting instructions, the file closest to the current working directory takes precedence. The <code>src/CLAUDE.md</code> rule overrides the project-root rule for any session started inside <code>src/</code>.</p>
  </div>
  <div class="ccg-q" data-answer="a">
    <p><strong>Q3.</strong> You launch Claude from the project root <code>quips/</code>. You have a <code>quips/src/CLAUDE.md</code> with two rules. Which statement is correct?</p>
    <label><input type="radio" name="015-q3" value="a"> A. The <code>src/</code> rules are not in scope — they will not appear in Claude's effective instructions</label>
    <label><input type="radio" name="015-q3" value="b"> B. The <code>src/</code> rules are in scope because the project root is a parent of <code>src/</code></label>
    <label><input type="radio" name="015-q3" value="c"> C. The <code>src/</code> rules are in scope only if you open a file inside <code>src/</code></label>
    <label><input type="radio" name="015-q3" value="d"> D. Claude auto-detects all subdirectory <code>CLAUDE.md</code> files regardless of launch directory</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">The walk goes upward, not downward. Launching from <code>quips/</code> means the walk stops at <code>quips/CLAUDE.md</code> and never descends into <code>src/</code>. To activate nested files, you must launch from inside that subdirectory.</p>
  </div>
  <div class="ccg-q" data-answer="b">
    <p><strong>Q4.</strong> A project has <code>CLAUDE.md</code> files at the root, in <code>src/</code>, in <code>src/routes/</code>, in <code>src/lib/</code>, and in <code>test/</code>. What is the practical concern with this arrangement?</p>
    <label><input type="radio" name="015-q4" value="a"> A. Claude cannot load more than two <code>CLAUDE.md</code> files at once</label>
    <label><input type="radio" name="015-q4" value="b"> B. Each additional file increases maintenance burden and makes it harder to know which scope holds each rule</label>
    <label><input type="radio" name="015-q4" value="c"> C. Nested files at depth three or greater are silently ignored by Claude</label>
    <label><input type="radio" name="015-q4" value="d"> D. Having five files causes Claude to randomly select which file to obey</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Claude supports any depth of nesting, but each file adds cognitive and maintenance overhead. Two to three files (project root, one per major subtree) is the practical sweet spot. More than that and you spend more time tracking which rule lives where than you save on scoping precision.</p>
  </div>
</div>

## Stretch (optional, ~10 min)

Add an intentional override to `quips/src/CLAUDE.md` that contradicts a rule in `quips/CLAUDE.md`, but include a comment explaining the override:

```markdown
# Overrides project-wide "log with console.error" rule — src/ uses structured logger
- Never call console.error — use logger.error({ err }, 'message') from lib/logger.js.
```

Then launch Claude from `quips/src/` and confirm it applies the override. Finally, remove the conflicting project-wide rule and observe whether Claude's behavior changes.

## Recall

What is the keyboard shortcut (or slash command) that compacts the Claude Code conversation without clearing it entirely?

> Expected: `/compact` — covered in Lab 014.

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/memory
- https://docs.claude.com/en/docs/claude-code/overview

## Next

→ **Checkpoint C** — end of Part III, consolidating everything from Labs 011–015 before Week 2 begins.
