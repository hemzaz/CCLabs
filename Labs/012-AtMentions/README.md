# Lab 012 — @ Mentions

⏱ **20 min**   📦 **You'll add**: `Labs/012-AtMentions/session.md`   🔗 **Builds on**: Lab 011   🎯 **Success**: `session.md exists, non-empty, contains at least 3 occurrences of @ followed by a file path`

<!--
  Template contract - do not remove this comment.
  CI (lint-prose + structure linter) enforces:
    1. Header line above (one line, five fields, in this exact order)
    2. Nine sections below (in this exact order, same H2 titles)
    3. Single new concept (a "Concept:" Bloom-tagged line)
    4. Every Do step ends with a verify COMMAND, not a screenshot
  See CONTRIBUTING.md and docs/DESIGN.md §7 for the full author contract.
-->

**Concept**: `Pin context with @ to force Claude to read specific files` (Bloom: Apply)

---

## Why

Claude reads files opportunistically — without hints it may choose the wrong file, or read several before finding the relevant one. Pinning context with `@path` directs Claude to the exact file you mean, cutting wasted tokens and producing sharper answers on the first try. This lab builds the habit of reaching for `@` before asking anything file-specific.

## Check

```bash
./scripts/doctor.sh 012
```

Expected output: `OK lab 012 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — without `@` mentions, how does Claude decide which files to read? Write one sentence before running anything. Then confirm the quips submodule is present:

   ```bash
   [[ -d quips ]] && echo "quips present" || echo "missing quips"
   ```
   Expected: `quips present`

2. **Run** — from the repo root, start a Claude Code session and ask generically, without any `@` path:

   ```bash
   cd .. && claude
   ```

   Type inside the REPL:

   > explain quips

   Observe which files Claude opens via its Read tool calls. Notice whether it reads any file you did not specify.

   Verify the transcript shows at least one Read tool call by Claude before it answers:

   ```bash
   echo "confirm you saw at least one Read tool call in Claude's output"
   ```

3. **Investigate** — still in the same session (or start a fresh one), ask again with an explicit `@` pin:

   > @quips/src/db.js explain how the schema is initialized

   Observe whether Claude reads `quips/src/db.js` first, before any other file. Notice that the `@` path is resolved relative to the repo root where Claude was launched.

   Verify Claude referenced `db.js` specifically in its answer:

   ```bash
   echo "confirm Claude's answer mentions db.js schema details (CREATE TABLE, resetDb, etc.)"
   ```

4. **Modify** — ask a two-file question using two `@` pins in one prompt:

   > @quips/src/server.js @quips/src/db.js explain how POST /quips flows from route to storage

   Verify Claude references both files in its answer:

   ```bash
   echo "confirm Claude's answer covers both server.js route handling and db.js storage"
   ```

5. **Make** — save an excerpt of the three exchanges above (steps 2, 3, 4) to `Labs/012-AtMentions/session.md`. The file must preserve the `@path` lines exactly as you typed them. Then verify:

   ```bash
   ./scripts/verify.sh 012
   ```
   Expected: `OK lab 012 verified`

## Observe

One sentence — when does a plain question waste tokens vs an `@`-pinned one?

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| `@` isn't expanding | Path doesn't exist or is misspelled | Check the path with `ls quips/src/` and paste the exact filename | https://docs.claude.com/en/docs/claude-code/overview |
| Claude ignores `@` for image files | Some file extensions are not supported as inline context | Paste the file content inline instead of using `@` | https://docs.claude.com/en/docs/claude-code/common-workflows |
| Too many `@` mentions blow the context window | Pinning many large files at once exhausts the token budget | Pin one file per turn rather than five at once | https://docs.claude.com/en/docs/claude-code/common-workflows |

## Stretch (optional, ~10 min)

Pin a directory instead of a single file (`@quips/src/`) and ask Claude to enumerate the files it finds there. Compare Claude's output to the result of `ls quips/src/` — are they identical?

## Recall

What file introduced in Lab 011 does Claude read automatically at session start?

> Expected: `quips/CLAUDE.md`

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/common-workflows
- https://docs.claude.com/en/docs/claude-code/overview

## Next

→ **Lab 013 — Settings Layering** — control Claude's behaviour per-project and per-user with layered settings files.
