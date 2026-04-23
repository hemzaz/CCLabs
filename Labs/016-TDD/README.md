# Lab 016 — TDD with Claude

⏱ **25 min**   📦 **You'll add**: `quips/test/count.test.js`   🔗 **Builds on**: Checkpoint C   🎯 **Success**: `npm test` green in quips/ AND `quips/test/count.test.js` tests the GET /quips/count endpoint

<!--
  Template contract - do not remove this comment.
  CI (lint-prose + structure linter) enforces:
    1. Header line above (one line, five fields, in this exact order)
    2. Nine sections below (in this exact order, same H2 titles)
    3. Single new concept (a "Concept:" Bloom-tagged line)
    4. Every Do step ends with a verify COMMAND, not a screenshot
  See CONTRIBUTING.md and docs/DESIGN.md §7 for the full author contract.
-->

!!! hint "Overview"
    - You will write a failing test for `GET /quips/count` before any implementation exists.
    - You will hand the failing test to Claude and constrain it to only make that test pass.
    - You will refactor Claude's implementation under the green suite without breaking it.
    - By the end you will have practiced the full red-green-refactor loop with Claude as the implementer.

**Concept**: `Red-green-refactor loop with Claude as the implementer` (Bloom: Apply)

---

## Prerequisites

- Checkpoint C complete (`quips/` project running, `npm test` passes)
- Node.js 20+ and `npm` on PATH
- `claude` authenticated (Lab 001)

## What You Will Learn

- Why writing tests before implementation produces better results with Claude
- How to constrain Claude to a specific scope so it does not over-build
- How to refactor Claude-written code safely under a green test suite
- How to reproduce a bug with a test before asking Claude to fix it

## Why

Most developers ask Claude to write code first and tests second. That order has a subtle flaw: the test author already knows what the implementation does, so the test is written to fit the code rather than the requirement. Bugs hide comfortably in that gap.

Reversing the order solves the problem. When you write the test first, the test defines the requirement. Claude must satisfy a constraint it did not invent. Edge cases surface early because the test is honest about what "correct" means — it was not written by the same mind that wrote the code.

There is a second benefit specific to AI-assisted development. If you ask Claude to write a feature without a test, Claude naturally adds scaffolding, defensive branches, and configuration hooks "just in case." Those extras are harder to review and often untested. A pre-written failing test acts as a fence: Claude writes exactly what is needed to cross the finish line, no more.

| Phase | Who acts | What happens |
|---|---|---|
| **Red** | You | Write a test that fails because the feature does not exist yet |
| **Green** | Claude | Implement the minimum code that makes the test pass |
| **Refactor** | You | Improve the implementation without breaking the green suite |

## Walkthrough

The feature you will build is `GET /quips/count` — an endpoint that returns a JSON object with a `count` field holding the number of quips currently stored. It is simple enough to fit in one test file and one route handler, which makes it ideal for practicing the cycle.

The red-green-refactor loop works like this. First you write `count.test.js` with an assertion that `GET /quips/count` responds with `{ count: <number> }`. You run the tests and confirm they fail — the endpoint does not exist yet. That is the red state. Then you open Claude inside the quips project and give it a single, scope-locked prompt: make the failing test pass, touch only `src/`. Claude adds the route handler and nothing else. You run the tests again; they pass. That is the green state. Finally, you read Claude's code and refactor it — rename a variable, extract a helper, tighten a comment — then run the tests a third time to confirm you did not break anything.

The refactor step is often skipped when working with AI because "it already works." Do not skip it. The refactor is where you learn the code and take ownership. A codebase where you understand every line is easier to maintain than one where you only understand the lines you wrote yourself.

## Check

```bash
./scripts/doctor.sh 016
```

