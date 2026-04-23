# Checkpoint A — End of Part I

⏱ 30 min · 📦 You'll add: GET /version to Quips + reflection.md · 🔗 Integrates: Labs 001-005 · 🎯 Success: see verify.sh

---

### Part 1 — Quiz (5 min)

Answer from memory. Write your answers in `answers.md`, then compare against the key after Part 2.

1. **(Lab 001)** What single command installs Claude Code globally?
2. **(Lab 002)** When you exit a Claude Code REPL session and start a new one, does the new session remember the old? Why/why not?
3. **(Lab 003)** Which slash command clears the current session's conversation history?
4. **(Lab 004)** What database does Quips use under the hood?
5. **(Lab 005)** What HTTP status code should `GET /random` return when the quips table is empty?

#### Interactive quiz

<div class="ccg-quiz" data-lab="checkpoint-a">
  <div class="ccg-q" data-answer="c">
    <p><strong>Q1.</strong> What single command installs Claude Code globally?</p>
    <label><input type="radio" name="checkpoint-a-q1" value="a"> A. <code>npm install claude-code</code></label>
    <label><input type="radio" name="checkpoint-a-q1" value="b"> B. <code>npx claude-code install</code></label>
    <label><input type="radio" name="checkpoint-a-q1" value="c"> C. <code>npm i -g @anthropic-ai/claude-code</code></label>
    <label><input type="radio" name="checkpoint-a-q1" value="d"> D. <code>brew install claude-code</code></label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">The official install command is <code>npm i -g @anthropic-ai/claude-code</code>, which installs the package globally so the <code>claude</code> binary is available anywhere in your shell.</p>
  </div>
  <div class="ccg-q" data-answer="d">
    <p><strong>Q2.</strong> When you exit a Claude Code REPL session and start a new one, does the new session remember the previous conversation?</p>
    <label><input type="radio" name="checkpoint-a-q2" value="a"> A. Yes, Claude Code persists all conversation history to disk by default</label>
    <label><input type="radio" name="checkpoint-a-q2" value="b"> B. Yes, but only the last five messages are retained</label>
    <label><input type="radio" name="checkpoint-a-q2" value="c"> C. Only if you ran <code>/compact</code> before exiting</label>
    <label><input type="radio" name="checkpoint-a-q2" value="d"> D. No, each new invocation starts with a fresh context</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Each <code>claude</code> invocation begins with an empty context. Session history is not persisted between separate REPL launches — memory must be explicitly loaded via CLAUDE.md files or MCP tools.</p>
  </div>
  <div class="ccg-q" data-answer="b">
    <p><strong>Q3.</strong> Which slash command clears the current session's conversation history?</p>
    <label><input type="radio" name="checkpoint-a-q3" value="a"> A. <code>/reset</code></label>
    <label><input type="radio" name="checkpoint-a-q3" value="b"> B. <code>/clear</code></label>
    <label><input type="radio" name="checkpoint-a-q3" value="c"> C. <code>/forget</code></label>
    <label><input type="radio" name="checkpoint-a-q3" value="d"> D. <code>/purge</code></label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain"><code>/clear</code> wipes the conversation history so the next message starts a blank context, without exiting the REPL or saving anything to disk.</p>
  </div>
  <div class="ccg-q" data-answer="a">
    <p><strong>Q4.</strong> What database does the Quips project use under the hood?</p>
    <label><input type="radio" name="checkpoint-a-q4" value="a"> A. SQLite via better-sqlite3</label>
    <label><input type="radio" name="checkpoint-a-q4" value="b"> B. PostgreSQL via pg</label>
    <label><input type="radio" name="checkpoint-a-q4" value="c"> C. MongoDB via Mongoose</label>
    <label><input type="radio" name="checkpoint-a-q4" value="d"> D. An in-memory Map with no persistence</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Quips uses SQLite through the better-sqlite3 driver, giving it a file-based relational store that requires no separate server process.</p>
  </div>
  <div class="ccg-q" data-answer="c">
    <p><strong>Q5.</strong> What HTTP status code should <code>GET /random</code> return when the quips table is empty?</p>
    <label><input type="radio" name="checkpoint-a-q5" value="a"> A. 200 with an empty body</label>
    <label><input type="radio" name="checkpoint-a-q5" value="b"> B. 204 No Content</label>
    <label><input type="radio" name="checkpoint-a-q5" value="c"> C. 404 with <code>{"error": "no quips"}</code></label>
    <label><input type="radio" name="checkpoint-a-q5" value="d"> D. 500 Internal Server Error</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">When no quips exist the server returns 404 with body <code>{"error": "no quips"}</code>, signalling that the requested resource cannot be found rather than that the server failed.</p>
  </div>
</div>

---

### Part 2 — Integration task (20 min)

Add a `GET /version` endpoint to Quips that returns `{"version": "0.1.0"}` with status 200. Use Claude Code to implement it — but before executing, dry-run in your head: which files change? Which tests should you add?

**a.** Read `quips/package.json` and note the `version` field.

```bash
grep '"version"' quips/package.json
```

**b.** Open Claude Code inside the Quips project and ask it to add the route, reading the version dynamically from `package.json` — not hardcoded.

```bash
cd quips && claude
```

Prompt to use:

> Add a `GET /version` route that reads the `version` field from `package.json` at startup and returns `{"version": "<value>"}` with status 200. Follow the existing style in `src/server.js`.

**c.** Still in the REPL, ask Claude to add a Vitest test for it:

> Add a Vitest test for `GET /version` that asserts status 200 and that the body has a `version` string. Add it to `test/server.test.js` following the existing `describe` block style.

**(d)** Run the test suite — it must be fully green:

```bash
cd quips && npm test
```

Expected: all tests pass, including the new `/version` test.

**(e)** Write `Labs/_CHECKPOINTS/A/reflection.md` (from the repo root) with at least 3 sentences covering:
  - (i) What felt harder than Part I suggested
  - (ii) What you now trust Claude to do unsupervised
  - (iii) What you still want to confirm manually

---

### Part 3 — Self-debrief (5 min)

Open `Labs/_CHECKPOINTS/A/answers.md` and compare against your quiz answers from Part 1. Score yourself out of 5.

Add one line to your `reflection.md`:

```
Quiz: X/5
```

Replace `X` with your actual score.

---

### References

- https://docs.claude.com/en/docs/claude-code/overview

---

### Next — Part II opens with Lab 006.
