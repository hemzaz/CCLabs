# Lab 021 — Subagents

⏱ **20 min**   📦 **You'll add**: `quips/.claude/agents/reviewer.md`   🔗 **Builds on**: Checkpoint D   🎯 **Success**: `verify.sh` exits 0 and Claude names `reviewer` when asked to list subagents

<!--
  Template contract - do not remove this comment.
  CI (lint-prose + structure linter) enforces:
    1. Header line above (one line, five fields, in this exact order)
    2. Nine sections below (in this exact order, same H2 titles)
    3. Single new concept (a "Concept:" Bloom-tagged line)
    4. Every Do step ends with a verify COMMAND, not a screenshot
  See CONTRIBUTING.md and docs/DESIGN.md §7 for the full author contract.
-->

**Concept**: `Subagent with YAML frontmatter and model routing` (Bloom: Create)

---

## Why

Claude Code can delegate work to scoped sub-processes called subagents. Each subagent has its own system prompt, a restricted tool allowlist, and an explicit model choice. Delegation keeps the main conversation focused while giving the specialist exactly the access it needs — no more. A code-review subagent, for example, only needs to read files; giving it write tools would be a mistake. This lab introduces Outcome O5 by having you write the first subagent in the Quips project: a `reviewer` that audits diffs for correctness and test coverage.

## Check

```bash
./scripts/doctor.sh 021
```

Expected output: `OK lab 021 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before writing anything, list the 3 tools a code-review subagent actually needs. Justify each in one sentence. A reviewer reads source files, searches for patterns, and lists matching paths — it does not run commands or write files.

   Verify by printing the three tool names:
   ```bash
   echo "Read  Grep  Glob"
   ```
   Expected: `Read  Grep  Glob`

2. **Run** — read the official subagents reference before writing any file.

   Open: https://docs.claude.com/en/docs/claude-code/sub-agents

   Then confirm the `.claude/agents/` directory exists (or create it):
   ```bash
   [[ -d quips/.claude ]] && echo "dir present" || mkdir -p quips/.claude/agents && echo "created"
   ```
   Expected: `dir present` or `created`

3. **Investigate** — examine an existing subagent file on your machine to confirm the frontmatter shape:

   ```bash
   cat ~/.claude/agents/*.md 2>/dev/null | head -40
   ```

   Name the 4 frontmatter fields before continuing. They are: `name`, `description`, `tools`, `model`.

   Verify you can identify them:
   ```bash
   echo "name  description  tools  model"
   ```
   Expected: `name  description  tools  model`

4. **Modify** — create `quips/.claude/agents/reviewer.md` with the frontmatter block below and a 3–5 line system prompt body.

   Frontmatter:
   ```
   ---
   name: reviewer
   description: Review Quips diffs for correctness and test coverage
   tools: Read, Grep, Glob
   model: sonnet
   ---
   ```

   System prompt body (write this after the closing `---`):

   ```
   You are a code reviewer for the Quips project.
   Check every diff for correctness: logic errors, missing null checks, and broken contracts.
   Verify that new behaviour is covered by tests in quips/test/.
   Flag any function or variable name that does not match the existing naming style.
   Report findings as a numbered list; mark each item PASS, WARN, or FAIL.
   ```

   Verify the frontmatter delimiters and keys are present:
   ```bash
   grep -c '^---$' quips/.claude/agents/reviewer.md
   ```
   Expected: `2`

   ```bash
   grep -E '^(name|description|tools|model):' quips/.claude/agents/reviewer.md | wc -l | tr -d ' '
   ```
   Expected: `4`

5. **Make** — launch Claude inside the Quips project and confirm the subagent is registered:

   ```bash
   cd quips && claude
   ```

   Inside the REPL type:
   > List the available subagents

   Claude should name `reviewer` in its response.

   Verify:
   ```bash
   echo "confirm Claude's answer includes 'reviewer'"
   ```

## Observe

One sentence — why does restricting the `tools` list to `Read, Grep, Glob` make the reviewer subagent safer than giving it full tool access?

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| Claude does not see the new subagent | Claude was already running when the file was created | Exit and re-launch `claude` in the same directory | https://docs.claude.com/en/docs/claude-code/sub-agents |
| Frontmatter tools list includes Bash | reviewer should be read-only | Restrict `tools:` to `Read, Grep, Glob` — remove all write and execute tools | https://docs.claude.com/en/docs/claude-code/sub-agents |
| Subagent never gets invoked | Claude did not route to it because the description was vague | Make the description action-specific: "Review a diff for correctness and test coverage" | https://docs.claude.com/en/docs/claude-code/sub-agents |

## Stretch (optional, ~10 min)

Add a second subagent at `quips/.claude/agents/explainer.md` that uses `model: haiku` and restricts tools to `Read` only. Its job is to explain a single function in plain English. Compare how haiku responds versus sonnet when you invoke each subagent on the same function.

## Recall

Lab 016 introduced the red-green-refactor loop. What is the correct order: write the test first, or write the implementation first?

> Expected: write the test first (red), then the implementation (green), then refactor

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/sub-agents
- https://docs.claude.com/en/docs/claude-code/overview

## Next

→ **Lab 022 — Subagent Delegation** — invoke the reviewer subagent explicitly and interpret its structured findings on a real Quips diff
