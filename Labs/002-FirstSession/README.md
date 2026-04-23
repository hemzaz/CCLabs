# Lab 002 — First Session

⏱ **15 min**   📦 **You'll add**: `Labs/002-FirstSession/transcript.md`   🔗 **Builds on**: Lab 001   🎯 **Success**: `transcript.md exists, non-empty, contains the word 'Node' (case-insensitive)`

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
    - You will start an interactive Claude Code REPL session and send your first message.
    - You will explore how session state works: follow-up questions carry context from earlier turns.
    - You will learn the difference between REPL mode and the headless `-p` flag you used in Lab 001.
    - By the end you will have saved a transcript and be comfortable entering, querying, and exiting a live session.

**Concept**: `Hold an interactive REPL session with Claude Code` (Bloom: Apply)

---

## Prerequisites

- Completed Lab 001 — `claude --version` exits 0 and `claude -p "ping"` returns output
- A terminal with `claude` on PATH and auth configured (Pro/Max login or `ANTHROPIC_API_KEY`)

## What You Will Learn

- How to start and exit a Claude Code REPL session
- How in-session state (conversational memory) differs from headless `-p`
- What `/clear` and `/compact` do and when to reach for each
- How to list and use slash commands from inside the session
- How to save a session transcript manually

## Why

The headless flag (`-p`) from Lab 001 is useful for scripting, but real exploratory work happens in the REPL. Every lab from here on assumes you can start a session, hold a multi-turn conversation, and exit cleanly. Understanding session state — what Claude remembers within a session and what it forgets across sessions — is the mental model you need before you add files, tools, and agents on top.

## Walkthrough

Claude Code's interactive mode is a REPL — a Read-Eval-Print Loop that keeps a session alive until you exit. Run `claude` with no arguments and you land at a prompt. Type a message, press Enter, and Claude replies. Type another message and Claude remembers everything said earlier in the same session. This is your first chat with a very capable coworker who has excellent short-term memory and zero long-term memory between sessions.

**In-session memory** means every message you send in one `claude` invocation is part of one conversation context. When you ask "Why is it event-driven?" after asking "What is Node.js?", Claude knows what "it" refers to. This is fundamentally different from running `claude -p` twice — each `-p` call is a clean, stateless request with no memory of any prior call.

The table below summarises the two modes side by side:

| Mode | Command | State | Best for |
|---|---|---|---|
| **Headless** | `claude -p "…"` | Stateless — each call is independent | CI scripts, one-shot queries, automation |
| **REPL (interactive)** | `claude` | Stateful — full conversation history | Exploration, multi-turn reasoning, hands-on labs |

**Slash commands** are control signals you type inside the REPL — they start with `/` and are not sent to the model as questions. The most useful ones at this stage:

| Command | What it does |
|---|---|
| `/help` | Lists all available slash commands |
| `/clear` | Wipes the conversation history — starts a fresh context in the same terminal session |
| `/compact` | Summarises older turns to reclaim context window space without losing the thread |
| `/exit` | Ends the session gracefully (Ctrl+D also works) |

**`/clear` vs `/compact`**: use `/clear` when you want to completely change topic and prior context would only confuse things. Use `/compact` when a long conversation is approaching the context limit but you still need to refer back to earlier decisions. After `/clear`, Claude has no memory of what you just discussed. After `/compact`, it retains a compressed summary.

One practical implication: if you open a new terminal and run `claude` again, that is a fresh session — equivalent to `/clear`. Claude Code does not persist conversation history to disk between invocations (unless you use a tool or MCP server that does so explicitly). The transcript you save in this lab is your own record.

## Check

```bash
./scripts/doctor.sh 002
```

