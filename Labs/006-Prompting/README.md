# Lab 006 — Prompting

⏱ **20 min**   📦 **You'll add**: `Labs/006-Prompting/prompts.md` with before/after pairs   🔗 **Builds on**: Lab 005   🎯 **Success**: `prompts.md` contains pairs for all five core moves and `./scripts/verify.sh 006` exits 0

<!--
  Template contract - do not remove this comment.
  CI (lint-prose + structure linter) enforces:
    1. Header line above (one line, five fields, in this exact order)
    2. Fourteen sections below (in this exact order, same H2 titles)
    3. Single new concept (a "Concept:" Bloom-tagged line)
    4. Every Do step ends with a verify COMMAND, not a screenshot
  See CONTRIBUTING.md and docs/DESIGN.md §7 for the full author contract.
-->

!!! hint "Overview"
    - You will learn five core prompting moves that reliably improve Claude Code's output quality.
    - You will practice each move against the Quips project, writing before/after pairs for real tasks.
    - You will see how specificity, few-shot examples, constraints, role framing, and step-by-step decomposition each address a different failure mode.
    - By the end you will have a personal prompt reference file and a repeatable approach to prompting Claude on any future task.

**Concept**: `Prompt quality: specificity, examples, constraints, role framing, decomposition` (Bloom: Apply)

---

## Prerequisites

- Completed Lab 005 (you have a running Quips project and `npm test` passes)
- `quips/` directory with `src/server.js`, `src/db.js`, and `test/server.test.js` present
- Node.js 20 or newer and `npm` on PATH

## What You Will Learn

- The five core moves that separate reliable prompts from wishful-thinking prompts
- Which move to reach for in which situation
- How to write a before/after prompt pair that makes the difference visible
- How to ask Claude to critique and improve a prompt before it answers

## Why

A vague prompt produces plausible-looking code that quietly misses the specification. That pattern is expensive: you accept the diff, tests fail, you debug, you re-prompt. Prompting well the first time is not about politeness or magic words — it is about front-loading information Claude would otherwise have to guess. Every minute you spend sharpening a prompt buys back multiple minutes of debugging. The five moves in this lab cover the most common guessing situations.

## Walkthrough

### The five core moves

Claude Code processes exactly what you write. It cannot see intent, cannot assume project conventions it was not told, and cannot read the test file you forgot to mention. The moves below are a vocabulary for filling those gaps before they become bugs.

**Move 1 — Specificity.** The single highest-leverage change. Replace category words with precise values: instead of "add a field", write "add a `created_at` INTEGER NOT NULL column to the `quips` table, defaulting to `strftime('%s', 'now')`." Specificity cuts clarifying-question loops and prevents Claude from picking a plausible-but-wrong interpretation.

**Move 2 — Few-shot examples.** When a format is ambiguous, show two or three concrete input/output pairs rather than describing the format in prose. Prose descriptions of formats are harder to parse than examples — for humans and models alike. Few-shot is most useful when the shape of the output matters more than the logic that produces it.

**Move 3 — Constraints.** State what the output must NOT do. Constraints are the antidote to over-engineering: "do not add try/catch; the caller handles errors" prevents Claude from wrapping every call in defensive boilerplate. Constraints also encode security requirements ("use parameterized queries, never string interpolation") and scope limits ("only modify `src/db.js`, not `src/server.js`").

**Move 4 — Role framing.** Prepending a role shifts Claude's defaults toward the expertise level and priorities of that role. "As a security reviewer, audit this route" produces different emphasis than a bare audit request. Role framing is most effective for review, critique, and analysis tasks where the *angle* of the response matters.

**Move 5 — Step-by-step decomposition.** For complex or multi-file tasks, break the work into numbered steps in the prompt itself. This is not asking Claude to think aloud — it is telling Claude the intended execution order so that each step can be verified before the next begins. Decomposition prevents Claude from collapsing multiple distinct concerns into one undifferentiated blob of changes.

### Pattern reference

| Move | Best for | Failure mode it prevents |
|---|---|---|
| **Specificity** | Any code generation task | Plausible-but-wrong interpretation |
| **Few-shot examples** | Format-sensitive output | Ambiguous shape; wrong style |
| **Constraints** | Security, scope, defensive-code avoidance | Over-engineering; policy violations |
| **Role framing** | Reviews, audits, analysis | Generic response; wrong emphasis |
| **Step-by-step** | Multi-file or multi-concern changes | Collapsed, hard-to-review diffs |

### Before/after: a Quips database task

Here is how Move 1 (specificity) changes the outcome for a Quips schema change.

**Before (vague):**
> make the database better

