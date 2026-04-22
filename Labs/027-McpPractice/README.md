# Lab 027 — MCP Practice

⏱ **35 min**   📦 **You'll add**: second MCP server (git) in `quips/.claude/settings.json` + `quips/.claude/mcp-git-log.md`   🔗 **Builds on**: Lab 026   🎯 **Success**: `quips/.claude/settings.json` has both `fs-scoped` and `git-read`; `mcp-git-log.md` contains a commit reference`

<!--
  Template contract - do not remove this comment.
  CI (lint-prose + structure linter) enforces:
    1. Header line above (one line, five fields, in this exact order)
    2. Nine sections below (in this exact order, same H2 titles)
    3. Single new concept (a "Concept:" Bloom-tagged line)
    4. Every Do step ends with a verify COMMAND, not a screenshot
  See CONTRIBUTING.md and docs/DESIGN.md §7 for the full author contract.
-->

**Concept**: `Wire and use a second MCP server alongside the first` (Bloom: Apply)

---

## Why

One MCP server is an integration. Two is ops. When Claude has both a filesystem server and a git history server active in the same session, it can cross-reference what a file contains right now against what change introduced it. That makes Claude useful for audit and blame workflows, not just read workflows. This lab adds the reference `git` MCP server from the MCP servers repository alongside the `fs-scoped` server you configured in Lab 025, then drives both in one session to answer a real question: which commit last changed a route file?

## Check

```bash
./scripts/doctor.sh 027
```

Expected output: `OK lab 027 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before configuring anything, predict which of the two MCP servers (`fs-scoped` or `git`) has a larger blast radius if compromised. Justify in one sentence.

   Verify your prediction is recorded:
   ```bash
   echo "prediction recorded"
   ```
   Expected: `prediction recorded`

2. **Run** — read the git MCP server README at https://github.com/modelcontextprotocol/servers/tree/main/src/git to understand what tools it exposes. Then verify your local quips repo has at least one commit:

   ```bash
   git -C quips log -1 --oneline
   ```
   Expected: a short hash followed by a commit message.

3. **Investigate** — plan the second `mcpServers` entry before editing any file. The server name will be `git-read`, the command is `npx`, and the args are `["-y", "@modelcontextprotocol/server-git", "--repository", "<absolute path to quips>"]`. Decide why this server should be treated as read-only even though the git MCP server can perform writes.

   Verify you can state the absolute path you will use:
   ```bash
   echo "$PWD/quips"
   ```
   Expected: a string beginning with `/`.

4. **Modify** — extend `quips/.claude/settings.json` with the `git-read` entry alongside the existing `fs-scoped` entry. The finished `mcpServers` block should look like:

   ```json
   {
     "mcpServers": {
       "fs-scoped": {
         "command": "npx",
         "args": ["-y", "@modelcontextprotocol/server-filesystem", "/absolute/path/to/quips/src"]
       },
       "git-read": {
         "command": "npx",
         "args": ["-y", "@modelcontextprotocol/server-git", "--repository", "/absolute/path/to/quips"]
       }
     }
   }
   ```

   Verify the JSON is valid and both keys are present:
   ```bash
   python3 -c "import json; s=json.load(open('quips/.claude/settings.json')); assert {'fs-scoped','git-read'} <= set(s.get('mcpServers',{}).keys())"
   ```
   Expected: exits 0 with no output.

5. **Make** — launch a fresh Claude session inside quips (exit and re-launch if one is already open — MCP servers load at session start):

   ```bash
   cd quips && claude
   ```

   Inside the REPL, type:

   > Use fs-scoped to list src/, pick one route file, then use git-read to show the commit that last changed it.

   When Claude responds, paste the full response into `quips/.claude/mcp-git-log.md`. Then verify the log is non-empty and contains a commit reference:
   ```bash
   [[ -s quips/.claude/mcp-git-log.md ]] && grep -qiE 'commit|author' quips/.claude/mcp-git-log.md && echo "ok" || echo "missing or empty"
   ```
   Expected: `ok`

## Observe

One sentence — when Claude had both servers available, how did it decide which server to call first, and what in your prompt drove that choice?

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| git MCP server fails to start | Package name or `--repository` arg is wrong | Check the package is `@modelcontextprotocol/server-git`; pass `--repository` with an absolute path | https://github.com/modelcontextprotocol/servers |
| Claude uses fs-scoped when you meant git-read | Router matched the first useful server | Be explicit in the prompt: "Use the `git-read` server, not fs-scoped" | https://docs.claude.com/en/docs/claude-code/mcp |
| Both MCP servers see your home directory | Scope args missing on at least one server | Every server must pass its own scope arg — filesystem path for fs-scoped, repo path for git-read | https://modelcontextprotocol.io/introduction |

## Stretch (optional, ~10 min)

Ask Claude to use `git-read` to list the five most recent commits that touched any file under `src/`, then append the list to `quips/.claude/mcp-git-log.md` under a `## Recent src/ commits` heading. Verify the heading appears in the log.

## Recall

In Lab 022, you saw two ways to hand work to a subagent: automatic delegation and explicit `Task()` calls. What is the practical difference between letting Claude route automatically versus calling `Task()` explicitly in a prompt?

> Expected: automatic delegation lets Claude choose the subagent and its prompt, which is convenient but opaque; explicit `Task()` calls give you full control over what the subagent receives and which model or tool set it uses.

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/mcp
- https://github.com/modelcontextprotocol/servers
- https://modelcontextprotocol.io/introduction

## Next

→ **Lab 028 — Claude in CI** — run Claude Code as a non-interactive step inside a GitHub Actions workflow and assert on its output.
