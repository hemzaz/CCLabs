# Lab 025 — MCP

⏱ **35 min**   📦 **You'll add**: MCP server entry in `quips/.claude/settings.json` + `quips/.claude/mcp-log.md`   🔗 **Builds on**: Lab 024   🎯 **Success**: `quips/.claude/settings.json` contains `mcpServers.fs-scoped` and `quips/.claude/mcp-log.md` is non-empty with a reference to a file under src/`

<!--
  Template contract - do not remove this comment.
  CI (lint-prose + structure linter) enforces:
    1. Header line above (one line, five fields, in this exact order)
    2. Nine sections below (in this exact order, same H2 titles)
    3. Single new concept (a "Concept:" Bloom-tagged line)
    4. Every Do step ends with a verify COMMAND, not a screenshot
  See CONTRIBUTING.md and docs/DESIGN.md §7 for the full author contract.
-->

**Concept**: `Integrate one MCP server and call a tool against real data` (Bloom: Apply)

---

## Why

Claude Code can call tools hosted by external servers through the Model Context Protocol (MCP). This extends what Claude can do beyond editing files: live filesystem reads, real API calls, and data lookups — all scoped and auditable. The filesystem MCP server is the canonical first example: you point it at one directory, and Claude can list and read files inside that scope without touching anything outside it. This lab wires up that server, verifies the config, and records a real tool call in a log file.

## Check

```bash
./scripts/doctor.sh 025
```

Expected output: `OK lab 025 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before configuring anything, write down the three top risks of adding an MCP server to Claude Code: think about scope (what directories can the server touch), trust (who wrote the server code), and auth (what credentials does the server run with). Keep your list for the Observe section.

   Verify your list exists:
   ```bash
   echo "risk-1: scope creep; risk-2: untrusted server code; risk-3: credential leakage"
   ```
   Expected: that line prints without error.

2. **Run** — read the MCP configuration reference and the filesystem server source. Identify the top-level key Claude Code uses in `settings.json` to declare MCP servers.

   - Config reference: https://docs.claude.com/en/docs/claude-code/mcp
   - Filesystem server: https://github.com/modelcontextprotocol/servers/tree/main/src/filesystem

   Verify you can name the config key:
   ```bash
   echo "mcpServers"
   ```
   Expected: `mcpServers`

3. **Investigate** — plan the exact config entry before touching any file. The server name is `fs-scoped`, the command is `npx`, and the args are `["-y", "@modelcontextprotocol/server-filesystem", "<absolute path to quips/src>"]`. Confirm the absolute path you will use.

   Verify the path resolves to an absolute path starting with `/`:
   ```bash
   echo "$PWD/quips/src"
   ```
   Expected: a string beginning with `/`.

4. **Modify** — open `quips/.claude/settings.json` (create it if it does not exist) and add an `mcpServers` block with a `fs-scoped` entry. Use the absolute path from step 3 as the final argument. The finished block looks like:

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

5. **Make** — launch a fresh Claude session inside quips and call the MCP tool. Exit and re-launch if you already had a session open before step 4 — MCP servers load at session start.

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
| MCP server fails to start | `npx` is pulling from the wrong package; name typo | Double-check the package: `@modelcontextprotocol/server-filesystem` — run `npx -y @modelcontextprotocol/server-filesystem --help` once to seed the cache | https://github.com/modelcontextprotocol/servers |
| Claude claims MCP tools are not available | Claude session started before settings.json change | Exit and re-launch `claude`; MCP servers are loaded at session start | https://docs.claude.com/en/docs/claude-code/mcp |
| MCP server reads outside the scoped dir | No scope arg, or wrong absolute path | Always pass the absolute path argument; verify with `pwd` before editing settings | https://modelcontextprotocol.io/introduction |

## Stretch (optional, ~10 min)

Ask Claude to use `fs-scoped` to read `src/db.js` and list every function name it finds. Then append that list to `quips/.claude/mcp-log.md` under a `## db.js functions` heading. Verify the heading appears in the log.

## Recall

In Lab 020, you established a green test suite before starting a refactor. What is the purpose of running `npm test` before making any code changes?

> Expected: a passing test suite gives you a safety net — if tests break during the refactor, you know your changes caused it, not pre-existing breakage.

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/mcp
- https://modelcontextprotocol.io/introduction

## Next

→ **Checkpoint E** — end of Part V (Autonomy and Orchestration)
