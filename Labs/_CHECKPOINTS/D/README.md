# Checkpoint D — End of Part IV

⏱ 30 min · 📦 You'll add: hardened feature with verify.sh + reflection.md · 🔗 Integrates: Labs 016-020 · 🎯 Success: see verify.sh

---

### Part 1 — Quiz (5 min)

Answer from memory. Write your answers in `answers.md`, then compare against the key after Part 2.

1. **(Lab 016)** In red-green-refactor, what is the correct order of the three phases?
2. **(Lab 017)** When Claude goes off-track mid-generation, what is the first rescue move?
3. **(Lab 018)** In a self-review workflow, what is the purpose of a challenge prompt after Claude produces a diff?
4. **(Lab 019)** What exit-code contract must a valid `verify.sh` script honour: when does it exit 0, and when does it exit non-zero?
5. **(Lab 020)** Why must you establish a green baseline BEFORE starting a refactor?

---

### Part 2 — Integration task (20 min)

Add a `DELETE /quips/:id` route to the Quips server using strict TDD discipline, then verify it with a shell script and clean up if a refactor opportunity appears.

**Steps:**

1. Write a failing test first. Open `quips/test/server.test.js` and add a `DELETE /quips/:id` test block that asserts:
   - `DELETE` on an existing id returns 204 (or 200) and the quip is no longer returned by `GET /quips`.
   - `DELETE` on a non-existent id returns 404.
   Run the suite — it must be **red** before you implement anything.

2. Implement the route. Ask Claude to add `DELETE /quips/:id` to `quips/src/server.js` following the existing style. Run the suite — it must go **green**.

3. Self-review the diff. Ask Claude:
   > Challenge this diff: what could go wrong, what edge cases are unhandled, and what would a code reviewer flag?
   Address any HIGH-severity findings before moving on.

4. Write `quips/verify-delete.sh` that:
   - Starts the server (or uses a test runner), hits `DELETE /quips/:id` on a known id, and asserts the expected status code.
   - Exits 0 on success, non-zero on any failure.
   - Is executable (`chmod +x`).

5. Refactor opportunity: if removing the quip leaves duplicate logic in the route handlers (e.g., repeated id-lookup), extract it. All prior tests must remain green.

Run the full suite before submitting:

```bash
cd quips && npm test
```

Expected: all tests pass, including the new DELETE tests.

---

### Part 3 — Self-debrief (5 min)

Write `Labs/_CHECKPOINTS/D/reflection.md` with at least 3 sentences covering:

- (i) Which of the five labs' discipline (TDD, rescue, self-review, verify.sh contracts, baseline-first refactor) was hardest to apply and why.
- (ii) What failed first during Part 2 and how you rescued it.
- (iii) One rule you would add to `quips/CLAUDE.md` based on what you observed in this checkpoint.

Add one line at the end:

```
Quiz: X/5
```

Replace `X` with your actual score.

---

### References

- https://docs.claude.com/en/docs/claude-code/common-workflows

---

### Next

Next — Lab 021 opens Part V.
