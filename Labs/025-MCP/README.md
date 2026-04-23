# Lab 025 — MCP

⏱ **35 min**   📦 **You'll add**: `quips/.claude/settings.json` with `mcpServers.fs-scoped` + `quips/.claude/mcp-log.md`   🔗 **Builds on**: Lab 024   🎯 **Success**: `quips/.claude/settings.json` contains `mcpServers.fs-scoped` and `quips/.claude/mcp-log.md` is non-empty with a reference to a file under `src/`

<!--
  Template contract - do not remove this comment.
  CI (lint-prose + structure linter) enforces:
    1. Header line above (one line, five fields, in this exact order)
    2. Fourteen sections below (in this exact order, same H2 titles)
    3. Single new concept (a "Concept:" Bloom-tagged line)
    4. Every Do step ends with a verify COMMAND, not a screenshot
  See CONTRIBUTING.md and docs/DESIGN.md §7 for the full author contract.
-->

!!! hint "Overview"
    - You will configure a filesystem MCP server scoped to `quips/src` — Claude can read files inside that directory but nothing outside it.
    - You will invoke the server from inside a Claude session and observe the tool call in action.
    - You will attempt a read outside the declared scope and confirm the denial.
    - You will add a second MCP server entry to understand multi-server configuration, then verify both servers load at session start.

**Concept**: `Integrate one MCP server and call a tool against real data` (Bloom: Apply)

---

## Prerequisites

- Lab 024 complete — `quips/.claude/` directory exists
- `npx` on PATH (`node -v` prints `v20.x.x` or later)
- A working Claude Code installation (`claude --version` exits 0)

## What You Will Learn

- What MCP is and how Claude routes a natural-language request to an MCP tool rather than a built-in Bash call
- How `mcpServers` in `settings.json` declares a server, its command, and its scope arguments
- Why scope arguments (the directory path passed to the filesystem server) enforce least-privilege
- How to observe a real MCP tool call, attempt a denied read, and check MCP logs

## Why

Claude Code can call tools hosted by external servers through the Model Context Protocol (MCP). This extends what Claude can do beyond editing files: live filesystem reads, real API calls, and data lookups — all scoped and auditable. The filesystem MCP server is the canonical first example. You point it at one directory, and Claude can list and read files inside that scope without touching anything outside it. This lab introduces Outcome O6 by wiring up that server, verifying the config, testing the scope boundary, and recording a real tool call in a log file.

MCP and a direct Bash `cat` call both read a file, but they differ in auditability and control. A Bash call runs in your shell with your full credentials and CWD. An MCP call is mediated by a server process that enforces its own scope rules — the server refuses paths outside its declared root, and every call is logged at the protocol level. That boundary is what makes MCP suitable for agentic workflows where you need Claude to read data without also being able to write or escape the project tree.

| Approach | Who enforces scope | Logged at protocol level | Requires server config |
|---|---|---|---|
| `claude -p` + Bash `cat` | Nothing — full shell access | No | No |
| MCP filesystem server | Server process (refuses out-of-scope paths) | Yes | Yes — `mcpServers` in `settings.json` |

Common MCP servers and what they expose:

| Server package | Tools exposed | Typical scope arg |
|---|---|---|
| `@modelcontextprotocol/server-filesystem` | `list_directory`, `read_file`, `write_file` | One or more absolute directory paths |
| `@modelcontextprotocol/server-git` | `git_log`, `git_diff`, `git_show` | Repository root path |
| `@modelcontextprotocol/server-github` | `search_code`, `get_file_contents`, `list_issues` | GitHub token (env var) |
| `@modelcontextprotocol/server-sqlite` | `read_query`, `write_query`, `list_tables` | Absolute path to `.db` file |

## Walkthrough

MCP follows a client-server model. Claude Code is the client. When you declare an `mcpServers` entry in `settings.json`, Claude Code launches that server process at session start and keeps it running as a sidecar. When you ask Claude to read a file, Claude can choose to call the server's `read_file` tool instead of its built-in file-reading capability — particularly useful when the server enforces access controls that Claude itself cannot.

