# Lab 007 — Tool Use

⏱ **20 min**   📦 **You'll add**: `observations.md` listing 3+ tools Claude used and what it did with each   🔗 **Builds on**: Lab 006   🎯 **Success**: `observations.md contains at least 3 of: Read, Edit, Write, Bash, Grep, Glob, Task — each with a 1-line note`

<!--
  Template contract - do not remove this comment.
  CI (lint-prose + structure linter) enforces:
    1. Header line above (one line, five fields, in this exact order)
    2. Nine sections below (in this exact order, same H2 titles)
    3. Single new concept (a "Concept:" Bloom-tagged line)
    4. Every Do step ends with a verify COMMAND, not a screenshot
  See CONTRIBUTING.md and docs/DESIGN.md §7 for the full author contract.
-->

**Concept**: `Claude uses tools (Read, Edit, Bash, Grep, Glob, Task) to act on a codebase` (Bloom: Apply)

---

## Why

Prompting Claude produces text; tools are what let Claude act on real files. When you understand which tool Claude reaches for — and why — you can write prompts that guide it toward the right action and catch mistakes before they land. This lab makes tool use visible so it stops being a black box.

## Check

```bash
./scripts/doctor.sh 007
```

Expected output: `OK lab 007 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before running anything, list the tools you think Claude will use to answer "How many test files are in `quips/`?" Write your list down (e.g. Bash, Grep, Glob). No answer is wrong yet — this is your baseline.

   Verify that the `quips/` directory is present:
   ```bash
   [[ -d quips ]] && echo "quips present" || echo "quips missing"
   ```
   Expected: `quips present`

2. **Run** — from the repo root, open Claude Code and ask it to count test files:

   ```bash
   claude
   ```

   In the REPL, ask:

   > How many test files are in the quips/ directory? Use tools and report the count plus the command that produced it.

   Verify: the response contains a number.

   ```bash
   # Claude should have printed something like "3 test files" or "found 2 files"
   # Nothing to grep here — just confirm you see a digit in Claude's output.
   echo "check: did Claude print a number? y/n"
   ```

3. **Investigate** — re-read the transcript in your terminal. Claude shows its tool calls inline (e.g. `Bash(find quips -name '*.test.*' | wc -l)`). Write down every tool name you see.

   Verify: you can identify at least one of Bash, Grep, or Glob in the transcript.

   ```bash
   # Confirm test files exist so Claude had something to find:
   find quips -name '*.test.*' | wc -l
   ```
   Expected: a number greater than 0.

4. **Modify** — still in the REPL (or reopen it), ask Claude to edit a file using a tool sequence:

   > Now add a placeholder comment on line 1 of quips/src/db.js.

   Watch the transcript: Claude should call Read (to load the file) then Edit (to insert the comment).

   Verify the first line of `db.js` now starts with a comment character:
   ```bash
   head -1 quips/src/db.js
   ```
   Expected: a line beginning with `//` or `/*` (or note the tool sequence even if you declined the edit).

5. **Make** — create `Labs/007-ToolUse/observations.md` listing at least 3 tools you observed, one per line, with a 1-line note on what Claude did with each. Example format:

   ```
   - Bash: ran `find quips -name '*.test.*' | wc -l` to count test files
   - Read: loaded quips/src/db.js before editing it
   - Edit: inserted a placeholder comment at line 1 of db.js
   ```

   Verify:
   ```bash
   ./scripts/verify.sh 007
   ```
   Expected: exits 0 with no error output.

## Observe

Which tool does Claude prefer for "find X in files" — Bash, Grep, or Glob — and why? Write one sentence in your own words based on what you actually saw in the transcript, not what you expected.

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| Tool calls not visible in the terminal | Old CLI version or `--output-format` not set to default | Run `npm i -g @anthropic-ai/claude-code@latest` | https://github.com/anthropics/claude-code |
| Claude refuses to run a Bash command | That path isn't in the permission allowlist | Check or relax permissions (see Lab 009) | https://docs.claude.com/en/docs/claude-code/overview |
| Edit fails with "file not read first" | Edit requires a prior Read call | Ask Claude to read the file first, then edit it | https://docs.claude.com/en/docs/claude-code/overview |

## Stretch (optional, ~10 min)

Ask Claude to use ONLY the Grep tool (no Bash) to find every placeholder comment across the repo:

> Using only the Grep tool — no Bash — find every placeholder comment in the quips/ directory.

Note whether it complies. If it falls back to Bash, ask why. No single right answer exists — this is productive failure that reveals how Claude reasons about tool choice.

## Recall

What does the Quips `/random` endpoint return when the table is empty?

> Expected from Lab 005: status 404 with body `{"error": "no quips"}`.

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/overview
- https://github.com/anthropics/claude-code

## Next

→ **Lab 008 — Plan Mode** — learn how Claude's plan mode structures multi-step changes before touching any files.
