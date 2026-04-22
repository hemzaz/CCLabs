# Lab 017 — Rescue and Recover

⏱ **20 min**   📦 **You'll add**: `quips/.claude/rescue-log.md`   🔗 **Builds on**: Lab 016   🎯 **Success**: `quips/.claude/rescue-log.md exists with at least 3 lines documenting one rescue`

<!--
  Template contract - do not remove this comment.
  CI (lint-prose + structure linter) enforces:
    1. Header line above (one line, five fields, in this exact order)
    2. Nine sections below (in this exact order, same H2 titles)
    3. Single new concept (a "Concept:" Bloom-tagged line)
    4. Every Do step ends with a verify COMMAND, not a screenshot
  See CONTRIBUTING.md and docs/DESIGN.md §7 for the full author contract.
-->

**Concept**: `Diagnose a stalled or wrong Claude run, then recover` (Bloom: Evaluate)

---

## Why

Claude sometimes goes wrong: it spins on a failing test, deletes code it should not touch, or hallucinates a file. Waiting and hoping it self-corrects wastes time and can deepen the damage. The rescue discipline is: STOP the run, diagnose what happened, and recover to a known-good state. You learn more from one deliberate rescue than from ten sessions that go smoothly.

## Check

```bash
./scripts/doctor.sh 017
```

Expected output: `OK lab 017 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before starting Claude, name three failure modes you have seen or can imagine for an AI coding session. Write them in a scratch file or on paper. Examples to spark thinking: infinite retry loop, wrong file deleted, test suite broken by partial edit.

   Verify the quips project is in a clean state before you introduce chaos:
   ```bash
   git -C quips status --short
   ```
   Expected: no output (clean working tree).

2. **Run** — launch Claude Code inside the quips project and give it a deliberately vague, risky prompt. Do NOT approve any file edits when Claude asks.

   ```bash
   cd quips && claude
   ```

   Then type this prompt inside the REPL:

   > Clean up everything in src/. Remove anything that looks redundant or unused.

   Watch Claude's proposed plan. Capture it mentally (or copy to a scratch note). Stop before approving any writes.

   Verify Claude is mid-session and has produced at least a plan:
   ```bash
   echo "confirm Claude's output describes files it intends to modify"
   ```
   Expected: `confirm Claude's output describes files it intends to modify`

3. **Investigate** — press ESC to interrupt Claude mid-stream. Then check what, if anything, changed on disk.

   ```bash
   git -C quips status --short
   ```
   Expected: no output, or a list of modified files if Claude wrote before you interrupted.

4. **Modify** — undo any partial changes and reset the session context.

   If `git status` showed modified files, restore them:
   ```bash
   git -C quips reset --hard HEAD
   ```

   Then in the Claude REPL, run `/clear` to drop the bad context. Confirm the tree is clean:
   ```bash
   git -C quips status --short
   ```
   Expected: no output (clean working tree).

5. **Make** — create the rescue log. Document what happened in `quips/.claude/rescue-log.md` with at least three lines: the symptom you observed, what you tried, and what actually recovered the session.

   ```bash
   mkdir -p quips/.claude
   ```

   Write `quips/.claude/rescue-log.md` — plain text, three lines minimum:
   ```
   Symptom: <what Claude was doing or proposing>
   Tried: <first action you took>
   Recovered: <what actually returned the session to a clean state>
   ```

   Verify:
   ```bash
   wc -l quips/.claude/rescue-log.md
   ```
   Expected: a number >= 3 (e.g., `       3 quips/.claude/rescue-log.md`).

## Observe

One sentence — which rescue move had the most impact: ESC, `/clear`, or `git reset --hard HEAD`? Why?

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| ESC does not stop Claude | terminal is buffering, or a tool call is already in flight | Press ESC twice; if still stuck, Ctrl+C kills the session | https://docs.claude.com/en/docs/claude-code/overview |
| `git reset --hard` destroys uncommitted work you wanted to keep | you had valid changes alongside Claude's bad ones | Use `git stash` first to preserve valid work, then reset | https://docs.claude.com/en/docs/claude-code/common-workflows |
| `/clear` loses useful context | you dropped the good parts of the session along with the bad | Prefer `/compact` to keep a summary; save the log before clearing | https://docs.claude.com/en/docs/claude-code/overview |

## Stretch (optional, ~10 min)

Re-run the same vague prompt but this time use `/compact` instead of `/clear` after interrupting. Compare the session summaries. Note whether `/compact` preserved enough context to continue safely or whether `/clear` would have been the better call.

## Recall

In Lab 012, you used `@` mentions to bring files into context. Name one situation where forgetting an `@` mention caused Claude to make a wrong assumption about the codebase.

> Expected: any plausible answer, e.g., Claude edited the wrong version of a function because it did not see the updated file.

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/overview
- https://docs.claude.com/en/docs/claude-code/common-workflows

## Next

→ **Lab 018 — Code Review with Subagents** — delegate a review pass to a second Claude session and reconcile its findings with your own judgment.
