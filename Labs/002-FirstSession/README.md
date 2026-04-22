# Lab 002 — First Session

⏱ **15 min**   📦 **You'll add**: `Labs/002-FirstSession/transcript.md`   🔗 **Builds on**: Lab 001   🎯 **Success**: `transcript.md exists, non-empty, contains the word 'Node' (case-insensitive)`

<!--
  Template contract - do not remove this comment.
  CI (lint-prose + structure linter) enforces:
    1. Header line above (one line, five fields, in this exact order)
    2. Nine sections below (in this exact order, same H2 titles)
    3. Single new concept (a "Concept:" Bloom-tagged line)
    4. Every Do step ends with a verify COMMAND, not a screenshot
  See CONTRIBUTING.md and docs/DESIGN.md §7 for the full author contract.
-->

**Concept**: `Hold an interactive REPL session with Claude Code` (Bloom: Apply)

---

## Why

Starting an interactive REPL session is the most direct way to use Claude Code. Knowing how to enter, query, and exit a session is the foundation for every hands-on lab that follows.

## Check

```bash
./scripts/doctor.sh 002
```

Expected output: `OK lab 002 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before running, write down what you expect the Claude REPL prompt to look like. Will it show a `>` symbol, a cursor, a special prefix? Write your guess.

   Verify:
   ```bash
   claude --version
   ```
   Expected: exits 0 and prints a semver string (sanity check from Lab 001).

2. **Run** — start the interactive REPL.

   ```bash
   claude
   ```

   Verify: you see a prompt awaiting input (terminal cursor is active and the session is waiting for your message).

3. **Investigate** — ask Claude a question inside the running session.

   Type and send:
   ```
   What is Node.js? Answer in 2 sentences.
   ```

   Verify: the response includes the word `JavaScript` or `runtime`.

4. **Modify** — ask a follow-up in the same session (do not exit).

   Type and send:
   ```
   Why is it event-driven?
   ```

   Verify: the response references events, non-blocking, or a similar concept.

5. **Make** — exit the session and save the transcript.

   Type:
   ```
   /exit
   ```
   (or press Ctrl+D)

   Copy the full session output into `Labs/002-FirstSession/transcript.md` manually.

   Verify:
   ```bash
   wc -l Labs/002-FirstSession/transcript.md
   ```
   Expected: output shows a non-zero line count.

## Observe

Note one thing Claude did that a plain Google search would NOT have done. For example: did it synthesise across concepts, ask a clarifying question, or tailor its answer to your phrasing? Write one paragraph in your own words. No answer key — this is metacognition practice.

## If stuck

Exactly three entries. Each cites a source URL from canonical Anthropic docs.

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| REPL won't start | Auth token missing | Re-run `/login` or set `ANTHROPIC_API_KEY` in your shell, then retry `claude` | https://docs.claude.com/en/docs/claude-code/overview |
| Session hangs on first prompt | Slow network | Press Ctrl+C, retry with a shorter question | https://github.com/anthropics/claude-code |
| Can't find transcript — CLI doesn't auto-save | No built-in auto-save to a named file | Copy/paste the terminal output into `Labs/002-FirstSession/transcript.md` manually | https://docs.claude.com/en/docs/claude-code/overview |

## Stretch (optional, ~10 min)

Open a second terminal and start a fresh `claude` session. Ask the same question ("What is Node.js? Answer in 2 sentences.") and compare the two answers. Note: each session starts fresh — no memory is shared across sessions by default.

## Recall

What command installs Claude Code globally?

> Expected answer from Lab 001: `npm i -g @anthropic-ai/claude-code`

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/overview
- https://github.com/anthropics/claude-code

## Next

→ **Lab 003 — Slash Commands** — explore built-in `/` commands that control your Claude Code session.
