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

#### Interactive quiz

<div class="ccg-quiz" data-lab="checkpoint-b">
  <div class="ccg-q" data-answer="a">
    <p><strong>Q1.</strong> Which single prompting move most reliably prevents Claude from asking clarifying questions?</p>
    <label><input type="radio" name="checkpoint-b-q1" value="a"> A. Adding specificity — schema, function signature, or expected output</label>
    <label><input type="radio" name="checkpoint-b-q1" value="b"> B. Providing examples of the desired tone</label>
    <label><input type="radio" name="checkpoint-b-q1" value="c"> C. Listing explicit constraints such as line-length limits</label>
    <label><input type="radio" name="checkpoint-b-q1" value="d"> D. Asking Claude to think step by step before replying</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Specificity — including a concrete schema, function signature, or expected output — removes the ambiguity that triggers clarifying questions, so Claude can proceed directly to implementation.</p>
  </div>
  <div class="ccg-q" data-answer="b">
    <p><strong>Q2.</strong> When Claude wants to change a file, which tool must it invoke before calling Edit?</p>
    <label><input type="radio" name="checkpoint-b-q2" value="a"> A. Write</label>
    <label><input type="radio" name="checkpoint-b-q2" value="b"> B. Read</label>
    <label><input type="radio" name="checkpoint-b-q2" value="c"> C. Grep</label>
    <label><input type="radio" name="checkpoint-b-q2" value="d"> D. Glob</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Edit requires a prior Read of the same file in the same session. Without the Read, the Edit tool cannot verify the existing content and will reject the call to prevent accidental overwrites.</p>
  </div>
  <div class="ccg-q" data-answer="c">
    <p><strong>Q3.</strong> What does plan mode prevent Claude from doing, even if you explicitly ask?</p>
    <label><input type="radio" name="checkpoint-b-q3" value="a"> A. Generating code or pseudocode in its response</label>
    <label><input type="radio" name="checkpoint-b-q3" value="b"> B. Reading files from the project</label>
    <label><input type="radio" name="checkpoint-b-q3" value="c"> C. Executing edits or running non-read-only Bash commands</label>
    <label><input type="radio" name="checkpoint-b-q3" value="d"> D. Asking follow-up clarifying questions</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Plan mode locks Claude into a read-only posture: it can explore, analyse, and produce a plan, but it cannot write files or run shell commands until you exit plan mode.</p>
  </div>
  <div class="ccg-q" data-answer="d">
    <p><strong>Q4.</strong> What file path holds project-local Claude permissions?</p>
    <label><input type="radio" name="checkpoint-b-q4" value="a"> A. <code>.clauderc</code></label>
    <label><input type="radio" name="checkpoint-b-q4" value="b"> B. <code>claude.config.json</code></label>
    <label><input type="radio" name="checkpoint-b-q4" value="c"> C. <code>.claude/permissions.json</code></label>
    <label><input type="radio" name="checkpoint-b-q4" value="d"> D. <code>.claude/settings.local.json</code> (or <code>.claude/settings.json</code>)</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Project-local permissions live in <code>.claude/settings.local.json</code> (gitignored by convention) or <code>.claude/settings.json</code> (checked in), both relative to the project root.</p>
  </div>
  <div class="ccg-q" data-answer="b">
    <p><strong>Q5.</strong> When a schema change breaks tests, what is the cheapest way to keep them green without hiding bugs?</p>
    <label><input type="radio" name="checkpoint-b-q5" value="a"> A. Skip the failing assertions with <code>.skip</code> until the migration is complete</label>
    <label><input type="radio" name="checkpoint-b-q5" value="b"> B. Update the tests' seed data or use <code>resetDb()</code></label>
    <label><input type="radio" name="checkpoint-b-q5" value="c"> C. Loosen the assertions so any shape is accepted</label>
    <label><input type="radio" name="checkpoint-b-q5" value="d"> D. Mock the database layer so no real schema is exercised</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Updating seed data or calling <code>resetDb()</code> brings fixtures in line with the new schema while keeping assertions strict, so tests still catch regressions without masking real bugs.</p>
  </div>
</div>

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
