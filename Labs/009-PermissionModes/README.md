# Lab 009 — Permission Modes

⏱ **25 min**   📦 **You'll add**: `quips/.claude/settings.local.json` with an allow/deny permissions block   🔗 **Builds on**: Lab 008   🎯 **Success**: `quips/.claude/settings.local.json is valid JSON containing a 'permissions' object with both 'allow' and 'deny' arrays`

<!--
  Template contract - do not remove this comment.
  CI (lint-prose + structure linter) enforces:
    1. Header line above (one line, five fields, in this exact order)
    2. !!! hint "Overview" admonition with >=3 bullets
    3. Concept: line with a Bloom tag
    4. Fourteen H2 sections below in this exact order:
       Prerequisites, What You Will Learn, Why, Walkthrough, Check, Do,
       Observe, If stuck, Tasks, Quiz, Stretch, Recall, References, Next
    5. >=5 Tasks, each with a ??? success "Solution" block
    6. >=3 MCQ questions inside a <div class="ccg-quiz">
  See CONTRIBUTING.md and docs/DESIGN.md §7 for the full author contract.
-->

!!! hint "Overview"
    - You will learn the four Claude Code permission modes and when each is appropriate.
    - You will build a project-local permissions file that allows `npm test` but denies `rm -rf`.
    - You will practice layering user-global rules on top of project rules and observe how they merge.
    - By the end you can describe the settings hierarchy, write allow/deny rules with wildcards, and choose the right mode for a given context.

**Concept**: `Permission modes gate what Claude can do without asking` (Bloom: Analyze)

---

## Prerequisites

- Completed [Lab 008 — Plan Mode](../008-PlanMode/README.md)
- The `quips/` project directory from earlier labs is present on disk

## What You Will Learn

- The four permission modes (`default`, `acceptEdits`, `plan`, `bypassPermissions`) and what each one permits or withholds
- How the settings file hierarchy works — enterprise overrides project overrides user overrides session — and why the order matters
- How to write `allow` and `deny` rules using tool-name wildcards such as `Bash(npm *)` and `Bash(rm *)` and how a deny takes precedence over a matching allow
- When `acceptEdits` is the right choice for semi-autonomous work versus when `bypassPermissions` is unsafe outside a fully sandboxed environment

## Why

Claude Code can run shell commands, edit files, and push to remotes — all without a second prompt when you give it broad trust. That power is exactly what makes permission modes worth understanding. A well-configured permissions file lets you say "run tests freely, but never delete files," turning an open-ended assistant into a predictable collaborator you can leave running in CI. Learning the hierarchy also means you can set a personal default in your user settings and override it per project without touching either file's rules unexpectedly.

## Walkthrough

### The four modes

Claude Code ships with four named permission modes. Each one decides which tool calls need an interactive approval prompt and which do not.

| Mode | What it does | Safe when |
|---|---|---|
| `default` | Claude asks before every write, shell command, or network call | You want full visibility; standard interactive use |
| `acceptEdits` | File edits are auto-accepted; shell commands still prompt unless explicitly allowed | Trusted project with a curated allow list; light CI automation |
| `plan` | Claude proposes a plan and waits for approval before any action | High-stakes changes; learning or review scenarios |
| `bypassPermissions` | All prompts are suppressed; every tool call proceeds immediately | Fully sandboxed environments only — containers with no external access |

`bypassPermissions` is not a shortcut for convenience. It is specifically designed for environments where external damage is impossible — a throwaway Docker container, a disposable VM, or a purpose-built CI runner with no secrets and no persistent storage. Using it on a developer workstation removes every safety net.

### The settings hierarchy

Claude Code loads settings from four sources, each narrower scope overriding a broader one:

```
enterprise  (managed policy, read-only)
  └─ project  (.claude/settings.json inside the repo)
       └─ user  (~/.claude/settings.json on the local machine)
            └─ session  (--permission-mode flag at launch)
```

