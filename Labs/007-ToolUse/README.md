# Lab 007 — Tool Use

⏱ **25 min**   📦 **You'll add**: `Labs/007-ToolUse/observations.md` listing 3+ tools Claude used and what it did with each   🔗 **Builds on**: Lab 006   🎯 **Success**: `observations.md contains at least 3 of: Read, Edit, Write, Bash, Grep, Glob, Task — each with a 1-line note`

<!--
  Template contract - do not remove this comment.
  See docs/DESIGN.md §7 and scripts/lint-labs.sh for the author contract.
-->

!!! hint "Overview"
    - You will observe Claude deciding which tool to reach for based on the shape of your query.
    - You will explore the full tool set: Read, Write, Edit, Grep, Glob, Bash, WebFetch, WebSearch, Task, and TodoWrite.
    - You will construct a small reference table mapping query shape to the best tool.
    - You will contrast what Bash-only and Grep-only approaches produce for the same task.
    - By the end you will have `observations.md` documenting the tools Claude chose and why.

**Concept**: `Claude selects tools based on query shape, not guesswork` (Bloom: Apply)

---

## Prerequisites

- Lab 006 complete and `claude` available on PATH
- The `quips/` directory present in this repository (added in Lab 003)
- A working `ANTHROPIC_API_KEY` or Pro/Max browser login

## What You Will Learn

- The full tool set Claude Code provides and what each one is for
- How Claude decides which tool to call based on the shape (structure) of a query
- The practical difference between using Bash and Grep for a text-search task
- How the Edit tool's Read-first rule protects files from blind overwrites
- How to observe tool calls inline and use them as a learning signal

## Why

Prompting Claude produces text; tools are what let Claude act on real files and systems. When you understand which tool Claude reaches for — and why — you can write prompts that steer it toward the right action and catch mistakes before they land. Making tool use visible turns it from a black box into a transparent, auditable loop.

## Walkthrough

Claude Code ships ten tools. Each one is designed for a specific kind of job, and Claude chooses among them based on the shape of what you ask.

**The full tool set**

| Tool | Job | When Claude reaches for it |
|---|---|---|
| **Read** | Fetch the content of a specific file | You name a file explicitly, or Claude needs to inspect it before editing |
| **Write** | Create a new file from scratch | A file does not yet exist and needs to be created whole |
| **Edit** | Replace a precise string in an existing file | A file exists and needs a targeted change (requires a prior Read) |
| **Grep** | Search file contents for a string or regex | You want to know where something appears across files |
| **Glob** | List files matching a pattern | You want to know what files exist without reading their content |
| **Bash** | Run any shell command | A computation, pipeline, or system call is needed |
| **WebFetch** | Download and read a URL | You need the content of a specific web page |
| **WebSearch** | Search the web and return ranked results | You need to discover URLs or get an answer from the web |
| **Task** | Spawn a sub-agent to do parallel work | A job can be delegated and run independently |
| **TodoWrite** | Write a structured task list | You want Claude to track multi-step work in a checklist |

**Query shape drives tool choice**

Claude does not pick tools randomly. Each query has a shape — a structure that signals what kind of work is needed. You can learn to read that signal the same way Claude does:

| Query shape | Signal | Best tool |
|---|---|---|
| "What does `src/db.js` say about…" | Named file, needs content | Read |
| "Find every place X appears in `src/`" | Pattern across files | Grep |
| "What test files are in `quips/`?" | File listing, no content needed | Glob or Bash (find) |
| "Add a comment to line 1 of `db.js`" | Targeted change to existing file | Read then Edit |
| "Create a new file called `config.js`" | File does not yet exist | Write |
| "How many lines does `server.js` have?" | Computation, counting | Bash |
| "What does the Fastify docs say about hooks?" | External URL | WebFetch |

**Bash vs Grep for text search: a concrete contrast**

Both Bash and Grep can find text in files, but the result differs.

- **Bash only:** `bash("grep -r 'placeholder' quips/src")` runs a shell subprocess, which works but provides no structured output to Claude. Claude receives raw stdout and must parse it.
- **Grep only:** `Grep(pattern="placeholder", path="quips/src")` calls a native tool that returns structured matches with file paths and line numbers. Claude can reference those matches precisely in its response.

In practice, for a simple pattern search Grep gives cleaner, more actionable results. Bash is the better choice when you need pipes, counting (`wc -l`), or other shell operations that go beyond text search.

