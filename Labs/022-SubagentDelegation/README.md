# Lab 022 — Subagent Delegation

⏱ **30 min**   📦 **You'll add**: `quips/.claude/agents/test-writer.md` + delegation log   🔗 **Builds on**: Lab 021   🎯 **Success**: `test-writer.md has valid frontmatter AND delegation-log.md references at least one subagent`

<!--
  Template contract - do not remove this comment.
  CI (lint-prose + structure linter) enforces:
    1. Header line above (one line, five fields, in this exact order)
    2. Nine sections below (in this exact order, same H2 titles)
    3. Single new concept (a "Concept:" Bloom-tagged line)
    4. Every Do step ends with a verify COMMAND, not a screenshot
  See CONTRIBUTING.md and docs/DESIGN.md §7 for the full author contract.
-->

**Concept**: `Delegate a task to a named subagent in-session` (Bloom: Apply)

---

## Why

A subagent that exists but never gets work is useless. Delegation — routing a task to the right subagent — is what turns a directory of agent definitions into a working system. Claude can delegate automatically when a subagent's description matches the task, or you can force it with an explicit Task tool call. Understanding both paths lets you build sessions where specialist agents handle what they know best, then hand results back to a coordinating agent that stitches things together. This lab builds a second subagent (`test-writer`) alongside the `reviewer` from Lab 021, then delegates real work to both in sequence.

## Check

```bash
./scripts/doctor.sh 022
```

Expected output: `OK lab 022 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before writing any files, write one sentence: why should `test-writer` NOT have `Edit` access to `src/`?

   Capture your prediction:
   ```bash
   echo "prediction captured"
   ```
   Expected: `prediction captured`

2. **Run** — start a fresh Claude session inside the quips project and list known subagents.

   ```bash
   cd quips && claude
   ```

   Inside the REPL, type:

   > List subagents

   Verify that `reviewer` appears in Claude's output before continuing.

   ```bash
   ls quips/.claude/agents/
   ```
   Expected: output includes `reviewer.md` (created in Lab 021).

3. **Investigate** — read the subagent invocation docs to learn the two delegation paths.

   Open: https://docs.claude.com/en/docs/claude-code/sub-agents

   After reading, verify you can name both paths:
   ```bash
   echo "automatic (description-match) and explicit (Task tool)"
   ```
   Expected: `automatic (description-match) and explicit (Task tool)`

4. **Modify** — create the `test-writer` subagent definition.

   Create `quips/.claude/agents/test-writer.md` with this exact content:

   ```
   ---
   name: test-writer
   description: Draft Vitest tests for quips routes
   tools: Read, Grep, Write
   model: sonnet
   ---
   Draft focused Vitest tests for the route or function you are given.
   Write tests to quips/test/. Do not touch quips/src/.
   Cover happy path, missing fields, and invalid input.
   ```

   Verify the frontmatter delimiters are present:
   ```bash
   grep -c '^---$' quips/.claude/agents/test-writer.md
   ```
   Expected: `2`

5. **Make** — run a coordinated delegation session. Start a new `claude` session inside `quips/` and issue this prompt:

   > Use test-writer to draft tests for POST /quips edge cases, then use reviewer to critique the draft. Paste both outputs into quips/.claude/delegation-log.md.

   After Claude finishes, verify the log was created and references at least one subagent:
   ```bash
   [[ -s quips/.claude/delegation-log.md ]] && grep -qi 'test-writer\|reviewer' quips/.claude/delegation-log.md && echo "ok" || echo "missing or empty"
   ```
   Expected: `ok`

## Observe

One sentence — did Claude route to `test-writer` automatically, or did it need an explicit Task call? What in the description triggered (or failed to trigger) automatic routing?

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| Claude never routes to test-writer automatically | description was too generic | Rewrite description with an action verb and a trigger: "Draft Vitest tests when..." | https://docs.claude.com/en/docs/claude-code/sub-agents |
| test-writer edits src/ files | tools allowlist included Edit | Restrict tools to Read, Grep, Write — and Write only to test/ via permission rules | https://docs.claude.com/en/docs/claude-code/settings |
| Reviewer and test-writer give conflicting advice | no orchestrator — both are peers | Use a main-agent prompt that sequences them: draft → review → revise | https://docs.claude.com/en/docs/claude-code/sub-agents |

## Stretch (optional, ~10 min)

Add a third subagent `reviser.md` that reads `delegation-log.md` and applies the reviewer's feedback to the test file. Prompt Claude to run all three in sequence: draft → review → revise.

## Recall

In Lab 017, one rescue move returned the session to a clean state faster than the others. Which slash command did that, and when should you prefer it over `git reset --hard HEAD`?

> Expected: `/clear` drops session context without touching disk; prefer it when no files were written and you only need to reset Claude's understanding of the task.

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/sub-agents
- https://docs.claude.com/en/docs/claude-code/settings

## Next

→ **Lab 023 — Hooks** — attach pre- and post-tool hooks to automate checks that run on every Claude action without manual prompting.
