# Lab 016 — TDD

⏱ **25 min**   📦 **You'll add**: `quips/test/validation.test.js`   🔗 **Builds on**: Checkpoint C   🎯 **Success**: `npm test` green in quips/ AND `quips/test/validation.test.js` rejects empty-text quips

<!--
  Template contract - do not remove this comment.
  CI (lint-prose + structure linter) enforces:
    1. Header line above (one line, five fields, in this exact order)
    2. Nine sections below (in this exact order, same H2 titles)
    3. Single new concept (a "Concept:" Bloom-tagged line)
    4. Every Do step ends with a verify COMMAND, not a screenshot
  See CONTRIBUTING.md and docs/DESIGN.md §7 for the full author contract.
-->

**Concept**: `Red-green-refactor loop with Claude as the implementer` (Bloom: Apply)

---

## Why

Most developers ask Claude to write code, then tests. That order hides bugs — the test writer already knows what the code does, so the test fits the code rather than the requirement. Reversing the order forces the test to define the requirement first. Claude must satisfy a constraint it did not invent, which surfaces edge cases neither you nor Claude would have thought to test after the fact. This lab practices that discipline: you write the test, Claude writes the code, and the test result is the only arbiter.

## Check

```bash
./scripts/doctor.sh 016
```

Expected output: `OK lab 016 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before writing any test, predict: which HTTP status code should `POST /quips` return when the request body has an empty `text` field? Write your answer down. A status code in the 4xx range means the server rejected the input; 2xx means it accepted it.

   Verify your prediction is recorded before continuing:
   ```bash
   echo "my prediction: <your status code here>"
   ```
   Expected: a line beginning with `my prediction:`

2. **Run** — write a failing test first. Create `quips/test/validation.test.js` with a test that posts an empty `text` value and asserts the server returns a 4xx status. Do not touch any `src/` file yet. Then run the test suite:

   ```bash
   (cd quips && npm test 2>&1; echo "exit:$?")
   ```
   Expected: output contains your new test name and `exit:1` (at least one test fails).

3. **Investigate** — read the failure output. Identify which file in `quips/src/` needs to add the validation check. Confirm your new test file exists:

   ```bash
   grep -n 'test\|it(' quips/test/validation.test.js
   ```
   Expected: at least one line showing a `test(` or `it(` call.

4. **Modify** — launch Claude inside the quips project and give it exactly this prompt. Do not add to or soften the constraint:

   ```bash
   cd quips && claude
   ```

   Inside the REPL type:
   > Make the failing test in test/validation.test.js pass. Do not modify any file inside test/. Only change files in src/.

   After Claude finishes, verify all tests pass:
   ```bash
   (cd quips && npm test --silent; echo "exit:$?")
   ```
   Expected: final line is `exit:0`.

5. **Make** — add one more assertion to `quips/test/validation.test.js`: post a `text` value longer than 500 characters and assert the server returns a 4xx status. Run the tests to confirm the new assertion fails (red), then repeat the Claude prompt from step 4 to make it green:

   ```bash
   (cd quips && npm test 2>&1; echo "exit:$?")
   ```
   Expected: after the second Claude pass, final line is `exit:0` and both validation assertions appear in the passing output.

## Observe

One sentence — what would have gone wrong if you had asked Claude to write the test and the implementation at the same time?

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| Claude wrote the test AND the implementation together | The prompt did not forbid modifying test files | Be explicit: "Do not modify any file inside test/. Only change files in src/." | https://docs.claude.com/en/docs/claude-code/overview |
| Test passes immediately without any src/ change (false positive) | The assertion is already satisfied by the default behavior | Tighten the assertion or add a distinct failing case before accepting the green result | https://github.com/anthropics/anthropic-cookbook |
| Claude deletes the failing test instead of fixing it | Permission mode allows writes anywhere, including test/ | Use `--permission-mode acceptEdits` with a deny rule on test/; see Lab 013 for settings | https://docs.claude.com/en/docs/claude-code/settings |

## Stretch (optional, ~10 min)

Add a third assertion: post a `text` value that is exactly one character long and assert the server accepts it (2xx). Confirm this assertion passes without any further Claude prompt — it should already be covered by the validation logic Claude added.

## Recall

What key file did Lab 011 introduce to give Claude project-wide rules automatically on startup?

> Expected: `quips/CLAUDE.md`

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/overview
- https://docs.claude.com/en/docs/claude-code/settings

## Next

→ **Lab 017 — Rescue and Recover** — diagnose and fix a broken codebase using Claude without discarding the existing tests
