# Lab 012 — @ Mentions

⏱ **20 min**   📦 **You'll add**: `Labs/012-AtMentions/session.md`   🔗 **Builds on**: Lab 011   🎯 **Success**: `session.md exists, non-empty, contains at least 3 occurrences of @ followed by a file path`

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
    - You will learn the `@path` syntax that pins a specific file into Claude's reading list before it answers.
    - You will see how referencing two files in one prompt differs from asking Claude to find them on its own.
    - You will combine an `@file` mention with a constraint to see how pinning sharpens Claude's focus.
    - By the end you will have a saved session that shows the before-and-after of using `@` versus pasting code.

**Concept**: `Pin context with @ to direct Claude to a specific file or URL` (Bloom: Apply)

---

## Prerequisites

- Completed Lab 011 — `quips/CLAUDE.md` exists and Claude reads it automatically at session start
- The `quips` submodule is present: `ls quips/src/` shows `db.js` and `server.js`

## What You Will Learn

- The `@file` syntax and how to resolve paths relative to the repo root
- How to reference two files in a single prompt with multiple `@` mentions
- How to combine `@file` with a constraint prompt for focused answers
- How to mention a remote URL (`@https://...`) to pull in documentation
- Why `@file` produces sharper answers than pasting large chunks of code
- How to narrow a debugging session by pinning the file that contains the bug

## Why

Claude reads files opportunistically — without hints it may choose the wrong file, or scan several before reaching the one you mean. The `@` mention syntax tells Claude exactly which file to read first, cutting wasted context and producing sharper answers on the first try. The same syntax works for remote URLs: `@https://docs.example.com/api` pulls a live documentation page into the conversation without any copy-pasting. This lab builds the habit of reaching for `@` before asking anything file-specific.

## Walkthrough

The `@` mention is a context-pinning shortcut built into Claude Code. Type `@` immediately followed by a path or URL and Claude treats that source as a required starting point before it forms its reply.

**File mentions** resolve relative to the directory where you launched `claude`. From the repo root, `@quips/src/db.js` pins that exact file. Claude reads it as part of the prompt, not as a free-form request to go searching:

```
@quips/src/server.js summarise this file in one sentence
```

**Two-file mentions** work by stacking `@` references in a single prompt:

```
@quips/src/server.js @quips/src/db.js explain how POST /quips flows from route to storage
```

Claude reads both files before composing its answer, so it can draw on the full call chain rather than guessing what the other file contains.

**URL mentions** bring remote documentation into the session with the same syntax:

```
@https://docs.claude.com/en/docs/claude-code/overview summarise the key flags in one paragraph
```

The table below shows all supported mention patterns:

| Pattern | Example | What Claude reads |
|---|---|---|
| Relative file path | `@quips/src/db.js` | That single file from the working directory |
| Directory | `@quips/src/` | All files Claude can enumerate in that directory |
| Remote URL | `@https://docs.claude.com/...` | The page content at that URL |
| Glob (interactive only) | `@quips/src/*.js` | All matching files |

**Why `@file` beats pasting** — pasting a file body consumes the same tokens as `@file`, but `@` keeps your prompt readable, avoids copy-paste errors, and lets Claude see the real filename. Claude can then use that filename in its answer, cite line numbers, and refer back to the file by name rather than "the code you pasted." For large files the difference is even clearer: paste a 400-line file and the prompt grows unwieldy; pin it with `@` and the prompt stays one line.

**What happens when the file does not exist** — Claude will report that it cannot read the path and may ask you to confirm the filename. Nothing silently fails; you see the error in the tool output and can correct the path.

## Check

```bash
./scripts/doctor.sh 012
```