A rule at the enterprise layer cannot be overridden by any lower layer. A project rule overrides the user default for everyone who checks out that repo. A session flag (`--permission-mode acceptEdits`) applies only for that single invocation and does not persist. That distinction — flag vs file — matters in Task f below.

Project-committed settings go in `.claude/settings.json` (shared with the team). Settings you do not want committed go in `.claude/settings.local.json` (git-ignored by convention). Both files live inside the project root, so they apply only when Claude is launched from that directory.

### Allow and deny rules

Inside a `permissions` object you write two arrays:

```json
{
  "permissions": {
    "allow": ["Bash(npm test)", "Bash(npm ci)", "Read", "Edit", "Write"],
    "deny":  ["Bash(rm -rf *)", "Bash(git push*)"]
  }
}
```

Rules use the pattern `ToolName(argument-glob)`. The tool name matches the name Claude Code uses internally — `Bash`, `Read`, `Edit`, `Write`, `WebFetch`, and so on. When no parenthetical is given (`"Read"`) the rule applies to every call of that tool regardless of arguments.

**Precedence:** a `deny` rule always wins over a matching `allow`. If `Bash(npm *)` is in `allow` and `Bash(npm run deploy)` is in `deny`, running `npm run deploy` will be blocked even though the allow pattern would otherwise match. This makes it safe to write broad allows with targeted carve-outs.

**Wildcards:** the glob `*` matches any sequence of characters within a single argument segment. `Bash(rm *)` blocks any `rm` invocation. `Bash(npm *)` allows any npm subcommand. The colon shorthand `Bash:*` is equivalent to `Bash(*)` and allows every Bash call — use it only when you trust every possible shell command Claude might generate.

### The mode flag vs the settings file

`--permission-mode acceptEdits` sets the mode for that launch and is gone when the session ends. Adding `"permissionMode": "acceptEdits"` to a settings file persists it for every future launch in that scope. The two mechanisms compose: if your settings file sets `plan` mode but you launch with `--permission-mode acceptEdits`, the flag wins for that session.

## Check

```bash
./scripts/doctor.sh 009
```

