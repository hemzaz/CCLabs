# Lab 011 — CLAUDE.md

⏱ **20 min**   📦 **You'll add**: `quips/CLAUDE.md`   🔗 **Builds on**: Checkpoint B   🎯 **Success**: `quips/CLAUDE.md exists, non-empty, contains >= 3 rule lines`

<!--
  Template contract - do not remove this comment.
  CI (lint-prose + structure linter) enforces:
    1. Header line above (one line, five fields, in this exact order)
    2. Nine sections below (in this exact order, same H2 titles)
    3. Single new concept (a "Concept:" Bloom-tagged line)
    4. Every Do step ends with a verify COMMAND, not a screenshot
  See CONTRIBUTING.md and docs/DESIGN.md §7 for the full author contract.
-->

**Concept**: `Project memory: CLAUDE.md steers Claude automatically` (Bloom: Create)

---

## Why

Every project has unwritten rules — test frameworks, DB helpers, naming conventions — that you re-explain to Claude every session. A `CLAUDE.md` at the project root makes those rules permanent: Claude reads it automatically on startup, so the rules apply without any prompting. This lab gives you practice writing concrete, enforceable rules rather than vague preferences.

## Check

```bash
./scripts/doctor.sh 011
```

Expected output: `OK lab 011 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before writing anything, name three rules you would want Claude to always follow inside the Quips project (test framework choice, DB reset helper usage, test coverage expectations, etc.). Write them down.

   Verify the quips directory exists before continuing:
   ```bash
   [[ -d quips ]] && echo "quips present" || echo "missing quips — run: git submodule update --init quips"
   ```
   Expected: `quips present`

2. **Run** — launch Claude Code inside the quips project and ask it what `CLAUDE.md` is used for:

   ```bash
   cd quips && claude
   ```

   Inside the REPL type:
   > What is CLAUDE.md used for?

   Verify Claude's answer references project memory or auto-loaded context:
   ```bash
   echo "confirm Claude's answer mentions project memory or auto-loaded context"
   ```

3. **Investigate** — read the official memory docs to understand the three scopes:

   https://docs.claude.com/en/docs/claude-code/memory

   Verify you can name the three scopes (project, user, nested) before moving on:
   ```bash
   echo "name the three CLAUDE.md scopes: project-root, user (~/.claude/CLAUDE.md), nested (subdirectory)"
   ```

4. **Modify** — create `quips/CLAUDE.md` with your three (or more) rules. Example rules to get you started:
   - `Always use Vitest, never Jest`
   - `Never mock better-sqlite3 — use resetDb() from test/helpers.js`
   - `Every new route needs at least one success test and one error test`

   Verify the file exists and has at least three rule lines:
   ```bash
   wc -l quips/CLAUDE.md
   grep -cE '^[-*]|^[0-9]+\.' quips/CLAUDE.md
   ```
   Expected: `wc -l` shows >= 3 lines; `grep -cE` shows >= 3.

5. **Make** — open a fresh Claude Code session in quips and ask:

   ```bash
   cd quips && claude
   ```

   Inside the REPL type:
   > What rules should I follow in this project?

   Verify Claude repeats at least one of your rules verbatim:
   ```bash
   echo "confirm Claude's answer contains at least one rule from quips/CLAUDE.md verbatim"
   ```

## Observe

In one sentence, when is a `CLAUDE.md` rule worth writing vs leaving implicit?

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| Claude ignores CLAUDE.md | Wrong path — file must be at the project root | Ensure the file is at `quips/CLAUDE.md`, not a subdirectory | https://docs.claude.com/en/docs/claude-code/memory |
| Rules too vague ("be careful") | Claude cannot enforce fuzzy instructions | Make rules testable and specific: "every route has a test", "always use resetDb()" | https://docs.claude.com/en/docs/claude-code/memory |
| Rules contradict each other | Conflicting directives at different scopes | Split by scope using nested CLAUDE.md files (covered in Lab 015) | https://docs.claude.com/en/docs/claude-code/memory |

## Stretch (optional, ~10 min)

Add a rule to `quips/CLAUDE.md` that forbids `console.log` in `src/`. Then try to get Claude to add a `console.log` statement in a new route. Does Claude refuse, warn, or comply silently?

## Recall

What Part I lab produced Quips' `/random` endpoint?

> Expected: Lab 005

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/memory
- https://docs.claude.com/en/docs/claude-code/overview

## Next

→ **Lab 012 — @ Mentions** — target specific files and docs without copy-pasting context
