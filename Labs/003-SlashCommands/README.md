# Lab 003 — Slash Commands

⏱ **15 min**   📦 **You'll add**: `Labs/003-SlashCommands/notes.md`   🔗 **Builds on**: Lab 002   🎯 **Success**: `notes.md lists at least three slash commands with descriptions`

<!--
  Template contract - do not remove this comment.
  CI (lint-prose + structure linter) enforces:
    1. Header line above (one line, five fields, in this exact order)
    2. Nine sections below (in this exact order, same H2 titles)
    3. Single new concept (a "Concept:" Bloom-tagged line)
    4. Every Do step ends with a verify COMMAND, not a screenshot
  See CONTRIBUTING.md and docs/DESIGN.md §7 for the full author contract.
-->

**Concept**: `slash commands` (Bloom: Apply)

---

## Why

Claude Code's REPL exposes built-in slash commands that let you control session state, memory, and context without leaving the terminal. Knowing which commands exist — and what each one resets — prevents subtle bugs where stale history or loaded files silently affect Claude's answers.

## Check

```bash
./scripts/doctor.sh 003
```

Expected output: `OK lab 003 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before running, write down three slash commands you think might exist in Claude Code (e.g. `/help`, `/clear`, `/exit`).

2. **Run** — open the Claude Code REPL and list all commands:
   ```
   claude
   /help
   ```
   Verify: `claude --help 2>&1 | grep -c '\-\-'` prints a number ≥ 1, confirming the CLI is present.

3. **Investigate** — scroll the `/help` output; note three commands that interest you. Good candidates: `/clear`, `/memory`, `/compact`, `/resume`, `/exit`.

4. **Modify** — inside the REPL, ask a question, then run `/clear`, then ask the same question again. Notice the assistant has no memory of the earlier exchange:
   ```
   /clear
   ```
   Verify: the assistant responds as if it is a fresh session (no reference to prior content).

5. **Make** — create `Labs/003-SlashCommands/notes.md` with exactly three lines, each starting with the slash command name, a dash, and a one-sentence description. Then verify:
   ```bash
   grep -c '^/' Labs/003-SlashCommands/notes.md
   ```
   Expected output: `3` (or higher).

## Observe

Which command surprised you most, and why? Write one sentence describing what you did not expect about its behaviour.

## If stuck

Exactly three entries. Each cites a source URL from `sources.yml` or canonical Anthropic docs.

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| `/help` prints nothing | You are not in the REPL | Type `claude` first to enter the interactive session | https://docs.claude.com/en/docs/claude-code/overview |
| A slash command is unknown | CLI version is old | Run `npm update -g @anthropic-ai/claude-code` to upgrade | https://github.com/anthropics/claude-code |
| `notes.md` fails the 3-line grep | Lines do not start with `/` | Prefix each line with the slash command (e.g. `/help - ...`) | (self-evident; see template) |

## Stretch (optional, ~10 min)

Try `/memory` and `/compact` inside the REPL. In one sentence each, describe what each does differently from `/clear`: does it wipe history, condense it, or modify loaded files?

## Recall

> Where did you save your first REPL transcript, and what command did you run to create it?

Expected answer from Lab 002: `Labs/002-FirstSession/transcript.md`.

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/overview
- https://github.com/anthropics/claude-code

## Next

→ **Lab 004 — Reading a Codebase** — using Claude Code to explore and understand an unfamiliar project.