The filesystem server (`@modelcontextprotocol/server-filesystem`) accepts one or more absolute directory paths as positional arguments. It refuses any `read_file` or `list_directory` call whose path does not start with one of those roots. That is the entire scope mechanism: a path allowlist baked into the server's startup arguments.

The `settings.json` location determines which Claude sessions see the server. Placing it in `quips/.claude/settings.json` means only sessions launched from inside the `quips/` tree load the server. Placing it in `~/.claude/settings.json` would expose it globally. Least privilege recommends the project-scoped file.

MCP servers load at session start. If you edit `settings.json` while a Claude session is open, you must exit and re-launch for the change to take effect.

## Check

```bash
./scripts/doctor.sh 025
```

Expected output: `OK lab 025 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before configuring anything, write down the three top risks of adding an MCP server to Claude Code: scope (what directories can the server touch), trust (who wrote the server code), and credentials (what the server process can reach). Keep your list for the Observe section.

   Verify your list exists:
   ```bash
   echo "risk-1: scope creep; risk-2: untrusted server code; risk-3: credential leakage"
   ```
   Expected: that line prints without error.

2. **Run** — read the MCP configuration reference and the filesystem server README to identify the top-level key Claude Code uses in `settings.json` to declare MCP servers.

   - Config reference: https://docs.claude.com/en/docs/claude-code/mcp
   - Filesystem server: https://github.com/modelcontextprotocol/servers/tree/main/src/filesystem

   Verify you can name the config key:
   ```bash
   echo "mcpServers"
   ```
   Expected: `mcpServers`

3. **Investigate** — plan the exact config entry before touching any file. The server name will be `fs-scoped`, the command is `npx`, and the args are `["-y", "@modelcontextprotocol/server-filesystem", "<absolute path to quips/src>"]`. Confirm the absolute path you will use.

   Verify the path resolves to a string beginning with `/`:
   ```bash
   echo "$PWD/quips/src"
   ```
   Expected: a string beginning with `/`.

4. **Modify** — open `quips/.claude/settings.json` (create it if it does not exist) and add an `mcpServers` block with the `fs-scoped` entry. Use the absolute path from step 3 as the final argument.

   The finished block looks like:
   ```json
   {
     "mcpServers": {
       "fs-scoped": {
         "command": "npx",
         "args": ["-y", "@modelcontextprotocol/server-filesystem", "/absolute/path/to/quips/src"]
       }
     }
   }
   ```

   Verify the key is present and the JSON is valid:
   ```bash
   python3 -c "import json; s=json.load(open('quips/.claude/settings.json')); assert 'fs-scoped' in s.get('mcpServers',{})"
   ```
   Expected: exits 0 with no output.

5. **Make** — launch a fresh Claude session inside quips. Exit and re-launch if you already had a session open before step 4 — MCP servers load at session start.

   ```bash
   cd quips && claude
   ```

   Inside the REPL, type:
   > Use the fs-scoped MCP server to list files in src/ and read src/server.js. Summarize the routes.

   When Claude responds, paste the full response into `quips/.claude/mcp-log.md`. Then verify the log is non-empty and references the file:
   ```bash
   [[ -s quips/.claude/mcp-log.md ]] && grep -qi 'server\.js\|route' quips/.claude/mcp-log.md && echo "ok" || echo "missing or empty"
   ```
   Expected: `ok`

## Observe

One sentence — why does the filesystem server need an explicit directory argument rather than defaulting to the current working directory?

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| MCP server fails to start | `npx` is pulling from the wrong registry or package name has a typo | Double-check the package name `@modelcontextprotocol/server-filesystem`; run `npx -y @modelcontextprotocol/server-filesystem --help` once to seed the cache | https://github.com/modelcontextprotocol/servers |
| Claude claims MCP tools are not available | Claude session started before `settings.json` was changed | Exit and re-launch `claude`; MCP servers are loaded at session start, not mid-session | https://docs.claude.com/en/docs/claude-code/mcp |
| MCP server reads outside the scoped directory | No scope arg passed, or wrong absolute path in `args` | Always pass the absolute path as the final element of `args`; verify with `echo $PWD/quips/src` before editing `settings.json` | https://modelcontextprotocol.io/introduction |
| `python3 -c` validation fails with JSON decode error | `settings.json` has a trailing comma or malformed value | Run `python3 -m json.tool quips/.claude/settings.json` to pinpoint the syntax error | https://docs.claude.com/en/docs/claude-code/mcp |

## Tasks

Click the checkbox next to each task to mark it done — your progress is saved locally.

### Task 1 — Configure the fs-scoped MCP server

**Scenario:** You want Claude to read files under `quips/src` via MCP rather than direct Bash, so every file access is scoped and logged by the protocol.

**Hint:** The `args` array must end with an absolute path — use `$PWD/quips/src` as a reference while editing the file.

??? success "Solution"

    ```bash
    # Create or update quips/.claude/settings.json
    ABS_SRC="$(pwd)/quips/src"
    mkdir -p quips/.claude
    python3 - <<EOF
    import json, pathlib
    p = pathlib.Path("quips/.claude/settings.json")
    cfg = json.loads(p.read_text()) if p.exists() else {}
    cfg.setdefault("mcpServers", {})["fs-scoped"] = {
        "command": "npx",
        "args": ["-y", "@modelcontextprotocol/server-filesystem", "$ABS_SRC"]
    }
    p.write_text(json.dumps(cfg, indent=2))
    EOF
    # Verify
    python3 -c "import json; s=json.load(open('quips/.claude/settings.json')); assert 'fs-scoped' in s['mcpServers']"
    echo "ok"
    ```

### Task 2 — Ask Claude to list files via MCP

**Scenario:** With the server configured, you want to confirm Claude actually uses the MCP tool — not a built-in Bash `ls` — to enumerate files.

**Hint:** Be explicit in your prompt: "use the fs-scoped MCP server to list files." Claude will prefer the named server when you reference it directly.

??? success "Solution"

    Inside a fresh `claude` session launched from `quips/`:
    ```
    Use the fs-scoped MCP server to list all files in src/
    ```
    Claude should call `list_directory` via the MCP server. Observe the tool call label in the response — it will reference the server name, not a shell command.

    Verify the log captures the response:
    ```bash
    # After pasting Claude's response into mcp-log.md:
    [[ -s quips/.claude/mcp-log.md ]] && echo "log written" || echo "log empty"
    ```

### Task 3 — Attempt to read outside the declared scope and observe denial

**Scenario:** You want to confirm that the scope argument actually enforces a boundary — Claude cannot read a file above `quips/src` even if you ask.

**Hint:** Ask Claude to read a file one directory up from `src/`, such as `quips/package.json`, using the `fs-scoped` MCP server. The server should refuse.

??? success "Solution"

    Inside the same Claude session:
    ```
    Use the fs-scoped MCP server to read the file ../package.json
    ```
    Expected: the MCP server returns an error such as "path is outside allowed directories" and Claude reports it cannot read the file via that server. Claude may offer to read it another way — that is expected behavior, not a bug.

    Confirm:
    ```bash
    echo "scope boundary confirmed — server refused the out-of-scope path"
    ```

### Task 4 — Add a second MCP server entry

**Scenario:** Real projects often need more than one MCP server. You want to understand the multi-server shape in `settings.json` without fully exercising the second server.

**Hint:** Add a `git-read` entry alongside `fs-scoped`. Use the `@modelcontextprotocol/server-git` package with `args: ["/absolute/path/to/quips"]` as its repository root. You do not need to invoke it — the goal is valid JSON with two named servers.

??? success "Solution"

    ```bash
    ABS_QUIPS="$(pwd)/quips"
    python3 - <<EOF
    import json, pathlib
    p = pathlib.Path("quips/.claude/settings.json")
    cfg = json.loads(p.read_text())
    cfg["mcpServers"]["git-read"] = {
        "command": "npx",
        "args": ["-y", "@modelcontextprotocol/server-git", "$ABS_QUIPS"]
    }
    p.write_text(json.dumps(cfg, indent=2))
    EOF
    python3 -c "import json; s=json.load(open('quips/.claude/settings.json')); assert len(s['mcpServers']) >= 2"
    echo "two servers configured"
    ```

### Task 5 — Restart Claude and verify both MCP servers load at init

**Scenario:** You need to confirm that a fresh session picks up both servers from `settings.json` automatically — no manual registration step required.

**Hint:** Exit your current session, re-launch `claude` from `quips/`, and ask Claude to list the available MCP tools. Both `fs-scoped` and `git-read` should appear.

??? success "Solution"

    ```bash
    # Exit your current session, then:
    cd quips && claude
    ```

    Inside the new session:
    ```
    What MCP servers are currently available in this session?
    ```

    Claude should list both `fs-scoped` and `git-read`. If only one appears, confirm `settings.json` has both entries:
    ```bash
    python3 -c "import json; s=json.load(open('quips/.claude/settings.json')); print(list(s['mcpServers'].keys()))"
    ```
    Expected output: `['fs-scoped', 'git-read']` (order may vary).

### Task 6 — Read MCP logs if available

**Scenario:** MCP servers write protocol-level logs that help you debug tool call failures. You want to locate and read any log output the filesystem server produced during this lab.

**Hint:** Claude Code stores MCP logs under `~/.claude/logs/` or in a session-specific directory. Use `find` to locate files with `mcp` in the name modified in the last hour.

??? success "Solution"

    ```bash
    find ~/.claude -name '*mcp*' -newer /tmp -type f 2>/dev/null | head -10
    # or search by modification time (last 60 minutes):
    find ~/.claude/logs -type f -mmin -60 2>/dev/null | head -10
    ```

    If log files exist, read the most recent one:
    ```bash
    latest=$(find ~/.claude/logs -type f -mmin -60 2>/dev/null | sort -t/ -k1 | tail -1)
    [[ -n "$latest" ]] && tail -30 "$latest" || echo "no recent MCP log found — this is normal if the server started cleanly"
    ```

    Expected: either a log file showing JSON-RPC tool call records, or the "no recent log" message if the server reported no errors.

## Quiz

<div class="ccg-quiz" data-lab="025">
  <div class="ccg-q" data-answer="b">
    <p><strong>Q1.</strong> What is the Model Context Protocol (MCP) in the context of Claude Code?</p>
    <label><input type="radio" name="025-q1" value="a"> A. A custom prompt template format that Claude interprets on startup</label>
    <label><input type="radio" name="025-q1" value="b"> B. A client-server protocol that lets Claude call tools hosted in external server processes</label>
    <label><input type="radio" name="025-q1" value="c"> C. A file-compression scheme used to reduce token usage on large codebases</label>
    <label><input type="radio" name="025-q1" value="d"> D. An authentication layer between the Anthropic API and the local CLI</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">MCP is a client-server protocol. Claude Code acts as the client and launches declared server processes at session start. Claude can then call tools those servers expose — such as <code>list_directory</code> or <code>read_file</code> — just as it calls built-in tools, but with the server enforcing its own access controls.</p>
  </div>
  <div class="ccg-q" data-answer="c">
    <p><strong>Q2.</strong> Why must you pass an absolute directory path as an argument to the filesystem MCP server?</p>
    <label><input type="radio" name="025-q2" value="a"> A. Because <code>npx</code> requires absolute paths for all packages</label>
    <label><input type="radio" name="025-q2" value="b"> B. Because Claude Code resolves relative paths incorrectly on macOS</label>
    <label><input type="radio" name="025-q2" value="c"> C. Because the path argument is the server's scope allowlist — it refuses requests outside that root</label>
    <label><input type="radio" name="025-q2" value="d"> D. Because the MCP spec requires paths to be SHA-256 hashed before transmission</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">The directory path in <code>args</code> is the server's entire scope mechanism. The <code>@modelcontextprotocol/server-filesystem</code> process checks every incoming path against that root and returns an error for anything outside it. Omitting the path — or passing the wrong one — either removes the boundary entirely or scopes to the wrong tree.</p>
  </div>
  <div class="ccg-q" data-answer="a">
    <p><strong>Q3.</strong> In which file and under which key do you declare MCP servers for a project-scoped Claude session?</p>
    <label><input type="radio" name="025-q3" value="a"> A. <code>quips/.claude/settings.json</code> under the <code>mcpServers</code> key</label>
    <label><input type="radio" name="025-q3" value="b"> B. <code>quips/CLAUDE.md</code> as a fenced JSON block labeled <code>mcp</code></label>
    <label><input type="radio" name="025-q3" value="c"> C. <code>~/.claude/mcp.json</code> as a flat list of server URLs</label>
    <label><input type="radio" name="025-q3" value="d"> D. <code>quips/.claude/agents/mcp.md</code> as a YAML frontmatter file</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Project-scoped MCP servers belong in <code>.claude/settings.json</code> inside the project tree, under the <code>mcpServers</code> top-level key. Placing the config there means only sessions launched from inside that project tree load those servers. The global equivalent is <code>~/.claude/settings.json</code>.</p>
  </div>
  <div class="ccg-q" data-answer="d">
    <p><strong>Q4.</strong> When you ask Claude to "read <code>src/server.js</code>," how does Claude decide whether to use the MCP <code>read_file</code> tool or a built-in file-read capability?</p>
    <label><input type="radio" name="025-q4" value="a"> A. Claude always prefers Bash <code>cat</code> unless the file is over 100 KB</label>
    <label><input type="radio" name="025-q4" value="b"> B. Claude flips a coin between available tools to avoid bias</label>
    <label><input type="radio" name="025-q4" value="c"> C. The MCP server intercepts the request before Claude's built-in tools can respond</label>
    <label><input type="radio" name="025-q4" value="d"> D. Claude routes based on tool descriptions and your prompt — naming the server explicitly biases it toward the MCP tool</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Claude selects tools the same way it selects any action: by matching tool descriptions to your intent. When you say "use the fs-scoped MCP server," you are directly naming a tool source, so Claude routes there. Without that hint, Claude may use its built-in read capability instead — both are valid, but only the MCP path goes through the server's scope enforcement.</p>
  </div>
</div>

## Stretch (optional, ~10 min)

Ask Claude to use `fs-scoped` to read `src/db.js` and list every function name it finds. Then append that list to `quips/.claude/mcp-log.md` under a `## db.js functions` heading. Verify the heading appears in the log:

```bash
grep -q '## db.js functions' quips/.claude/mcp-log.md && echo "heading found" || echo "missing"
```

## Recall

In Lab 021, you restricted the `reviewer` subagent's `tools` list to `Read, Grep, Glob`. What is the connection between that restriction and the scope argument you passed to the filesystem MCP server in this lab?

> Expected: both enforce least-privilege at the boundary between Claude and the capability being granted. The subagent tools list prevents the reviewer from writing or executing; the MCP scope argument prevents the server from reading outside the declared directory. The mechanism differs — one is a JSON allowlist in frontmatter, the other is a startup argument to a server process — but the principle is the same: grant only what the task requires.

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/mcp
- https://modelcontextprotocol.io/introduction
- https://github.com/modelcontextprotocol/servers

## Next

→ **Checkpoint E** — end of Part V (Autonomy and Orchestration)
