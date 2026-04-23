# Lab 031 — Claude Prompting Workshop

⏱ **45 min**   📦 **You'll add**: `Labs/031-PromptingWorkshop/prompts.md` with your answers   🔗 **Builds on**: Capstone   🎯 **Success**: prompts.md has >=8 labeled prompt drills with claude transcripts

<!--
  Template contract - do not remove this comment.
  See docs/DESIGN.md §7 and scripts/lint-labs.sh for the author contract.
-->

!!! hint "Overview"
    - You will study six prompting patterns — specificity, role-framing, few-shot, step-by-step, constraints, and chain-of-thought — with annotated before/after pairs drawn from the Quips codebase.
    - You will work through one PRIMM exercise that takes a realistic endpoint improvement from vague prompt to production-ready output.
    - You will complete eight timed drills covering every pattern and write your transcripts into `prompts.md`.
    - By the end you will have a personal prompt pattern reference you can reach for on any future Claude Code task.

**Concept**: `Apply prompting patterns to realistic Claude Code tasks` (Bloom: Apply)

---

## Prerequisites

- Capstone completed (or Labs 001–030 in sequence)
- `claude` on PATH with working auth (`claude -p "ping"` exits 0)
- The Quips project cloned at `quips/` from Lab 005 (used as the realistic codebase for drills)

## What You Will Learn

- The six core prompt patterns and when each one pays off
- How to predict Claude's behaviour before running a prompt, then close the gap
- How to chain prompts iteratively rather than expecting one-shot perfection
- How to ask Claude to critique its own output, and why that is surprisingly effective

## Why

You have just finished a full Claude Code bootcamp. Congratulations — that is a real achievement. But prompting is a durable skill that compounds every time you use it. A 20-word prompt tweak can be the difference between Claude nailing a task in one turn and you spending 30 minutes correcting its output. This lab gives you deliberate practice on that specific skill so the patterns become muscle memory.

## Walkthrough

Prompting Claude Code is not magic — it follows predictable patterns. The six patterns below cover the vast majority of real-world prompting situations you will encounter. Each pattern is shown with an annotated before/after pair from the Quips codebase.

### Pattern reference table

| # | Pattern | When to use |
|---|---------|-------------|
| 1 | **Specificity** | You know exactly what output format, file, or behaviour you need |
| 2 | **Role-framing** | You want Claude to adopt a perspective it wouldn't assume by default (e.g. security reviewer, senior backend engineer) |
| 3 | **Few-shot examples** | You need consistent format (e.g. test names, error messages, JSON shape) |
| 4 | **Step-by-step instructions** | The task has ordering constraints or multi-file side-effects that Claude might skip |
| 5 | **Constraints** | You need Claude to stay narrow — no extra files, no speculative abstractions, no defensive code that wasn't asked for |
| 6 | **Chain-of-thought** | The task requires reasoning before action (e.g. architecture choice, algorithm selection, root-cause analysis) |

---

### Pattern 1 — Specificity

Vague prompts shift the decision burden onto Claude. Specific prompts make every decision explicit.

**Before (weak):**
```
add a count endpoint
```

**After (specific):**
```
In quips/src/routes/quips.js, add a GET /quips/count endpoint.
It must return JSON { "count": <number> } using the existing
db.query pattern already used in getAll(). Do not add a new file.
Do not add auth middleware — this endpoint is public.
```

Annotations:
- `In quips/src/routes/quips.js` — pins the file; Claude won't guess
- `using the existing db.query pattern` — tells Claude to match existing style
- `Do not add a new file` / `Do not add auth middleware` — explicit constraints prevent scope creep

---

### Pattern 2 — Role-framing

Giving Claude a role shifts its default perspective. It writes different code as a "security reviewer" than as a "junior developer."

**Before (no role):**
```
review the createQuip function
```

**After (role-framed):**
```
Act as a senior security engineer doing a pre-merge review of quips/src/routes/quips.js.
For the createQuip handler, list every input validation gap that could lead to
stored XSS or SQL injection. Format your output as a numbered list.
One finding per line. No preamble.
```

Annotations:
- `Act as a senior security engineer` — sets perspective; Claude weighs findings differently
- `stored XSS or SQL injection` — names the threat model so Claude does not range across unrelated issues
- `No preamble` — suppresses the hedging paragraph Claude often prepends

---

### Pattern 3 — Few-shot examples

When format consistency matters, show Claude two or three examples of the exact output shape you want.

**Before (no examples):**
```
write tests for the quip validation logic
```