Expected output: `OK lab 016 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before writing any test, predict: what JSON shape should `GET /quips/count` return? Write down the exact response body you expect, including the field name and value type. Then verify the quips project is green before you add anything:

   ```bash
   (cd quips && npm test --silent; echo "exit:$?")
   ```

   Expected: final line is `exit:0` (existing tests pass).

2. **Run** — write the failing test. Create `quips/test/count.test.js` with a test that calls `GET /quips/count` and asserts the response has status 200 and a body with a numeric `count` field. Do not touch any `src/` file. Then run the suite:

   ```bash
   (cd quips && npm test 2>&1; echo "exit:$?")
   ```

   Expected: output contains the name of your new test and `exit:1` (the new test fails because the endpoint does not exist).

3. **Investigate** — read the failure output carefully. Identify which file in `quips/src/` you would need to add a route to. Confirm your test file exists and contains at least one test:

   ```bash
   grep -n 'test\|it(' quips/test/count.test.js
   ```

   Expected: at least one line showing a `test(` or `it(` call.

4. **Modify** — launch Claude inside the quips project and give it exactly this prompt. Do not expand or soften the scope:

   ```bash
   cd quips && claude
   ```

   Inside the REPL type:
   > Make the failing test in test/count.test.js pass. Do not modify any file inside test/. Only change files in src/. Do not add any feature beyond what the test requires.

   After Claude finishes, verify all tests pass:

   ```bash
   (cd quips && npm test --silent; echo "exit:$?")
   ```

   Expected: final line is `exit:0`.

5. **Make** — refactor Claude's implementation. Read the code Claude wrote in `src/`. Rename any unclear variable, add a one-line comment explaining what the route does, or extract a repeated expression into a named constant. Then verify the suite stays green:

   ```bash
   (cd quips && npm test --silent; echo "exit:$?")
   ```

   Expected: final line is `exit:0` (your refactor did not break anything).

## Observe

One sentence — what would have been different about Claude's implementation if you had asked it to write both the test and the code at the same time?

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| Claude added the route but the test still fails | Claude returned a different JSON shape than the test expects | Read the assertion in `count.test.js` carefully; give Claude the exact field name and type from your test | https://docs.claude.com/en/docs/claude-code/overview |
| Claude modified files inside `test/` | The prompt did not explicitly forbid it | Re-run with the exact prompt from step 4; add "Do not modify any file inside test/" verbatim | https://docs.claude.com/en/docs/claude-code/overview |
| Test passes immediately before Claude does anything | The assertion is already satisfied by existing behavior | Tighten the assertion — assert a specific numeric value, not just `typeof count === 'number'` | https://github.com/anthropics/anthropic-cookbook |
| Refactor breaks the test | The refactor changed observable behavior (e.g., renamed the JSON key) | Undo the change and refactor only internals, not the external contract | https://docs.claude.com/en/docs/claude-code/overview |

## Tasks

Click the checkbox next to each task to mark it done — your progress is saved locally.

### Task 1 — Write a failing test for GET /quips/count

**Scenario:** The `GET /quips/count` endpoint does not exist yet. You need a test that will fail until someone adds it, proving the red state is genuine.

**Hint:** Use the same HTTP client your other quips tests use. Assert status 200 and that `response.body.count` is a number.

??? success "Solution"

    ```js
    // quips/test/count.test.js
    import { describe, it, expect, beforeAll, afterAll } from 'vitest'
    import request from 'supertest'
    import { app } from '../src/app.js'

    describe('GET /quips/count', () => {
      it('returns 200 with a numeric count field', async () => {
        const res = await request(app).get('/quips/count')
        expect(res.status).toBe(200)
        expect(typeof res.body.count).toBe('number')
      })
    })
    ```

    Run `npm test` — the new test should fail with 404 because the route does not exist yet.

### Task 2 — Ask Claude to make it pass, no extra scope

**Scenario:** You have a red test. Now you want Claude to implement the minimum route that makes it green, without adding unasked-for features.

**Hint:** The scope-locking phrase is critical. Include "Do not modify any file inside test/. Only change files in src/. Do not add any feature beyond what the test requires."

??? success "Solution"

    Open Claude inside the quips project:

    ```bash
    cd quips && claude
    ```

    Paste exactly:

    > Make the failing test in test/count.test.js pass. Do not modify any file inside test/. Only change files in src/. Do not add any feature beyond what the test requires.

    After Claude finishes:

    ```bash
    (cd quips && npm test --silent; echo "exit:$?")
    ```

    Expected: `exit:0`. If Claude touched `test/`, press ESC, run `git checkout test/`, and repeat the prompt with the constraint made more explicit.

### Task 3 — Refactor Claude's code under the green suite

**Scenario:** Claude's implementation works but may not be the clearest code. Refactor it — rename, extract, comment — without breaking the passing tests.

**Hint:** Read the route handler Claude added. Pick one thing to improve: a variable name, a magic number, or a missing comment. Change it, then run `npm test` again immediately.

??? success "Solution"

    ```bash
    # 1. Open the file Claude wrote, e.g.:
    cat quips/src/routes/quips.js

    # 2. Make one focused improvement (example: rename a variable for clarity)
    #    Edit the file directly — do NOT use Claude for this step.

    # 3. Confirm the suite stays green:
    (cd quips && npm test --silent; echo "exit:$?")
    ```

    Expected: `exit:0`. If the test fails, your refactor changed the external contract (e.g., the JSON key name). Undo and refactor only internals.

### Task 4 — TDD a bug fix: write a failing test that reproduces first

**Scenario:** Imagine `GET /quips/count` returns `count: -1` when there are no quips. Before asking Claude to fix it, write a test that proves the bug exists.

**Hint:** Seed zero quips (or rely on a fresh test database), call the endpoint, and assert `count` is `>= 0`. The test should fail against the buggy implementation before any fix is applied.

??? success "Solution"

    ```js
    // Add to quips/test/count.test.js
    it('returns count >= 0 when no quips exist', async () => {
      // Assumes test setup starts with an empty store
      const res = await request(app).get('/quips/count')
      expect(res.status).toBe(200)
      expect(res.body.count).toBeGreaterThanOrEqual(0)
    })
    ```

    Run `npm test` — confirm the new assertion fails. Then give Claude the same scope-locked prompt used in Task 2. The bug-fix test passes once Claude corrects the implementation.

### Task 5 — Compare TDD-first vs Claude-implements-first

**Scenario:** You want to see concretely what changes when you skip writing a test first. Describe the difference based on what you observed in this lab.

**Hint:** Think about what Claude added in Task 2 vs what it might have added if you had just said "add a GET /quips/count endpoint." Consider: extra config, error handling for cases your test does not cover, optional query parameters.

??? success "Solution"

    There is no single correct code answer — this task is reflective. A strong response names at least two differences:

    - **Scope**: without a test, Claude typically adds optional query parameters or pagination. With a test that only asserts `{ count: number }`, Claude adds only that.
    - **Correctness signal**: without a test, "it works" means "Claude says it works." With a test, "it works" means the test runner says it works — a repeatable, objective check.
    - **Ownership**: writing the test first means you understand the requirement before Claude touches any code, so you can evaluate Claude's output rather than just accepting it.

### Task 6 — Add a second test case without changing the implementation

**Scenario:** You want to assert that `GET /quips/count` returns the correct count after a quip is added — not just that the field exists. Add this assertion and confirm it passes with the implementation already in place.

**Hint:** Make a `POST /quips` request first to seed one quip, then call `GET /quips/count` and assert `count` is at least 1. Do not touch any `src/` file.

??? success "Solution"

    ```js
    // Add to quips/test/count.test.js
    it('reflects a newly added quip in the count', async () => {
      await request(app)
        .post('/quips')
        .send({ text: 'hello world' })
        .expect(201)

      const res = await request(app).get('/quips/count')
      expect(res.status).toBe(200)
      expect(res.body.count).toBeGreaterThanOrEqual(1)
    })
    ```

    ```bash
    (cd quips && npm test --silent; echo "exit:$?")
    ```

    Expected: `exit:0`. If this fails, the implementation does not query the live store — let the test guide you to the correct fix.

## Quiz

<div class="ccg-quiz" data-lab="016">
  <div class="ccg-q" data-answer="b">
    <p><strong>Q1.</strong> What is the correct order of the red-green-refactor cycle?</p>
    <label><input type="radio" name="016-q1" value="a"> **a.** Write implementation → write test → refactor</label>
    <label><input type="radio" name="016-q1" value="b"> **b.** Write failing test → implement to pass → refactor</label>
    <label><input type="radio" name="016-q1" value="c"> **c.** Refactor → write test → implement</label>
    <label><input type="radio" name="016-q1" value="d"> **d.** Write test → refactor → implement</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Red means the test exists and fails (no implementation yet). Green means the implementation makes the test pass. Refactor means improving the code while keeping it green. Writing implementation first breaks the discipline because the test ends up describing what the code does rather than what it should do.</p>
  </div>
  <div class="ccg-q" data-answer="c">
    <p><strong>Q2.</strong> Why does writing the test first produce better results when Claude is the implementer?</p>
    <label><input type="radio" name="016-q2" value="a"> **a.** Claude runs faster when given a test file to read</label>
    <label><input type="radio" name="016-q2" value="b"> **b.** Tests make Claude less likely to use the wrong language</label>
    <label><input type="radio" name="016-q2" value="c"> **c.** Claude must satisfy a constraint it did not invent, which limits scope and surfaces edge cases</label>
    <label><input type="radio" name="016-q2" value="d"> **d.** Claude cannot write tests, so you must always write them first</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">When Claude writes both the test and the code, the test naturally fits the code — it is written by the same reasoning process. A pre-written test acts as an external constraint. Claude must satisfy it rather than invent its own definition of success, which tends to produce leaner, more focused implementations.</p>
  </div>
  <div class="ccg-q" data-answer="d">
    <p><strong>Q3.</strong> When is the right moment to refactor?</p>
    <label><input type="radio" name="016-q3" value="a"> **a.** Before writing the test, so the code is clean from the start</label>
    <label><input type="radio" name="016-q3" value="b"> **b.** While the test is still failing, to improve the implementation incrementally</label>
    <label><input type="radio" name="016-q3" value="c"> **c.** After every single line of implementation code is written</label>
    <label><input type="radio" name="016-q3" value="d"> **d.** Only after the test is passing (green), so you have a safety net</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Refactoring while the test is red means you have no signal: any change could be moving closer to green or further away. Waiting until green gives you a clear safety net — the test tells you immediately if your refactor broke the behavior that matters.</p>
  </div>
  <div class="ccg-q" data-answer="a">
    <p><strong>Q4.</strong> What does "just enough to pass" mean in the green phase?</p>
    <label><input type="radio" name="016-q4" value="a"> **a.** Implement only the behavior the test asserts — no extra features, no defensive branches for untested cases</label>
    <label><input type="radio" name="016-q4" value="b"> **b.** Write the shortest possible code even if it hard-codes the expected test output</label>
    <label><input type="radio" name="016-q4" value="c"> **c.** Add pagination, error handling, and logging so the code is production-ready before merging</label>
    <label><input type="radio" name="016-q4" value="d"> **d.** Make the test pass as fast as possible by skipping code review</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">"Just enough to pass" means the implementation is bounded by the test: if the test does not assert pagination, you do not add it. This keeps the green phase fast, keeps Claude's output reviewable, and defers unverified features to future tests. Hard-coding the expected value (option B) is not the intent — the implementation should be genuinely correct, not a cheat.</p>
  </div>
</div>

## Stretch (optional, ~10 min)

Add a third test case: `GET /quips/count` when exactly five quips exist should return `{ count: 5 }`. Seed exactly five quips in the test setup, then assert the exact value rather than `>= 1`. Confirm it passes without any further Claude prompt — the implementation Claude wrote in Task 2 should handle this correctly if it queries the live store.

## Recall

What file did Lab 011 introduce to give Claude project-wide rules automatically on startup?

> Expected: `quips/CLAUDE.md`

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/overview
- https://docs.claude.com/en/docs/claude-code/settings
- https://github.com/anthropics/anthropic-cookbook

## Next

→ **Lab 017 — Rescue and Recover** — diagnose and fix a broken codebase using Claude without discarding the existing tests