Claude will ask clarifying questions, or guess and add something unrelated to your actual need. Either way you iterate.

**After (specific):**
> Add a `created_at` INTEGER NOT NULL column to the `quips` table in `src/db.js`, defaulting to `strftime('%s', 'now')` in the CREATE TABLE statement. Update the INSERT in `createQuip` to populate it with `strftime('%s', 'now')`. Update `test/server.test.js` to assert that `created_at` is a number greater than zero on newly created rows.

The second prompt specifies the column name, type, nullability, default expression, the file to touch, the function to update, and the test assertion. Claude writes it correctly the first time.

## Check

```bash
./scripts/doctor.sh 006
```

Expected output: `OK lab 006 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before writing any prompts, write down which of the five moves you think will have the biggest impact on a task like "add a field to the database." Which failure mode would a vague prompt hit first?

   Verify:
   ```bash
   [[ -d quips/ ]] && echo "quips present" || echo "quips missing"
   ```
   Expected: `quips present` (the Quips project exists from Lab 005).

2. **Run** — open Claude Code inside the Quips project and try the vague version of the database task.

   ```bash
   cd quips && claude
   ```

   In the REPL, send:

   > make the database better

   Verify: Claude responds with clarifying questions or a vague suggestion rather than a concrete diff.

   ```bash
   echo "observed: Claude asked for clarification or gave a generic response"
   ```
   Expected: you can confirm the output was not a concrete, targeted code change.

3. **Investigate** — still in the same session, send the specific version:

   > Add a `created_at` INTEGER NOT NULL column to the `quips` table in `src/db.js`, defaulting to `strftime('%s', 'now')`. Update the INSERT in `createQuip` to populate it. Update `test/server.test.js` to assert that `created_at` is a number greater than zero on a new row.

   Verify: Claude proposes a concrete diff touching `src/db.js` and `test/server.test.js`.

   ```bash
   grep -qi "created_at" quips/src/db.js && echo "column present" || echo "column missing"
   ```
   Expected: `column present`

4. **Modify** — practice moves 2 through 5 on the following tasks. For each, run the vague version, note what Claude does, then run the specific version.

   Task b — format request:
   - Vague: `format the quip output nicely`
   - Specific (few-shot): `Return each quip as a JSON object with exactly these keys: {"id": 1, "text": "...", "tags": ["a"], "created_at": 1700000000}. No extra keys, no wrapping envelope.`

   Task c — test generation:
   - Vague: `write a test`
   - Specific (constraints): `Add a Vitest test in test/server.test.js for POST /quips that asserts a 400 is returned when "text" is missing. Do not add try/catch; use Vitest's built-in assertion. Do not modify any existing test.`

   Verify after each specific prompt produces a targeted diff:
   ```bash
   grep -qi "createQuip" quips/src/db.js && echo "function present" || echo "function missing"
   ```
   Expected: `function present`

5. **Make** — write all five before/after pairs into `prompts.md`.

   ```bash
   touch Labs/006-Prompting/prompts.md
   ```

   Fill in the file with one section per move (Specificity, Few-shot, Constraints, Role framing, Step-by-step), each containing a BAD version, a GOOD version, and one sentence describing the observed difference. Then verify:

   ```bash
   ./scripts/verify.sh 006
   ```
   Expected: exits 0 with no error output.

## Observe

Which of the five moves produced the most visible change in Claude's output quality across your tasks? Write one sentence in your own words. No answer key — this is metacognition practice.

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| Claude keeps asking clarifying questions | Prompt is under-specified | Add the schema name, function signature, or expected output shape directly in the prompt | https://docs.claude.com/en/docs/claude-code/overview |
| Output is verbose and goes off-topic | Missing scope constraint | Add "only modify `src/db.js`" or "answer in two sentences, no prose" to your prompt | https://docs.claude.com/en/docs/claude-code/overview |
| Claude makes up file paths | Missing codebase context | Reference files with `@path/to/file` or read them first with the Read tool before prompting | https://github.com/anthropics/claude-code |
| Role framing produces no visible difference | Role is too broad | Make the role specific: "senior SQLite performance engineer" beats "expert developer" | https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/overview |

## Tasks

Click the checkbox next to each task to mark it done — your progress is saved locally.

### Task 1 — Turn a vague prompt into a specific one

**Scenario:** A teammate sends you this prompt to review before they run it:

> update the quips table

Your job is to rewrite it using Move 1 (specificity) so it produces a deterministic diff.

**Hint:** Include the column name, type, default value, the file to edit, and the function to update.

