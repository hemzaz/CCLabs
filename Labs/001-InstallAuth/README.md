# Lab 001 — Install and Auth

⏱ **10 min**   📦 **You'll add**: `claude` CLI on PATH   🔗 **Builds on**: baseline (no prior lab)   🎯 **Success**: `claude --version` prints a version and `claude -p` returns an answer

<!--
  Template contract - do not remove this comment.
  CI (lint-prose + structure linter) enforces:
    1. Header line above (one line, five fields, in this exact order)
    2. Nine sections below (in this exact order, same H2 titles)
    3. Single new concept (a "Concept:" Bloom-tagged line)
    4. Every Do step ends with a verify COMMAND, not a screenshot
  See CONTRIBUTING.md and docs/DESIGN.md §7 for the full author contract.
-->

**Concept**: `Install and authenticate Claude Code` (Bloom: Remember)

---

## Why

Claude Code is the CLI that makes every subsequent lab possible. Installing it once and confirming it can reach the Anthropic API means all future labs start from a known-good baseline.

## Check

```bash
./scripts/doctor.sh 001
```

Expected output: `OK lab 001 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before running, write down what you expect your shell to say when you look for `claude`. Does it exist yet?

   Verify:
   ```bash
   command -v claude || echo "not installed"
   ```
   Expected: either a filesystem path (if already installed) or the string `not installed`.

2. **Run** — install Claude Code globally via npm.

   ```bash
   npm i -g @anthropic-ai/claude-code
   ```

   Verify:
   ```bash
   command -v claude
   claude --version
   ```
   Expected: `command -v claude` prints a non-empty path; `claude --version` exits 0 and prints a semver string (e.g. `1.2.3`).

3. **Investigate** — inspect the CLI's top-level help to understand what subcommands are available.

   ```bash
   claude --help | head -20
   ```

   Verify: output contains the word `Usage`.

4. **Modify** — authenticate Claude Code so it can reach the Anthropic API.

   **Option A (Claude.ai plan subscriber):** run `claude` inside an interactive terminal and complete the browser `/login` flow when prompted.

   **Option B (API key):** add the following to your shell rc file (`~/.zshrc` or `~/.bashrc`), then reload it:
   ```bash
   export ANTHROPIC_API_KEY=sk-ant-...
   source ~/.zshrc   # or source ~/.bashrc
   ```

   Verify:
   ```bash
   claude -p "say hi in three words"
   ```
   Expected: exits 0 and prints non-empty output (three words from Claude).

5. **Make** — run a one-shot arithmetic prompt to confirm end-to-end functionality.

   ```bash
   claude -p "what is 2+2, just the number"
   ```

   Verify: output contains `4`.

## Observe

Describe what Claude printed at step 5 and whether its answer format surprised you. Did it include any preamble, or just the bare number? Write one paragraph in your own words. No answer key — this is metacognition practice.

## If stuck

Exactly three entries. Each cites a source URL from canonical Anthropic docs.

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| `claude: command not found` | npm global bin directory not on PATH | Run `hash -r` or restart your shell; check `npm config get prefix` and ensure its `bin/` subdirectory is in `$PATH` | https://docs.claude.com/en/docs/claude-code/overview |
| Auth prompt loops (browser never completes) | Stale OAuth token cached locally | Run `claude /logout` then start the login flow again with `claude /login` | https://github.com/anthropics/claude-code |
| Network/proxy error on `claude -p` | Corporate proxy intercepts TLS | Set `export HTTPS_PROXY=http://your-proxy:port` in your shell before running `claude` | https://docs.claude.com/en/docs/claude-code/overview |

## Stretch (optional, ~10 min)

Run the following and save Claude's answer to a note — you will compare it against future labs as model versions evolve:

```bash
claude -p "which Claude model are you using right now? answer in one line."
```

## Recall

First lab — no recall question.

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/overview
- https://github.com/anthropics/claude-code

## Next

→ **Lab 002 — First Session** — your first interactive REPL session with Claude Code.