**After (few-shot):**
```
Write Jest unit tests for validateQuip() in quips/src/lib/validation.js.
Follow this exact naming pattern:

  it('returns error when title is empty', ...)
  it('returns error when title exceeds 200 chars', ...)
  it('returns null when quip is valid', ...)

Add 4 more tests following the same "returns X when Y" pattern.
```

Annotations:
- Three named examples train the format in-context
- Claude extrapolates the pattern reliably for the 4 additional cases
- No need to describe "snake_case" or "present tense" in prose — examples show it

---

### Pattern 4 — Step-by-step instructions

Multi-file tasks with ordering constraints need an explicit sequence. Without it, Claude may apply changes in the wrong order or skip a step.

**Before (no ordering):**
```
migrate the quips table to add a tags column
```

**After (step-by-step):**
```
Perform the following steps in order. Do not combine steps.

1. Create quips/migrations/003_add_tags.sql with:
   ALTER TABLE quips ADD COLUMN tags TEXT DEFAULT '';
2. Run the migration: (cd quips && node scripts/migrate.js)
3. Update the Quip model in quips/src/models/quip.js to include tags
   in SELECT and INSERT statements.
4. Add a test in quips/test/quip.model.test.js that asserts tags
   defaults to an empty string on INSERT.
```

Annotations:
- Numbered steps force ordering; Claude executes them sequentially
- `Do not combine steps` prevents Claude from collapsing two steps into one and missing a verify opportunity
- Each step is atomic and independently verifiable

---

### Pattern 5 — Constraints

Constraints tell Claude what NOT to do. They prevent the most common failure mode: Claude doing more than you asked.

**Before (no constraints):**
```
add rate limiting to the API
```

**After (constrained):**
```
Add rate limiting to quips/src/server.js using the express-rate-limit
package that is already listed in package.json.

Constraints:
- Limit: 100 requests per 15 minutes per IP
- Apply only to routes starting with /api/
- Do not install any new packages
- Do not modify any existing route handlers
- Do not add a Redis backend — in-memory store is fine for now
```

Annotations:
- Constraints prevent Claude from reaching for Redis, installing extra deps, or touching route handlers it shouldn't
- `already listed in package.json` avoids an npm install Claude might otherwise trigger
- Each constraint is one sentence — short constraints are easier for Claude to track

---

### Pattern 6 — Chain-of-thought

For decisions that require reasoning before code, ask Claude to think out loud first. This surfaces assumptions you can correct before Claude writes a line.

**Before (no CoT):**
```
how should we structure the quip feed for high read load?
```

**After (chain-of-thought):**
```
Before recommending an architecture for the Quips feed under high read load,
reason step by step:

1. What is the current data access pattern in quips/src/routes/quips.js?
2. What are the two or three most impactful bottlenecks likely to appear
   at 10k requests/min?
3. For each bottleneck, what is the cheapest fix that does not require
   a new infrastructure component?

After your reasoning, give a single recommended next step with a code sketch.
```

Annotations:
- Steps 1-3 make Claude's reasoning visible, so you can interrupt before a wrong assumption propagates
- `cheapest fix that does not require a new infrastructure component` is a constraint embedded in the CoT prompt
- `After your reasoning` separates the thinking phase from the output phase

---

## Check

```bash
./scripts/doctor.sh 031
```

Expected output: `OK lab 031 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

This PRIMM exercise improves an existing Quips endpoint's error handling using the specificity and constraints patterns together.

1. **Predict** — open `quips/src/routes/quips.js` and find the `createQuip` handler. Write down: what happens if the request body is missing the `content` field? Does the current code return a useful error to the caller?

   ```bash
   grep -n 'createQuip\|content' quips/src/routes/quips.js | head -20
   ```

   Expected: you see the handler but likely no input validation before the database call.

2. **Run** — send Claude a weak, unspecified prompt and observe what it produces.

   ```bash
   cd quips && claude -p "improve error handling in createQuip"
   ```

   Save the output to your `prompts.md` under `## Drill 0 — PRIMM baseline`.

   Verify:
   ```bash
   grep -c 'Drill 0' Labs/031-PromptingWorkshop/prompts.md
   ```
   Expected: prints `1`.

3. **Investigate** — compare what Claude produced to what you actually needed. Did it add validation? Did it add extra abstractions you didn't ask for? Did it touch files you didn't want touched?

   ```bash
   git diff quips/src/
   ```

   Note every surprise. These surprises are exactly the gaps that pattern 1 (specificity) and pattern 5 (constraints) close.

