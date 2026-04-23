# Lab 008 — Plan Mode

⏱ **20 min**   📦 **You'll add**: `Labs/008-PlanMode/plan-transcript.md`   🔗 **Builds on**: Lab 007   🎯 **Success**: `plan-transcript.md exists, contains the word 'plan' and a numbered or bulleted list of steps, plus an APPROVE/REVISE note`

<!--
  Template contract - do not remove this comment.
  See docs/DESIGN.md §7 and scripts/lint-labs.sh for the author contract.
-->

!!! hint "Overview"
    - You will enter plan mode and ask Claude to propose a multi-file refactor without touching a single file.
    - You will revise the plan mid-review, then approve and watch Claude execute exactly what it described.
    - You will discover how plan mode catches risky changes — like overwriting tests — before any damage is done.
    - By the end you will have saved a plan transcript and built the habit of reviewing before executing.

**Concept**: `Plan mode: Claude proposes a complete plan before executing any action` (Bloom: Analyze)

---

## Prerequisites

- Completed Lab 007 — Claude's tool use is familiar and `observations.md` exists
- A running `claude` installation and auth configured (Pro/Max login or `ANTHROPIC_API_KEY`)
- The `quips/` project present in the repo root (`./scripts/doctor.sh 008` confirms this)

## What You Will Learn

- What plan mode is and what it prevents (no file writes, no tool execution during planning)
- How to enter plan mode with Shift+Tab or `/plan`
- How to revise a plan before approving it
- How to approve a plan and let Claude execute it
- Why plan mode is valuable even for tasks that feel small

## Why

When Claude executes immediately, you only see what it did — not what it considered. Plan mode surfaces the reasoning step: Claude describes every file it would touch and every action it would take, before writing a single byte. That gap between intent and execution is where costly mistakes hide. A plan takes thirty seconds to read and can save you from a refactor that quietly overwrites your tests, renames the wrong module, or skips an edge case you cared about.

Reviewing a plan is also a skill. You learn to spot vague steps ("update the code"), probe for specifics, and negotiate changes before they hit the filesystem. That habit transfers to code review, architecture discussions, and any other situation where reading carefully before approving matters.

## Walkthrough

Plan mode is a special operating state inside the Claude Code REPL. While it is active, Claude responds to every prompt with a structured plan — a numbered list of actions it would take — but does not call any tools, write any files, or execute any shell commands. The session stays in a read-only, deliberation state until you either approve the plan or revise it.

**Entering plan mode.** There are two ways:

| Method | Steps |
|---|---|
| **Shift+Tab** | Press Shift+Tab once (or twice) at the REPL prompt until the footer status bar shows `plan mode` |
| **`/plan`** | Type `/plan` at the REPL prompt to toggle plan mode on |

If your terminal does not support Shift+Tab (some SSH setups strip it), `/plan` always works.

**What changes while plan mode is active.** Claude still reads, reasons, and replies — but every response is a plan document rather than an execution. No `Edit`, `Write`, or `Bash` calls happen. If you check the filesystem mid-review, it will be completely unchanged.

**Contrast: direct mode vs plan mode.**

Suppose you ask Claude to extract a `logger.js` module from `app.js`. In direct mode, files change immediately — you review the diff after the fact. In plan mode, Claude instead outputs something like:

```
Plan (3 steps):
1. Read app.js to identify all logging calls.
2. Create logger.js with a single exported `log(level, msg)` function.
3. Replace each logging call in app.js with an import of logger.js.
```

No file was written. You can now read step 2 and notice it is missing error-level logging you need, revise the plan, and only then approve it. This is where plan mode earns its keep: it caught the gap before the file existed.

**Revising a plan.** Type any follow-up message while still in plan mode. Claude updates the plan in place. You can iterate as many times as you need.

**Approving and executing.** When the plan looks right, approve it. Claude exits plan mode automatically and executes each step. If you decide not to proceed at all, type `/plan` again to toggle off and abandon without any side effects.

**Saving a plan.** Plans exist only in the REPL output — they are not auto-saved. Copy the plan text into a file if you want a record (Task 5 below walks through this).

## Check

