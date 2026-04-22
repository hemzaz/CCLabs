# Lab 006 — Prompting

⏱ **20 min**   📦 **You'll add**: `Labs/006-Prompting/prompts.md` with 3 before/after pairs   🔗 **Builds on**: Lab 005   🎯 **Success**: `prompts.md contains 3 pairs, each with a BAD version, a GOOD version, and the observed outcome`

<!--
  Template contract - do not remove this comment.
  CI (lint-prose + structure linter) enforces:
    1. Header line above (one line, five fields, in this exact order)
    2. Nine sections below (in this exact order, same H2 titles)
    3. Single new concept (a "Concept:" Bloom-tagged line)
    4. Every Do step ends with a verify COMMAND, not a screenshot
  See CONTRIBUTING.md and docs/DESIGN.md §7 for the full author contract.
-->

**Concept**: `Prompt quality: specificity, examples, constraints` (Bloom: Apply)

---

## Why

A vague prompt gets vague code. This lab makes that concrete: you run the same task twice — once with a weak prompt, once with a precise one — and observe the difference in Claude's output. The skill you build here compounds across every future lab.

## Check

```bash
./scripts/doctor.sh 006
```

Expected output: `OK lab 006 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before running anything, write down what you think a bad prompt for "add a field to the database" looks like. What will Claude do when it receives it?

   Verify:
   ```bash
   [[ -d quips/ ]]
   ```
   Expected: exits 0 (the Quips project exists from Lab 005).

2. **Run** — open Claude Code inside the Quips project and try the BAD version of task (a).

   ```bash
   cd quips && claude
   ```

   In the REPL, send:

   > make the database better

   Verify: Claude responds with clarifying questions or a vague suggestion rather than a concrete diff.

   ```bash
   echo "observed: Claude asked for clarification or gave a generic response"
   ```
   Expected: you can confirm the output was not a concrete code change.

3. **Investigate** — still in the same REPL session, send the GOOD version of task (a):

   > Add a `created_at` INTEGER NOT NULL column to the quips table, defaulting to the current unix timestamp. Update the INSERT in createQuip to populate it. Update tests to verify the new column exists.

   Verify: Claude proposes a concrete diff touching `src/db.js` and `test/`.

   ```bash
   grep -qi "created_at" quips/src/db.js && echo "column present" || echo "column missing"
   ```
   Expected: `column present`

4. **Modify** — repeat for tasks b and c. For each, run the BAD version first, note Claude's response, then run the GOOD version.

   Task b — write a test:
   - BAD: `write a test`
   - GOOD: `Add a Vitest test in test/server.test.js for GET /quips that asserts the response is an array and each item has id, text, and tags fields. Use resetDb() in beforeEach.`

   Task c — explain a function:
   - BAD: `explain the code`
   - GOOD: `Explain the createQuip function in src/db.js in three bullet points: what SQL it runs, what it returns on success, and what happens if text is null.`

   Verify after each GOOD prompt produces a concrete output:
   ```bash
   grep -qi "createQuip" quips/src/db.js && echo "function present" || echo "function missing"
   ```
   Expected: `function present`

5. **Make** — write all three BAD/GOOD/OUTCOME pairs into `prompts.md`.

   ```bash
   touch Labs/006-Prompting/prompts.md
   ```

   Fill in the file with sections for each task. See the stub below, then verify:

   ```bash
   ./scripts/verify.sh 006
   ```
   Expected: exits 0 with no error output.

## Observe

Which dimension — specificity, examples, or constraints — moved the needle most across your three tasks? Write one sentence in your own words. No answer key — this is metacognition practice.

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| Claude keeps asking clarifying questions | Your prompt is under-specified | Add the schema, function signature, or expected output directly in the prompt | https://github.com/anthropics/courses |
| Output is verbose and goes off-topic | Missing output-format constraint | Add "answer in one sentence" or "only the diff, no prose" to your prompt | https://docs.claude.com/en/docs/claude-code/overview |
| Claude makes up file paths | Missing context about the codebase | Reference files directly with `@path/to/file` or read them first with the Read tool | https://docs.claude.com/en/docs/claude-code/overview |

## Stretch (optional, ~10 min)

Take the GOOD prompt for task (a) and tighten it further: add an output-format constraint such as "show only the SQL migration and the updated INSERT statement, no prose". Run it and compare the diff to your original GOOD version. Write one sentence: did the diff get cleaner?

## Recall

What command ran the Quips test suite?

> Expected from Lab 005: `npm test` run inside the `quips/` directory.

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://github.com/anthropics/courses
- https://docs.claude.com/en/docs/claude-code/overview

## Next

→ **Lab 007 — Tool Use** — learn how Claude calls tools and how to direct which tools it reaches for.