4. **Modify** — craft a specific, constrained prompt. Use the before/after template from Pattern 1 above. Add at least two explicit constraints from Pattern 5.

   Example starting point (modify to fit what you observed):
   ```
   In quips/src/routes/quips.js, add input validation to the createQuip handler only.
   If req.body.content is missing or empty string, return HTTP 400 with JSON
   { "error": "content is required" }.
   Constraints:
   - Do not modify any other handler
   - Do not add a validation middleware or utility function
   - Do not import any new module
   ```

   Run it:
   ```bash
   git stash  # reset from the weak-prompt attempt
   claude -p "<your improved prompt here>"
   ```

   Verify:
   ```bash
   grep -c '400' quips/src/routes/quips.js
   ```
   Expected: at least `1` (the new status code).

5. **Make** — write your improved prompt and Claude's response into `prompts.md` under `## Drill 1 — Specificity + Constraints`.

   ```bash
   grep -c '^## Drill' Labs/031-PromptingWorkshop/prompts.md
   ```
   Expected: at least `1` (more to come in Tasks).

## Observe

Compare the two transcripts side by side (Drill 0 vs Drill 1). Write one paragraph in your `prompts.md` describing: what was different in the output, how many lines changed, and what constraint would you add next time. No answer key — this is metacognition practice.

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| Claude ignores a constraint ("do not add X" but it adds X anyway) | Constraint buried in prose; Claude de-prioritises mid-paragraph negatives | Move all constraints to a bulleted list at the end of the prompt, explicitly prefixed with `Do not` | https://github.com/anthropics/courses |
| Claude hedges with "I would suggest..." instead of writing code | No action verb in the prompt; Claude defaults to advisory mode | Start the prompt with an imperative verb: `Add`, `Rewrite`, `Create`, `Fix` | https://github.com/anthropics/courses |
| Claude's chain-of-thought reasoning is correct but its code is wrong | CoT and code generation are separate passes; Claude can reason correctly then implement incorrectly | After the CoT, add: `Now implement exactly what your reasoning concluded. No deviations.` | https://docs.claude.com/en/docs/claude-code/overview |

## Tasks

Click the checkbox next to each task to mark it done — your progress is saved locally.

### Task 1 — Specificity on a bug report

**Scenario:** The `getQuipById` handler in `quips/src/routes/quips.js` returns a 500 when the ID does not exist instead of a 404.

**Pattern:** Specificity (Pattern 1)

**Hint:** Name the exact file, the exact handler, the exact HTTP status code you expect, and the exact JSON shape of the error body.

??? success "Solution"

    ```
    In quips/src/routes/quips.js, fix the getQuipById handler so that when
    the database returns zero rows, the handler responds with HTTP 404 and
    JSON { "error": "quip not found" }.
    Do not change the 200 response shape.
    Do not add a new function or middleware.
    ```

    Save your prompt and Claude's diff to `prompts.md` under `## Drill 1 — Specificity`.

### Task 2 — Role-framing for a security review

**Scenario:** Before merging a PR that adds a new POST endpoint, you want a threat-focused review of the input handling.

**Pattern:** Role-framing (Pattern 2)

**Hint:** Name the role, the threat model, and the output format explicitly.

??? success "Solution"

    ```
    Act as a senior OWASP-aware security engineer.
    Review the createQuip handler in quips/src/routes/quips.js for:
    - Stored XSS risk (is content sanitised before storage?)
    - Mass assignment risk (are unexpected body fields silently accepted?)
    Format: numbered list, one risk per line, severity in brackets [HIGH/MED/LOW].
    No preamble. No conclusion paragraph.
    ```

    Save your prompt and Claude's output to `prompts.md` under `## Drill 2 — Role-framing`.

### Task 3 — Few-shot for test generation

**Scenario:** You need 6 unit tests for `validateQuip()` and you want every test name in the same "returns X when Y" format.

**Pattern:** Few-shot examples (Pattern 3)

**Hint:** Write two complete example test names in your prompt; Claude will replicate the pattern for the remaining four.

??? success "Solution"

    ```
    Write 6 Jest unit tests for validateQuip() in quips/src/lib/validation.js.
    Follow this exact naming pattern — no variation:

      it('returns error when content is empty', ...)
      it('returns null when content is valid', ...)

    Write 4 more tests in the same format covering: content > 500 chars,
    content is null, content is a number, and content is whitespace-only.
    ```

    Save your prompt and Claude's test output to `prompts.md` under `## Drill 3 — Few-shot`.

### Task 4 — Step-by-step for a migration

