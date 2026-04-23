# Lab 013 — Settings Layering

⏱ **20 min**   📦 **You'll add**: `Labs/013-SettingsLayering/observations.md` that mentions all three scopes: user, project, local   🔗 **Builds on**: Lab 012   🎯 **Success**: `observations.md exists, non-empty, mentions all three scopes: user, project, local (case-insensitive)`

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
    - You will learn the five-level settings precedence chain and be able to recite it from memory.
    - You will set the same key at two different scopes, observe which one wins, and record why.
    - You will understand why `settings.json` belongs in version control but `settings.local.json` does not.
    - By the end you will have an `observations.md` that captures which scope won in your live experiment.

**Concept**: `Settings precedence: enterprise → CLI flag → local → project → user` (Bloom: Analyze)

---

## Prerequisites

- Lab 012 complete — `quips/` submodule is present and `@` mentions work
- `claude --version` exits 0 and `~/.claude/settings.json` exists (or you can create it)
- Basic familiarity with JSON syntax

## What You Will Learn

- The full five-level precedence chain Claude Code uses when merging settings
- Which scope wins when two files set the same key — and why
- Why `settings.local.json` exists as a separate file rather than just overwriting `settings.json`
- How to inspect the effective merged config from inside the REPL with `/permissions`
- Why teams check in `settings.json` but `.gitignore` `settings.local.json`

## Why

Claude Code reads settings from up to five sources and merges them silently. When something behaves unexpectedly — a tool that should be allowed is blocked, a model you set globally is ignored — the root cause is almost always a higher-priority scope overriding a lower one without you noticing. Understanding the precedence order lets you predict Claude's behaviour before you run anything, design team configs that stay safe even when individuals fiddle locally, and debug surprises in under a minute rather than staring at config files wondering which one "won."

## Walkthrough

### The five-level precedence chain

Claude Code evaluates settings from highest priority to lowest:

| Priority | Scope | File / mechanism | Who controls it |
|---|---|---|---|
| 1 (highest) | Enterprise | Centrally managed policy | IT / platform team |
| 2 | CLI flag | `--permission-mode` etc. at invocation time | The person running the command |
| 3 | Local | `<project>/.claude/settings.local.json` | Individual developer (not committed) |
| 4 | Project | `<project>/.claude/settings.json` | Team (committed to the repo) |
| 5 (lowest) | User | `~/.claude/settings.json` | Individual (global across all projects) |

When two scopes set the same key, the **higher-priority scope wins entirely** for that key. There is no deep-merging of arrays: if both user scope and project scope set `permissions.allow`, Claude uses the project-scope list and ignores the user-scope list.

### Why the split between project and local?

`settings.json` is committed to the repo so every contributor gets the same baseline: the same allowed tools, the same default model, the same permission mode. `settings.local.json` is in `.gitignore` by convention (Claude Code creates a `.gitignore` entry automatically) so personal tweaks — a local API key, a wider allow-list you need for your workflow, a debug flag — never land in the shared repo. The design is deliberate: shared defaults committed, personal overrides private.

### Inspecting the effective config

From inside the REPL, `/permissions` prints the merged effective permission list and annotates which scope each entry came from. This is the fastest way to answer "which scope is actually controlling this right now?"

```
/permissions
# prints: effective allow/deny list with source scope labels
```

### A concrete example

Suppose user scope sets:

```json
{ "permissions": { "allow": ["Read"] } }
```

And project scope sets:

```json
{ "permissions": { "allow": ["Read", "Edit", "Bash(npm test)"] } }
```

When you start a session from inside that project, the project-scope list wins. Claude will allow `Read`, `Edit`, and `Bash(npm test)` — not just `Read`. If you want personal overrides on top of the project list, put them in `settings.local.json` at priority 3.

## Check

```bash
./scripts/doctor.sh 013
```

