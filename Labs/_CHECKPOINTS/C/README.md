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

#### Interactive quiz

<div class="ccg-quiz" data-lab="checkpoint-c">
  <div class="ccg-q" data-answer="a">
    <p><strong>Q1.</strong> Where does Claude look first for project memory when you open a session in <code>quips/</code>?</p>
    <label><input type="radio" name="checkpoint-c-q1" value="a"> A. <code>quips/CLAUDE.md</code> at the working-directory root</label>
    <label><input type="radio" name="checkpoint-c-q1" value="b"> B. <code>~/.claude/CLAUDE.md</code> in the user's home directory</label>
    <label><input type="radio" name="checkpoint-c-q1" value="c"> C. <code>.claude/settings.json</code> inside the project</label>
    <label><input type="radio" name="checkpoint-c-q1" value="d"> D. The most recently edited file in the repo</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Claude loads <code>CLAUDE.md</code> from the current working directory first, making <code>quips/CLAUDE.md</code> the primary source of project-specific memory and rules.</p>
  </div>
  <div class="ccg-q" data-answer="b">
    <p><strong>Q2.</strong> What does prefixing a file path with <code>@</code> change about Claude's behavior?</p>
    <label><input type="radio" name="checkpoint-c-q2" value="a"> A. It marks the file as read-only so Claude will not edit it</label>
    <label><input type="radio" name="checkpoint-c-q2" value="b"> B. It forces Claude to Read that path into context immediately, rather than guess at its contents</label>
    <label><input type="radio" name="checkpoint-c-q2" value="c"> C. It adds the file to the gitignore list automatically</label>
    <label><input type="radio" name="checkpoint-c-q2" value="d"> D. It pins the file so compaction never drops it</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">The <code>@path</code> syntax tells Claude to read that file into context immediately, ensuring it works from the actual content rather than a guess or a stale mental model.</p>
  </div>
  <div class="ccg-q" data-answer="d">
    <p><strong>Q3.</strong> Rank these memory sources by precedence, highest first: user, project, local, enterprise, CLI flag.</p>
    <label><input type="radio" name="checkpoint-c-q3" value="a"> A. user &gt; project &gt; local &gt; enterprise &gt; CLI flag</label>
    <label><input type="radio" name="checkpoint-c-q3" value="b"> B. enterprise &gt; user &gt; project &gt; local &gt; CLI flag</label>
    <label><input type="radio" name="checkpoint-c-q3" value="c"> C. local &gt; project &gt; user &gt; enterprise &gt; CLI flag</label>
    <label><input type="radio" name="checkpoint-c-q3" value="d"> D. CLI flag &gt; enterprise &gt; local &gt; project &gt; user</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">CLI flags override everything at runtime, then enterprise policy, then local settings, then project settings, then user settings — the most-specific and most-immediate source wins.</p>
  </div>
  <div class="ccg-q" data-answer="c">
    <p><strong>Q4.</strong> After running <code>/compact</code>, can Claude still recall the first message you sent this session?</p>
    <label><input type="radio" name="checkpoint-c-q4" value="a"> A. Yes, compaction preserves every message verbatim</label>
    <label><input type="radio" name="checkpoint-c-q4" value="b"> B. Yes, but only the first and last five messages are retained</label>
    <label><input type="radio" name="checkpoint-c-q4" value="c"> C. Partially — compaction summarises and drops raw turns; earlier specifics may be lost but key facts are preserved</label>
    <label><input type="radio" name="checkpoint-c-q4" value="d"> D. No, compaction deletes all history and restarts the context</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Compaction replaces the conversation history with a summary. Key facts are carried forward, but verbatim early messages are dropped, so highly specific details from the first turn may no longer be retrievable.</p>
  </div>
  <div class="ccg-q" data-answer="b">
    <p><strong>Q5.</strong> When do nested <code>CLAUDE.md</code> rules take effect?</p>
    <label><input type="radio" name="checkpoint-c-q5" value="a"> A. Always, regardless of which directory Claude is working in</label>
    <label><input type="radio" name="checkpoint-c-q5" value="b"> B. When Claude is working in the directory containing the nested file or any subdirectory below it</label>
    <label><input type="radio" name="checkpoint-c-q5" value="c"> C. Only when you explicitly reference them with <code>@path</code></label>
    <label><input type="radio" name="checkpoint-c-q5" value="d"> D. Only if the root <code>CLAUDE.md</code> imports them with an <code>include:</code> directive</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Nested <code>CLAUDE.md</code> files are scoped to their directory and below: Claude picks them up automatically when it is operating inside that subtree, layering them on top of any parent-level rules.</p>
  </div>
</div>

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
