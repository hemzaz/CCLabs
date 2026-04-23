# Lab 003 — Slash Commands

⏱ **15 min**   📦 **You'll add**: `Labs/003-SlashCommands/notes.md`   🔗 **Builds on**: Lab 002   🎯 **Success**: `notes.md` lists at least three slash commands with one-line descriptions

<!--
  Template contract - do not remove this comment.
  See docs/DESIGN.md §7 and scripts/lint-labs.sh for the author contract.
-->

!!! hint "Overview"
    - You will discover the full set of built-in slash commands by running `/help` inside the Claude Code REPL.
    - You will learn what each major command does — from wiping session history (`/clear`) to compacting context (`/compact`) to inspecting loaded memory (`/memory`).
    - You will distinguish built-in slash commands (always present) from skill-invoked slashes (added by oh-my-claudecode or other plugins).
    - You will document your findings in `notes.md` and verify the output with a one-liner grep.

**Concept**: `slash commands` (Bloom: Apply)

---

## Prerequisites

- Completed Lab 002 — First Session (you can open the REPL and have a conversation)
- `claude` on PATH (`command -v claude` returns a path)
- An authenticated Claude Code install (either browser login or `ANTHROPIC_API_KEY` set)

## What You Will Learn

- What slash commands are and how they differ from normal prompts
- The built-in command set and what each one does to session state
- The difference between built-in commands and skill-invoked slash commands
- How to inspect, reset, compact, and query your session from inside the REPL

## Why

Claude Code's REPL exposes built-in slash commands that let you control session state, memory, and context without leaving the terminal. Knowing which commands exist — and what each one resets — prevents subtle bugs where stale history or loaded files silently affect Claude's answers. Once you have this map in your head, you stop fighting the tool and start steering it.

## Walkthrough

Slash commands are typed directly in the REPL (not as part of a prompt to Claude). They start with `/`, take effect immediately, and never consume a model turn. Think of them as control-plane operations on the session itself.

### Built-in commands

The following commands ship with every Claude Code install. Run `/help` inside the REPL to see the current list for your installed version.

| Command | What it does |
|---|---|
| `/help` | List all available slash commands with short descriptions |
| `/clear` | Wipe the entire conversation history; next message starts a fresh session |
| `/compact` | Summarize and compress history without fully discarding it |
| `/logout` | Sign out of your Claude account and clear stored credentials |
| `/login` | Open the browser authentication flow to sign in |
| `/model` | Switch the active Claude model for the remainder of the session |
| `/cost` | Show token usage and estimated cost for the current session |
| `/permissions` | Inspect which tool permissions are currently active |
| `/memory` | Display the CLAUDE.md files and memory loaded into context |
| `/agents` | List agents and skills available in the current configuration |

### Built-in vs. skill-invoked slashes

Built-in commands (`/clear`, `/compact`, etc.) are part of the Claude Code binary itself — they work even in a minimal install with no plugins. Skill-invoked slashes, by contrast, are registered by oh-my-claudecode or other plugin layers. When you type `/ralph` or `/ultrawork` you are invoking a skill, not a built-in. The distinction matters when troubleshooting: a missing built-in is an install problem; a missing skill-slash is a plugin configuration problem.

A quick way to tell them apart: `/help` lists the built-ins. If a command doesn't appear there, it's skill-invoked.

## Check

```bash
./scripts/doctor.sh 003
```

