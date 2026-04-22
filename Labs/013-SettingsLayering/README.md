# Lab 013 — Settings Layering

⏱ **20 min**   📦 **You'll add**: `Labs/013-SettingsLayering/observations.md` describing which layer won in each experiment   🔗 **Builds on**: Lab 012   🎯 **Success**: `observations.md exists, non-empty, mentions all three scopes: user, project, local (case-insensitive)`

<!--
  Template contract - do not remove this comment.
  CI (lint-prose + structure linter) enforces:
    1. Header line above (one line, five fields, in this exact order)
    2. Nine sections below (in this exact order, same H2 titles)
    3. Single new concept (a "Concept:" Bloom-tagged line)
    4. Every Do step ends with a verify COMMAND, not a screenshot
  See CONTRIBUTING.md and docs/DESIGN.md §7 for the full author contract.
-->

**Concept**: `User vs project vs local settings precedence` (Bloom: Analyze)

---

## Why

Claude Code reads settings from three scopes — user, project, and local — and merges them in a defined order. When two scopes set the same key, one wins silently. Knowing the precedence order means you can predict Claude's behaviour before running it, and design team configs that stay safe even when individuals override them locally.

## Check

```bash
./scripts/doctor.sh 013
```

Expected output: `OK lab 013 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before reading any docs, write down your prediction: if `~/.claude/settings.json` and `quips/.claude/settings.json` both set `permissionMode`, which file wins?

   Verify:
   ```bash
   [[ -d quips ]]
   ```
   Expected: exits 0 (the Quips project exists from earlier labs).

2. **Run** — read the official settings documentation to learn the full precedence chain.

   Reference: https://docs.claude.com/en/docs/claude-code/settings

   The precedence order from highest to lowest is:
   **enterprise → CLI flag → local (`settings.local.json`) → project (`settings.json`) → user (`~/.claude/settings.json`)**

   Verify: you can recite all five levels from memory before moving on.

   ```bash
   echo "precedence order memorised"
   ```
   Expected: exits 0.

3. **Investigate** — inspect the real settings files on this machine.

   ```bash
   cat ~/.claude/settings.json 2>/dev/null | head -20
   ```

   ```bash
   cat quips/.claude/settings.local.json 2>/dev/null || echo "(file does not exist yet)"
   ```

   Note which files exist and what keys they contain.

   Verify: you can state which files are present (or absent) and name at least one key from each that does exist.

   ```bash
   echo "settings files inspected"
   ```
   Expected: exits 0.

4. **Modify** — set the same key at two different scopes and observe which wins.

   Choose the key `permissions.allow`. In user scope (`~/.claude/settings.json`) add or update:

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

   Start a fresh Claude session from inside `quips/` and run `/permissions`. Observe which allow-list is active.

   ```bash
   python3 -m json.tool ~/.claude/settings.json >/dev/null && \
   python3 -m json.tool quips/.claude/settings.json >/dev/null && \
   echo "both files are valid JSON"
   ```
   Expected: `both files are valid JSON`.

5. **Make** — write `Labs/013-SettingsLayering/observations.md` documenting what you found. Include three sections — **User scope**, **Project scope**, **Local scope** — each stating what you set and which layer won.

   Verify:
   ```bash
   ./scripts/verify.sh 013
   ```
   Expected: exits 0 with no error output.

## Observe

A team checks in `settings.json` (project scope) so every contributor shares the same baseline permissions, but keeps `settings.local.json` out of version control so individual overrides — personal API keys, local-only allow-list tweaks — never accidentally land in the shared repo.

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| Can't find user settings file | `~/.claude/settings.json` may not exist yet | Create it: `echo '{}' > ~/.claude/settings.json` — it is safe to create from scratch | https://docs.claude.com/en/docs/claude-code/settings |
| Changes not taking effect | Claude caches settings on session start | Exit the current REPL and restart with a fresh `claude` invocation | https://docs.claude.com/en/docs/claude-code/settings |
| Unsure which scope is active | No visible indicator in normal output | Run `/permissions` or `/settings` inside the REPL — Claude prints the merged effective config and its source scope | https://docs.claude.com/en/docs/claude-code/settings |

## Stretch (optional, ~10 min)

If your organisation uses Claude for Enterprise, add an enterprise-level policy and observe that it overrides every other scope — even a CLI flag. If enterprise is unavailable, write a paragraph in `observations.md` describing what an enterprise policy would override and why that matters for compliance-driven teams.

## Recall

What lab created `quips/.claude/settings.local.json` and why?

> Lab 009 created `quips/.claude/settings.local.json` to gate Bash commands — defining an explicit allow/deny list so Claude could not run destructive shell operations without permission.

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/settings
- https://docs.claude.com/en/docs/claude-code/iam

## Next

→ **Lab 014 — Compaction** — understand how Claude manages context window limits and triggers compaction to keep long sessions coherent.