??? success "Solution"

    ```
    Add a `view_count` INTEGER NOT NULL DEFAULT 0 column to the `quips` table
    in src/db.js. Update the CREATE TABLE statement in the schema definition.
    Do not modify the INSERT in createQuip — the column default handles it.
    Update the SELECT in listQuips to include view_count in returned rows.
    ```

    Compare: the original prompt would require at least one clarifying round.
    This version produces a reviewable diff on the first attempt.

### Task 2 — Add few-shot examples to an ambiguous format request

**Scenario:** You want Claude to format tag arrays as comma-separated strings in API responses, but prose alone keeps producing different formats.

**Hint:** Show two input/output pairs where the input is a tags array and the output is the formatted string.

??? success "Solution"

    ```
    Rewrite the tags field in all API responses as a comma-separated string
    instead of a JSON array. Match this exact format:

    Input:  ["comedy", "short"]   → Output: "comedy, short"
    Input:  []                    → Output: ""
    Input:  ["single"]            → Output: "single"

    Update listQuips and getQuip in src/db.js only.
    Do not change the database schema or test fixtures.
    ```

    The three examples remove all ambiguity about spacing, empty-array
    handling, and single-element behavior.

### Task 3 — Add constraints to prevent defensive code

**Scenario:** You want Claude to add input validation for the `text` field in `POST /quips`, but previous attempts produced deeply nested try/catch blocks that made the diff hard to review.

**Hint:** List each constraint as a bullet point. Include what Claude must NOT do as well as what it must do.

??? success "Solution"

    ```
    Add input validation for the `text` field in the POST /quips handler
    in src/server.js:
    - If text is missing or empty string, return 400 with {"error": "text is required"}.
    - If text is longer than 280 characters, return 400 with {"error": "text too long"}.
    - Do not add try/catch — the existing error middleware handles thrown errors.
    - Do not modify src/db.js or any test file.
    - Keep the validation above the db.createQuip call, not inside it.
    ```

    The constraint list prevents the try/catch reflex and confines the change
    to a single file, making the diff surgical and easy to review.

### Task 4 — Role-frame for a security review

**Scenario:** You want Claude to audit the `POST /quips` and `GET /quips` handlers for injection risks, but a bare "review for security" request produces a generic checklist unrelated to your actual code.

**Hint:** Assign a specific security role and name the exact files and concerns you want addressed.

??? success "Solution"

    ```
    You are a security engineer specializing in Node.js API vulnerabilities.
    Review the POST /quips and GET /quips handlers in src/server.js and the
    corresponding DB helpers in src/db.js for:
    1. SQL injection risks (are all inputs parameterized?)
    2. Missing input length limits that could cause DoS
    3. Any field returned to the client that should not be exposed

    For each finding, cite the exact line and suggest a one-line fix.
    Do not suggest architectural changes — focus on the handlers as written.
    ```

    The role tells Claude what expertise to apply; the explicit concern list
    prevents it from drifting into unrelated advice about auth or rate limiting.

### Task 5 — Decompose a complex migration request

**Scenario:** You need to rename the `text` column to `body` across the database schema, all DB helpers, the server routes, and the tests. A single "rename text to body" prompt produced a diff that missed the test fixtures.

**Hint:** Number each sub-task in the prompt. Make the file scope of each step explicit.

??? success "Solution"

    ```
    Rename the `text` column to `body` across the Quips project in this order:

    Step 1: Update the CREATE TABLE in src/db.js — rename `text` to `body`.
    Step 2: Update createQuip in src/db.js — change the INSERT and parameter name.
    Step 3: Update listQuips and getQuip in src/db.js — rename in SELECT and rowToQuip.
    Step 4: Update src/server.js — rename any reference to .text on quip objects to .body.
    Step 5: Update test/server.test.js — rename all uses of the text property in
            assertions and seed data.

    After all steps, run: npm test
    Do not change variable names inside individual test functions beyond the
    property rename.
    ```

    Numbering the steps lets you review each sub-diff in isolation and catch
    the test-fixture step that was previously missed.

### Task 6 — Ask Claude to critique its own prompt before answering

**Scenario:** You are about to send a prompt to Claude but you are not sure if it is specific enough. Instead of guessing, you ask Claude to evaluate the prompt first and tell you what is missing.

**Hint:** Wrap your draft prompt in a meta-request asking Claude to identify any ambiguities before it answers.

??? success "Solution"

    ```
    Before answering, critique the following prompt for ambiguity and missing
    information. List what is unclear or under-specified, then rewrite it as a
    more precise version. Only after showing the improved prompt should you
    execute it.

    Draft prompt:
    "Add error handling to the API"
    ```

    Claude will surface the missing details (which routes, which error types,
    what error shape, which file) and produce a sharper version before writing
    any code. This costs one extra exchange but eliminates the clarification
    loop that would have followed anyway.