Expected output: `OK lab 003 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before running anything, write down three slash commands you think exist. Good guesses: `/help`, `/clear`, `/exit`. Write them in your own words.

2. **Run** — open the Claude Code REPL and list all built-in commands:

   ```bash
   claude
   ```

   Then inside the REPL:

   ```
   /help
   ```

   Verify: the REPL is reachable.

   ```bash
   command -v claude && echo "claude is installed"
   ```

   Expected: prints a path and `claude is installed`.

3. **Investigate** — scroll the `/help` output and find three commands that interest you. Note what `/clear`, `/compact`, and `/memory` say they do. How do their descriptions differ?

   Verify: you can describe in one sentence what `/compact` does that `/clear` does not.

4. **Modify** — inside the REPL, have a short conversation (two or three messages), then run `/clear`. Ask Claude about the earlier conversation:

   ```
   /clear
   ```

   Verify: Claude responds as if the session just started — no reference to the prior messages.

5. **Make** — create your notes file with at least three entries, one per slash command:

   ```bash
   cat > Labs/003-SlashCommands/notes.md <<'EOF'
   /help - lists all slash commands available in the current Claude Code install
   /clear - wipes the full conversation history and resets the session
   /compact - compresses history into a summary without discarding it entirely
   EOF
   ```

   Verify:

   ```bash
   grep -c '^/' Labs/003-SlashCommands/notes.md
   ```

   Expected output: `3` (or higher if you added more).

   Then run the lab verifier:

   ```bash
   ./scripts/verify.sh 003
   ```

   Expected output: `OK lab 003 verified`

## Observe

Which command surprised you most, and why? Write one sentence describing what you did not expect about its behavior. There is no answer key here — this is metacognition practice.

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| `/help` prints nothing | You typed it at a shell prompt, not inside the REPL | Run `claude` first to enter the interactive session, then type `/help` | https://docs.claude.com/en/docs/claude-code/overview |
| A slash command is not recognized | Your Claude Code version is older than when the command was added | Run `npm update -g @anthropic-ai/claude-code` to upgrade, then restart the REPL | https://github.com/anthropics/claude-code |
| `notes.md` fails the grep check | Lines do not start with `/` | Prefix each line with the slash command (e.g. `/help - ...`) | (self-evident; see template) |
| `/compact` behaves like `/clear` | Nothing to compact yet — the session is too short | Have a longer conversation (10+ messages) before compacting | https://docs.claude.com/en/docs/claude-code/overview |

## Tasks

Click the checkbox next to each task to mark it done — your progress is saved locally.

### Task 1 — Discover all built-in commands

**Scenario:** You are on a new machine and want to see the full list of slash commands before starting work. You need to know what's available without reading docs.

**Hint:** There is exactly one command that prints the complete list.

??? success "Solution"

    ```bash
    claude
    # Inside the REPL:
    # /help
    # Scroll to see every built-in command.
    ```

    The output lists each command name and a short description. Count them — as of Claude Code 2.x there are roughly ten built-ins.

### Task 2 — Reset the session with /clear

**Scenario:** You have been debugging a tricky problem and Claude keeps referencing old context that is no longer relevant. You want a completely clean slate without restarting the binary.

**Hint:** One command wipes the full conversation history in a single keystroke.

??? success "Solution"

    ```bash
    # Inside the REPL:
    # /clear
    # Then ask: "what did we just talk about?"
    # Claude should say it has no record of any prior conversation.
    ```

    After `/clear`, the context window is empty. Claude cannot recall anything from before the command — it is functionally a new session sharing the same binary process.

### Task 3 — Check token usage with /cost

**Scenario:** You have been working with Claude for 20 minutes on a large codebase and want to know how many tokens you have consumed and roughly what it cost.

**Hint:** There is a command that reports session-level token and cost information.

??? success "Solution"

    ```bash
    # Inside the REPL, after a few exchanges:
    # /cost
    # Output shows input tokens, output tokens, cache hits, and estimated USD cost.
    ```

    The cost display resets when you run `/clear` or start a new session. It is useful for budgeting long autonomous runs.

### Task 4 — Switch models with /model

**Scenario:** You started a session with the default model and now want to switch to a faster, cheaper model for a repetitive task — without restarting the REPL.

**Hint:** One command opens an interactive model picker inside the REPL.

??? success "Solution"

    ```bash
    # Inside the REPL:
    # /model
    # A list of available models appears. Select one with the arrow keys and press Enter.
    # Your next message will use the newly selected model.
    ```

    You can switch back at any time by running `/model` again. The cost display from `/cost` will reflect the new model's pricing from that point forward.

### Task 5 — Inspect loaded memory with /memory

**Scenario:** You are in an unfamiliar project and want to know which CLAUDE.md files Claude Code has loaded into context. You also want to see what guidelines are currently active.

**Hint:** One command displays the memory and CLAUDE.md content currently in the session.

??? success "Solution"

    ```bash
    # Inside the REPL:
    # /memory
    # Claude Code prints the list of memory files it loaded (global, project, and local),
    # along with their content so you can see what guidelines are active.
    ```

    If you see unexpected instructions influencing Claude's behavior, `/memory` is the first place to look. You can trace exactly which CLAUDE.md is responsible.

### Task 6 — Distinguish built-in from skill-invoked commands

**Scenario:** A colleague tells you about a `/ralph` command. You try it and it works, but it does not appear in `/help`. You want to understand why.

**Hint:** `/help` only lists built-ins. Skill-invoked commands are registered by plugins.

??? success "Solution"

    ```bash
    # Inside the REPL:
    # /help
    # Note that /ralph does not appear.
    #
    # /ralph works because oh-my-claudecode registers it as a skill-invoked slash.
    # Built-in commands live in the Claude Code binary.
    # Skill-invoked commands live in plugin configuration (~/.claude/settings.json or similar).
    ```

    If a skill-invoked slash stops working, the fix is in your plugin config, not in Claude Code itself. If a built-in stops working, update Claude Code.

## Quiz

<div class="ccg-quiz" data-lab="003">
  <div class="ccg-q" data-answer="b">
    <p><strong>Q1.</strong> You run <code>/clear</code> in the middle of a session. What happens to the conversation history?</p>
    <label><input type="radio" name="003-q1" value="a"> A. It is compressed into a summary and kept in context</label>
    <label><input type="radio" name="003-q1" value="b"> B. It is completely wiped; the next message starts a fresh session</label>
    <label><input type="radio" name="003-q1" value="c"> C. It is saved to a file and then cleared from memory</label>
    <label><input type="radio" name="003-q1" value="d"> D. It is unchanged; <code>/clear</code> only clears the terminal display</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain"><code>/clear</code> wipes the full conversation history from the context window. Claude has no memory of anything said before the command. This is different from <code>/compact</code>, which compresses history into a summary rather than discarding it.</p>
  </div>
  <div class="ccg-q" data-answer="c">
    <p><strong>Q2.</strong> What does <code>/logout</code> do?</p>
    <label><input type="radio" name="003-q2" value="a"> A. It exits the REPL immediately</label>
    <label><input type="radio" name="003-q2" value="b"> B. It clears the conversation history</label>
    <label><input type="radio" name="003-q2" value="c"> C. It signs you out and clears stored authentication credentials</label>
    <label><input type="radio" name="003-q2" value="d"> D. It uninstalls Claude Code from your system</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain"><code>/logout</code> signs you out of your Claude account and removes cached credentials. After logging out, the next time you open Claude Code you will need to authenticate again via <code>/login</code> or by setting <code>ANTHROPIC_API_KEY</code>.</p>
  </div>
  <div class="ccg-q" data-answer="a">
    <p><strong>Q3.</strong> Which command shows you how many tokens you have used and the estimated cost for the current session?</p>
    <label><input type="radio" name="003-q3" value="a"> A. <code>/cost</code></label>
    <label><input type="radio" name="003-q3" value="b"> B. <code>/usage</code></label>
    <label><input type="radio" name="003-q3" value="c"> C. <code>/stats</code></label>
    <label><input type="radio" name="003-q3" value="d"> D. <code>/memory</code></label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain"><code>/cost</code> displays session-level token consumption (input, output, cache hits) and an estimated dollar cost. It resets when you start a new session or run <code>/clear</code>. The other options are not built-in Claude Code commands.</p>
  </div>
  <div class="ccg-q" data-answer="d">
    <p><strong>Q4.</strong> You want to see all user-invocable skill-based slash commands registered by oh-my-claudecode. Which approach works?</p>
    <label><input type="radio" name="003-q4" value="a"> A. Run <code>/help</code> — all commands including skills appear there</label>
    <label><input type="radio" name="003-q4" value="b"> B. Run <code>/permissions</code> — it lists registered skills</label>
    <label><input type="radio" name="003-q4" value="c"> C. Run <code>/memory</code> — skill registrations are stored in memory files</label>
    <label><input type="radio" name="003-q4" value="d"> D. Run <code>/agents</code> or check the plugin documentation — skill slashes do not appear in <code>/help</code></label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain"><code>/help</code> only lists built-in commands. Skill-invoked slashes registered by plugins like oh-my-claudecode do not appear there. Use <code>/agents</code> for a summary of available agents, or consult the plugin's own documentation for the full skill slash list.</p>
  </div>
</div>

## Stretch (optional, ~10 min)

Try `/compact` after a long conversation — at least ten exchanges — and compare its effect to `/clear`. In one sentence each, describe: does `/compact` preserve Claude's ability to reference earlier context, and if so, how accurately?

## Recall

> Where did you save your first REPL transcript, and what command did you run to create it?

Expected answer from Lab 002: `Labs/002-FirstSession/transcript.md`.

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/overview
- https://github.com/anthropics/claude-code

## Next

→ **Lab 004 — Reading a Codebase** — using Claude Code to explore and understand an unfamiliar project.
