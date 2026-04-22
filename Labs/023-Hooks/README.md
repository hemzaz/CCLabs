# Lab 023 — Hooks

⏱ **20 min**   📦 **You'll add**: PreToolUse hook in `quips/.claude/settings.json` + `.claude/hooks/no-rm.sh`   🔗 **Builds on**: Lab 022   🎯 **Success**: `quips/.claude/hooks/no-rm.sh` blocks `rm -rf` and Claude reports the denial

<!--
  Template contract - do not remove this comment.
  CI (lint-prose + structure linter) enforces:
    1. Header line above (one line, five fields, in this exact order)
    2. Nine sections below (in this exact order, same H2 titles)
    3. Single new concept (a "Concept:" Bloom-tagged line)
    4. Every Do step ends with a verify COMMAND, not a screenshot
  See CONTRIBUTING.md and docs/DESIGN.md §7 for the full author contract.
-->

**Concept**: `PreToolUse hook that blocks an unsafe action` (Bloom: Create)

---

## Why

Claude runs tools — Bash, file edits, web fetches — on your behalf. Hooks let you intercept those calls before they execute. A PreToolUse hook reads the tool's input from stdin and can block the call entirely by exiting with code 2 or higher. This gives you a safety layer that Claude itself cannot override. In this lab you write a hook that blocks any Bash command containing `rm -rf`, enforcing a rule no prompt can work around.

## Check

```bash
./scripts/doctor.sh 023
```

Expected output: `OK lab 023 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before writing any code, list three Bash operations a PreToolUse hook should block in a dev repo (for example: dropping a database, overwriting a production config, deleting files recursively).

   Write the list to a temporary file so the verify command can confirm you completed the step:

   ```bash
   echo "1. rm -rf on any path
   2. drop production database
   3. overwrite .env with untrusted content" > /tmp/023-predict.txt
   cat /tmp/023-predict.txt
   ```

   Expected: three lines printed.

2. **Run** — read the hooks reference at https://docs.claude.com/en/docs/claude-code/hooks to learn the JSON shape for a hook entry. You need two fields per hook: `matcher` (a tool-name pattern) and `hooks` (an array of command entries). The three supported event types are `PreToolUse`, `PostToolUse`, and `Stop`.

   Verify you can name the two fields and three event types:

   ```bash
   echo "fields: matcher, hooks — events: PreToolUse PostToolUse Stop"
   ```

   Expected: the line prints without error.

3. **Investigate** — plan the hook script logic. Claude passes a JSON blob on stdin that describes the tool call. For a Bash tool call the field `.tool_input.command` holds the shell command string. The exit-code contract is: exit 0 = allow, exit 2 or higher = block. Exit 1 signals a hook error (different from a block).

   Verify `jq` is available (used to parse stdin in the script):

   ```bash
   command -v jq && echo "jq found" || echo "jq missing — install with: brew install jq"
   ```

   Expected: `jq found` (if missing, install jq before step 4).

4. **Modify** — create the hook script and the settings entry.

   First, create the directory and the script:

   ```bash
   mkdir -p quips/.claude/hooks
   ```

   Create `quips/.claude/hooks/no-rm.sh` with this content:

   ```bash
   #!/usr/bin/env bash
   # Blocks any Bash command that contains 'rm -rf'.
   set -euo pipefail

   input=$(cat)
   cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // ""')

   if printf '%s' "$cmd" | grep -q 'rm -rf'; then
     echo "Hook blocked: 'rm -rf' is not allowed in this repo." >&2
     exit 2
   fi

   exit 0
   ```

   Make it executable:

   ```bash
   chmod +x quips/.claude/hooks/no-rm.sh
   ```

   Now create or update `quips/.claude/settings.json` to register the hook. If the file already exists, merge the `hooks` key into it. A minimal file looks like:

   ```json
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
       ]
     }
   }
   ```

   Verify the JSON is valid:

   ```bash
   python3 -c "import json; json.load(open('quips/.claude/settings.json'))" && echo "JSON valid"
   ```

   Expected: `JSON valid`

5. **Make** — test the hook live. Start a Claude session inside quips and ask it to remove a safe temporary directory:

   ```bash
   cd quips && claude
   ```

   Inside the REPL, type:

   > Run `rm -rf /tmp/safe-test-dir` and tell me what happened.

   Verify Claude reports the hook blocked the command. You should see the denial message in Claude's output. Confirm with:

   ```bash
   echo '{"tool_input":{"command":"rm -rf /tmp/test"}}' | quips/.claude/hooks/no-rm.sh; echo "exit: $?"
   ```

   Expected: the script prints the denial message to stderr and the exit code is `2`.

## Observe

One sentence — what is the difference between a hook exiting 1 and exiting 2, and why does that distinction matter?

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| Hook script runs but Claude still executes the command | Exit code wrong — Claude only blocks on exit >=2 | Change the script to `exit 2` not `exit 1`; see the hook exit-code contract | https://docs.claude.com/en/docs/claude-code/hooks |
| `settings.json` JSON invalid | Trailing commas or unquoted keys | Run `python3 -m json.tool quips/.claude/settings.json` to get the exact line number | https://docs.claude.com/en/docs/claude-code/settings |
| Hook fires on every Bash command including safe ones | Matcher too broad or script logic too aggressive | Narrow the grep pattern inside the script so only `rm -rf` (with a space) triggers the block | https://docs.claude.com/en/docs/claude-code/hooks |

## Stretch (optional, ~10 min)

Extend `no-rm.sh` to also block `git push --force` to any remote that contains `origin`. Add a second test invocation to confirm the block fires:

```bash
echo '{"tool_input":{"command":"git push --force origin main"}}' | quips/.claude/hooks/no-rm.sh; echo "exit: $?"
```

Expected: exit code `2`.

## Recall

Lab 018 introduced challenge prompts for code review. What is the key difference between asking Claude to "review this" and asking Claude to "find all security issues and list them by severity"?

> Expected: the second prompt gives Claude a concrete output format and a success criterion, so it can self-check completeness; the first is open-ended and produces variable depth.

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/hooks
- https://docs.claude.com/en/docs/claude-code/settings

## Next

→ **Lab 024 — Skills** — package reusable Claude behaviors as named skills and invoke them with a slash command.
