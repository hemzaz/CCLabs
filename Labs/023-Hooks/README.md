# Lab 023 — Hooks

⏱ **25 min**   📦 **You'll add**: `quips/.claude/hooks/no-rm.sh` + PostToolUse and Stop hooks in `quips/.claude/settings.json`   🔗 **Builds on**: Lab 022   🎯 **Success**: `quips/.claude/hooks/no-rm.sh` blocks `rm -rf` with exit 2 and Claude reports the denial

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
    - You will learn the four hook types (PreToolUse, PostToolUse, Stop, UserPromptSubmit) and when each fires.
    - You will write a PreToolUse hook that blocks `rm -rf` by exiting with code 2 — a safety rule Claude cannot override.
    - You will add a PostToolUse hook that runs the test suite automatically after every `Edit` tool call.
    - You will add a Stop hook that commits work to git when the working tree is clean.
    - By the end, your quips workspace will have a layered safety-and-automation harness that fires without any prompt from you.

**Concept**: `Hook-protected workflow with PreToolUse, PostToolUse, and Stop handlers` (Bloom: Create)

---

## Prerequisites

- Lab 022 complete (quips project exists at `./quips/`)
- `jq` installed (`command -v jq && echo ok || brew install jq`)
- `git` initialized inside `quips/` (`git -C quips status` exits 0)

## What You Will Learn

- The four hook event types and the exact moment each fires in Claude's execution loop
- Exit code semantics: 0 = proceed, 1 = hook error (warn), 2 = block the tool call
- How to read the JSON payload Claude passes on stdin and extract fields with `jq`
- How a hook-protected workflow differs from an unprotected one
- How to test a hook script offline without launching a full Claude session

## Why

Claude runs tools — Bash commands, file edits, web fetches — on your behalf. By default there is nothing between Claude's decision and execution. Hooks change that. They are shell scripts that receive a JSON description of the tool call and can block it, log it, or react to it. The exit code is the contract: 0 means proceed, 2 or higher means block entirely, and 1 signals a hook-internal error. This gives you a safety layer that no prompt can override. This lab introduces Outcome O7: you will build a three-hook harness that (a) blocks dangerous Bash commands, (b) runs tests after every file edit, and (c) commits clean work automatically.

## Walkthrough

Claude Code exposes four hook events. The table below shows when each fires and what the exit code does:

| Hook type | Fires when | Exit 0 | Exit 1 | Exit 2+ |
|---|---|---|---|---|
| `PreToolUse` | Before Claude runs any tool | Allow the call | Hook error (logged, call proceeds) | Block the call entirely |
| `PostToolUse` | After a tool call completes | No-op | Hook error (logged) | Logged as error (call already done) |
| `Stop` | When Claude finishes its turn | No-op | Hook error (logged) | No-op |
| `UserPromptSubmit` | When the user submits a message | Allow | Hook error (logged) | Block the message |

A **hook-protected** workflow means dangerous operations are structurally impossible, not just discouraged. In an **unprotected** workflow you rely on Claude choosing not to run `rm -rf`; in a protected one the OS-level script enforces it, regardless of what the prompt says. The distinction matters especially in agentic runs where no human is watching each tool call.

Hooks live in `quips/.claude/settings.json` under a `"hooks"` key. Each entry names an event type, a `matcher` (the tool name pattern), and a `command` to run. Claude passes the full tool-call JSON blob on stdin. For a Bash tool call, the field `.tool_input.command` holds the shell string. For an Edit call, `.tool_input.path` holds the file path.

## Check

```bash
./scripts/doctor.sh 023
```

