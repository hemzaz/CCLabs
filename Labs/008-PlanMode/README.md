# Lab 008 — Plan Mode

⏱ **20 min**   📦 **You'll add**: `Labs/008-PlanMode/plan-transcript.md`   🔗 **Builds on**: Lab 007   🎯 **Success**: `plan-transcript.md exists, contains the word 'plan' and a numbered or bulleted list of steps, plus an APPROVE/REVISE note`

<!--
  Template contract - do not remove this comment.
  CI (lint-prose + structure linter) enforces:
    1. Header line above (one line, five fields, in this exact order)
    2. Nine sections below (in this exact order, same H2 titles)
    3. Single new concept (a "Concept:" Bloom-tagged line)
    4. Every Do step ends with a verify COMMAND, not a screenshot
  See CONTRIBUTING.md and docs/DESIGN.md §7 for the full author contract.
-->

**Concept**: `Plan mode: Claude proposes a plan before acting on it` (Bloom: Analyze)

---

## Why

When Claude executes immediately, you only see what it did — not what it considered. Plan mode surfaces the reasoning step: Claude lays out every file it would touch and why, before writing a single byte. That gap between intent and execution is where costly mistakes hide. Analyzing the plan before approving it is a skill that makes you a safer, faster collaborator with AI tools.

## Check

```bash
./scripts/doctor.sh 008
```

Expected output: `OK lab 008 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — in one line, write down what you expect plan mode to prevent compared with normal execution.

   Verify that the quips project exists before proceeding:
   ```bash
   [[ -d quips ]] && echo "quips present" || echo "quips missing"
   ```
   Expected: `quips present`

2. **Run** — start the Claude Code REPL inside the quips project and activate plan mode.

   ```bash
   cd quips && claude
   ```

   Once inside the REPL, enable plan mode. Press **Shift+Tab** once or twice until the footer status line shows `plan mode on`. If that keybinding does not work in your CLI version, type `/plan-mode on` at the prompt (or check `claude --help | grep -i plan` for the documented flag).

   Verify the footer reads `plan mode` before continuing.

   ```bash
   echo "confirm footer shows plan mode, then continue"
   ```

3. **Investigate** — ask Claude to refactor `db.js` into two files, but do NOT approve execution yet.

   Type the following prompt inside the REPL:

   > Refactor db.js into two files: db.js for setup and queries.js for the CRUD helpers.

   In plan mode Claude outputs a numbered plan of at least 3 steps and does NOT write any files. Verify by checking that `queries.js` does not exist:

   ```bash
   [[ ! -f quips/src/queries.js ]] && echo "no file written — plan only" || echo "file written unexpectedly"
   ```
   Expected: `no file written — plan only`

4. **Modify** — review the plan Claude proposed. If any step is unclear or wrong, ask it to revise.

   Example: "Expand step 2 to list the exact function names that move to queries.js."

   Verify a revised plan appears in the REPL output. Then confirm files are still unchanged:

   ```bash
   [[ ! -f quips/src/queries.js ]] && echo "still no file written" || echo "file written unexpectedly"
   ```
   Expected: `still no file written`

5. **Make** — copy the final plan from the REPL output plus your approval or revision note into the artifact file.

   Create `Labs/008-PlanMode/plan-transcript.md` containing:
   - The full plan Claude proposed (numbered or bulleted list of at least 3 steps)
   - A final line starting with `APPROVE:` or `REVISE:` and your one-sentence note

   Do NOT execute the plan — this lab is about planning, not refactoring.

   Verify:
   ```bash
   ./scripts/verify.sh 008
   ```
   Expected: exits 0 with no error output.

## Observe

One sentence — what did plan mode surface that you would have missed if you had let Claude just execute?

## If stuck

Exactly three entries. Each cites a source URL from canonical Anthropic docs.

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| No "plan mode" footer after Shift+Tab | Older CLI version or different keybinding | Run `claude --help \| grep -i plan` and use the documented flag, or type `/help` inside the REPL | https://docs.claude.com/en/docs/claude-code/overview |
| Claude still edits files in plan mode | You may be in a different mode; confirm footer status | Exit the REPL, re-enter, and re-enable plan mode before re-submitting the prompt | https://docs.claude.com/en/docs/claude-code/overview |
| Plan is too vague to evaluate | Claude summarised at too high a level | Ask "expand step 2 into sub-steps with file paths and exact function names" | https://github.com/anthropics/claude-code |

## Stretch (optional, ~10 min)

Ask the same refactor question WITHOUT plan mode. Compare the two sessions. Write one sentence on the difference in risk between the two approaches.

## Recall

What tool does Claude use to execute shell commands?

> Expected from Lab 007: `Bash`

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/overview
- https://github.com/anthropics/claude-code

## Next

→ **Lab 009 — Permission Modes** — control exactly which tools Claude is allowed to use and which require your approval.
