# Checkpoint F — End of Part VI

⏱ 30 min · 📦 You'll add: shipped PR, CI review comment thread, reflection.md · 🔗 Integrates: Labs 026-030 · 🎯 Success: see verify.sh

---

### Part 1 — Quiz (5 min)

Answer from memory. Write your answers in `answers.md`, then compare against the key after Part 2.

1. **(Lab 026)** How does `dump-db` compose with `seed-db` — what round-trip do they form together?
2. **(Lab 027)** Why does each MCP server need its own `scope` argument when registered in `settings.json`?
3. **(Lab 028)** Which secret must be added to the repo's Actions settings before the `claude-code-action` workflow can run?
4. **(Lab 029)** Which flag makes Claude Code run non-interactively and print the response to stdout?
5. **(Lab 030)** Which `gh` CLI command opens a pull request from the current branch?

---

### Part 2 — Integration task (20 min)

Ship a small follow-up feature to Quips using all five Part VI capabilities.

**Steps:**

1. **Add a `GET /quips/count` endpoint (Labs 026 + 030).** Implement the route in `quips/src/server.js` and add a test for it in `quips/test/server.test.js`. Run `npm test` inside `quips/` — all tests must pass.

2. **Seed, then snapshot the DB (Lab 026).** Run the `seed-db` skill to populate the database, then run `dump-db` to export the current state. The dump file proves the new endpoint has data to count. Confirm `quips/.claude/skills/dump-db/SKILL.md` exists.

3. **Confirm MCP scopes (Lab 027).** Verify `quips/.claude/settings.json` contains both `fs-scoped` and `git-read` entries under `mcpServers`. Use the `fs-scoped` server to list `quips/src/` and confirm the new file appears.

4. **Open a PR and let CI run (Labs 028 + 030).** Commit your changes and open a pull request:
   ```bash
   gh pr create --fill
   ```
   Wait for the `claude-review` workflow to post its automated review comment. Record the PR URL.

5. **Respond to one review comment with headless Claude (Lab 029).** Pick one comment from the CI review thread and address it using `claude -p`:
   ```bash
   claude -p "The CI reviewer said: '<comment text>'. Suggest a one-line fix."
   ```
   Apply the suggested fix, push the revision, and confirm CI turns green.

6. **Record the outcome in `quips/SHIPPED.md`.** Append a line of the form:
   ```
   PR: https://github.com/<owner>/<repo>/pull/<number>
   ```
   so `verify.sh` can confirm the feature shipped.

7. **Capture your headless prompt in `quips/PR-LOOP.md`.** Record the exact `claude -p` invocation you used and the response it returned.

Run the full suite to confirm nothing regressed:

```bash
cd quips && npm test
```

Expected: all tests pass.

---

### Part 3 — Self-debrief (5 min)

Write `Labs/_CHECKPOINTS/F/reflection.md` with at least 3 sentences covering:

- (i) What the CI review caught that local `verify.sh` missed.
- (ii) Which headless `claude -p` prompt was most effective and why.
- (iii) One question you still have about operating Claude in CI.

Add one line at the end:

```
Quiz: X/5
```

Replace `X` with your actual score.

---

### References

- https://github.com/anthropics/claude-code-action
- https://docs.claude.com/en/docs/claude-code/github-actions

---

### Next — Capstone.