```bash
./scripts/doctor.sh 008
```

Expected output: `OK lab 008 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before running, write down one sentence: what does plan mode prevent that normal direct execution allows?

   Verify the `quips` project exists before proceeding:

   ```bash
   [[ -d quips ]] && echo "quips present" || echo "quips missing"
   ```

   Expected: `quips present`

2. **Run** — start the Claude Code REPL inside the `quips` project and activate plan mode.

   ```bash
   cd quips && claude
   ```

   Once inside the REPL, enable plan mode. Press **Shift+Tab** once or twice until the footer status bar shows `plan mode`. If Shift+Tab does not work in your terminal, type `/plan` at the prompt instead.

   Confirm plan mode is on before continuing:

   ```bash
   echo "confirm the footer shows 'plan mode', then continue"
   ```

3. **Investigate** — ask Claude to plan a two-file refactor, but do NOT approve execution yet.

   Type the following prompt inside the REPL:

   > Refactor db.js into two files: db.js for connection setup and queries.js for all CRUD helpers.

   Claude will output a numbered plan of at least 3 steps and will not write any files. Verify:

   ```bash
   [[ ! -f quips/src/queries.js ]] && echo "no file written — plan only" || echo "file written unexpectedly"
   ```

   Expected: `no file written — plan only`

4. **Modify** — review the plan Claude proposed. If any step is vague or missing, ask for a revision while still in plan mode.

   Example revision prompt:

   > Expand step 2 to list the exact function names that move to queries.js.

   A revised plan appears in the REPL output. Confirm the filesystem is still unchanged:

   ```bash
   [[ ! -f quips/src/queries.js ]] && echo "still no file written" || echo "file written unexpectedly"
   ```

   Expected: `still no file written`

5. **Make** — copy the final plan from the REPL output (plus your approval or revision note) into the artifact file.

   Create `Labs/008-PlanMode/plan-transcript.md` containing:
   - The full plan Claude proposed (numbered or bulleted list of at least 3 steps)
   - A final line starting with `APPROVE:` or `REVISE:` and your one-sentence note

   Do NOT execute the plan — this lab is about planning, not executing the refactor.

   Verify:

   ```bash
   ./scripts/verify.sh 008
   ```

   Expected: exits 0 with no error output.

## Observe

Write one sentence: what did the plan reveal that you would have missed if Claude had executed immediately? No answer key — this is metacognition practice.

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| No "plan mode" in footer after Shift+Tab | Older CLI version or terminal strips the key sequence | Type `/plan` at the REPL prompt instead; or run `claude --help \| grep -i plan` to see the documented option | https://docs.claude.com/en/docs/claude-code/overview |
| Claude still edits files while plan mode appears active | Footer may be showing a cached state; mode was not applied to this prompt | Exit the REPL with `/exit`, re-enter, and re-enable plan mode before submitting the refactor prompt | https://docs.claude.com/en/docs/claude-code/overview |
| Plan is too vague to evaluate | Claude summarised at too high a level | Ask "expand step 2 into sub-steps with exact file paths and function names" — Claude will fill in the details without executing | https://github.com/anthropics/claude-code |

## Tasks

Click the checkbox next to each task to mark it done — your progress is saved locally.

### Task 1 — Enter plan mode and request a two-file refactor

**Scenario:** You want Claude to plan splitting `db.js` into two files without touching anything on disk.

**Hint:** Enter plan mode first (Shift+Tab or `/plan`), then submit the refactor request. Check that `queries.js` does not appear after Claude responds.

??? success "Solution"

    Start a session inside `quips/`:
    ```bash
    cd quips && claude
    ```
    Enable plan mode with Shift+Tab or by typing:
    ```
    /plan
    ```
    Then submit the prompt:
    ```
    Refactor db.js into two files: db.js for connection setup and queries.js for CRUD helpers.
    ```
    Claude responds with a numbered plan. Verify no file was created:
    ```bash
    [[ ! -f quips/src/queries.js ]] && echo "plan only — no file written" || echo "unexpected write"
    ```

### Task 2 — Revise the plan to add an edge case

**Scenario:** After reading the plan, you realise Claude did not account for transactions. You want that covered before approving.

**Hint:** While still in plan mode, send a follow-up message asking Claude to add a step covering transaction wrapping.

??? success "Solution"

    With plan mode still active after Task 1, type:
    ```
    Add a step to the plan that wraps the CRUD helpers in a transaction helper so callers can group operations atomically.
    ```
    Claude produces a revised plan with the new step inserted. Confirm the filesystem is still clean:
    ```bash
    [[ ! -f quips/src/queries.js ]] && echo "still plan only" || echo "unexpected write"
    ```

### Task 3 — Approve the plan and observe Claude following it

**Scenario:** The plan looks right after revision. You want to approve it and watch Claude execute each step in order.

**Hint:** In plan mode, approving the plan tells Claude to exit plan mode and execute. Look for tool calls (Read, Edit, Write) appearing one by one.

??? success "Solution"

    When the revised plan is on screen, approve it. The exact wording Claude prompts you with may vary — look for a confirmation step or type:
    ```
    Approved. Please proceed.
    ```
    Claude exits plan mode and executes each numbered step. Watch the tool calls appear (Read on `db.js`, then Write on the two output files). Verify the files now exist:
    ```bash
    ls quips/src/queries.js && echo "queries.js created" || echo "not yet"
    ```

### Task 4 — Try a plan that would overwrite existing tests

**Scenario:** You ask Claude to rewrite the test suite. In plan mode you can see the impact before any test file changes.

**Hint:** Enter plan mode and ask Claude to "rewrite all tests in quips/test/ to use a new assertion style." Read the plan carefully — does it overwrite existing test files? You control whether to approve.

??? success "Solution"

    Enter plan mode (Shift+Tab or `/plan`), then submit:
    ```
    Rewrite all tests in quips/test/ to use Node's built-in assert module instead of the current test framework.
    ```
    Claude produces a plan listing every test file it intends to overwrite. Read it. If the plan shows files you want to keep unchanged, you can revise ("skip tests that already pass with assert") or simply not approve. Exit plan mode without approving:
    ```
    /plan
    ```
    Verify the test files are untouched:
    ```bash
    git -C quips diff --name-only | wc -l
    ```
    Expected: `0` (no files changed).

### Task 5 — Save the plan to a file for later

**Scenario:** You want a record of the refactor plan to share with a teammate or revisit after a break.

**Hint:** Plans live only in REPL output — copy the text and paste it into a Markdown file. The artifact for this lab is `Labs/008-PlanMode/plan-transcript.md`.

??? success "Solution"

    After Claude displays the final plan in the REPL:
    1. Select the plan text in your terminal.
    2. Copy it (Cmd+C on macOS, Ctrl+Shift+C in most Linux terminals).
    3. Open `Labs/008-PlanMode/plan-transcript.md` in your editor and paste the plan.
    4. Add a final line:
       ```
       APPROVE: The plan covers all CRUD helpers and adds transaction support.
       ```
    5. Save the file, then verify:
    ```bash
    ./scripts/verify.sh 008
    ```
    Expected: exits 0.

### Task 6 — Ask for alternatives in plan mode

**Scenario:** You are not sure whether to split `db.js` into two files or three. You want Claude to propose both options before you commit to one.

**Hint:** While in plan mode, ask Claude to present two alternative refactor plans so you can compare them before deciding.

??? success "Solution"

    Enter plan mode (Shift+Tab or `/plan`), then submit:
    ```
    Give me two alternative plans for splitting db.js: option A is two files, option B is three files with a separate connection pool module. Show both plans side by side.
    ```
    Claude responds with two numbered plans. Neither is executed. Read both, pick the one that fits your codebase, then either approve one plan by name or exit plan mode to decide later:
    ```
    /plan
    ```
    No files are written either way — plan mode keeps the filesystem clean throughout deliberation.

## Quiz

<div class="ccg-quiz" data-lab="008">
  <div class="ccg-q" data-answer="b">
    <p><strong>Q1.</strong> While plan mode is active, what does Claude do when you submit a prompt asking it to edit a file?</p>
    <label><input type="radio" name="008-q1" value="a"> A. It edits the file and then describes what it did</label>
    <label><input type="radio" name="008-q1" value="b"> B. It produces a plan describing the edit but writes nothing to disk</label>
    <label><input type="radio" name="008-q1" value="c"> C. It refuses the request and asks you to exit plan mode first</label>
    <label><input type="radio" name="008-q1" value="d"> D. It creates a backup of the file, then edits it</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Plan mode is a deliberation-only state. Claude reasons and responds with a structured plan, but no tools are called and no files are written. The filesystem is completely unchanged until you approve the plan and Claude exits plan mode to execute.</p>
  </div>
  <div class="ccg-q" data-answer="c">
    <p><strong>Q2.</strong> Which of the following correctly describes how to enter plan mode in the Claude Code REPL?</p>
    <label><input type="radio" name="008-q2" value="a"> A. Run <code>claude --plan</code> from the shell before starting the session</label>
    <label><input type="radio" name="008-q2" value="b"> B. Type <code>/mode plan</code> at the REPL prompt</label>
    <label><input type="radio" name="008-q2" value="c"> C. Press Shift+Tab at the REPL prompt, or type <code>/plan</code></label>
    <label><input type="radio" name="008-q2" value="d"> D. Pass the <code>-p</code> flag when launching the session</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Plan mode is toggled from inside the running REPL. Shift+Tab cycles through modes until the footer shows <code>plan mode</code>. Typing <code>/plan</code> is the fallback for terminals where Shift+Tab is intercepted. The <code>-p</code> flag controls headless mode, not plan mode.</p>
  </div>
  <div class="ccg-q" data-answer="d">
    <p><strong>Q3.</strong> You are in plan mode and Claude proposes a plan that would overwrite three test files you want to keep. What is the safest next step?</p>
    <label><input type="radio" name="008-q3" value="a"> A. Approve the plan and then undo the changes with git</label>
    <label><input type="radio" name="008-q3" value="b"> B. Exit the REPL immediately — plan mode has already changed the files</label>
    <label><input type="radio" name="008-q3" value="c"> C. Approve the plan — Claude will prompt you before each file overwrite</label>
    <label><input type="radio" name="008-q3" value="d"> D. Revise the plan (tell Claude to skip those three files) before approving</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">While plan mode is active, no files have changed — this is exactly the window where revision is free. Ask Claude to update the plan to preserve the files you care about, confirm the revised plan, then approve. If you had been in direct mode, those test files would already be overwritten.</p>
  </div>
  <div class="ccg-q" data-answer="a">
    <p><strong>Q4.</strong> A colleague says plan mode is only useful for large refactors. You want to push back. Which argument is most accurate?</p>
    <label><input type="radio" name="008-q4" value="a"> A. Plan mode is useful even for small tasks because the plan often reveals an assumption or edge case you had not considered</label>
    <label><input type="radio" name="008-q4" value="b"> B. Your colleague is right — the overhead of reviewing a plan is not worth it for tasks under 10 lines of change</label>
    <label><input type="radio" name="008-q4" value="c"> C. Plan mode is only useful when working in codebases you do not own</label>
    <label><input type="radio" name="008-q4" value="d"> D. Plan mode slows Claude down and reduces output quality</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">The value of plan mode is not proportional to the size of the change — it is proportional to how surprised you would be if Claude made a wrong assumption. Small tasks can carry big surprises (wrong file, missing import, test collision). The habit of reading the plan before approving costs seconds and can prevent minutes or hours of cleanup.</p>
  </div>
</div>

## Stretch (optional, ~10 min)

Start a fresh session and ask Claude the same refactor question in direct mode (no plan mode). Compare the experience: what did you see and when? Write one sentence on the difference in risk between reviewing a plan and reviewing a completed diff. Then try `/plan` mid-session — you can activate plan mode after a few turns, not only at the start.

## Recall

What tool does Claude use to execute shell commands?

> Expected from Lab 007: `Bash`

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/overview
- https://github.com/anthropics/claude-code

## Next

→ **Lab 009 — Permission Modes** — control exactly which tools Claude is allowed to use and which require your approval.
