# Checkpoint B — End of Part II

⏱ 30 min · 📦 You'll add: pagination on GET /quips + reflection.md · 🔗 Integrates: Labs 006-010 · 🎯 Success: see verify.sh

---

### Part 1 — Quiz (5 min)

Answer from memory. Write your answers in `answers.md`, then compare against the key after Part 2.

1. **(Lab 006)** Which single prompting move tends to prevent Claude from asking clarifying questions: specificity, examples, or constraints?
2. **(Lab 007)** When Claude wants to change a file, which tool must it invoke BEFORE Edit?
3. **(Lab 008)** What does plan mode prevent Claude from doing, even if you ask?
4. **(Lab 009)** What file path holds project-local Claude permissions?
5. **(Lab 010)** When a schema change breaks tests, what's the cheapest way to keep them green without hiding bugs?

---

### Part 2 — Integration task (20 min)

Enter plan mode, then ask Claude to design pagination for `GET /quips`:

```
Plan: add pagination to GET /quips with query params:
  - limit  (default 20, max 100)
  - offset (default 0)
Return shape: { data: [...], total: <n>, limit: <n>, offset: <n> }
```

Review the plan. Revise if needed. Exit plan mode. Execute.

Add Vitest tests covering:

- Default limits apply when no params are given
- Explicit `limit` and `offset` are respected
- `limit` out of range (e.g. 101) → 400
- `offset` beyond data length → empty `data` array

All prior tests must still pass.

---

### Part 3 — Self-debrief (5 min)

Write `Labs/_CHECKPOINTS/B/reflection.md` with at least 3 sentences covering:

- (i) What plan mode added vs. going straight to execution
- (ii) What permission mode you used during this checkpoint
- (iii) What you'd automate next

Add one line at the end:

```
Quiz: X/5
```

Replace `X` with your actual score.

---

### References

- https://docs.claude.com/en/docs/claude-code/overview

---

### Next — Lab 011 opens Part III.