Expected output: `OK lab 009 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before opening Claude, write down the four permission modes by name and, next to each, one word describing the trust level it implies. Keep the note beside you as a reference.

   Verify the Quips project is present:

   ```bash
   [[ -d quips ]] && echo "quips present" || echo "quips missing — complete earlier labs first"
   ```

   Expected: `quips present`

2. **Run** — open Claude Code inside the Quips project and identify the current permission mode.

   ```bash
   cd quips && claude
   ```

   Inside the REPL, type `/help` and look for the mode indicator in the footer or help output. Identify which of the four modes is active.

   Verify:

   ```bash
   echo "current mode identified"
   ```

   Expected: exits 0; you have written down the mode name.

3. **Investigate** — read the settings documentation to understand the hierarchy.

   Reference: https://docs.claude.com/en/docs/claude-code/settings

   Answer in your notes: *Which mode would you pick for a CI pipeline that runs tests but must never push to git?*

   A good answer: `acceptEdits` with `Bash(git push*)` in the deny list. The pipeline auto-applies file changes but cannot reach the remote.

   Verify:

   ```bash
   echo "hierarchy understood"
   ```

   Expected: exits 0.

4. **Modify** — create the permissions file inside the Quips project.

   ```bash
   mkdir -p quips/.claude
   ```

   Create `quips/.claude/settings.local.json`:

   ```json
   {
     "permissions": {
       "allow": ["Bash(npm test)", "Bash(npm ci)", "Bash(npm run *)", "Read", "Edit", "Write"],
       "deny":  ["Bash(rm -rf *)", "Bash(rm -r *)", "Bash(git push*)"]
     }
   }
   ```

   Verify the file parses as valid JSON:

   ```bash
   python3 -c "import json,sys; json.load(open(sys.argv[1]))" quips/.claude/settings.local.json && echo "valid JSON"
   ```

   Expected: `valid JSON`

5. **Make** — re-enter the REPL from `quips/` and ask Claude to attempt a `git push`. Observe that Claude declines or surfaces a permission warning rather than executing the push.

   ```bash
   cd quips && claude
   ```

   In the REPL, send:

   > Please run git push for me.

   Verify the file was created and the verify script passes:

   ```bash
   ./scripts/verify.sh 009
   ```

   Expected: exits 0 with no error output.

## Observe

When would you prefer a deny list over an allow list? Write one sentence. Consider: a deny list fits best when the space of safe commands is large and mostly open-ended, and you only need to block a small number of dangerous operations.

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| Permissions file ignored | Wrong path; file must be at `.claude/settings.local.json` inside the project root | Move the file and confirm with `ls quips/.claude/` | https://docs.claude.com/en/docs/claude-code/settings |
| JSON parse error on launch | Trailing commas or curly-quote characters in the file | Validate with `python3 -m json.tool quips/.claude/settings.local.json` and fix the reported line | https://docs.claude.com/en/docs/claude-code/settings |
| Claude still prompts on allowed commands | Mode is `default`; the allow list alone does not suppress prompts | Add `"permissionMode": "acceptEdits"` to the settings file, or launch with `claude --permission-mode acceptEdits` | https://docs.claude.com/en/docs/claude-code/settings |

## Tasks

Click the checkbox next to each task to mark it done — your progress is saved locally.

### Task 1 — Set project-local permissions

**Scenario:** Your team uses `quips/` for a shared project. You want Claude to run `npm test` without prompting but never to execute `rm -rf` under any circumstance.

**Hint:** The file is `quips/.claude/settings.local.json`; both `allow` and `deny` live inside a `"permissions"` key.

??? success "Solution"

    ```bash
    mkdir -p quips/.claude
    cat > quips/.claude/settings.local.json <<'EOF'
    {
      "permissions": {
        "allow": ["Bash(npm test)", "Bash(npm ci)", "Read", "Edit", "Write"],
        "deny":  ["Bash(rm -rf *)", "Bash(rm -r *)"]
      }
    }
    EOF
    python3 -m json.tool quips/.claude/settings.local.json > /dev/null && echo "valid"
    ```

### Task 2 — Flip to acceptEdits and observe auto-apply

**Scenario:** You want file edits accepted automatically so Claude can iterate on code without interrupting you on every write.

**Hint:** Add `"permissionMode": "acceptEdits"` to the settings file, or use the `--permission-mode` flag at launch.

??? success "Solution"

    ```bash
    # Option 1: persist it in the settings file
    python3 - <<'PY'
    import json, pathlib
    p = pathlib.Path("quips/.claude/settings.local.json")
    data = json.loads(p.read_text())
    data["permissionMode"] = "acceptEdits"
    p.write_text(json.dumps(data, indent=2))
    print("updated")
    PY

    # Option 2: one-off session flag (does not persist)
    # claude --permission-mode acceptEdits
    ```

    With `acceptEdits` active, Claude applies `Edit` and `Write` calls immediately; shell commands not in the allow list still produce a prompt.

### Task 3 — Attempt rm from Claude and observe deny

**Scenario:** A junior teammate accidentally prompts Claude to clean up temp files with `rm -rf tmp/`. You want to confirm the deny rule blocks it.

**Hint:** Ask Claude inside the REPL to remove a directory; watch the output rather than the filesystem.

??? success "Solution"

    ```bash
    # From inside quips/, start Claude with the settings file active:
    # claude
    # Then send the prompt:
    #   Please run: rm -rf tmp/
    #
    # Expected: Claude surfaces a permission denied message or declines outright.
    # Verify the directory was not deleted:
    ls quips/ | grep -v "^$" && echo "directory intact"
    ```

    The `deny` rule `Bash(rm -rf *)` matches before the Bash tool is invoked, so no shell process is ever spawned.

### Task 4 — Layer a user-global rule and observe merge

**Scenario:** You want a personal rule — say, always allowing `Bash(cat *)` — to apply across every project without adding it to each repo's settings file.

**Hint:** The user-global settings file lives at `~/.claude/settings.json`; lower-scope rules merge with it rather than replace it.

??? success "Solution"

    ```bash
    # Read the current user settings (create if absent)
    USER_SETTINGS=~/.claude/settings.json
    python3 - <<'PY'
    import json, pathlib, os
    p = pathlib.Path(os.path.expanduser("~/.claude/settings.json"))
    data = json.loads(p.read_text()) if p.exists() else {}
    perms = data.setdefault("permissions", {})
    allow = perms.setdefault("allow", [])
    if "Bash(cat *)" not in allow:
        allow.append("Bash(cat *)")
    p.write_text(json.dumps(data, indent=2))
    print("user settings updated")
    PY

    # Now launch Claude from quips/. Both the user-global allow
    # and the project deny list are active simultaneously.
    # Project deny rules still override the user allow for matching patterns.
    ```

### Task 5 — Test plan mode combined with strict permissions

**Scenario:** You want Claude to propose all changes before touching files, AND you want the deny list enforced so Claude cannot even plan a `git push` as an approved step.

**Hint:** Combine `"permissionMode": "plan"` in the settings file with the existing deny rules.

??? success "Solution"

    ```bash
    python3 - <<'PY'
    import json, pathlib
    p = pathlib.Path("quips/.claude/settings.local.json")
    data = json.loads(p.read_text())
    data["permissionMode"] = "plan"
    p.write_text(json.dumps(data, indent=2))
    print("mode set to plan")
    PY

    # Inside the REPL, prompt:
    #   Refactor db.js and then push the result to origin main.
    #
    # Expected: Claude produces a plan that stops before git push,
    # and when you inspect the plan steps, the push step is absent
    # or marked as blocked by the deny rule.
    ```

### Task 6 — Observe the difference between --permission-mode flag and settings file

**Scenario:** A colleague says "just use `--permission-mode bypassPermissions`" to skip all prompts. You want to understand why the flag differs from a settings file entry, and why `bypassPermissions` is not the default answer.

**Hint:** The flag applies only to that session; the settings file persists. Run both forms and compare what remains after the session ends.

??? success "Solution"

    ```bash
    # Flag form — applies only while this process runs
    claude --permission-mode acceptEdits -p "list the files in src/"
    # After it exits, the mode reverts to whatever settings.local.json says.

    # File form — persists across sessions
    python3 - <<'PY'
    import json, pathlib
    p = pathlib.Path("quips/.claude/settings.local.json")
    data = json.loads(p.read_text())
    print("Current permissionMode:", data.get("permissionMode", "(not set — inherits default)"))
    PY

    # bypassPermissions: only safe in containers with no secrets,
    # no network access to production, and ephemeral storage.
    # On a developer workstation it removes every safeguard.
    ```

## Quiz

<div class="ccg-quiz" data-lab="009">
  <div class="ccg-q" data-answer="c">
    <p><strong>Q1.</strong> Which settings scope takes highest precedence when Claude Code loads its configuration?</p>
    <label><input type="radio" name="009-q1" value="a"> A. User (~/.claude/settings.json)</label>
    <label><input type="radio" name="009-q1" value="b"> B. Project (.claude/settings.json inside the repo)</label>
    <label><input type="radio" name="009-q1" value="c"> C. Enterprise (managed policy layer)</label>
    <label><input type="radio" name="009-q1" value="d"> D. Session (--permission-mode flag)</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">The hierarchy is enterprise &gt; project &gt; user &gt; session. Enterprise is the outermost, read-only layer set by an organization's IT policy; no user or project setting can override it. The session flag is the narrowest scope and applies only for that single invocation.</p>
  </div>
  <div class="ccg-q" data-answer="b">
    <p><strong>Q2.</strong> In <code>acceptEdits</code> mode, which category of tool call is still subject to an interactive approval prompt?</p>
    <label><input type="radio" name="009-q2" value="a"> A. <code>Read</code> calls</label>
    <label><input type="radio" name="009-q2" value="b"> B. <code>Bash</code> calls not covered by an allow rule</label>
    <label><input type="radio" name="009-q2" value="c"> C. <code>Edit</code> and <code>Write</code> calls</label>
    <label><input type="radio" name="009-q2" value="d"> D. All tool calls are auto-accepted in this mode</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain"><code>acceptEdits</code> auto-accepts file edits (<code>Edit</code>, <code>Write</code>) but does not suppress shell command prompts. A <code>Bash</code> invocation that is not covered by an explicit <code>allow</code> rule will still pause and ask. That is precisely what makes <code>acceptEdits</code> safer than <code>bypassPermissions</code> for everyday use.</p>
  </div>
  <div class="ccg-q" data-answer="d">
    <p><strong>Q3.</strong> You have <code>Bash(npm *)</code> in the <code>allow</code> array and <code>Bash(npm run deploy)</code> in the <code>deny</code> array. What happens when Claude tries to run <code>npm run deploy</code>?</p>
    <label><input type="radio" name="009-q3" value="a"> A. The allow rule wins because it was declared first</label>
    <label><input type="radio" name="009-q3" value="b"> B. Claude asks for confirmation because there is a conflict</label>
    <label><input type="radio" name="009-q3" value="c"> C. The more specific allow pattern wins over the broader deny</label>
    <label><input type="radio" name="009-q3" value="d"> D. The deny rule wins — deny always takes precedence over allow</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">In Claude Code's permissions model a <code>deny</code> rule always overrides a matching <code>allow</code>, regardless of declaration order or specificity. This makes it safe to write a broad allow with targeted carve-outs: you can allow <code>Bash(npm *)</code> while still blocking individual dangerous commands with deny entries.</p>
  </div>
  <div class="ccg-q" data-answer="a">
    <p><strong>Q4.</strong> A teammate suggests using <code>bypassPermissions</code> on their laptop to avoid permission prompts during development. What is the primary reason this is not the right choice?</p>
    <label><input type="radio" name="009-q4" value="a"> A. It removes every safeguard on a machine that has real secrets, files, and network access</label>
    <label><input type="radio" name="009-q4" value="b"> B. It is slower than <code>acceptEdits</code> because it performs extra validation</label>
    <label><input type="radio" name="009-q4" value="c"> C. It is not supported outside of enterprise accounts</label>
    <label><input type="radio" name="009-q4" value="d"> D. It requires a separate API key scoped to bypass mode</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain"><code>bypassPermissions</code> is designed for fully sandboxed environments — throwaway containers, ephemeral CI runners with no production secrets — where external damage is impossible. On a developer laptop with credentials, production configs, and persistent storage, bypassing all permissions means a mistaken prompt could delete files or push to remotes with no warning. <code>acceptEdits</code> with a deny list is the right tool for comfortable-but-safe local development.</p>
  </div>
</div>

## Stretch (optional, ~10 min)

Add a wildcard deny for every `Bash` call that touches the `.git` directory — `Bash(git *)` — and then try asking Claude to commit a file. Note what happens. Then relax it to deny only `Bash(git push*)` and `Bash(git reset --hard*)` so commits are allowed but destructive git operations are not.

## Recall

What artifact did Lab 008 produce, and what was its purpose?

> Expected from Lab 008: a `plan-transcript.md` capturing Claude's proposed plan before execution — useful because it lets you review and reject a plan before any files are changed.

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/settings
- https://docs.claude.com/en/docs/claude-code/iam
- https://github.com/anthropics/claude-code

## Next

→ **Lab 010 — Multi-File Edits** — direct Claude to make coordinated changes across several files in a single session.
