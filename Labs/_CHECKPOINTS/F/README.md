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

#### Interactive quiz

<div class="ccg-quiz" data-lab="checkpoint-f">
  <div class="ccg-q" data-answer="b">
    <p><strong>Q1.</strong> How do <code>dump-db</code> and <code>seed-db</code> compose — what round-trip do they form together?</p>
    <label><input type="radio" name="checkpoint-f-q1" value="a"> A. <code>seed-db</code> exports the schema; <code>dump-db</code> imports it into a new database</label>
    <label><input type="radio" name="checkpoint-f-q1" value="b"> B. <code>seed-db</code> loads a known state; <code>dump-db</code> exports current state — diffing both proves changes</label>
    <label><input type="radio" name="checkpoint-f-q1" value="c"> C. <code>dump-db</code> creates a backup; <code>seed-db</code> restores it after a failed migration</label>
    <label><input type="radio" name="checkpoint-f-q1" value="d"> D. They are independent tools with no intended composition</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Together they form a round-trip: <code>seed-db</code> installs a known fixture state and <code>dump-db</code> exports the current state, so diffing the two snapshots proves exactly what changed.</p>
  </div>
  <div class="ccg-q" data-answer="c">
    <p><strong>Q2.</strong> Why does each MCP server need its own <code>scope</code> argument when registered in <code>settings.json</code>?</p>
    <label><input type="radio" name="checkpoint-f-q2" value="a"> A. So Claude can display the server name in the UI</label>
    <label><input type="radio" name="checkpoint-f-q2" value="b"> B. To specify which Claude model the server communicates with</label>
    <label><input type="radio" name="checkpoint-f-q2" value="c"> C. Scope args prevent one server from reading outside its intended directory or repo, enforcing least privilege</label>
    <label><input type="radio" name="checkpoint-f-q2" value="d"> D. To set the authentication token for each server independently</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Each MCP server's <code>scope</code> argument limits the filesystem paths or git repositories it can access, implementing least-privilege so a compromised server cannot read the entire machine.</p>
  </div>
  <div class="ccg-q" data-answer="a">
    <p><strong>Q3.</strong> Which secret must be added to the repo's Actions settings before the <code>claude-code-action</code> workflow can run?</p>
    <label><input type="radio" name="checkpoint-f-q3" value="a"> A. <code>ANTHROPIC_API_KEY</code></label>
    <label><input type="radio" name="checkpoint-f-q3" value="b"> B. <code>CLAUDE_TOKEN</code></label>
    <label><input type="radio" name="checkpoint-f-q3" value="c"> C. <code>GITHUB_TOKEN</code> (must be created manually)</label>
    <label><input type="radio" name="checkpoint-f-q3" value="d"> D. <code>CI_SECRET</code></label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">The <code>claude-code-action</code> workflow authenticates with Anthropic's API using <code>ANTHROPIC_API_KEY</code>, which must be stored in the repo's Actions secrets before the workflow can make any API calls.</p>
  </div>
  <div class="ccg-q" data-answer="b">
    <p><strong>Q4.</strong> Which flag makes Claude Code run non-interactively and print the response to stdout?</p>
    <label><input type="radio" name="checkpoint-f-q4" value="a"> A. <code>--headless</code></label>
    <label><input type="radio" name="checkpoint-f-q4" value="b"> B. <code>-p</code> (or <code>--print</code>)</label>
    <label><input type="radio" name="checkpoint-f-q4" value="c"> C. <code>--batch</code></label>
    <label><input type="radio" name="checkpoint-f-q4" value="d"> D. <code>--quiet</code></label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">The <code>-p</code> (or <code>--print</code>) flag runs Claude non-interactively with the given prompt and prints the response to stdout, making it composable with shell pipelines and CI scripts.</p>
  </div>
  <div class="ccg-q" data-answer="d">
    <p><strong>Q5.</strong> Which <code>gh</code> CLI command opens a pull request from the current branch?</p>
    <label><input type="radio" name="checkpoint-f-q5" value="a"> A. <code>gh pr open</code></label>
    <label><input type="radio" name="checkpoint-f-q5" value="b"> B. <code>gh pull-request new</code></label>
    <label><input type="radio" name="checkpoint-f-q5" value="c"> C. <code>gh pr submit</code></label>
    <label><input type="radio" name="checkpoint-f-q5" value="d"> D. <code>gh pr create</code> (typically with <code>--fill</code> or <code>--title</code>/<code>--body</code>)</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain"><code>gh pr create</code> opens a pull request from the current branch. Adding <code>--fill</code> populates the title and body from the commit log automatically, making it the fastest path in a scripted workflow.</p>
  </div>
</div>

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