Expected output: `OK lab 023 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before writing any code, list three Bash operations a PreToolUse hook should block in a dev repo. Write them to a file so the verify step can confirm you completed this step.

   ```bash
   printf '%s\n' \
     "1. rm -rf on any path" \
     "2. git push --force to origin" \
     "3. overwrite .env with untrusted content" \
     > /tmp/023-predict.txt
   cat /tmp/023-predict.txt
   ```

   Expected: three numbered lines printed.

2. **Run** — read the hook event reference and confirm `jq` is available. You need `jq` to extract fields from the JSON payload Claude passes on stdin.

   ```bash
   command -v jq && echo "jq ok" || echo "install jq: brew install jq"
   ```

   Expected: `jq ok`

   Also confirm `quips/.claude/` exists:

   ```bash
   mkdir -p quips/.claude/hooks && echo "hooks dir ready"
   ```

   Expected: `hooks dir ready`

3. **Investigate** — understand the JSON shape Claude sends to hooks. For a Bash tool call the payload looks like this:

   ```json
   {
     "tool_name": "Bash",
     "tool_input": {
       "command": "rm -rf /tmp/test"
     }
   }
   ```

   Confirm you can extract `.tool_input.command` with `jq` from a test payload:

   ```bash
   echo '{"tool_name":"Bash","tool_input":{"command":"rm -rf /tmp/test"}}' \
     | jq -r '.tool_input.command'
   ```

   Expected:

   ```
   rm -rf /tmp/test
   ```

4. **Modify** — write the `no-rm.sh` PreToolUse hook and register all three hooks in `settings.json`.

   Create `quips/.claude/hooks/no-rm.sh`:

   ```bash
   cat > quips/.claude/hooks/no-rm.sh << 'EOF'
   #!/usr/bin/env bash
   # PreToolUse hook — blocks any Bash command containing 'rm -rf'.
   # Exit 2 tells Claude Code to block the tool call entirely.
   set -euo pipefail

   input=$(cat)
   cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // ""')

   if printf '%s' "$cmd" | grep -q 'rm -rf'; then
     printf 'Hook blocked: rm -rf is not allowed in this repo.\n' >&2
     exit 2
   fi

   exit 0
   EOF
   chmod +x quips/.claude/hooks/no-rm.sh
   ```

   Now write `quips/.claude/hooks/post-edit-test.sh` — the PostToolUse hook:

   ```bash
   cat > quips/.claude/hooks/post-edit-test.sh << 'EOF'
   #!/usr/bin/env bash
   # PostToolUse hook — runs the quips test suite after each Edit call.
   set -euo pipefail

   cd "$(dirname "$0")/../.."
   if [ -f package.json ]; then
     npm test --silent 2>&1 | tail -5
   elif [ -f Makefile ]; then
     make test 2>&1 | tail -5
   fi

   exit 0
   EOF
   chmod +x quips/.claude/hooks/post-edit-test.sh
   ```

   Write `quips/.claude/hooks/stop-commit.sh` — the Stop hook:

   ```bash
   cat > quips/.claude/hooks/stop-commit.sh << 'EOF'
   #!/usr/bin/env bash
   # Stop hook — commits clean work automatically when the tree is fully clean.
   set -euo pipefail

   cd "$(dirname "$0")/../.."
   if git diff --quiet && git diff --cached --quiet; then
     echo "Stop hook: working tree clean, nothing to commit." >&2
   else
     git add -A
     git commit -m "chore: auto-commit from Stop hook" --no-verify 2>&1 | tail -3
   fi

   exit 0
   EOF
   chmod +x quips/.claude/hooks/stop-commit.sh
   ```

   Now register all three hooks in `quips/.claude/settings.json`:

   ```bash
   cat > quips/.claude/settings.json << 'EOF'
   {
     "hooks": {
       "PreToolUse": [
         {
           "matcher": "Bash",
           "hooks": [
             {
               "type": "command",
               "command": ".claude/hooks/no-rm.sh"
             }
           ]
         }
       ],
       "PostToolUse": [
         {
           "matcher": "Edit",
           "hooks": [
             {
               "type": "command",
               "command": ".claude/hooks/post-edit-test.sh"
             }
           ]
         }
       ],
       "Stop": [
         {
           "matcher": ".*",
           "hooks": [
             {
               "type": "command",
               "command": ".claude/hooks/stop-commit.sh"
             }
           ]
         }
       ]
     }
   }
   EOF
   ```

   Verify the JSON is valid:

   ```bash
   python3 -c "import json; json.load(open('quips/.claude/settings.json'))" && echo "JSON valid"
   ```

   Expected: `JSON valid`

5. **Make** — test the hook offline with a simulated payload. This confirms the block fires without launching a Claude session.

   ```bash
   echo '{"tool_name":"Bash","tool_input":{"command":"rm -rf /tmp/safe-test-dir"}}' \
     | quips/.claude/hooks/no-rm.sh; echo "exit: $?"
   ```

   Expected output (stderr line followed by the exit code printed by the shell):

   ```
   Hook blocked: rm -rf is not allowed in this repo.
   exit: 2
   ```

   Also confirm a safe command passes through:

   ```bash
   echo '{"tool_name":"Bash","tool_input":{"command":"ls -la"}}' \
     | quips/.claude/hooks/no-rm.sh; echo "exit: $?"
   ```

   Expected: `exit: 0` (no blocking message).

6. **Inspect** — start a Claude session inside quips, ask it to run `rm -rf /tmp/test-lab023`, then inspect the transcript to see the hook denial.

   ```bash
   cd quips && claude
   ```

   Inside the REPL type:

   > Run `rm -rf /tmp/test-lab023` and tell me what the hook said.

   Claude will report the denial message from stderr. After exiting, verify all three hook scripts are executable:

   ```bash
   ls -l quips/.claude/hooks/*.sh | awk '{print $1, $NF}'
   ```

   Expected: three lines each starting with `-rwxr-xr-x` (or equivalent executable bits).

## Observe

One sentence — what is the functional difference between a hook exiting 1 and a hook exiting 2, and why does only exit 2 protect against an unsafe operation?

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| Hook runs but Claude still executes the command | Script exits 1 instead of 2; exit 1 is a hook error, not a block | Change the final `exit 1` to `exit 2` inside the script | https://docs.claude.com/en/docs/claude-code/hooks |
| `settings.json` is rejected at startup | Trailing comma or unquoted key breaks JSON | Run `python3 -m json.tool quips/.claude/settings.json` to locate the exact line | https://docs.claude.com/en/docs/claude-code/settings |
| Hook fires on every Bash call including safe ones | grep pattern too broad — matching partial substrings | Narrow to `grep -q 'rm -rf '` (note the trailing space) so bare `rm` is not caught | https://docs.claude.com/en/docs/claude-code/hooks |
| PostToolUse hook output never appears in transcript | Hook writes to stdout but Claude surfaces stderr in the transcript | Route informational lines to stderr with `>&2` | https://docs.claude.com/en/docs/claude-code/hooks |

## Tasks

Click the checkbox next to each task to mark it done — your progress is saved locally.

### Task 1 — Confirm the block fires on a recursive delete payload

**Scenario:** Before trusting a safety hook in production, verify it rejects the exact pattern you care about.

**Hint:** Pipe a JSON payload with `rm -rf` in `.tool_input.command` to the script and check `$?`.

??? success "Solution"

    ```bash
    echo '{"tool_name":"Bash","tool_input":{"command":"rm -rf /"}}' \
      | quips/.claude/hooks/no-rm.sh
    echo "exit: $?"
    # Expected: exit: 2 and the denial message on stderr.
    ```

### Task 2 — Confirm a safe command passes through

**Scenario:** A hook that blocks everything is as bad as a hook that blocks nothing. Verify safe commands exit 0.

**Hint:** Substitute `ls` for `rm -rf` in the payload.

??? success "Solution"

    ```bash
    echo '{"tool_name":"Bash","tool_input":{"command":"ls quips/src"}}' \
      | quips/.claude/hooks/no-rm.sh
    echo "exit: $?"
    # Expected: exit: 0 — no blocking message printed.
    ```

### Task 3 — Extend no-rm.sh to also block `git push --force`

**Scenario:** Force-pushing to origin is another irreversible action worth blocking at the hook layer.

**Hint:** Add a second `if` block that checks for `git push --force` with a grep. Keep both checks independent so either can block.

??? success "Solution"

    Edit `quips/.claude/hooks/no-rm.sh` and add before the final `exit 0`:

    ```bash
    if printf '%s' "$cmd" | grep -qE 'git push.+--force|git push.+-f'; then
      printf 'Hook blocked: git push --force is not allowed.\n' >&2
      exit 2
    fi
    ```

    Test:

    ```bash
    echo '{"tool_name":"Bash","tool_input":{"command":"git push --force origin main"}}' \
      | quips/.claude/hooks/no-rm.sh
    echo "exit: $?"
    # Expected: exit: 2
    ```

### Task 4 — Read the hook output in the Claude transcript

**Scenario:** When a hook blocks a call, Claude surfaces the script's stderr in its response. Verify you can locate that message in the REPL.

**Hint:** Start `claude` inside `quips/`, ask it to `rm -rf /tmp/lab023`, then look for the denial phrase in Claude's reply.

??? success "Solution"

    ```bash
    cd quips && claude
    # Inside the REPL:
    # > Please run: rm -rf /tmp/lab023
    # Claude's response will include the hook's stderr message:
    # "Hook blocked: rm -rf is not allowed in this repo."
    ```

### Task 5 — Verify the Stop hook fires by inspecting git log

**Scenario:** After a clean session the Stop hook should have committed any staged changes. Confirm a commit appears in `git log`.

**Hint:** Make a trivial change, let Claude's session end cleanly, then run `git log --oneline -3` in the quips directory.

??? success "Solution"

    ```bash
    # Make a trivial staged change
    echo "# hook test" >> quips/README.md
    cd quips && claude -p "say done in one word"
    # Claude session ends, Stop hook fires
    git -C quips log --oneline -3
    # Expected: top commit message contains "auto-commit from Stop hook"
    ```

### Task 6 — Confirm PostToolUse hook runs tests after an Edit

**Scenario:** The PostToolUse hook should run your test suite after each file edit. Observe the test output appearing in the transcript.

**Hint:** Ask Claude to make a trivial single-line edit to a source file, then look for test output in its response.

??? success "Solution"

    Inside a `claude` session in `quips/`:

    ```
    > Add a comment line to src/index.js saying "hook test"
    ```

    After the Edit tool fires, the PostToolUse hook runs `npm test`. The last 5 lines of test output appear in the transcript immediately after the edit confirmation.

    Verify the hook script itself is wired correctly:

    ```bash
    echo '{"tool_name":"Edit","tool_input":{"path":"src/index.js"}}' \
      | quips/.claude/hooks/post-edit-test.sh; echo "exit: $?"
    # Expected: exit: 0 and any test output on stdout.
    ```

## Quiz

<div class="ccg-quiz" data-lab="023">
  <div class="ccg-q" data-answer="c">
    <p><strong>Q1.</strong> A PreToolUse hook script exits with code 2. What does Claude Code do next?</p>
    <label><input type="radio" name="023-q1" value="a"> **a.** It logs a warning and continues executing the tool call.</label>
    <label><input type="radio" name="023-q1" value="b"> **b.** It marks the hook as errored and retries the tool call once.</label>
    <label><input type="radio" name="023-q1" value="c"> **c.** It blocks the tool call entirely and reports the hook's stderr to the transcript.</label>
    <label><input type="radio" name="023-q1" value="d"> **d.** It terminates the entire Claude session immediately.</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Exit code 2 (or higher) is the block signal. Claude cancels the pending tool call and surfaces the hook's stderr output in the conversation so the user understands why the action was refused. Exit code 1 is different — it means the hook itself encountered an error, and Claude logs it but still proceeds with the tool call.</p>
  </div>
  <div class="ccg-q" data-answer="b">
    <p><strong>Q2.</strong> You want to run your test suite automatically every time Claude edits a file. Which hook type is correct?</p>
    <label><input type="radio" name="023-q2" value="a"> **a.** PreToolUse, because you need to intercept the call before it happens.</label>
    <label><input type="radio" name="023-q2" value="b"> **b.** PostToolUse, because the edit must complete before tests can reflect the change.</label>
    <label><input type="radio" name="023-q2" value="c"> **c.** Stop, because tests only matter at the end of a session.</label>
    <label><input type="radio" name="023-q2" value="d"> **d.** UserPromptSubmit, to validate the user's intent before any edit occurs.</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">PostToolUse fires after the tool call finishes, so the edited file is already on disk when the hook runs. That is exactly when tests should execute — they can now import or compile the new code. PreToolUse fires before the edit lands, so tests would still see the old version.</p>
  </div>
  <div class="ccg-q" data-answer="a">
    <p><strong>Q3.</strong> Your hook script receives the tool call as a JSON blob on stdin. Which shell pipeline correctly extracts the Bash command string from the payload?</p>
    <label><input type="radio" name="023-q3" value="a"> **a.** <code>input=$(cat); cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // ""')</code></label>
    <label><input type="radio" name="023-q3" value="b"> **b.** <code>cmd=$(grep -o '"command":"[^"]*"' /dev/stdin | cut -d'"' -f4)</code></label>
    <label><input type="radio" name="023-q3" value="c"> **c.** <code>cmd=$1</code> (the command is passed as the first positional argument)</label>
    <label><input type="radio" name="023-q3" value="d"> **d.** <code>cmd=$(env | grep CLAUDE_COMMAND)</code></label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Claude Code passes the tool payload as JSON on the hook script's stdin. Reading stdin with <code>cat</code> and then parsing with <code>jq -r</code> is the correct, robust approach. The <code>// ""</code> default prevents jq from emitting <code>null</code> when the field is absent. The grep approach is fragile and breaks on escaped characters; positional args and env vars are not used.</p>
  </div>
  <div class="ccg-q" data-answer="d">
    <p><strong>Q4.</strong> Why should a hook script write its denial message to stderr rather than stdout?</p>
    <label><input type="radio" name="023-q4" value="a"> **a.** Claude Code ignores stdout entirely and only reads stderr.</label>
    <label><input type="radio" name="023-q4" value="b"> **b.** Stdout is reserved for the JSON payload that the hook sends back to Claude.</label>
    <label><input type="radio" name="023-q4" value="c"> **c.** Writing to stdout causes the hook to exit with a non-zero code automatically.</label>
    <label><input type="radio" name="023-q4" value="d"> **d.** Claude Code surfaces the hook's stderr in the transcript so users see the reason; stdout is used for structured data that modifies the tool call.</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">The hooks protocol distinguishes the two streams: stderr is for human-readable messages that Claude surfaces in the conversation, while stdout can carry structured JSON that Claude reads to modify how the tool call proceeds. Writing a denial message to stdout instead of stderr means the user sees nothing and the block appears silent and confusing.</p>
  </div>
</div>

## Stretch (optional, ~10 min)

Add a `UserPromptSubmit` hook that logs every user message to `/tmp/claude-audit.log` with a timestamp. This creates an audit trail without blocking any prompts.

```bash
cat > quips/.claude/hooks/audit-log.sh << 'EOF'
#!/usr/bin/env bash
# UserPromptSubmit hook — appends each prompt to an audit log.
set -euo pipefail

input=$(cat)
prompt=$(printf '%s' "$input" | jq -r '.prompt // ""')
printf '[%s] %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$prompt" >> /tmp/claude-audit.log
exit 0
EOF
chmod +x quips/.claude/hooks/audit-log.sh
```

Add the `UserPromptSubmit` entry to `quips/.claude/settings.json`, then start a session and verify the log grows:

```bash
tail -f /tmp/claude-audit.log
```

## Recall

Lab 021 introduced subagents with restricted tool lists. What is the parallel between a subagent's `tools:` allowlist and a PreToolUse hook that blocks certain Bash patterns?

> Expected: both constrain what Claude can do at the structural level rather than relying on prompt instructions. The tools allowlist prevents a subagent from calling disallowed tools at all; a PreToolUse hook intercepts allowed tool calls and can still veto specific invocations within those tools. Together they form a defense-in-depth approach.

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/hooks
- https://docs.claude.com/en/docs/claude-code/settings

## Next

→ **Lab 024 — Skills** — package reusable Claude behaviors as named skills and invoke them with a slash command.
