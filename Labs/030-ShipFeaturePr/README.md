# Lab 030 — Ship Feature PR

⏱ **35 min**   📦 **You'll add**: branch, PR URL recorded in `quips/SHIPPED.md`   🔗 **Builds on**: Lab 029   🎯 **Success**: `feat/quips-by-tag branch merged with CI green and PR URL in quips/SHIPPED.md`

<!--
  Template contract - do not remove this comment.
  CI (lint-prose + structure linter) enforces:
    1. Header line above (one line, five fields, in this exact order)
    2. Nine sections below (in this exact order, same H2 titles)
    3. Single new concept (a "Concept:" Bloom-tagged line)
    4. Every Do step ends with a verify COMMAND, not a screenshot
  See CONTRIBUTING.md and docs/DESIGN.md §7 for the full author contract.
-->

**Concept**: `Ship a feature via reviewed PR end-to-end` (Bloom: Create)

---

## Why

Every lab so far contributed one piece: prompting discipline, CLAUDE.md, verify scripts, subagents, hooks, skills, MCP, CI review, and the PR review loop. This lab puts them together. You will ship one small feature — `GET /quips/by-tag/:tag` — through the full cycle: branch, implement, test, push, PR, CI review, URL recorded. That cycle is the job. Practising it on a small feature builds the muscle for larger ones.

## Check

```bash
./scripts/doctor.sh 030
```

Expected output: `OK lab 030 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before writing any code, predict one thing the CI reviewer (the workflow from Lab 028) will flag on a careless first diff. Write it down.

   ```bash
   echo "My prediction: <your one-line prediction here>"
   ```
   Expected: the command echoes your prediction without error.

2. **Run** — create a feature branch inside the quips project.

   ```bash
   cd /path/to/repo && cd quips && git checkout -b feat/quips-by-tag
   ```

   Verify the branch is active:
   ```bash
   cd quips && git branch --show-current
   ```
   Expected: `feat/quips-by-tag`

3. **Investigate** — decide the exact contract for the new route before touching any code. The contract has three rules: path parameter is `:tag`, response is always a JSON array, status is always 200 (empty array when no match). Write those three rules as bullet points into `quips/SHIPPED.md`.

   ```bash
   wc -l quips/SHIPPED.md
   ```
   Expected: `3` or higher (at least three lines).

4. **Modify** — open Claude Code inside the quips project and give it the spec you wrote.

   ```bash
   cd quips && claude
   ```

   Prompt Claude with:

   > Implement `GET /quips/by-tag/:tag`. Return all quips whose tags array includes the value of `:tag`. Always return a JSON array with status 200; return an empty array when no quip matches. Add tests: one with a match, one without, one with multiple matches. Run `npm test` after.

   Let Claude implement and run the tests. When it finishes, verify tests pass:
   ```bash
   (cd quips && npm test --silent) && echo OK
   ```
   Expected: `OK`

5. **Make** — commit, push, open the PR, and record the URL.

   ```bash
   cd quips && git add -A && git commit -m "feat: add GET /quips/by-tag/:tag" && git push -u origin feat/quips-by-tag && gh pr create --fill
   ```

   Copy the PR URL that `gh pr create` prints. Append it to `quips/SHIPPED.md` on a line starting with `PR: `:

   ```bash
   echo "PR: <paste URL here>" >> quips/SHIPPED.md
   ```

   Verify the line is present:
   ```bash
   grep -q '^PR: ' quips/SHIPPED.md && echo "recorded"
   ```
   Expected: `recorded`

## Observe

Look at the CI review comment on the PR. Name one specific change it suggested and whether you agree the suggestion improves the code.

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| `gh pr create` fails with "no upstream" | Branch was not pushed before creating the PR | Run `git push -u origin HEAD` first, then retry `gh pr create --fill` | https://docs.claude.com/en/docs/claude-code/common-workflows |
| CI review workflow does not run on the PR | Path filter or `pull_request` trigger missing in the workflow file | Open `.github/workflows/claude-review.yml` and confirm the trigger includes `pull_request` and covers the paths you changed | https://github.com/anthropics/claude-code-action |
| PR description is empty after `--fill` | Commit body was too terse for `--fill` to extract a description | Rewrite with `gh pr create --title "feat: add GET /quips/by-tag/:tag" --body "..."` or edit the description in the GitHub UI after creation | https://docs.claude.com/en/docs/claude-code/common-workflows |

## Stretch (optional, ~10 min)

Add a second query parameter `?limit=N` to `GET /quips/by-tag/:tag` that caps the number of results. Decide the default (suggest 20) and write a test for the limit boundary.

## Recall

In Lab 025, you configured an MCP server in a JSON file. What is the top-level key under which MCP servers are declared in that file?

> Expected: `mcpServers`

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://github.com/anthropics/claude-code-action
- https://docs.claude.com/en/docs/claude-code/common-workflows

## Next

→ **Capstone** — the summative performance task
