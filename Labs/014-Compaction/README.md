# Lab 014 — Compaction

⏱ **15 min**   📦 **You'll add**: `Labs/014-Compaction/compact-notes.md`   🔗 **Builds on**: Lab 013   🎯 **Success**: `compact-notes.md exists, non-empty, contains the word 'compact' (case-insensitive) AND a 'before' + 'after' marker`

<!--
  Template contract - do not remove this comment.
  CI (lint-prose + structure linter) enforces:
    1. Header line above (one line, five fields, in this exact order)
    2. Nine sections below (in this exact order, same H2 titles)
    3. Single new concept (a "Concept:" Bloom-tagged line)
    4. Every Do step ends with a verify COMMAND, not a screenshot
  See CONTRIBUTING.md and docs/DESIGN.md §7 for the full author contract.
-->

**Concept**: `/compact trims conversation while preserving key facts` (Bloom: Apply)

---

## Why

Every token you send costs latency and money. Long sessions accumulate context — tool call results, chain-of-thought, intermediate code — that Claude no longer needs but still pays to re-read. `/compact` replaces that bulk with a tight summary so the session continues with full awareness of what matters and far fewer tokens. This lab builds the habit of running `/compact` before context pressure forces you to `/clear` and start over.

## Check

```bash
./scripts/doctor.sh 014
```

Expected output: `OK lab 014 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before running anything, write down which categories of content you expect Claude to keep vs. drop when compacting (e.g. schema details, file contents, casual remarks). Then verify the quips submodule is present:

   ```bash
   [[ -d quips ]] && echo "quips present" || echo "missing quips"
   ```
   Expected: `quips present`

2. **Run** — start a long session. From the repo root:

   ```bash
   cd quips && claude
   ```

   Inside the REPL ask at least 10 unrelated questions, for example:
   - What Node.js version does this project target?
   - Explain the schema in `src/db.js`.
   - What is integration testing?
   - What does `express.json()` do?
   - What HTTP status code means "created"?
   - What is a foreign key?
   - How does `npm test` discover test files in this project?
   - What is the difference between `==` and `===` in JavaScript?
   - What does the `PORT` environment variable control here?
   - What is the purpose of `resetDb()` in this codebase?

   Verify you have at least 10 turns before continuing:

   ```bash
   echo "confirm: at least 10 question-answer pairs exchanged in the session"
   ```

3. **Investigate** — check context usage. Inside the REPL try `/status` (available in newer CLI versions); if it is not present the footer of each response shows an approximate token count. Note the rough figure.

   Verify you have a token estimate:

   ```bash
   echo "confirm: you have a rough token count (or turn count) noted"
   ```

4. **Modify** — run `/compact` inside the REPL. After compaction, ask a question that depends on earlier context:

   > What was the schema I asked about?

   Claude should answer correctly by recalling the `src/db.js` schema discussion. Verify the session continues:

   ```bash
   echo "confirm: session still active and Claude answered the schema question correctly"
   ```

5. **Make** — write `Labs/014-Compaction/compact-notes.md` with three sections: **Before** (rough token count or turn count, topics covered), **After** (rough token count, topics Claude preserved), **Dropped** (any topics Claude forgot or answered less precisely). Then verify:

   ```bash
   ./scripts/verify.sh 014
   ```
   Expected: `OK lab 014 verified`

## Observe

One sentence — what kind of conversation is WORST to compact and why?

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| `/compact` errors | Old CLI version that lacks the command | Update with `npm i -g @anthropic-ai/claude-code@latest` | https://github.com/anthropics/claude-code |
| Compaction drops something you need | Claude summarises facts it deems low-salience | Save critical outputs to files you can re-read with `@path` — the conversation history is not your only memory | https://docs.claude.com/en/docs/claude-code/overview |
| Token count unclear | `/status` may not exist in older CLI versions | Approximate by counting turns (each Q+A pair ≈ 1 turn); 10 turns ≈ a few thousand tokens | https://docs.claude.com/en/docs/claude-code/overview |

## Stretch (optional, ~10 min)

Compare `/compact` vs `/clear`. After each command ask Claude: "what was my last question?" Note the difference in what Claude can recall. Write one sentence explaining when you would choose `/compact` over `/clear`.

## Recall

What Part II lab taught you to propose before executing?

> Expected: Lab 008 — Plan Mode

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/overview
- https://github.com/anthropics/claude-code

## Next

→ **Lab 015 — Custom Instructions** — shape Claude's default behaviour for every session with persistent instructions.
