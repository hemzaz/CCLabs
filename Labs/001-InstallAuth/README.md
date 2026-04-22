# Lab 001 — Install and Auth

⏱ **15 min**   📦 **You'll add**: `claude` CLI on PATH   🔗 **Builds on**: baseline (no prior lab)   🎯 **Success**: `claude --version` prints a version and `claude -p` returns an answer

<!--
  Template contract - do not remove this comment.
  See docs/DESIGN.md §7 and scripts/lint-labs.sh for the author contract.
-->

!!! hint "Overview"
    - You will install Claude Code globally via npm.
    - You will authenticate in one of two ways: Claude Pro/Max login or `ANTHROPIC_API_KEY`.
    - You will run your first headless prompt with `claude -p` and confirm end-to-end connectivity.
    - By the end your terminal will have a working Claude Code that every future lab builds on.

**Concept**: `Install and authenticate Claude Code` (Bloom: Remember)

---

## Prerequisites

- Node.js 20 or newer (`node -v` should print something like `v20.x.x`)
- A working `npm` on PATH
- Either a Claude Pro/Max subscription OR an `ANTHROPIC_API_KEY` from console.anthropic.com

## What You Will Learn

- How Claude Code ships (an npm-distributed CLI) and where it installs
- The two authentication paths and when to pick each
- How to confirm the install with a one-shot headless prompt (`-p`)

## Why

Every other lab assumes a working `claude` on your PATH. Getting install and auth right once means you never wrestle with setup again — you move straight into the actual learning. Future labs also layer on (subagents, skills, hooks, MCP) and each of those relies on a green baseline from here.

## Walkthrough

Claude Code is a Node package you install globally: `npm i -g @anthropic-ai/claude-code`. It's distributed through npm (not Homebrew or a standalone binary) because it updates frequently and npm's global bin mechanism is the most portable path across macOS, Linux, and WSL2.

After install, the `claude` command will be on your PATH but it won't work until it can reach the Anthropic API. There are two ways to authenticate:

| Path | When to use | What you get |
|---|---|---|
| **Claude Pro/Max login** | You have a Pro or Max plan on claude.ai | Usage billed against your plan. Run `claude` and complete the browser flow. |
| **`ANTHROPIC_API_KEY`** | You want per-request billing, or you don't have a Pro/Max plan | Pay-as-you-go. Export the key from your shell rc file. |

You can have both configured; the CLI prefers the API key when it's set. For these labs either works — pick whichever matches your situation.

The fastest sanity check is headless mode (`-p`): you pass a prompt, Claude prints the answer, and it exits. No REPL, no state. That's what we'll use to confirm the setup works.

## Check

```bash
./scripts/doctor.sh 001
```

Expected output: `OK lab 001 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before running, write down what you expect your shell to say when you look for `claude`. Does it exist yet?

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

   Expected: `command -v claude` prints a non-empty path; `claude --version` exits 0 and prints a semver string (e.g. `2.0.1`).

3. **Investigate** — inspect the CLI's top-level help to understand what subcommands are available.

   ```bash
   claude --help | head -20
   ```

   Verify: output contains the word `Usage`.

4. **Modify** — authenticate Claude Code so it can reach the Anthropic API.

   **Option A (Claude Pro/Max plan):** run `claude` inside an interactive terminal and complete the browser `/login` flow when prompted.

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

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| `claude: command not found` | npm global bin directory not on PATH | Run `hash -r` or restart your shell; check `npm config get prefix` and ensure its `bin/` subdirectory is in `$PATH` | https://docs.claude.com/en/docs/claude-code/overview |
| Auth prompt loops (browser never completes) | Stale OAuth token cached locally | Run `claude /logout`, then start the login flow again with `claude /login` | https://github.com/anthropics/claude-code |
| Network/proxy error on `claude -p` | Corporate proxy intercepts TLS | Set `export HTTPS_PROXY=http://your-proxy:port` in your shell before running `claude` | https://docs.claude.com/en/docs/claude-code/overview |

## Tasks

Click the checkbox next to each task to mark it done — your progress is saved locally.

### Task 1 — Check your Node version

**Scenario:** Claude Code requires Node 20 or newer. Before installing, confirm your environment.

**Hint:** `node -v` prints the installed version with a `v` prefix.

??? success "Solution"

    ```bash
    node -v
    # v20.x.x or later; if older, install Node 20+ via nvm or your package manager
    ```

### Task 2 — Find where npm installs global binaries

**Scenario:** When `claude: command not found` happens, the fix starts with knowing where npm puts global binaries on your system.

**Hint:** There's an `npm config get` value that holds the prefix; binaries live at `<prefix>/bin`.

??? success "Solution"

    ```bash
    npm config get prefix
    # e.g. /Users/you/.nvm/versions/node/v20.10.0
    echo "$(npm config get prefix)/bin in \$PATH?"
    echo "$PATH" | tr ':' '\n' | grep "$(npm config get prefix)/bin" && echo yes || echo no
    ```

### Task 3 — Ask Claude about itself

**Scenario:** You want to sanity-check that Claude Code is responsive and aware of what it is.

**Hint:** Use `claude -p "…"` with a simple one-line question.

