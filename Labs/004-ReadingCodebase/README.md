# Lab 004 — Reading a Codebase

⏱ **20 min**   📦 **You'll add**: `Labs/004-ReadingCodebase/summary.md`   🔗 **Builds on**: Lab 003   🎯 **Success**: `summary.md mentions SQLite, Fastify, and at least two of Quips' endpoints`

<!--
  Template contract - do not remove this comment.
  See docs/DESIGN.md §7 and scripts/lint-labs.sh for the author contract.
-->

!!! hint "Overview"
    - You will ask Claude to read the Quips repository and explain its purpose, data model, and HTTP surface.
    - You will compare what Claude surfaces against your own prediction before looking at any code.
    - You will practice iterative questioning — moving from high-level overview down to schema and routes.
    - By the end you will have a `summary.md` that captures Quips' architecture in three structured bullets.

**Concept**: `Claude reads a codebase and explains it back` (Bloom: Understand)

---

## Prerequisites

- Lab 003 complete (`claude --version` prints a version and the REPL opens without error)
- The `quips/` directory present in this repository (it was added in Lab 003)
- A working `ANTHROPIC_API_KEY` or Pro/Max browser login

## What You Will Learn

- How Claude uses Glob, Grep, and Read tools to explore a codebase before answering
- The difference between a one-shot "explain everything" prompt and an iterative questioning strategy
- How to guide Claude toward specific parts of a codebase (schema, routes, entry point) with follow-up questions
- How to synthesize Claude's answers into a structured artifact you can use as a reference

## Why

Reading unfamiliar code is the most common task in real engineering. Practising it with Claude as a guide builds the habit of asking precise questions about structure, storage, and interfaces — skills that scale to any codebase.

## Walkthrough

When you open Claude Code inside a project directory, Claude does not read every file upfront. Instead it uses three lightweight tools to orient itself before answering:

- **Glob** — lists files matching a pattern (`**/*.js`, `package.json`). Claude uses this to map what exists without reading content.
- **Grep** — searches file contents for a string or regex. Claude uses this to locate where a concept lives (a route definition, a schema declaration, a function name).
- **Read** — fetches the actual content of a specific file. Claude uses this only after it knows which file is relevant.

This order — structure before content — is deliberate. Asking Claude to "read the whole repo" on a large codebase can cost tokens and produce shallow answers. Asking iterative questions drives Claude to read only the files that matter, which produces sharper, more accurate answers.

**One-shot vs iterative questioning**

| Approach | Prompt | What Claude does | Typical result |
|---|---|---|---|
| One-shot | "Summarize this entire codebase" | Globs broadly, skims many files | High-level but may miss details |
| Iterative | "What does this repo do? → What is the data model? → What are the routes?" | Reads targeted files per question | Precise, verifiable answers |

The iterative approach is better for onboarding because each answer gives you a hook for the next question.

**Example prompt series for onboarding to an unfamiliar repo**

Start broad, then narrow:

1. "What does this repo do? Keep it to three sentences."
2. "What database does it use, and what is the table schema?"
3. "List every HTTP endpoint this server exposes."
4. "Where does input validation happen?"
5. "How does the server start? Walk me from the entry point to the first route registration."

Each prompt builds on the last. By prompt 5 you have a mental map of the entire codebase — without reading a single file yourself.

## Check

```bash
./scripts/doctor.sh 004
```

Expected output: `OK lab 004 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before opening any file in `quips/`, write your best guess at what "Quips" does. Add it as the first line of `Labs/004-ReadingCodebase/summary.md` prefixed with `Pre-prediction:`. You will compare it against Claude's answer at the end.

   Verify:
   ```bash
   head -1 Labs/004-ReadingCodebase/summary.md
   ```
   Expected: a line that starts with `Pre-prediction:`.

2. **Run** — open a Claude Code REPL inside the Quips project and ask for a high-level description.

   ```bash
   cd quips && claude
   ```

   In the REPL, ask:
   > What does this repo do? Keep it to 3 sentences.

   Verify: the answer mentions `HTTP` or `API`.

3. **Investigate** — still in the REPL, ask Claude about the database.

   > What database does this repo use, and what's the table schema?

   Verify: the answer mentions `SQLite` and the `quips` table with columns `id`, `text`, and `tags`.

4. **Modify** — ask Claude to enumerate the server's routes.

   > List the HTTP endpoints this server exposes.

   Verify: the answer lists at least 3 of: `POST /quips`, `GET /quips`, `GET /quips/:id`, `DELETE /quips/:id`, `GET /health`.

5. **Make** — synthesize what you have learned. Write `Labs/004-ReadingCodebase/summary.md` with exactly three bullets:
   - **a.** what Quips is in one line
   - **b.** its storage (database engine, table name, columns)
   - **c.** its HTTP endpoints

   Verify:
   ```bash
   ./scripts/verify.sh 004
   ```
   Expected: exits 0 with no error output.

## Observe

Compare Claude's explanation at step 2 with your `Pre-prediction:` line at the top of `summary.md`. Which details did Claude surface that you missed? Write one paragraph in your own words. No answer key — this is metacognition practice.

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| Claude doesn't see the files | You're not in the right directory | Run `pwd` to check; if needed exit the REPL and run `cd /path/to/quips && claude` | https://docs.claude.com/en/docs/claude-code/overview |
| Answer mentions the wrong framework | Claude guessed without reading files | Ask it to read `package.json` explicitly: `cat package.json` in the REPL | https://docs.claude.com/en/docs/claude-code/overview |
| Endpoints list is incomplete | Claude didn't grep the source | Ask: `grep route src/server.js` or `grep app\. src/server.js` | https://github.com/anthropics/claude-code |

## Tasks

Click the checkbox next to each task to mark it done — your progress is saved locally.

### Task 1 — Identify the data model

**Scenario:** You joined a team and need to understand what data Quips stores before you touch any code. Ask Claude to describe the data model without reading the source yourself.

**Hint:** Ask Claude about the database, then follow up with a question about the table columns.

??? success "Solution"

    Inside the `quips/` REPL:
    ```
    What database does this repo use, and what is the table schema?
    ```
    Claude will Grep for schema definitions and Read the relevant file. Confirm it names `SQLite`, the table `quips`, and columns `id`, `text`, `tags`.

### Task 2 — Trace a request from route to database

**Scenario:** You want to understand what happens end-to-end when a client calls `POST /quips`. Ask Claude to walk you through the call chain from the route handler down to the database write.

**Hint:** Start with "trace the POST /quips request from the route handler to the database write."

??? success "Solution"

    ```
    Trace the POST /quips request: route handler → validation → database insert.
    ```
    Claude will Read the route file and the database module. Expect it to name the handler function, any validation step, and the SQL `INSERT` call.

### Task 3 — List all HTTP endpoints

**Scenario:** A teammate needs a quick reference of every route the server exposes. Ask Claude to enumerate them in a table.

**Hint:** "List every HTTP endpoint this server exposes, as a table with method, path, and description."

??? success "Solution"

    ```
    List every HTTP endpoint this server exposes as a table: method, path, one-line description.
    ```
    Expect at minimum: `POST /quips`, `GET /quips`, `GET /quips/:id`, `DELETE /quips/:id`, `GET /health`.

### Task 4 — Find where input validation lives

**Scenario:** A security review flagged "where is user input validated?" You need to point to the exact file and function.

**Hint:** Ask Claude directly; if it is uncertain, ask it to grep for `validate` or `schema` in the source.

??? success "Solution"

    ```
    Where does this server validate incoming request bodies? Name the file and function.
    ```
    If Claude is unsure, follow up with:
    ```
    Grep for 'validate' or 'schema' in src/
    ```
    Confirm Claude names a specific file and line range, not just a general description.

### Task 5 — Find where the database resets between tests

**Scenario:** The test suite claims to start clean every run. You want to know exactly where the database is wiped between tests so you can add a new test safely.

**Hint:** Ask Claude to look at the test setup — often a `beforeEach` or `afterEach` hook in the test file.

??? success "Solution"

    ```
    Where does the test suite reset the database between tests? Show me the file and hook.
    ```
    Claude will Read the test files and locate the `beforeEach`/`afterEach` that drops and recreates the schema or deletes rows. Confirm it names a specific function and file.

### Task 6 — Ask Claude to explain a file you have never seen

**Scenario:** You notice a file you did not encounter during the walkthrough (perhaps a utility or config file). Ask Claude to explain what it does without opening it yourself.

**Hint:** Run `ls src/` inside the REPL first to see what files exist, then pick one you have not discussed yet.

??? success "Solution"

    ```
    List the files in src/ and tell me what each one is responsible for.
    ```
    Then pick one unfamiliar file:
    ```
    Explain what src/<filename> does. What are its exports and who calls them?
    ```

## Quiz

<div class="ccg-quiz" data-lab="004">
  <div class="ccg-q" data-answer="b">
    <p><strong>Q1.</strong> When Claude explores a codebase, which tool does it typically use <em>first</em> to understand what files exist?</p>
    <label><input type="radio" name="004-q1" value="a"> a. Read — it opens files one by one from the root</label>
    <label><input type="radio" name="004-q1" value="b"> b. Glob — it maps the file tree by pattern before reading content</label>
    <label><input type="radio" name="004-q1" value="c"> c. Grep — it searches for keywords across every file simultaneously</label>
    <label><input type="radio" name="004-q1" value="d"> d. Bash — it runs <code>find .</code> and parses the output</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Claude uses Glob first to map the file tree without reading content, then Grep to locate where a concept lives, then Read to fetch the specific file. This structure-before-content order is more token-efficient and produces sharper answers than reading blindly.</p>
  </div>
  <div class="ccg-q" data-answer="c">
    <p><strong>Q2.</strong> You are onboarding to a 200-file monorepo. Which strategy gives Claude the best chance of accurate answers?</p>
    <label><input type="radio" name="004-q2" value="a"> a. Ask "summarize the entire codebase" once and read the output carefully</label>
    <label><input type="radio" name="004-q2" value="b"> b. Paste all the files into the prompt so Claude can read them directly</label>
    <label><input type="radio" name="004-q2" value="c"> c. Ask a series of narrow questions — purpose, data model, routes — building on each answer</label>
    <label><input type="radio" name="004-q2" value="d"> d. Ask Claude to generate tests; whatever it assumes is the architecture</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Iterative narrow questions drive Claude to read only the files that matter for each answer. This produces precise, verifiable answers and avoids the shallow broad-strokes response that a one-shot "summarize everything" prompt tends to produce on large repos.</p>
  </div>
  <div class="ccg-q" data-answer="a">
    <p><strong>Q3.</strong> Why is reading the file structure (Glob) more useful than immediately asking Claude to read all files?</p>
    <label><input type="radio" name="004-q3" value="a"> a. It lets Claude identify the relevant files before spending tokens reading content</label>
    <label><input type="radio" name="004-q3" value="b"> b. Glob is faster because it runs in parallel on the file system</label>
    <label><input type="radio" name="004-q3" value="c"> c. Reading files is disabled by default in Claude Code for security reasons</label>
    <label><input type="radio" name="004-q3" value="d"> d. File content is too large for Claude's context window to handle</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Structure-first means Claude targets only files relevant to your question rather than reading everything indiscriminately. This keeps context clean and answers focused. It is not a technical limitation — Claude can read files — it is a prompting strategy for accuracy.</p>
  </div>
  <div class="ccg-q" data-answer="d">
    <p><strong>Q4.</strong> Claude tells you a route exists at <code>GET /quips/:id</code> but you want to be sure it is not hallucinating. What is the best follow-up?</p>
    <label><input type="radio" name="004-q4" value="a"> a. Trust the answer — Claude rarely invents route names</label>
    <label><input type="radio" name="004-q4" value="b"> b. Ask Claude to regenerate the answer with a different model</label>
    <label><input type="radio" name="004-q4" value="c"> c. Open the file yourself and ctrl-F for the route</label>
    <label><input type="radio" name="004-q4" value="d"> d. Ask Claude to show you the exact line in the source file that defines the route</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Asking Claude to cite the exact file and line forces it to use Read or Grep to verify rather than recall from a summary. If the line does not exist, Claude will say so — this is the most reliable way to catch hallucinated details about a codebase.</p>
  </div>
</div>

## Stretch (optional, ~10 min)

Ask Claude to generate an OpenAPI 3.0 spec for Quips and save it:

```bash
# inside the quips REPL
# Ask: "Generate an OpenAPI 3.0 YAML spec for this server"
# Then save the output to:
Labs/004-ReadingCodebase/openapi.yaml
```

No grading — just try. Compare the generated spec against what you saw in `src/server.js`.

## Recall

What slash command clears the session history without exiting the REPL?

> Expected from Lab 003: `/clear`

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/overview
- https://github.com/anthropics/claude-code

## Next

→ **Lab 005 — Writing First Code** — ask Claude to add a new endpoint and watch it write, test, and wire up production code from scratch.