**The Edit tool's Read-first rule**

Edit cannot make a blind change. Before calling Edit, Claude must call Read to fetch the current file content. This is not optional — if Claude skips Read and tries to edit a string that was already changed or never existed, the Edit call will fail with an error. The practical effect is that you will always see a Read call in the transcript before any Edit call on the same file.

This rule protects you: if the file changed between when you last saw it and when Claude edits it, the mismatch is caught immediately rather than silently overwriting content.

**TodoWrite in action**

When a request involves three or more steps, Claude may call TodoWrite to lay out the work before doing it. You will see a checklist appear in the transcript — each item moves from pending to in-progress to completed as Claude works through it. This makes multi-step changes auditable and easy to interrupt if a step goes wrong.

## Check

```bash
./scripts/doctor.sh 007
```

Expected output: `OK lab 007 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before running anything, write down which tool you expect Claude to use to answer "How many test files are in `quips/`?" Your options: Bash, Grep, or Glob. No answer is wrong yet — this is your baseline prediction.

   Verify that the `quips/` directory is present:

   ```bash
   [[ -d quips ]] && echo "quips present" || echo "quips missing"
   ```

   Expected: `quips present`

2. **Run** — open Claude Code from the repo root and ask it to count test files.

   ```bash
   claude
   ```

   In the REPL, ask:

   > How many test files are in the quips/ directory? Use tools and report the count plus the command that produced it.

   Verify: the response contains a number.

   ```bash
   # Claude should have printed something like "3 test files" or "found 2 files".
   # Confirm you see a digit in Claude's output:
   echo "check: did Claude print a number? y/n"
   ```

3. **Investigate** — re-read the transcript in your terminal. Claude shows its tool calls inline (for example `Bash(find quips -name '*.test.*' | wc -l)` or `Glob(pattern="quips/**/*.test.*")`). Write down every tool name you see.

   Verify: you can identify at least one of Bash, Grep, or Glob in the transcript.

   ```bash
   # Confirm test files exist so Claude had something to find:
   find quips -name '*.test.*' | wc -l
   ```

   Expected: a number greater than 0.

4. **Modify** — still in the REPL (or reopen it), ask Claude to make a targeted edit.

   > Add a placeholder comment on line 1 of quips/src/db.js.

   Watch the transcript: Claude should call Read (to load the file) then Edit (to insert the comment).

   Verify the first line of `db.js` now starts with a comment character:

   ```bash
   head -1 quips/src/db.js
   ```

   Expected: a line beginning with `//` or `/*` (or note the tool sequence even if you declined the edit).

5. **Make** — create `Labs/007-ToolUse/observations.md` listing at least 3 tools you observed, one per line, with a 1-line note on what Claude did with each. Example format:

   ```
   - Bash: ran `find quips -name '*.test.*' | wc -l` to count test files
   - Read: loaded quips/src/db.js before editing it
   - Edit: inserted a placeholder comment at line 1 of db.js
   ```

   Verify:

   ```bash
   ./scripts/verify.sh 007
   ```

   Expected: exits 0 with no error output.

## Observe

Which tool does Claude prefer for a "find X in files" query — Bash, Grep, or Glob — and what does its choice tell you about how it interprets the query shape? Write one sentence based on what you actually saw in the transcript, not what you expected.

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| Tool calls not visible in the terminal | Old CLI version or non-default output format | Run `npm i -g @anthropic-ai/claude-code@latest` to update | https://github.com/anthropics/claude-code |
| Claude refuses to run a Bash command | That path is not in the permission allowlist | Check or relax permissions (see Lab 009) | https://docs.claude.com/en/docs/claude-code/overview |
| Edit fails with "file not read first" | Edit requires a prior Read call on the same file | Ask Claude to read the file first, then request the edit again | https://docs.claude.com/en/docs/claude-code/overview |
| Grep returns no results | Pattern is case-sensitive by default | Add `(?i)` to the pattern or ask Claude to search case-insensitively | https://docs.claude.com/en/docs/claude-code/overview |

## Tasks

Click the checkbox next to each task to mark it done — your progress is saved locally.

### Task 1 — Count test files and observe the tool choice

**Scenario:** You want to know how many test files are in `quips/` and, more importantly, which tool Claude reaches for to find out.