Expected output: `OK lab 012 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — without `@` mentions, how does Claude decide which files to read? Write one sentence before running anything. Then confirm the quips submodule is present:

   ```bash
   [[ -d quips ]] && echo "quips present" || echo "missing quips"
   ```

   Expected: `quips present`

2. **Run** — from the repo root, start a Claude Code session and ask generically, without any `@` path:

   ```bash
   claude
   ```

   Type inside the REPL:

   > explain quips

   Observe which files Claude opens via its Read tool calls. Notice whether it reads any file you did not specify.

   Verify the transcript shows at least one Read tool call by Claude before it answers:

   ```bash
   echo "confirm you saw at least one Read tool call in Claude's output"
   ```

3. **Investigate** — still in the same session (or start a fresh one), ask again with an explicit `@` pin:

   > @quips/src/db.js explain how the schema is initialized

   Observe whether Claude reads `quips/src/db.js` first, before any other file. Notice that the `@` path is resolved relative to the repo root where Claude was launched.

   Verify Claude referenced `db.js` specifically in its answer:

   ```bash
   echo "confirm Claude's answer mentions db.js schema details (CREATE TABLE, resetDb, etc.)"
   ```

4. **Modify** — ask a two-file question using two `@` pins in one prompt:

   > @quips/src/server.js @quips/src/db.js explain how POST /quips flows from route to storage

   Verify Claude references both files in its answer:

   ```bash
   echo "confirm Claude's answer covers both server.js route handling and db.js storage"
   ```

5. **Make** — save an excerpt of the three exchanges above (steps 2, 3, 4) to `Labs/012-AtMentions/session.md`. The file must preserve the `@path` lines exactly as you typed them. Then verify:

   ```bash
   ./scripts/verify.sh 012
   ```

   Expected: `OK lab 012 verified`

## Observe

One sentence — when does a plain question waste tokens vs an `@`-pinned one?

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| `@` path is not expanding | File path does not exist or is misspelled | Check with `ls quips/src/` and paste the exact filename into the prompt | https://docs.claude.com/en/docs/claude-code/overview |
| Claude ignores `@` for certain file types | Some binary or image extensions are not supported as inline context | Paste the text content inline instead of using `@` for those files | https://docs.claude.com/en/docs/claude-code/common-workflows |
| Too many `@` mentions blow the context window | Pinning many large files at once exhausts the token budget | Pin one or two files per turn rather than five at once | https://docs.claude.com/en/docs/claude-code/common-workflows |
| URL mention returns no content | The URL requires authentication or is behind a firewall | Paste the relevant section of the page manually for this turn | https://docs.claude.com/en/docs/claude-code/overview |

## Tasks

Click the checkbox next to each task to mark it done — your progress is saved locally.

### Task 1 — Summarise a file in one sentence with @

**Scenario:** You want a one-sentence summary of `quips/src/server.js` without reading it yourself first.

**Hint:** Pin the file with `@` and add the constraint "one sentence" to the prompt.

??? success "Solution"

    ```bash
    claude
    ```

    Type inside the session:

    ```
    @quips/src/server.js summarise this file in one sentence
    ```

    Claude reads `server.js` and replies with a single sentence covering what the Express server does. The `@` ensures Claude reads exactly that file — not a README or a different source.

### Task 2 — Reference two files in one prompt

**Scenario:** You want to understand how the server talks to the database without switching context between files.

**Hint:** Stack two `@` mentions at the start of one prompt.

??? success "Solution"

    Inside a running `claude` session, type:

    ```
    @quips/src/server.js @quips/src/db.js how does the server call the database layer?
    ```

    Claude reads both files before answering. Look for references to both `server.js` exports and `db.js` functions in the reply — that confirms both files were loaded.

### Task 3 — Combine @file with a constraint prompt

**Scenario:** You need only the parts of `db.js` that affect data integrity, not a full walkthrough.

**Hint:** Pin the file and add a constraint such as "only discuss constraints, foreign keys, and error handling."

??? success "Solution"

    Inside a running `claude` session, type:

    ```
    @quips/src/db.js only discuss the parts that affect data integrity: constraints, error handling, and transactions
    ```

    Claude's answer should stay within those bounds and skip unrelated details like the connection setup. The constraint in the prompt narrows scope; the `@` ensures Claude starts from the right file.

### Task 4 — Mention a doc URL and ask Claude to apply it

**Scenario:** You want to check whether `quips/src/server.js` follows Claude Code's recommended common-workflows patterns for project context.

**Hint:** Use an `@https://...` mention to pull in the relevant docs page, then ask Claude to compare.

??? success "Solution"

    Inside a running `claude` session, type:

    ```
    @https://docs.claude.com/en/docs/claude-code/common-workflows @quips/src/server.js does server.js follow any of the patterns described in that page? list the ones it uses and the ones it skips
    ```

    Claude fetches the documentation page and reads `server.js`, then lists overlaps and gaps. The URL mention saves you from copying the documentation manually.

### Task 5 — Compare "paste the code" vs "@file"

**Scenario:** You want to see whether pinning with `@` and pasting the same file body produce different answers.

**Hint:** Run the same question twice — once with `@quips/src/db.js`, once by copy-pasting the file content — and compare Claude's ability to cite line numbers and filenames.

??? success "Solution"

    **a.** Run in a fresh session:

    ```
    @quips/src/db.js what does the resetDb function do?
    ```

    Note whether Claude names the file and cites line numbers.

    **b.** Start another fresh session and paste the contents of `db.js` inline:

    ```bash
    cat quips/src/db.js
    ```

    Paste that output into the REPL and ask the same question. Note that Claude may answer correctly but will describe "the code you shared" rather than `db.js` by name, and line-number references will be absent or less precise.

    The `@` form gives Claude a named anchor it can refer back to throughout the conversation.

### Task 6 — Use @-mention to narrow a debugging session

**Scenario:** A hypothetical bug report says the `/quips` POST endpoint sometimes returns 500. You want Claude to focus only on `server.js` when suggesting causes.

