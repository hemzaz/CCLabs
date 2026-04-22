# Lab 029 — PR Review Loop

⏱ **25 min**   📦 **You'll add**: `quips/PR-LOOP.md` + revised feature patch   🔗 **Builds on**: Lab 028   🎯 **Success**: `quips/PR-LOOP.md exists, is non-empty, and mentions review, comment, applied, or test`

<!--
  Template contract - do not remove this comment.
  CI (lint-prose + structure linter) enforces:
    1. Header line above (one line, five fields, in this exact order)
    2. Nine sections below (in this exact order, same H2 titles)
    3. Single new concept (a "Concept:" Bloom-tagged line)
    4. Every Do step ends with a verify COMMAND, not a screenshot
  See CONTRIBUTING.md and docs/DESIGN.md §7 for the full author contract.
-->

**Concept**: `Iterate on PR review comments with Claude headless` (Bloom: Apply)

---

## Why

When a reviewer leaves comments on a PR, the common move is to hand-fix each one. A faster path: feed the review comments back to Claude in headless mode (`claude -p`) and let it revise the code. Claude reads the comments, applies each change, and runs the tests — all without an interactive session. This lab teaches the review-then-revise loop using Claude non-interactively, so you can integrate it into scripts or CI pipelines.

## Check

```bash
./scripts/doctor.sh 029
```

Expected output: `OK lab 029 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before running anything, write down one class of review comment that Claude headless will handle poorly. Think about comments that are subjective or have no clear rule (for example, style nits with no linter backing them).

   ```bash
   echo "Claude handles poorly: <your prediction here>"
   ```
   Expected: any non-empty string printed to stdout.

2. **Run** — create `quips/review-comments.md` with exactly three reviewer comments. Each comment must be on its own line and must be concrete (for example: "test file is missing an edge case for empty input").

   ```bash
   cat quips/review-comments.md
   ```
   Verify the file has at least 3 lines:
   ```bash
   [[ $(wc -l < quips/review-comments.md) -ge 3 ]] && echo "ok" || echo "need at least 3 lines"
   ```
   Expected: `ok`

3. **Investigate** — read the `-p` flag documentation to understand how headless mode accepts a prompt.

   Visit: https://docs.claude.com/en/docs/claude-code/sdk

   Confirm the flag is present in your installed binary:
   ```bash
   claude --help | grep -q '\-p' && echo "flag present" || echo "flag missing"
   ```
   Expected: `flag present`

4. **Modify** — run Claude headless, passing the review comments as the prompt. Ask it to apply the comments to the repo and run `npm test` after.

   ```bash
   cd quips && claude -p "$(cat review-comments.md). Apply these review comments to the repo. Run npm test after." > ../quips/PR-LOOP.md
   ```

   Verify the output file exists and is non-empty:
   ```bash
   [[ -s quips/PR-LOOP.md ]] && echo "ok" || echo "PR-LOOP.md missing or empty"
   ```
   Expected: `ok`

   Verify it references the work done:
   ```bash
   grep -qi 'review\|comment\|applied\|test' quips/PR-LOOP.md && echo "content looks right" || echo "unexpected output"
   ```
   Expected: `content looks right`

5. **Make** — inspect the actual code changes Claude made.

   ```bash
   cd quips && git diff
   ```

   Verify at least one file was changed:
   ```bash
   cd quips && git diff --stat | tail -1
   ```
   Expected: a line showing at least `1 file changed`.

## Observe

One sentence — which review comment did Claude apply most precisely, and which did it interpret loosely or skip?

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| `claude -p` exits immediately with no output | Prompt via stdin vs argument confusion | Pass the prompt as an argument: `claude -p "..."` — or pipe via stdin with `echo '...' \| claude -p` | https://docs.claude.com/en/docs/claude-code/sdk |
| Headless Claude refuses edits because of permissions | Default permission mode is interactive-ask | Use `--permission-mode acceptEdits` (scoped) or configure via settings.json | https://docs.claude.com/en/docs/claude-code/settings |
| Revisions go beyond the reviewer's comments | Claude took initiative beyond what was asked | Tighten the prompt: "Apply ONLY the changes described in the comments — no extras" | https://github.com/anthropics/claude-code-action |

## Stretch (optional, ~10 min)

Add a fourth comment to `quips/review-comments.md` that is deliberately vague (for example, "make this more readable"). Re-run the headless command and compare the result. Note in a sentence whether Claude applied it, ignored it, or asked for clarification.

## Recall

In Lab 024, what directory path holds a project-scope skill inside the Quips repo?

> Expected: `quips/.claude/skills/<skill-name>/`

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/sdk
- https://docs.claude.com/en/docs/claude-code/settings
- https://github.com/anthropics/claude-code-action

## Next

→ **Lab 030 — Ship Feature PR** — open a real pull request from inside Claude Code, attach a CI workflow, and merge it once checks pass.
