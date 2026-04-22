# Capstone — Ship a Reviewed Feature End-to-End

⏱ 3-4 hours · 📦 You'll add: `evidence/` directory with pr_url.txt + reflection.md · 🔗 Integrates: Labs 001-030 · 🎯 Success: rubric.md scored ≥3 on all four dimensions

---

## Brief

This is the summative task for the Claude Code curriculum. Unlike the labs and checkpoints, which each focused on a single skill or a bounded cluster of skills, the Capstone asks you to integrate everything you have learned — end to end, on a real codebase, at production quality.

You will deliver a working feature to the Quips API. That means: planning the work in plan mode, writing failing tests first, letting Claude implement while you review every diff, running a subagent review pass before accepting, protecting the workflow with hooks, pushing to a branch, and opening a pull request whose body demonstrates the communication norms from Part VI. The CI workflow you built in Lab 028 will run on that PR.

The evidence you produce — a PR URL, a reflection, and key Claude transcript excerpts — is what gets scored against the rubric in `rubric.md`. No automated pass/fail exists for the quality of your work; `verify.sh` only confirms the artifacts exist. You or an instructor score the rubric. The pass bar is ≥3 on all four dimensions.

---

## Feature scope (pick one)

You must implement exactly one of the following options. All three are equivalent in scope and difficulty.

**Option A — Search endpoint**
Add `GET /quips/search?q=...` to the Quips API. The endpoint returns all quips whose text contains the query string (case-insensitive). Results must be paginated using the same `limit`/`offset` convention already used in the codebase. Return a 400 with a clear error body if `q` is missing or empty.

**Option B — Rate-limited POST**
Enforce a rate limit of 10 requests per minute per IP on `POST /quips`. Requests that exceed the limit must receive a `429 Too Many Requests` response whose JSON body contains `{ "error": "rate limit exceeded", "retry_after_seconds": N }`. The limit resets on a per-minute sliding or fixed window — document your choice.

**Option C — Tag-stats endpoint**
Add `GET /quips/tags` to the Quips API. The response is a JSON array of `{ "tag": "...", "count": N }` objects, ordered by `count` descending. Tags with equal counts are ordered alphabetically. Include only tags that appear on at least one quip.

---

## Outcomes exercised

| Outcome | Phase where demonstrated |
|---|---|
| O1 — Install, authenticate, and update Claude Code | Setup: confirm `claude --version` before starting the session |
| O2 — Hold a productive multi-turn session on a real codebase | Implementation: multi-turn session driving the feature; transcript captured in `evidence/claude-transcript.md` |
| O3 — Select a permission mode appropriate to a task | Planning phase: choose and justify `acceptEdits` or plan mode; documented in reflection |
| O4 — Write a `CLAUDE.md` that reliably steers Claude | Implementation: Quips `CLAUDE.md` rules steer the session; hook enforces at least one rule |
| O5 — Author a subagent with correct frontmatter and model routing | Review phase: invoke the `reviewer` subagent (or equivalent) to critique the diff before merging |
| O6 — Integrate one MCP server and call its tools | Optional enrichment: use an MCP tool (e.g., `fs-scoped` or `git-read`) during the session if it adds value |
| O7 — Write a hook that blocks an unsafe action | Workflow protection: at least one PreToolUse hook active during the capstone session |
| O8 — Author a skill and invoke it via slash | Optional enrichment: invoke a skill (e.g., `dump-db`) during the session if it adds value |
| O9 — Ship a feature via reviewed PR using Claude Code in CI | PR phase: open PR, CI claude-review workflow runs, you respond with `claude -p` |
| O10 — Diagnose a failed Claude run and recover | Reflection: document one point where the session went wrong and how you recovered |

---

## Deliverable structure

Create an `evidence/` directory inside `Labs/_CAPSTONE/` and populate it before running `verify.sh`.

```
Labs/_CAPSTONE/evidence/
├── pr_url.txt              # required
├── reflection.md           # required
├── claude-transcript.md    # required
└── architecture.md         # optional
```

**`pr_url.txt`** — A single line containing the full URL of your PR (merged or open for review). Example:
```
https://github.com/your-org/CCLabs/pull/42
```

**`reflection.md`** — At least 500 words. Address all four rubric dimensions:
- *Plan quality*: How did you plan? Did you revise the plan mid-session? What evidence do you have that plan mode shaped the output?
- *Safety*: Which permission mode did you use and why? What deny rules or hooks were active? Where did a safety choice change what Claude did?
- *Verification*: What tests did you write? Did you run the review subagent? Did CI catch anything? How did you close the loop?
- *Communication*: What is in your PR body? Did you use `claude -p` to respond to a review comment? Paste an example exchange.

**`claude-transcript.md`** — Key excerpts (not the full raw log) from the Claude sessions that shaped the solution. Include at minimum: the planning exchange, the first test-implementation loop, and the review subagent output. Annotate each excerpt with one sentence explaining why it was significant.

**`architecture.md`** (optional) — If your feature involved non-trivial design decisions (e.g., rate-limit storage strategy, pagination cursor vs. offset), document them here. Describe the tradeoffs you considered and the choice you made.

---

## Workflow (suggested)

1. **Plan with Claude in plan mode.** Open a session on the Quips codebase with `claude` and immediately engage plan mode. State which option you chose and ask Claude to produce a step-by-step implementation plan including tests. Capture this exchange for your transcript.

2. **Create a feature branch.** `git checkout -b capstone-<option-letter>` before any code changes.

3. **Write failing tests first.** Ask Claude to write the tests before any implementation. Run them; confirm they fail. This is your RED phase.

4. **Let Claude implement. Review every diff.** Use the `reviewer` subagent (or `claude -p "review this diff as a senior engineer"`) to critique each non-trivial change before accepting. Do not accept diffs you cannot explain.

5. **Run `verify.sh` and all Quips tests.** Confirm green. Fix any failures in production code, not by adjusting tests.

6. **Open a PR.** Write a meaningful PR body: what the feature does, how it was tested, what safety choices were made. Run `claude -p` with the PR URL to generate or refine the body if useful.

7. **Let the Lab 028 CI workflow run.** If it posts a review comment, respond to it using `claude -p "here is the review comment: ... draft a reply"`. Include this exchange in your transcript.

8. **Tag the final commit.** `git tag capstone-complete` (local tag is sufficient).

9. **Write `evidence/reflection.md`** against the four rubric dimensions. Be specific — vague claims score lower than concrete evidence.

---

## Scoring

See `rubric.md` for the full 4×4 rubric. Score yourself honestly against each dimension.

The pass bar is **≥3 on all four dimensions**. A score of 2 or below on any single dimension means the Capstone is not yet complete — revise the artifact and re-score.

If you are working with an instructor, share `evidence/reflection.md` and your PR URL. The instructor scores independently; discrepancies of more than one level on any dimension trigger a calibration conversation.

---

## References

- Claude Code documentation: <https://docs.claude.com/en/docs/claude-code/overview>
- Claude Code Action (CI integration): <https://github.com/anthropics/claude-code-action>
- Quips codebase: `quips/` in this repository