Expected output: `OK lab 013 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before reading any docs, write down your prediction: if `~/.claude/settings.json` and `quips/.claude/settings.json` both set `permissions.allow`, which file wins?

   Verify the quips directory exists:

   ```bash
   [[ -d quips ]] && echo "quips present" || echo "missing — run: git submodule update --init quips"
   ```

   Expected: `quips present`

2. **Run** — read the official settings documentation to learn the full precedence chain.

   Reference: https://docs.claude.com/en/docs/claude-code/settings

   The precedence order from highest to lowest is:
   **enterprise → CLI flag → local (`settings.local.json`) → project (`settings.json`) → user (`~/.claude/settings.json`)**

   Verify you can recite all five levels from memory before moving on:

   ```bash
   echo "five levels memorised: enterprise, cli-flag, local, project, user"
   ```

   Expected: exits 0.

3. **Investigate** — inspect the real settings files present on this machine.

   ```bash
   python3 -m json.tool ~/.claude/settings.json 2>/dev/null | head -20 || echo "(user settings missing or invalid)"
   ```

   ```bash
   python3 -m json.tool quips/.claude/settings.json 2>/dev/null | head -20 || echo "(project settings does not exist yet)"
   ```

   ```bash
   python3 -m json.tool quips/.claude/settings.local.json 2>/dev/null | head -20 || echo "(local settings does not exist yet)"
   ```

   Note which files exist and what keys they contain. This is your baseline before you modify anything.

   ```bash
   echo "settings files inspected"
   ```

   Expected: exits 0.

4. **Modify** — set the same key at two different scopes and observe which wins.

   In user scope (`~/.claude/settings.json`) add or update `permissions.allow` to contain only `Read`:

   ```json
   {
     "permissions": {
       "allow": ["Read"]
     }
   }
   ```

   In project scope (`quips/.claude/settings.json`, **not** `settings.local.json`) create:

   ```json
   {
     "permissions": {
       "allow": ["Read", "Edit", "Bash(npm test)"]
     }
   }
   ```

   Verify both files are valid JSON:

   ```bash
   python3 -m json.tool ~/.claude/settings.json >/dev/null && \
   python3 -m json.tool quips/.claude/settings.json >/dev/null && \
   echo "both files are valid JSON"
   ```

   Expected: `both files are valid JSON`

   Start a fresh Claude session from inside `quips/` and run `/permissions`. The effective allow-list should show `Read`, `Edit`, and `Bash(npm test)` — project scope wins.

5. **Make** — write `Labs/013-SettingsLayering/observations.md` documenting what you found. Include three sections: **User scope**, **Project scope**, **Local scope** — each stating what you set and which layer won.

   ```bash
   ./scripts/verify.sh 013
   ```

   Expected: exits 0 with no error output.

## Observe

A team checks in `settings.json` (project scope) so every contributor shares the same baseline permissions, but keeps `settings.local.json` out of version control so individual overrides — personal API keys, local-only allow-list tweaks — never accidentally land in the shared repo. The layering design enforces this separation structurally: shared defaults at no extra cost, private overrides without coordination overhead.

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| Can't find user settings file | `~/.claude/settings.json` may not exist yet | Create it: `echo '{}' > ~/.claude/settings.json` — it is safe to create from scratch | https://docs.claude.com/en/docs/claude-code/settings |
| Changes not taking effect | Claude caches settings on session start | Exit the current REPL and restart with a fresh `claude` invocation | https://docs.claude.com/en/docs/claude-code/settings |
| Unsure which scope is active | No visible indicator in normal output | Run `/permissions` inside the REPL — Claude prints the merged effective config annotated with its source scope | https://docs.claude.com/en/docs/claude-code/settings |
| `settings.local.json` keeps getting committed | `.gitignore` entry missing | Claude Code adds it automatically; check with `grep settings.local quips/.claude/.gitignore` and add manually if absent | https://docs.claude.com/en/docs/claude-code/settings |

## Tasks

Click the checkbox next to each task to mark it done — your progress is saved locally.

### Task 1 — Recite the five-level precedence chain

**Scenario:** A new teammate asks why their local permission override is being ignored. You need to explain which scope wins and why.

**Hint:** The chain runs from highest to lowest priority. The key insight is that higher-priority scopes win entirely for any key they set — there is no partial merge.

??? success "Solution"

    Highest to lowest:

    1. Enterprise policy (centrally managed, overrides everything)
    2. CLI flag (passed at invocation time, e.g. `--permission-mode`)
    3. Local (`quips/.claude/settings.local.json` — not committed)
    4. Project (`quips/.claude/settings.json` — committed)
    5. User (`~/.claude/settings.json` — global personal defaults)

    If a colleague's local file sets `permissions.allow`, that takes precedence over the project file. If they want the project defaults, they should delete the key from their local file — not fight the project file.

### Task 2 — Verify which scope is active from inside the REPL

**Scenario:** You have modified both `~/.claude/settings.json` and `quips/.claude/settings.json`. You want to confirm which allow-list Claude is actually using without restarting.

**Hint:** There is a REPL slash command that prints the effective merged configuration and labels each entry with its source scope.

??? success "Solution"

    ```bash
    cd quips && claude
    # Inside the REPL:
    /permissions
    # Output: effective allow/deny list with scope labels (user, project, local, etc.)
    ```

    The output shows which scope contributed each permission entry. If the project scope is contributing `Edit` and the user scope has no `Edit`, the project file is the source.

### Task 3 — Add a local override that adds a tool the project scope does not allow

**Scenario:** The `quips` project's `settings.json` only allows `Read`, `Edit`, and `Bash(npm test)`. You are doing local profiling work and need to also allow `Bash(node --prof)` — but you must not commit that change to the shared repo.

**Hint:** Local scope (`settings.local.json`) sits above project scope in the precedence chain. Use it for personal additions that should not affect teammates.

??? success "Solution"

    Create or edit `quips/.claude/settings.local.json`:

    ```json
    {
      "permissions": {
        "allow": ["Read", "Edit", "Bash(npm test)", "Bash(node --prof)"]
      }
    }
    ```

    Verify it is valid JSON and confirm `.gitignore` covers it:

    ```bash
    python3 -m json.tool quips/.claude/settings.local.json >/dev/null && echo "valid JSON"
    grep -r 'settings.local' quips/.claude/ 2>/dev/null || echo "(no gitignore entry — add one)"
    ```

    From the REPL, run `/permissions` — the local allow-list is now the effective one since local scope outranks project scope.

### Task 4 — Explain why `settings.local.json` is not committed

**Scenario:** A junior developer on the Quips team asks: "Why do we have both `settings.json` and `settings.local.json`? Can't I just edit `settings.json` directly for my personal stuff?"

**Hint:** Think about what happens when that developer's change lands in the shared repo and every other contributor pulls it.

??? success "Solution"

    `settings.json` is committed so every contributor shares the same baseline: allowed tools, default model, permission mode. If a developer edits it directly for personal needs and commits that change, every teammate now inherits their personal preferences — potentially widening permissions or changing models for the entire team.

    `settings.local.json` is in `.gitignore` by design. Personal tweaks stay local. The team baseline remains stable.

    Verify the gitignore entry:

    ```bash
    cat quips/.gitignore 2>/dev/null | grep -i 'local' || echo "(check .claude/.gitignore too)"
    cat quips/.claude/.gitignore 2>/dev/null | grep -i 'local' || echo "(no local ignore entry found)"
    ```

### Task 5 — Reset the experiment and restore original settings

**Scenario:** You have finished the experiment. You want to clean up the settings you modified so you do not accidentally affect later labs.

**Hint:** Remove the `permissions.allow` keys you added from user scope and project scope, or restore the files to their pre-lab state.

??? success "Solution"

    Remove the permissions key from user settings (preserve other keys):

    ```bash
    python3 -c "
    import json, os
    path = os.path.expanduser('~/.claude/settings.json')
    with open(path) as f:
        d = json.load(f)
    d.get('permissions', {}).pop('allow', None)
    if not d.get('permissions'):
        d.pop('permissions', None)
    print(json.dumps(d, indent=2))
    " > /tmp/settings_clean.json && mv /tmp/settings_clean.json ~/.claude/settings.json
    echo "user settings cleaned"
    ```

    Reset the project settings to an empty object:

    ```bash
    echo '{}' > quips/.claude/settings.json
    python3 -m json.tool quips/.claude/settings.json >/dev/null && echo "project settings reset"
    ```

    Remove the local override if you created one:

    ```bash
    rm -f quips/.claude/settings.local.json && echo "local settings removed"
    ```

### Task 6 — Map the precedence chain to a compliance scenario

**Scenario:** Your organisation deploys Claude for Enterprise with a policy that forbids `Bash` tool use entirely. A developer sets `"allow": ["Bash(rm -rf)"]` in their `settings.local.json`. Does that override the enterprise policy?

**Hint:** Enterprise scope is at priority 1 — the top of the chain.

??? success "Solution"

    No. Enterprise policy sits at priority 1, above local scope at priority 3. The developer's `settings.local.json` entry is ignored for any key the enterprise policy also sets.

    This is the security guarantee enterprises need: a centrally managed policy cannot be circumvented by editing local files or the project file. Even CLI flags (priority 2) are overridden by enterprise policy.

    You can verify the principle without an enterprise environment by substituting the highest scope you do have — observe that local scope overrides project scope but not CLI flags (try `claude --permission-mode default` at priority 2 and confirm it takes precedence over your local file).

## Quiz

<div class="ccg-quiz" data-lab="013">
  <div class="ccg-q" data-answer="b">
    <p><strong>Q1.</strong> You set <code>permissions.allow: ["Read"]</code> in <code>~/.claude/settings.json</code> and <code>permissions.allow: ["Read", "Edit"]</code> in <code>quips/.claude/settings.json</code>. Which allow-list does Claude use when you start a session from inside <code>quips/</code>?</p>
    <label><input type="radio" name="013-q1" value="a"> A. <code>["Read"]</code> — user scope has higher priority than project scope</label>
    <label><input type="radio" name="013-q1" value="b"> B. <code>["Read", "Edit"]</code> — project scope outranks user scope</label>
    <label><input type="radio" name="013-q1" value="c"> C. <code>["Read", "Edit"]</code> — both lists are deep-merged</label>
    <label><input type="radio" name="013-q1" value="d"> D. Claude asks you which one to use at session start</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Project scope (priority 4) outranks user scope (priority 5). The project allow-list wins entirely — Claude does not merge arrays across scopes. The user-scope list is ignored for that key as soon as the project scope sets it.</p>
  </div>
  <div class="ccg-q" data-answer="c">
    <p><strong>Q2.</strong> Why is <code>settings.local.json</code> kept out of version control?</p>
    <label><input type="radio" name="013-q2" value="a"> A. It is a temporary file that Claude deletes after each session</label>
    <label><input type="radio" name="013-q2" value="b"> B. It cannot be parsed by git</label>
    <label><input type="radio" name="013-q2" value="c"> C. It holds personal overrides that should not affect teammates who pull the repo</label>
    <label><input type="radio" name="013-q2" value="d"> D. It contains the user's API key and would expose secrets</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain"><code>settings.local.json</code> is for personal, machine-specific tweaks. Committing it would push your local preferences onto every contributor who pulls, potentially widening permissions or changing model defaults team-wide. The split — project file committed, local file ignored — separates shared defaults from personal choices.</p>
  </div>
  <div class="ccg-q" data-answer="d">
    <p><strong>Q3.</strong> Which scope is the highest priority in the Claude Code settings precedence chain?</p>
    <label><input type="radio" name="013-q3" value="a"> A. User (<code>~/.claude/settings.json</code>)</label>
    <label><input type="radio" name="013-q3" value="b"> B. Local (<code>settings.local.json</code>)</label>
    <label><input type="radio" name="013-q3" value="c"> C. CLI flag (passed at invocation time)</label>
    <label><input type="radio" name="013-q3" value="d"> D. Enterprise policy (centrally managed)</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Enterprise policy sits at the top of the chain — it overrides every other scope, including CLI flags. This is the compliance guarantee: an organisation-wide policy cannot be circumvented by a developer editing their local files or passing a flag on the command line.</p>
  </div>
  <div class="ccg-q" data-answer="a">
    <p><strong>Q4.</strong> You are inside the Claude REPL and want to see which scope is currently controlling your permission list. What is the fastest way?</p>
    <label><input type="radio" name="013-q4" value="a"> A. Run <code>/permissions</code> — it prints the merged effective config with scope labels</label>
    <label><input type="radio" name="013-q4" value="b"> B. Run <code>cat ~/.claude/settings.json</code> — that is always the active config</label>
    <label><input type="radio" name="013-q4" value="c"> C. Exit and restart Claude with <code>--verbose</code> to see which files were loaded</label>
    <label><input type="radio" name="013-q4" value="d"> D. There is no way to inspect the merged config at runtime</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain"><code>/permissions</code> is the built-in REPL command for this. It shows the effective merged permission list and annotates each entry with the scope that contributed it. Reading <code>~/.claude/settings.json</code> only tells you what one scope contains — it does not show the merged result or which scope won.</p>
  </div>
</div>

## Stretch (optional, ~10 min)

If your organisation uses Claude for Enterprise, add an enterprise-level policy that restricts `Bash` tool use and observe that it overrides every other scope — even a CLI flag passed at invocation time. If enterprise is unavailable, write a paragraph in `observations.md` describing what an enterprise policy would override and why that guarantee matters for compliance-driven teams: consider a scenario where a developer's `settings.local.json` tries to allow a sensitive tool that the policy forbids.

## Recall

What lab first introduced `quips/.claude/settings.local.json` and set up an explicit allow/deny list for Bash commands?

> Lab 009 — Permission Modes created `quips/.claude/settings.local.json` to gate Bash commands, defining an explicit allow/deny list so Claude could not run destructive shell operations without explicit permission. That file is still on your machine at local scope (priority 3), ready to be overridden by a CLI flag or enterprise policy.

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/settings
- https://docs.claude.com/en/docs/claude-code/iam

## Next

→ **Lab 014 — Compaction** — understand how Claude manages context window limits and triggers compaction to keep long sessions coherent.