??? success "Solution"

    ```bash
    claude -p "in one sentence, what are you?"
    # Expect a one-line description mentioning Claude, assistant, or coding.
    ```

### Task 4 — List available slash commands without entering the REPL

**Scenario:** You want to see what `/commands` exist without starting an interactive session.

**Hint:** `claude --help` plus a grep for the word "slash" or checking the docs page; the REPL also shows `/help`.

??? success "Solution"

    ```bash
    claude --help | grep -iE 'slash|command' || echo "not in --help; use /help inside the REPL"
    # Then inside `claude`, type /help and scroll to the commands list.
    ```

### Task 5 — Verify your auth path deliberately

**Scenario:** You authenticated but you're not sure which path is active (browser login vs API key).

**Hint:** Unset `ANTHROPIC_API_KEY` temporarily and retry — if it still works you're on Pro/Max, if it fails you were using the key.

??? success "Solution"

    ```bash
    # save, unset, test, restore
    saved="$ANTHROPIC_API_KEY"
    unset ANTHROPIC_API_KEY
    claude -p "ping" && echo "auth: Pro/Max browser login" || echo "auth: API key (was using key)"
    export ANTHROPIC_API_KEY="$saved"
    ```

### Task 6 — Update to the latest Claude Code

**Scenario:** A new Claude Code version dropped and you want to stay current.

**Hint:** `npm` has a specific command for upgrading an already-installed global package.

??? success "Solution"

    ```bash
    npm i -g @anthropic-ai/claude-code@latest
    claude --version
    ```

## Quiz

<div class="ccg-quiz" data-lab="001">
  <div class="ccg-q" data-answer="b">
    <p><strong>Q1.</strong> Which command installs Claude Code so that <code>claude</code> is globally available on PATH?</p>
    <label><input type="radio" name="001-q1" value="a"> A. <code>npm install @anthropic-ai/claude-code</code></label>
    <label><input type="radio" name="001-q1" value="b"> B. <code>npm i -g @anthropic-ai/claude-code</code></label>
    <label><input type="radio" name="001-q1" value="c"> C. <code>brew install claude</code></label>
    <label><input type="radio" name="001-q1" value="d"> D. <code>pip install claude-code</code></label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">The <code>-g</code> flag tells npm to install globally, placing the binary in npm's global bin directory so it lands on PATH. Without <code>-g</code> the package installs only inside the current project's <code>node_modules</code>.</p>
  </div>
  <div class="ccg-q" data-answer="c">
    <p><strong>Q2.</strong> You see <code>claude: command not found</code> right after a successful <code>npm i -g</code>. What's the most likely cause?</p>
    <label><input type="radio" name="001-q2" value="a"> A. The install silently failed</label>
    <label><input type="radio" name="001-q2" value="b"> B. You need to reinstall Node</label>
    <label><input type="radio" name="001-q2" value="c"> C. npm's global bin directory is not on your PATH</label>
    <label><input type="radio" name="001-q2" value="d"> D. Claude Code doesn't support your OS</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">The install succeeded but your shell can't find the binary because <code>$(npm config get prefix)/bin</code> isn't in PATH. Add that directory to PATH or reinstall Node via a version manager like nvm that wires PATH correctly.</p>
  </div>
  <div class="ccg-q" data-answer="a">
    <p><strong>Q3.</strong> Which flag runs Claude Code in headless (non-interactive, print-and-exit) mode?</p>
    <label><input type="radio" name="001-q3" value="a"> A. <code>-p</code> (or <code>--print</code>)</label>
    <label><input type="radio" name="001-q3" value="b"> B. <code>-h</code></label>
    <label><input type="radio" name="001-q3" value="c"> C. <code>--one-shot</code></label>
    <label><input type="radio" name="001-q3" value="d"> D. <code>--quiet</code></label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Headless mode uses <code>-p</code> (alias: <code>--print</code>). You pass a prompt, Claude prints the response, and the process exits. This is what every CI lab later in the curriculum uses.</p>
  </div>
  <div class="ccg-q" data-answer="b">
    <p><strong>Q4.</strong> If both <code>ANTHROPIC_API_KEY</code> is set AND you've logged in via <code>claude /login</code>, which auth path does the CLI use?</p>
    <label><input type="radio" name="001-q4" value="a"> A. It asks you each time</label>
    <label><input type="radio" name="001-q4" value="b"> B. It prefers the API key</label>
    <label><input type="radio" name="001-q4" value="c"> C. It prefers the browser login</label>
    <label><input type="radio" name="001-q4" value="d"> D. It refuses to start with both configured</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">When <code>ANTHROPIC_API_KEY</code> is set it takes precedence, so usage bills against the key (pay-as-you-go) even if you're also logged in on a Pro/Max plan. Unset the env var to fall back to the browser login path.</p>
  </div>
</div>

## Stretch (optional, ~10 min)

Run the following and save Claude's answer to a note. You'll compare it against future labs as model versions evolve over time:

```bash
claude -p "which Claude model are you using right now? answer in one line."
```

## Recall

First lab — no recall question yet. Come back here after Lab 006 and note how your answer to Task 3's prompt-craft would have changed.

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/overview
- https://github.com/anthropics/claude-code

## Next

→ **Lab 002 — First Session** — your first interactive REPL session with Claude Code.