**Scenario:** You need to add a `views` counter column to the quips table and wire it into the model without skipping any step.

**Pattern:** Step-by-step instructions (Pattern 4)

**Hint:** Number each step explicitly and add "Do not combine steps" to the prompt.

??? success "Solution"

    ```
    Perform these steps in order. Do not combine steps.

    1. Create quips/migrations/004_add_views.sql with:
       ALTER TABLE quips ADD COLUMN views INTEGER DEFAULT 0;
    2. Run: (cd quips && node scripts/migrate.js)
    3. In quips/src/models/quip.js, include views in SELECT statements only.
       Do not include it in INSERT — let the DB default apply.
    4. Add one test asserting views defaults to 0 on a newly created quip.
    ```

    Save your prompt and Claude's output to `prompts.md` under `## Drill 4 — Step-by-step`.

### Task 5 — Constraint for a rate limit

**Scenario:** Add rate limiting to the Quips API without introducing Redis or new packages.

**Pattern:** Constraints (Pattern 5)

**Hint:** List every "Do not" as a separate bullet point; put constraints after the main instruction, not before.

??? success "Solution"

    ```
    Add rate limiting to quips/src/server.js.
    Use the express-rate-limit package (already in package.json).
    Limit: 60 requests per minute per IP.
    Apply only to paths starting with /api/.

    Constraints:
    - Do not install any new npm package
    - Do not use a Redis store — in-memory is sufficient
    - Do not modify any existing route handler
    - Do not add any new file
    ```

    Save your prompt and Claude's diff to `prompts.md` under `## Drill 5 — Constraints`.

### Task 6 — Chain-of-thought for an architecture choice

**Scenario:** The Quips feed query is slow. Before writing any code, you want Claude to reason through the options.

**Pattern:** Chain-of-thought (Pattern 6)

**Hint:** Separate the reasoning phase from the recommendation phase with explicit section headers in your prompt.

??? success "Solution"

    ```
    Before writing any code, reason step by step:

    1. Read quips/src/routes/quips.js getAll() and describe the current query.
    2. Identify the two most likely performance bottlenecks at 5k requests/min.
    3. For each, describe the cheapest fix that requires no new infrastructure.

    After your reasoning, give a single recommended change as a code diff.
    Do not implement anything beyond that single change.
    ```

    Save your prompt and Claude's full reasoning + diff to `prompts.md` under `## Drill 6 — Chain-of-thought`.

### Task 7 — Iterative refinement across 3 turns

**Scenario:** You send an initial prompt, Claude's output is close but not right, and you refine it across two follow-up turns.

**Pattern:** Iterative refinement (combining patterns 1, 5)

**Hint:** Turn 1 sets the task. Turn 2 corrects one specific thing. Turn 3 adds one constraint that was missing. Record all three turns.

??? success "Solution"

    Turn 1: `Add a DELETE /quips/:id endpoint to quips/src/routes/quips.js`

    Turn 2 (after reviewing output): `The handler you added returns 200 on success.
    Change it to return 204 with no body, which is the correct HTTP semantics for DELETE.`

    Turn 3: `Also add a check: if the quip does not exist, return 404 JSON { "error": "not found" }.
    Do not change anything else.`

    Save all three turns and Claude's diffs to `prompts.md` under `## Drill 7 — Iterative refinement`.

### Task 8 — Self-critique of a diff

**Scenario:** Claude just produced a diff. You ask Claude to critique it before you accept it.

**Pattern:** Self-critique (meta-prompting)

**Hint:** Ask Claude to play the role of a reviewer of its own output. Give it a specific checklist to apply.

??? success "Solution"

    After any of the above drills, send this follow-up without resetting context:

    ```
    Review the diff you just produced. Apply this checklist:
    - Does any new code touch files outside the scope I specified?
    - Does any new function exist that is only called once (unnecessary abstraction)?
    - Is there any error case that is silently swallowed?
    - Is there any hardcoded value that should be a constant or config?

    For each item: answer yes/no, and if yes describe the problem in one sentence.
    Then produce a revised diff that fixes any yes answers.
    ```

    Save the self-critique exchange to `prompts.md` under `## Drill 8 — Self-critique`.

## Quiz