Expected output: `OK lab 002 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before running, write down what you expect the Claude REPL prompt to look like. Will it show a `>` symbol, a cursor, a special prefix? Write your guess.

   ```bash
   claude --version
   ```

   Expected: exits 0 and prints a semver string (sanity check from Lab 001).

2. **Run** — start the interactive REPL.

   ```bash
   claude
   ```

   Verify: you see a prompt awaiting input (terminal cursor is active and the session is waiting for your message).

3. **Investigate** — ask Claude a question inside the running session.

   Type and send:
   ```
   What is Node.js? Answer in 2 sentences.
   ```

   Verify: the response includes the word `JavaScript` or `runtime`.

4. **Modify** — ask a follow-up in the same session (do not exit).

   Type and send:
   ```
   Why is it event-driven?
   ```

   Verify: the response references events, non-blocking, or a similar concept.

5. **Make** — exit the session and save the transcript.

   Type:
   ```
   /exit
   ```
   (or press Ctrl+D)

   Copy the full session output into `Labs/002-FirstSession/transcript.md` manually.

   ```bash
   wc -l Labs/002-FirstSession/transcript.md
   ```

   Expected: output shows a non-zero line count.

## Observe

Note one thing Claude did that a plain Google search would NOT have done. For example: did it synthesise across concepts, ask a clarifying question, or tailor its answer to your phrasing? Write one paragraph in your own words. No answer key — this is metacognition practice.

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| REPL won't start | Auth token missing or expired | Re-run `claude /login` or export `ANTHROPIC_API_KEY` in your shell rc file, then retry `claude` | https://docs.claude.com/en/docs/claude-code/overview |
| Session hangs on first prompt | Slow network or proxy timeout | Press Ctrl+C, retry with a shorter question; if behind a corporate proxy set `HTTPS_PROXY` | https://github.com/anthropics/claude-code |
| Can't find transcript — CLI doesn't auto-save | No built-in auto-save to a named file | Copy/paste the terminal output into `Labs/002-FirstSession/transcript.md` manually | https://docs.claude.com/en/docs/claude-code/overview |
| Follow-up question gets a confused answer after `/clear` | `/clear` wipes history; Claude no longer knows the earlier context | This is expected — `/clear` resets the conversation; re-state the context in your next message | https://docs.claude.com/en/docs/claude-code/overview |

## Tasks

Click the checkbox next to each task to mark it done — your progress is saved locally.

### Task 1 — Start a session and explore the quips/ directory

**Scenario:** You want to ask Claude what files exist in the `Labs/002-FirstSession/` directory without leaving the REPL.

**Hint:** Inside the session, you can ask Claude to describe a directory. Try: "List the files in Labs/002-FirstSession/ and summarise what each one is for."

??? success "Solution"

    Start the REPL:
    ```bash
    claude
    ```
    Then type inside the session:
    ```
    List the files in Labs/002-FirstSession/ and summarise what each one is for.
    ```
    Claude will read the directory and describe `README.md`, `doctor.sh`, `verify.sh`, and any transcript you have saved. Exit with `/exit` when done.

### Task 2 — List all slash commands from inside the REPL

**Scenario:** You want to discover every `/command` available without leaving the session.

**Hint:** There is a slash command that shows all slash commands.

??? success "Solution"

    Inside a running `claude` session, type:
    ```
    /help
    ```
    The output lists every available slash command with a short description. Scroll through to find `/clear`, `/compact`, `/exit`, `/status`, and others. No need to leave the session.

### Task 3 — Save a transcript of a two-turn conversation

**Scenario:** You want a permanent record of the Node.js conversation you had during the Do steps.

**Hint:** Claude Code does not auto-save transcripts. Copy the terminal output after `/exit`.

??? success "Solution"

    1. Run the Do steps (start session, ask about Node.js, ask why it is event-driven).
    2. Type `/exit` to end the session.
    3. Select the full terminal output from the `claude` invocation through the last reply.
    4. Paste it into `Labs/002-FirstSession/transcript.md` and save the file.

    Verify the file is non-empty:
    ```bash
    wc -l Labs/002-FirstSession/transcript.md
    ```
    Expected: a number greater than 0.

### Task 4 — Exit gracefully with Ctrl+D

**Scenario:** You want to exit the session without typing `/exit`.

**Hint:** Ctrl+D sends an end-of-file signal that the REPL interprets as a clean exit.

??? success "Solution"

    Start a session:
    ```bash
    claude
    ```
    Send any message, then press **Ctrl+D** at the empty prompt. The session exits cleanly — equivalent to typing `/exit`. Verify:
    ```bash
    echo "exit code: $?"
    ```
    Expected: `exit code: 0`

### Task 5 — Observe state loss after /clear

**Scenario:** You want to confirm that `/clear` truly wipes context, not just the visual display.

**Hint:** Ask about a topic, use `/clear`, then ask a follow-up that assumes prior context.

??? success "Solution"

    Inside a `claude` session:
    ```
    What is Node.js? One sentence.
    ```
    Wait for the reply, then:
    ```
    /clear
    ```
    Then ask:
    ```
    What did I just ask you about?
    ```
    Claude will say it has no record of a prior question — the history was wiped by `/clear`. This confirms that `/clear` resets the conversation context, not just the screen.

### Task 6 — Start a second session and compare answers

**Scenario:** You want to confirm that two separate `claude` invocations share no state.

**Hint:** Open two terminal windows and ask the same question in each.

??? success "Solution"

    In terminal 1:
    ```bash
    claude
    ```
    Type: `What is Node.js? One sentence.`

    In terminal 2 (new window):
    ```bash
    claude
    ```
    Type: `What is Node.js? One sentence.`

    Compare the two answers. They may differ in phrasing — each session is independent. Neither session knows the other exists. This mirrors the headless `-p` statelessness, but within the interactive UX.

## Quiz

<div class="ccg-quiz" data-lab="002">
  <div class="ccg-q" data-answer="b">
    <p><strong>Q1.</strong> What is the key difference between <code>claude -p "…"</code> (headless) and running <code>claude</code> interactively?</p>
    <label><input type="radio" name="002-q1" value="a"> A. Headless mode is faster and uses a smaller model</label>
    <label><input type="radio" name="002-q1" value="b"> B. Headless mode is stateless; interactive mode maintains conversation history within the session</label>
    <label><input type="radio" name="002-q1" value="c"> C. Interactive mode saves transcripts automatically; headless mode does not</label>
    <label><input type="radio" name="002-q1" value="d"> D. They are identical except for the prompt display</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Each <code>-p</code> invocation is a self-contained request with no memory of prior calls. The REPL keeps a running conversation history for the lifetime of the session, so follow-up questions can reference earlier turns.</p>
  </div>
  <div class="ccg-q" data-answer="c">
    <p><strong>Q2.</strong> What does <code>/clear</code> do inside a running Claude Code session?</p>
    <label><input type="radio" name="002-q2" value="a"> A. Clears the terminal display only, keeping conversation history intact</label>
    <label><input type="radio" name="002-q2" value="b"> B. Saves the conversation to a file and then clears it</label>
    <label><input type="radio" name="002-q2" value="c"> C. Wipes the entire conversation history so the next message starts a fresh context</label>
    <label><input type="radio" name="002-q2" value="d"> D. Exits the session and relaunches it automatically</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain"><code>/clear</code> resets the conversation context — Claude will have no memory of anything said before the <code>/clear</code>. It does not exit the session, and it does not save anything. Use it when you want a completely fresh start without closing the terminal.</p>
  </div>
  <div class="ccg-q" data-answer="d">
    <p><strong>Q3.</strong> You start a new terminal and run <code>claude</code>. Does Claude remember what you said in a session you closed an hour ago?</p>
    <label><input type="radio" name="002-q3" value="a"> A. Yes, Claude Code persists history to disk between sessions by default</label>
    <label><input type="radio" name="002-q3" value="b"> B. Yes, but only the last five messages are retained</label>
    <label><input type="radio" name="002-q3" value="c"> C. Only if you used <code>/compact</code> before exiting</label>
    <label><input type="radio" name="002-q3" value="d"> D. No, each new invocation is a fresh session with no memory of prior ones</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Claude Code does not persist conversation history to disk between separate <code>claude</code> invocations (unless an MCP server or tool explicitly does so). Starting a new session is equivalent to pressing <code>/clear</code> — you get a blank context every time.</p>
  </div>
  <div class="ccg-q" data-answer="a">
    <p><strong>Q4.</strong> Which slash command shows all available slash commands from inside the REPL?</p>
    <label><input type="radio" name="002-q4" value="a"> A. <code>/help</code></label>
    <label><input type="radio" name="002-q4" value="b"> B. <code>/commands</code></label>
    <label><input type="radio" name="002-q4" value="c"> C. <code>/list</code></label>
    <label><input type="radio" name="002-q4" value="d"> D. <code>--help</code> (the CLI flag)</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain"><code>/help</code> typed inside the running REPL lists every available slash command and a short description of each. The <code>--help</code> flag works outside the session (before you start it) but does not enumerate slash commands the way <code>/help</code> does from within.</p>
  </div>
</div>

## Stretch (optional, ~10 min)

Open a second terminal and start a fresh `claude` session. Ask the same question ("What is Node.js? Answer in 2 sentences.") and compare the two answers. Note: each session starts fresh — no memory is shared across sessions by default.

Then, in one session, try `/compact` after a long exchange and observe what Claude says about the summary it has retained.

## Recall

What command installs Claude Code globally?

> Expected answer from Lab 001: `npm i -g @anthropic-ai/claude-code`

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/overview
- https://github.com/anthropics/claude-code

## Next

→ **Lab 003 — Slash Commands** — explore built-in `/` commands that control your Claude Code session.
