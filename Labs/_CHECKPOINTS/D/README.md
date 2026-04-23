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

#### Interactive quiz

<div class="ccg-quiz" data-lab="checkpoint-d">
  <div class="ccg-q" data-answer="b">
    <p><strong>Q1.</strong> In red-green-refactor, what is the correct order of the three phases?</p>
    <label><input type="radio" name="checkpoint-d-q1" value="a"> A. Green → Red → Refactor</label>
    <label><input type="radio" name="checkpoint-d-q1" value="b"> B. Red → Green → Refactor</label>
    <label><input type="radio" name="checkpoint-d-q1" value="c"> C. Refactor → Red → Green</label>
    <label><input type="radio" name="checkpoint-d-q1" value="d"> D. Red → Refactor → Green</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">TDD requires writing a failing test first (Red), then the minimal code to make it pass (Green), then cleaning up the implementation while keeping the suite green (Refactor).</p>
  </div>
  <div class="ccg-q" data-answer="a">
    <p><strong>Q2.</strong> When Claude goes off-track mid-generation, what is the first rescue move?</p>
    <label><input type="radio" name="checkpoint-d-q2" value="a"> A. Press ESC to interrupt Claude mid-stream, then run <code>git status</code> to inspect what changed</label>
    <label><input type="radio" name="checkpoint-d-q2" value="b"> B. Close the terminal and reopen a fresh session</label>
    <label><input type="radio" name="checkpoint-d-q2" value="c"> C. Run <code>/clear</code> and repeat the original prompt</label>
    <label><input type="radio" name="checkpoint-d-q2" value="d"> D. Let Claude finish, then revert with <code>git checkout .</code></label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">ESC interrupts the stream immediately, limiting unintended changes. Checking <code>git status</code> next gives you a clear picture of what was written before deciding how to proceed or roll back.</p>
  </div>
  <div class="ccg-q" data-answer="c">
    <p><strong>Q3.</strong> In a self-review workflow, what is the purpose of a challenge prompt after Claude produces a diff?</p>
    <label><input type="radio" name="checkpoint-d-q3" value="a"> A. To ask Claude to rewrite the diff in a different style</label>
    <label><input type="radio" name="checkpoint-d-q3" value="b"> B. To generate a changelog entry for the diff</label>
    <label><input type="radio" name="checkpoint-d-q3" value="c"> C. To force Claude to argue against its own output, surfacing edge cases and reviewer-worthy issues it would otherwise skip</label>
    <label><input type="radio" name="checkpoint-d-q3" value="d"> D. To confirm that the diff compiles before committing</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">A challenge prompt deliberately puts Claude in an adversarial role toward its own output, which uncovers missing error handling, hidden assumptions, and edge cases that a straightforward generation pass tends to miss.</p>
  </div>
  <div class="ccg-q" data-answer="d">
    <p><strong>Q4.</strong> What exit-code contract must a valid <code>verify.sh</code> script honour?</p>
    <label><input type="radio" name="checkpoint-d-q4" value="a"> A. Exit 0 always; use stderr messages to signal failures</label>
    <label><input type="radio" name="checkpoint-d-q4" value="b"> B. Exit 1 on success, exit 0 on failure</label>
    <label><input type="radio" name="checkpoint-d-q4" value="c"> C. Exit any non-zero code on both pass and fail to trigger CI notifications</label>
    <label><input type="radio" name="checkpoint-d-q4" value="d"> D. Exit 0 when every assertion passes; exit non-zero on the first assertion failure</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Shell convention and CI tooling both rely on exit 0 meaning success and any non-zero exit meaning failure. A <code>verify.sh</code> that exits 0 on failure silently hides breakage from automated pipelines.</p>
  </div>
  <div class="ccg-q" data-answer="b">
    <p><strong>Q5.</strong> Why must you establish a green baseline before starting a refactor?</p>
    <label><input type="radio" name="checkpoint-d-q5" value="a"> A. So that the refactor can be merged without a code review</label>
    <label><input type="radio" name="checkpoint-d-q5" value="b"> B. A green baseline proves existing tests pass before your changes, so any newly broken test is caused by your refactor, not a pre-existing bug</label>
    <label><input type="radio" name="checkpoint-d-q5" value="c"> C. It allows you to skip writing new tests during the refactor</label>
    <label><input type="radio" name="checkpoint-d-q5" value="d"> D. It documents the original code style before changes are made</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Without a green baseline you cannot distinguish regressions introduced by your refactor from bugs that were already present. A passing suite before you start gives you a reliable signal when something breaks.</p>
  </div>
</div>

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
