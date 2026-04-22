# Checkpoint C — End of Part III

⏱ 30 min · 📦 You'll add: enriched quips/CLAUDE.md + rule-honored feature + reflection.md · 🔗 Integrates: Labs 011-015 · 🎯 Success: see verify.sh

---

### Part 1 — Quiz (5 min)

Answer from memory. Write your answers in `answers.md`, then compare against the key after Part 2.

1. **(Lab 011)** Where does Claude look first for project memory when you open a session in `quips/`?
2. **(Lab 012)** What does prefixing a path with `@` change about Claude's behavior?
3. **(Lab 013)** Rank by precedence (highest first): user, project, local, enterprise, CLI flag.
4. **(Lab 014)** After running `/compact`, can Claude still recall the first message you sent this session? Why or why not?
5. **(Lab 015)** When do nested CLAUDE.md rules take effect?

---

### Part 2 — Integration task (20 min)

Strengthen `quips/CLAUDE.md` so it has **5 or more rule lines** (lines starting with `-`, `*`, or a digit followed by `.`). At least one rule must be *testable* — for example:

> Every route file must export a single default async function.

Once your `quips/CLAUDE.md` is in place, open Claude Code inside the Quips project and ask it to add a `PATCH /quips/:id` route that updates `text` and `tags`:

```bash
cd quips && claude
```

Prompt to use:

> Add a `PATCH /quips/:id` route that accepts `{ text?, tags? }` and updates only the supplied fields. Return the updated quip with status 200, or 404 if the id does not exist. Follow the existing style in `src/server.js`.

Then ask Claude to add tests:

> Add Vitest tests for `PATCH /quips/:id` to `test/server.test.js`: assert 200 + updated body, 404 for missing id, and that omitting a field leaves the original value unchanged.

Run the suite:

```bash
cd quips && npm test
```

Expected: all tests pass, including the new `PATCH` tests.

Observe: did Claude honor your `quips/CLAUDE.md` rules without you prompting it? Update your `reflection.md` accordingly.

---

### Part 3 — Self-debrief (5 min)

Write `Labs/_CHECKPOINTS/C/reflection.md` with at least 3 sentences covering:
- Which rule Claude followed best
- Which rule it broke (or ignored)
- What you would tighten next time

Add one line:

```
Quiz: X/5
```

Replace `X` with your actual score.

---

### References

- https://docs.claude.com/en/docs/claude-code/memory

---

### Next — Lab 016 opens Part IV.
