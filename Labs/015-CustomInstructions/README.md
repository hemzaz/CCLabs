# Lab 015 — Custom Instructions

⏱ **20 min**   📦 **You'll add**: `quips/src/CLAUDE.md`   🔗 **Builds on**: Lab 014   🎯 **Success**: `quips/src/CLAUDE.md exists, non-empty, distinct from quips/CLAUDE.md`

<!--
  Template contract - do not remove this comment.
  CI (lint-prose + structure linter) enforces:
    1. Header line above (one line, five fields, in this exact order)
    2. Nine sections below (in this exact order, same H2 titles)
    3. Single new concept (a "Concept:" Bloom-tagged line)
    4. Every Do step ends with a verify COMMAND, not a screenshot
  See CONTRIBUTING.md and docs/DESIGN.md §7 for the full author contract.
-->

**Concept**: `Nested CLAUDE.md for subdirectory-scoped rules` (Bloom: Create)

---

## Why

A project root `CLAUDE.md` covers the whole codebase, but some rules are only meaningful inside a specific subtree. Placing a second `CLAUDE.md` inside `src/` lets you scope stricter rules — like "no `console.log`" or "every route handler needs a JSDoc comment" — exactly where they apply without cluttering the project-wide file. Claude merges both files when you work in `src/`, and ignores the nested one everywhere else.

## Check

```bash
./scripts/doctor.sh 015
```

Expected output: `OK lab 015 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before writing anything, decide: which rules belong in `quips/CLAUDE.md` (project-wide) vs `quips/src/CLAUDE.md` (src-specific)? Write one rule for each scope, then verify `quips/CLAUDE.md` already exists from Lab 011:

   ```bash
   [[ -f quips/CLAUDE.md ]] && echo "quips/CLAUDE.md present" || echo "missing — complete Lab 011 first"
   ```
   Expected: `quips/CLAUDE.md present`

2. **Run** — read the official memory docs to understand how nested `CLAUDE.md` scoping works:

   https://docs.claude.com/en/docs/claude-code/memory

   Verify you can describe in one sentence how Claude merges nested CLAUDE.md files:

   ```bash
   echo "confirm: Claude loads all CLAUDE.md files from cwd up to the project root, innermost wins on conflicts"
   ```

3. **Investigate** — design two distinct rule sets. Project-wide rules already live in `quips/CLAUDE.md` (e.g. "always use Vitest"). Write down at least two src-specific rules that only make sense inside `src/` — for example:
   - `No console.log in src/ — use the logger module instead`
   - `All route handlers must have a JSDoc comment with @param and @returns`

   Verify you have two distinct rule sets written down before proceeding:

   ```bash
   echo "confirm: you have >= 2 project-wide rules (in quips/CLAUDE.md) AND >= 2 src-specific rules ready to write"
   ```

4. **Modify** — create `quips/src/CLAUDE.md` with your src-specific rules. Then verify it exists, is non-empty, and differs from the project-wide file:

   ```bash
   [[ -s quips/src/CLAUDE.md ]] && echo "src CLAUDE.md present and non-empty" || echo "missing or empty"
   diff -q quips/CLAUDE.md quips/src/CLAUDE.md && echo "ERROR: files are identical" || echo "files differ — good"
   ```
   Expected: `src CLAUDE.md present and non-empty` and `files differ — good`

5. **Make** — launch a Claude Code session from inside `quips/src/` and ask what rules apply:

   ```bash
   cd quips/src && claude
   ```

   Inside the REPL type:
   > What rules apply here?

   Verify Claude's answer cites both `quips/CLAUDE.md` and `quips/src/CLAUDE.md`:

   ```bash
   echo "confirm Claude's answer mentions both the project-wide rules (quips/CLAUDE.md) and the src-specific rules (quips/src/CLAUDE.md)"
   ```

## Observe

One sentence — when can nested `CLAUDE.md` files hurt instead of help?

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| Nested CLAUDE.md ignored | Claude reads nested files only when working in that directory; if launched from the root it may not activate inner scopes | `cd` into the subdirectory before starting Claude so the nested file is in scope | https://docs.claude.com/en/docs/claude-code/memory |
| Rules conflict between scopes | Both files define the same rule differently | Inner file (closer to cwd) wins; make the conflict explicit with a comment like `# overrides project-wide rule` | https://docs.claude.com/en/docs/claude-code/memory |
| Too many CLAUDE.md files | Each additional file adds load and maintenance burden | Consolidate; 2–3 files is the sweet spot for most projects | https://docs.claude.com/en/docs/claude-code/memory |

## Stretch (optional, ~10 min)

Create a `quips/test/CLAUDE.md` with a test-authoring rule (e.g. "every test file must have a top-level `describe` block named after the module under test"). Then open a file under `quips/test/` in a Claude session and verify Claude mentions the test-scoped rule.

## Recall

What slash command trims context without wiping it?

> Expected: `/compact`

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/memory
- https://docs.claude.com/en/docs/claude-code/overview

## Next

→ **Checkpoint C** — end of Part III