**Hint:** Pin `server.js` and describe the symptom — Claude will limit its analysis to what it can see in that file.

??? success "Solution"

    Inside a running `claude` session, type:

    ```
    @quips/src/server.js the POST /quips route sometimes returns 500. looking only at this file, what are the most likely causes and where in the code would you add a try/catch?
    ```

    By pinning `server.js`, Claude does not wander into `db.js` or other files unless it has a specific reason. The "looking only at this file" constraint plus the `@` mention together give you a focused, file-scoped debugging session.

## Quiz

<div class="ccg-quiz" data-lab="012">
  <div class="ccg-q" data-answer="b">
    <p><strong>Q1.</strong> What does an <code>@</code> mention primarily save when compared with pasting file contents into the prompt?</p>
    <label><input type="radio" name="012-q1" value="a"> A. It saves the tokens used by the file — the file is not loaded at all</label>
    <label><input type="radio" name="012-q1" value="b"> B. It keeps the prompt readable and gives Claude a named anchor it can cite throughout the conversation</label>
    <label><input type="radio" name="012-q1" value="c"> C. It saves you from needing an API key</label>
    <label><input type="radio" name="012-q1" value="d"> D. It compresses the file before sending it to the model</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Both <code>@file</code> and pasting load the file's contents into the context window. What <code>@</code> adds is a named reference — Claude knows the filename and can cite it in its answer and refer back to it by name in follow-up turns. The prompt also stays on one readable line rather than hundreds of pasted lines.</p>
  </div>
  <div class="ccg-q" data-answer="c">
    <p><strong>Q2.</strong> Which of the following is the correct syntax for pinning a remote documentation page into a Claude Code prompt?</p>
    <label><input type="radio" name="012-q2" value="a"> A. <code>fetch(https://docs.claude.com/...)</code></label>
    <label><input type="radio" name="012-q2" value="b"> B. <code>--url https://docs.claude.com/...</code></label>
    <label><input type="radio" name="012-q2" value="c"> C. <code>@https://docs.claude.com/...</code></label>
    <label><input type="radio" name="012-q2" value="d"> D. <code>include: https://docs.claude.com/...</code></label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">The <code>@</code> prefix works for both local paths and full HTTPS URLs. Claude fetches the page and treats its content as required reading before composing the reply — the same mechanics as a file mention, just pointing at the web instead of the filesystem.</p>
  </div>
  <div class="ccg-q" data-answer="a">
    <p><strong>Q3.</strong> When should you prefer <code>@file</code> over pasting the file body inline?</p>
    <label><input type="radio" name="012-q3" value="a"> A. Whenever you want Claude to be able to cite the filename and line numbers in its answer</label>
    <label><input type="radio" name="012-q3" value="b"> B. Only when the file is larger than 100 lines</label>
    <label><input type="radio" name="012-q3" value="c"> C. Only when you are using headless <code>-p</code> mode</label>
    <label><input type="radio" name="012-q3" value="d"> D. Only when the file is a JavaScript file</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">The named anchor that <code>@file</code> provides is useful at any file size. Even for short files, having Claude refer to <code>db.js</code> by name rather than "the code you pasted" makes follow-up turns cleaner and easier to read. Prefer <code>@file</code> as the default; paste inline only when <code>@</code> is not available or the file type is not supported.</p>
  </div>
  <div class="ccg-q" data-answer="d">
    <p><strong>Q4.</strong> You type <code>@quips/src/typo.js</code> in a prompt but the file does not exist. What happens?</p>
    <label><input type="radio" name="012-q4" value="a"> A. Claude silently ignores the mention and answers without reading any file</label>
    <label><input type="radio" name="012-q4" value="b"> B. Claude creates an empty file at that path</label>
    <label><input type="radio" name="012-q4" value="c"> C. The session crashes and you must restart <code>claude</code></label>
    <label><input type="radio" name="012-q4" value="d"> D. Claude reports that it cannot read the path and you can correct the filename</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Claude Code surfaces the read error in its tool output so you can see exactly what went wrong. Nothing silently fails. Correct the spelling or path and resend the prompt — no need to restart the session.</p>
  </div>
</div>

## Stretch (optional, ~10 min)

Pin a directory instead of a single file (`@quips/src/`) and ask Claude to enumerate the files it finds there. Compare Claude's output to the result of `ls quips/src/` — are they identical? Then try combining a directory mention with a URL mention in one prompt and observe how Claude merges both sources in its answer.

## Recall

What file introduced in Lab 011 does Claude read automatically at session start?

> Expected: `quips/CLAUDE.md`

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/common-workflows
- https://docs.claude.com/en/docs/claude-code/overview

## Next

→ **Lab 013 — Settings Layering** — control Claude's behaviour per-project and per-user with layered settings files.