<div class="ccg-quiz" data-lab="031">
  <div class="ccg-q" data-answer="b">
    <p><strong>Q1.</strong> You need Claude to add exactly one validation check to one function without touching anything else. Which pattern is most directly useful?</p>
    <label><input type="radio" name="031-q1" value="a"> A. Chain-of-thought, because it makes Claude reason before writing</label>
    <label><input type="radio" name="031-q1" value="b"> B. Specificity combined with constraints, because you name the exact target and list what must not change</label>
    <label><input type="radio" name="031-q1" value="c"> C. Few-shot examples, because you show Claude the shape of a validation check</label>
    <label><input type="radio" name="031-q1" value="d"> D. Role-framing, because a senior engineer would know not to touch other functions</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Specificity (naming the exact file and function) plus constraints (listing what must not be modified) is the direct combination. Chain-of-thought is most useful when the right decision is unclear; here the decision is already made. Role-framing helps perspective but does not prevent scope creep on its own.</p>
  </div>
  <div class="ccg-q" data-answer="c">
    <p><strong>Q2.</strong> Claude keeps adding a utility function that you did not ask for. What is the most effective single change to your prompt?</p>
    <label><input type="radio" name="031-q2" value="a"> A. Add chain-of-thought so Claude reasons more carefully</label>
    <label><input type="radio" name="031-q2" value="b"> B. Use role-framing to ask Claude to think like a minimalist engineer</label>
    <label><input type="radio" name="031-q2" value="c"> C. Add an explicit constraint: "Do not add any new function or helper"</label>
    <label><input type="radio" name="031-q2" value="d"> D. Use few-shot to show Claude an example without a utility function</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Claude's default is to be helpful by generalising. An explicit "Do not add any new function" constraint overrides that default directly. Role-framing nudges the perspective but does not reliably suppress helper generation. Few-shot can help with format but not with structural scope decisions.</p>
  </div>
  <div class="ccg-q" data-answer="a">
    <p><strong>Q3.</strong> You are asking Claude to generate 10 test cases and you need every test name in exactly the same format. Which pattern gives you the most reliable format consistency?</p>
    <label><input type="radio" name="031-q3" value="a"> A. Few-shot examples — show two or three test names in the exact format; Claude extrapolates reliably</label>
    <label><input type="radio" name="031-q3" value="b"> B. Step-by-step instructions — list each test case as a numbered step</label>
    <label><input type="radio" name="031-q3" value="c"> C. Role-framing — ask Claude to act as a TDD practitioner who names tests consistently</label>
    <label><input type="radio" name="031-q3" value="d"> D. Specificity — describe the naming convention in precise prose</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Few-shot examples exploit Claude's in-context learning: it pattern-matches against your examples rather than interpreting a prose description. Describing format in prose (specificity) is less reliable than showing it. Step-by-step is for ordering constraints, not format consistency.</p>
  </div>
  <div class="ccg-q" data-answer="d">
    <p><strong>Q4.</strong> Claude responds with "I would recommend considering..." instead of producing code. What should your follow-up do?</p>
    <label><input type="radio" name="031-q4" value="a"> A. Add more chain-of-thought to help Claude reason its way to a decision</label>
    <label><input type="radio" name="031-q4" value="b"> B. Use role-framing to make Claude more decisive</label>
    <label><input type="radio" name="031-q4" value="c"> C. Add few-shot examples of decisive responses</label>
    <label><input type="radio" name="031-q4" value="d"> D. Restate the request with an imperative verb and add "Do not hedge — implement it now"</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Hedging is Claude's default when no action verb is present or when it senses ambiguity. The fix is to open with an imperative ("Implement", "Add", "Rewrite") and explicitly suppress hedging with a constraint ("Do not suggest — implement directly"). More CoT will produce more reasoning, not less hedging.</p>
  </div>
</div>

## Stretch (optional, ~15 min)

Take one of your eight drills and run it through all six patterns back-to-back, changing only the prompt pattern each time. Record all six outputs in your `prompts.md`. You will find that some patterns produce nearly identical results for simple tasks and diverge sharply for complex ones. That divergence is the signal — it tells you which tasks genuinely need each pattern.

## Recall

Cast your mind back to Lab 025 (MCP intro). Answer these five questions in your `prompts.md`:

1. What was the core concept of Lab 025 in one sentence?
2. Which MCP tool did you wire up in that lab?
3. What is the difference between an MCP tool and a Claude Code skill?
4. How would you use the specificity pattern to prompt Claude to call a specific MCP tool rather than choosing one on its own?
5. If you were to revisit your Lab 025 MCP configuration now, what single constraint would you add to your CLAUDE.md to guide Claude's tool selection?

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://github.com/anthropics/courses
- https://docs.claude.com/en/docs/claude-code/overview

## Next

→ End of curriculum — you have completed the full Claude Code bootcamp.
