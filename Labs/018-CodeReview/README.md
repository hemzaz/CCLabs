# Lab 018 — Code Review

⏱ **30 min**   📦 **You'll add**: `quips/REVIEW-NOTES.md`   🔗 **Builds on**: Lab 017   🎯 **Success**: `quips/REVIEW-NOTES.md` exists with ≥10 lines and at least one line containing "Challenge"

<!--
  Template contract - do not remove this comment.
  CI (lint-prose + structure linter) enforces:
    1. Header line above (one line, five fields, in this exact order)
    2. Nine sections below (in this exact order, same H2 titles)
    3. Single new concept (a "Concept:" Bloom-tagged line)
    4. Every Do step ends with a verify COMMAND, not a screenshot
  See CONTRIBUTING.md and docs/DESIGN.md §7 for the full author contract.
-->

**Concept**: `Critique your own diff before accepting it` (Bloom: Evaluate)

---

## Why

Accepting a diff without review is how bugs ship. Claude generates plausible code fast, but plausible is not correct. A route that works on the happy path can still break on an empty table, a missing tag filter, or a concurrent request. The discipline here is simple: Claude proposes, you challenge, Claude revises. One round of "why did you do it that way?" before you accept a diff catches more issues than any amount of post-merge debugging.

## Check

```bash
./scripts/doctor.sh 018
```

Expected output: `OK lab 018 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before prompting Claude, write down three review criteria a senior engineer applies to any new route: correctness, edge cases, and one more you choose (examples: error handling, security, performance). Record your three criteria before continuing.

   Verify the quips project exists:
   ```bash
   [[ -f quips/src/server.js ]] && echo "ready" || echo "missing quips/src/server.js"
   ```
   Expected: `ready`

2. **Run** — launch Claude Code inside the quips project and ask for a new route. Do not accept the diff yet.

   ```bash
   cd quips && claude
   ```

   Then type this prompt inside the REPL:

   > Add a GET /quips/count route that returns the total row count as JSON: `{ "count": N }`. Propose the diff but wait — do not apply it yet.

   Paste or screenshot Claude's proposed diff into a scratch file so you have a record. Then verify you have captured it:
   ```bash
   echo "diff 1 captured"
   ```
   Expected: `diff 1 captured`

3. **Investigate** — challenge Claude in the same session with two questions. Send each as a separate message:

   - "What edge cases would this route miss?"
   - "Write 3 tests for this route. At least one test must currently fail against your proposed implementation."

   Read Claude's responses. Identify at least one gap it names or demonstrates (for example: empty table, a tag-filtered count that the route ignores, or a DB error path).

   Verify Claude produced test output you can inspect:
   ```bash
   echo "challenge responses captured"
   ```
   Expected: `challenge responses captured`

4. **Modify** — ask Claude to incorporate the fix for the gap you identified:

   > Update the implementation to fix the gap you just identified. Apply the changes now.

   After Claude applies the edits, capture the final diff with git:
   ```bash
   git diff quips/src/
   ```
   Expected: at least one line starting with `+` in the output (showing new code).

5. **Make** — write `quips/REVIEW-NOTES.md` with exactly three sections: `## Diff 1` (summary of Claude's first proposal), `## Challenge prompts` (the two questions you sent and key parts of Claude's answers), and `## Diff 2` (what changed between the first and second proposal, and why the gap mattered).

   Verify the file meets the minimum requirement:
   ```bash
   wc -l quips/REVIEW-NOTES.md
   ```
   Expected: a number ≥ 10.

## Observe

One sentence — which of your three review criteria from step 1 did Claude's first diff fail, and what exact prompt forced it to acknowledge that?

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| Claude agrees with every challenge immediately | it is sycophantic unless pressed with specifics | Quote a specific line from its diff and ask "what input breaks this exact line?" | https://docs.claude.com/en/docs/claude-code/overview |
| Challenges uncover no gaps | your prompt was too broad and Claude hedged safely | Ask for pathological inputs: empty string, null, long input, unicode, concurrent requests | https://github.com/anthropics/anthropic-cookbook |
| Second diff is worse than the first | Claude over-corrected and added speculative defensive code | Compare both diffs; reject speculative guards not backed by a test | https://docs.claude.com/en/docs/claude-code/common-workflows |

## Stretch (optional, ~10 min)

Add a fourth section to `REVIEW-NOTES.md` called `## Diff 3`. Ask Claude: "Add an optional `?tag=` query param to the count route so it filters by tag." Challenge it with the same two questions from step 3. Note whether the gap it finds this time is different from the first round.

## Recall

In Lab 013, settings are read from three scopes. Which scope wins when the same key appears in both project `settings.json` and user `~/.claude/settings.json`?

> Expected: project scope (`settings.json` checked into the repo) wins over user scope for that key, because more-specific scopes override less-specific ones.

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/overview
- https://docs.claude.com/en/docs/claude-code/common-workflows

## Next

→ **Lab 019 — Verify Scripts** — write a `verify.sh` that asserts your own lab outputs meet acceptance criteria, closing the loop between authoring and automated checking.