## Quiz

<div class="ccg-quiz" data-lab="006">
  <div class="ccg-q" data-answer="c">
    <p><strong>Q1.</strong> A colleague argues that being polite ("please" and "thank you") in prompts improves Claude's output. What is the most accurate response?</p>
    <label><input type="radio" name="006-q1" value="a"> A. They are right — Claude responds better to polite phrasing</label>
    <label><input type="radio" name="006-q1" value="b"> B. Politeness hurts output because it adds token overhead</label>
    <label><input type="radio" name="006-q1" value="c"> C. Politeness has no measurable effect; specificity — naming the column, file, function, and expected behavior — is what drives output quality</label>
    <label><input type="radio" name="006-q1" value="d"> D. Only the first word of a prompt affects the response style</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Politeness does not change what information Claude has to work with. Output quality is driven by the precision of the specification: what file, what function, what column, what the success condition looks like. A prompt that is rude but specific outperforms one that is polite but vague every time.</p>
  </div>
  <div class="ccg-q" data-answer="b">
    <p><strong>Q2.</strong> You want Claude to return API responses in a very specific JSON shape. Which move handles this situation best?</p>
    <label><input type="radio" name="006-q2" value="a"> A. Role framing — tell Claude it is a senior API designer</label>
    <label><input type="radio" name="006-q2" value="b"> B. Few-shot examples — show two or three concrete input/output pairs that define the exact shape</label>
    <label><input type="radio" name="006-q2" value="c"> C. Step-by-step decomposition — list each field in numbered steps</label>
    <label><input type="radio" name="006-q2" value="d"> D. Constraints — list every key Claude must not include</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Format ambiguity is best resolved with examples, not prose descriptions. Showing Claude <code>Input: ["a","b"] → Output: "a, b"</code> is unambiguous in a way that "comma-separated string" is not (spacing? empty array? single element?). Few-shot examples are the canonical tool for format-sensitive output.</p>
  </div>
  <div class="ccg-q" data-answer="d">
    <p><strong>Q3.</strong> When does role framing have the most impact on Claude's response?</p>
    <label><input type="radio" name="006-q3" value="a"> A. When you need Claude to write more code faster</label>
    <label><input type="radio" name="006-q3" value="b"> B. When the task is a simple one-line change</label>
    <label><input type="radio" name="006-q3" value="c"> C. When the codebase is large and Claude needs to pick a file</label>
    <label><input type="radio" name="006-q3" value="d"> D. When the angle or emphasis of the response matters — reviews, audits, and analysis tasks where a generic reply misses the point</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Role framing shifts the default priorities and vocabulary Claude uses. A security-engineer role makes it look for injection vectors first; a performance-engineer role makes it weigh query plans. For straightforward code generation the role adds little, but for review and analysis tasks it meaningfully changes what Claude pays attention to.</p>
  </div>
  <div class="ccg-q" data-answer="a">
    <p><strong>Q4.</strong> You ask Claude to rename a column across five files in a single prompt. The resulting diff mixes schema, helpers, routes, and tests in a way that is hard to review. What should you do differently?</p>
    <label><input type="radio" name="006-q4" value="a"> A. Use step-by-step decomposition — number each file in the prompt so Claude produces one logical sub-diff per step that can be reviewed in isolation</label>
    <label><input type="radio" name="006-q4" value="b"> B. Use few-shot examples to show Claude a sample renamed file</label>
    <label><input type="radio" name="006-q4" value="c"> C. Add a constraint saying "make the diff small"</label>
    <label><input type="radio" name="006-q4" value="d"> D. Ask Claude to explain the rename before executing it</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Step-by-step decomposition in the prompt maps directly to reviewable sub-diffs. When you number the steps (schema → helpers → routes → tests) Claude applies them in that order, and you can inspect each before the next is attempted. A single monolithic prompt for a cross-cutting change produces a monolithic diff that is hard to reason about.</p>
  </div>
</div>

## Stretch (optional, ~10 min)

Pick the specific prompt you wrote for Task 1 and apply a second move on top of it. For example, add constraints ("do not modify any existing test") or a role frame ("as a database migration author, …"). Run both versions and write one sentence comparing what changed in Claude's response.

## Recall

What does the `-p` flag do in `claude -p "…"`?

> Expected from Lab 001: `-p` (or `--print`) runs Claude in headless mode — it takes the prompt, prints the response, and exits without starting an interactive REPL.

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/overview
- https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/overview
- https://github.com/anthropics/claude-code

## Next

→ **Lab 007 — Tool Use** — learn how Claude calls tools and how to direct which tools it reaches for.