**Hint:** Ask Claude directly. Then look at the transcript — the tool call appears inline before the answer. Compare what you see against the reference table in the Walkthrough.

??? success "Solution"

    In the REPL:
    ```
    How many test files are in quips/? Use tools and show me the command.
    ```
    Claude will call Bash (`find … | wc -l`) or Glob (`quips/**/*.test.*`). Either is correct — note which one appeared and what the query-shape signal was. The key learning is reading the inline tool call, not the count itself.

### Task 2 — Force Grep-only and observe compliance

**Scenario:** You want to see what happens when you constrain Claude to a single tool. Does it follow the constraint, or does it fall back to Bash?

**Hint:** Ask explicitly: "Using only the Grep tool — no Bash — find every placeholder comment in `quips/src/`." Watch whether Claude complies or explains why it cannot.

??? success "Solution"

    In the REPL:
    ```
    Using only the Grep tool — no Bash — find every placeholder comment in quips/src/.
    ```
    Claude will either comply (calling `Grep(pattern="placeholder", path="quips/src")`) or explain that Bash would be more efficient and ask whether to proceed with Grep anyway. Both responses are informative. If it falls back to Bash, ask: "Why did you choose Bash over Grep here?" and read the reasoning.

### Task 3 — Trigger a Read-then-Edit sequence

**Scenario:** You need Claude to add a version comment to `quips/src/server.js`. This requires it to read the file first, then edit it — a two-tool sequence you can observe clearly.

**Hint:** Ask for a precise change to an existing file. Watch the transcript for the Read call that precedes the Edit call.

