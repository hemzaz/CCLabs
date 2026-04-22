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
