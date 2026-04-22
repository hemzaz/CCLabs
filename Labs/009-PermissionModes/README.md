# Lab 009 — Permission Modes

⏱ **20 min**   📦 **You'll add**: `quips/.claude/settings.local.json` with a permissions block   🔗 **Builds on**: Lab 008   🎯 **Success**: `quips/.claude/settings.local.json is valid JSON containing either a 'permissions' object with 'allow' OR 'deny' array, OR a 'permissionMode' string`

<!--
  Template contract - do not remove this comment.
  CI (lint-prose + structure linter) enforces:
    1. Header line above (one line, five fields, in this exact order)
    2. Nine sections below (in this exact order, same H2 titles)
    3. Single new concept (a "Concept:" Bloom-tagged line)
    4. Every Do step ends with a verify COMMAND, not a screenshot
  See CONTRIBUTING.md and docs/DESIGN.md §7 for the full author contract.
-->

**Concept**: `Permission modes gate what Claude can do without asking` (Bloom: Analyze)

---

## Why

Claude Code can run shell commands, edit files, and push to remotes — actions that matter. Permission modes let you declare exactly which operations are allowed, which require a prompt, and which are blocked entirely. Learning to configure them turns Claude from a "trust me" tool into one you can run in CI or hand to a teammate with confidence.

## Check

```bash
./scripts/doctor.sh 009
```

Expected output: `OK lab 009 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before opening Claude, write down the four Claude Code permission modes by name. Think about what each one implies about trust and automation.

   Verify:
   ```bash
   [[ -d quips ]]
   ```
   Expected: exits 0 (the Quips project exists from earlier labs).

2. **Run** — open Claude Code inside the Quips project and inspect the current permission mode.

   ```bash
   cd quips && claude
   ```

   In the REPL, run `/permissions` or `/help` and look for the current mode in the output. Identify which of the four modes is active: `default`, `acceptEdits`, `plan`, or `bypassPermissions`.

   Verify: you can name the current mode from the REPL output.

   ```bash
   echo "current mode identified"
   ```
   Expected: exits 0; you have written down the mode name.

3. **Investigate** — read the settings documentation to understand what each mode does.

   Reference: https://docs.claude.com/en/docs/claude-code/settings

   While reading, answer this question in your notes: *Which mode would you use for autonomous CI?*

   The answer: `acceptEdits` with a strict deny list is the practical choice for most CI pipelines; `bypassPermissions` is valid only in a fully sandboxed environment where external damage is impossible.

   Verify: you can state the difference between `acceptEdits` and `bypassPermissions`.

   ```bash
   echo "modes understood"
   ```
   Expected: exits 0.

4. **Modify** — create the permissions file inside the Quips project.

   ```bash
   mkdir -p quips/.claude
   ```

   Create `quips/.claude/settings.local.json` with content like:

   ```json
   {
     "permissions": {
       "allow": ["Bash(npm test)", "Bash(npm ci)", "Read", "Edit", "Write"],
       "deny": ["Bash(rm -rf *)", "Bash(git push*)"]
     }
   }
   ```

   Verify the file parses as valid JSON:

   ```bash
   python3 -c "import json,sys; json.load(open(sys.argv[1]))" quips/.claude/settings.local.json
   ```
   Expected: exits 0 with no output.

5. **Make** — re-enter the REPL from `quips/` and ask Claude to run `git push`. Observe that Claude refuses or prompts for confirmation because `Bash(git push*)` is in the deny list.

   ```bash
   cd quips && claude
   ```

   In the REPL, send:

   > Please run git push for me.

   Verify: Claude declines or surfaces a permission warning rather than executing the push.

   ```bash
   ./scripts/verify.sh 009
   ```
   Expected: exits 0 with no error output.

## Observe

When would you prefer a deny list over an allow list? Write one sentence — for example: a deny list is better when the set of safe commands is large and unbounded, and you only want to block a small number of dangerous ones.

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| Permissions file ignored | Wrong path; file must be at `.claude/settings.local.json` or `.claude/settings.json` inside the project root | Move the file to `quips/.claude/settings.local.json` and confirm the path with `ls quips/.claude/` | https://docs.claude.com/en/docs/claude-code/settings |
| JSON parse error | Trailing commas or smart quotes in the file | Validate with `python3 -m json.tool quips/.claude/settings.local.json` and fix the reported line | https://docs.claude.com/en/docs/claude-code/settings |
| Claude still asks for permission on allowed commands | Mode is still `default`; the settings file is present but a mode override is needed | Force the mode with `claude --permission-mode acceptEdits` or add `"permissionMode": "acceptEdits"` to the settings file | https://docs.claude.com/en/docs/claude-code/settings |

## Stretch (optional, ~10 min)

Switch to plan mode instead: `claude --permission-mode plan`. Ask Claude to refactor a function in `quips/src/db.js`. Note what changes compared to `acceptEdits` — specifically, when Claude asks before acting versus acting immediately.

## Recall

What artifact did Lab 008 produce, and why is it useful?

> Expected from Lab 008: a `plan-transcript.md` capturing Claude's proposed plan before execution — useful because it lets you review and reject a plan before any files are changed.

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/settings
- https://docs.claude.com/en/docs/claude-code/iam
- https://github.com/anthropics/claude-code

## Next

→ **Lab 010 — Multi-File Edits** — direct Claude to make coordinated changes across several files in a single session.