??? success "Solution"

    In the REPL:
    ```
    Add the comment `// v1 — Quips HTTP server` as line 1 of quips/src/server.js.
    ```
    You should see:
    1. `Read(file_path="quips/src/server.js")` — Claude loads current content
    2. `Edit(file_path="quips/src/server.js", old_string="…", new_string="// v1 — Quips HTTP server\n…")` — targeted replacement

    If only Edit appears without a preceding Read, that is the error case: Edit will fail because the tool requires file content to be loaded first.

### Task 4 — Ask Claude to explain its own tool choice

**Scenario:** Claude just used a tool. You want to understand the reasoning behind that choice — not just accept the output.

**Hint:** After any tool call, follow up with: "Why did you use that tool instead of [alternative]?"

??? success "Solution"

    After Claude uses Bash for a file count, ask:
    ```
    Why did you use Bash rather than Glob for that count?
    ```
    A good answer names the query shape ("counting required `wc -l`, which is a shell computation") and explains why Glob alone cannot produce a count. This is a metacognitive prompt — it makes Claude's reasoning visible and builds your own mental model of tool selection.

### Task 5 — Observe the Edit preamble Read requirement

**Scenario:** You want to confirm that Claude always calls Read before Edit — not just sometimes — and understand what happens if you ask for an edit to a file that has not been read.

**Hint:** Open a fresh REPL session (no prior context), then immediately ask for an edit to a file. Watch whether Claude reads first or attempts the edit blind.

??? success "Solution"

    In a fresh REPL session (`/clear` or restart):
    ```
    Edit quips/src/db.js to add a trailing newline at the end of the file.
    ```
    Claude will call `Read(file_path="quips/src/db.js")` before calling Edit. If it skips Read and Edit fails, you will see an error message explaining the read-first requirement. Either outcome teaches the same lesson: the constraint is enforced at the tool level, not by convention.

### Task 6 — Find every placeholder comment using Claude's preferred tool

**Scenario:** The codebase has scattered placeholder comments and you want a comprehensive list. Let Claude choose the tool, then compare whether it picks Grep or Bash.

**Hint:** Ask with no tool constraint. After it answers, ask which tool it used and why that tool was the better fit for this query shape.

??? success "Solution"

    In the REPL:
    ```
    Find every placeholder comment across quips/src/ and list them with their file and line number.
    ```
    Claude will likely call Grep (structured pattern search with line numbers) rather than Bash. Follow up:
    ```
    Why did you use Grep rather than Bash for that search?
    ```
    The answer should reference that Grep returns structured matches (file, line, content) that Claude can use directly, whereas Bash returns raw stdout that requires additional parsing.

## Quiz

<div class="ccg-quiz" data-lab="007">
  <div class="ccg-q" data-answer="b">
    <p><strong>Q1.</strong> Why must Claude call Read before it can call Edit on the same file?</p>
    <label><input type="radio" name="007-q1" value="a"> a. Edit is slower than Read and needs a warm-up call first</label>
    <label><input type="radio" name="007-q1" value="b"> b. Edit replaces an exact string match; without reading first, Claude cannot know the current content to match against</label>
    <label><input type="radio" name="007-q1" value="c"> c. The file system locks the file during a Read so Edit has exclusive access</label>
    <label><input type="radio" name="007-q1" value="d"> d. Read grants permission to edit; without it the file is read-only</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Edit works by finding the exact <code>old_string</code> in the file and replacing it with <code>new_string</code>. If Claude has not read the file, it cannot know what the current content looks like, so the string match will fail. Reading first ensures Claude is working from the actual, current file state rather than a stale assumption.</p>
  </div>
  <div class="ccg-q" data-answer="c">
    <p><strong>Q2.</strong> You ask Claude to find every occurrence of the word "timeout" across 50 source files. Which tool gives the most actionable result?</p>
    <label><input type="radio" name="007-q2" value="a"> a. Bash — it runs <code>grep -r</code> and returns stdout</label>
    <label><input type="radio" name="007-q2" value="b"> b. Glob — it lists all files, then Claude reads each one</label>
    <label><input type="radio" name="007-q2" value="c"> c. Grep — it returns structured matches with file paths and line numbers Claude can reference directly</label>
    <label><input type="radio" name="007-q2" value="d"> d. Read — it opens every file and scans for the word</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Grep returns structured output: file path, line number, and matched line. Claude can reference these directly in its response without parsing raw text. Bash (<code>grep -r</code>) produces the same text search but delivers raw stdout that Claude must interpret, which is less reliable for follow-up operations like "now edit line 42 in that file."</p>
  </div>
  <div class="ccg-q" data-answer="a">
    <p><strong>Q3.</strong> What is the Glob tool best suited for?</p>
    <label><input type="radio" name="007-q3" value="a"> a. Listing which files exist that match a pattern, without reading their content</label>
    <label><input type="radio" name="007-q3" value="b"> b. Searching file contents for a regular expression</label>
    <label><input type="radio" name="007-q3" value="c"> c. Running shell commands and returning their output</label>
    <label><input type="radio" name="007-q3" value="d"> d. Fetching the content of a remote URL</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Glob maps the file tree by pattern — for example <code>quips/**/*.test.*</code> returns a list of file paths that match, without opening any of them. This is more efficient than Read when you only need to know what exists. Claude uses Glob to orient itself before deciding which files are worth reading.</p>
  </div>
  <div class="ccg-q" data-answer="d">
    <p><strong>Q4.</strong> Claude shows its tool calls inline in the terminal. What is the most useful thing this transparency gives you?</p>
    <label><input type="radio" name="007-q4" value="a"> a. It proves that Claude is working, rather than generating text from memory</label>
    <label><input type="radio" name="007-q4" value="b"> b. It lets you copy the tool calls into your own scripts</label>
    <label><input type="radio" name="007-q4" value="c"> c. It logs the session so you can replay it later</label>
    <label><input type="radio" name="007-q4" value="d"> d. It lets you catch wrong tool choices before they produce bad output, and build a mental model of when each tool applies</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Inline tool visibility is primarily a learning and safety mechanism. When you see <code>Bash(rm -rf …)</code> or <code>Edit(old_string="…")</code> before the output appears, you have a window to interrupt, redirect, or simply learn from the choice. Over time, reading those tool calls trains your intuition for which tool fits which query shape.</p>
  </div>
</div>

## Stretch (optional, ~10 min)

Ask Claude to use only the Grep tool (no Bash) to find every placeholder comment across the repo:

> Using only the Grep tool — no Bash — find every placeholder comment in the quips/ directory.

Note whether it complies. If it falls back to Bash, ask why. There is no single right answer here — this is productive exploration that reveals how Claude reasons about tool choice under constraints.

## Recall

What does the Quips `/random` endpoint return when the table is empty?

> Expected from Lab 005: status 404 with body `{"error": "no quips"}`.

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/overview
- https://github.com/anthropics/claude-code

## Next

→ **Lab 008 — Plan Mode** — learn how Claude's plan mode structures multi-step changes before touching any files.
