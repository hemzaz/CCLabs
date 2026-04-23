# Lab 027 — MCP Practice

⏱ **35 min**   📦 **You'll add**: second MCP server (`git-read`) in `quips/.claude/settings.json` + `quips/.claude/mcp-git-log.md`   🔗 **Builds on**: Lab 025   🎯 **Success**: `quips/.claude/settings.json` has both `fs-scoped` and `git-read`; `mcp-git-log.md` contains a commit reference

<!--
  Template contract - do not remove this comment.
  CI (lint-prose + structure linter) enforces:
    1. Header line above (one line, five fields, in this exact order)
    2. Nine sections below (in this exact order, same H2 titles)
    3. Single new concept (a "Concept:" Bloom-tagged line)
    4. Every Do step ends with a verify COMMAND, not a screenshot
  See CONTRIBUTING.md and docs/DESIGN.md §7 for the full author contract.
-->

!!! hint "Overview"
    - You will add a second MCP server (`git-read`) alongside the `fs-scoped` server from Lab 025.
    - You will learn how Claude routes between multiple servers based on tool names and your prompt wording.
    - You will use a reference table to predict which server handles each type of request.
    - By the end you will have driven both servers in a single session and recorded the result.

**Concept**: `Wire and use a second MCP server alongside the first` (Bloom: Apply)

---

## Prerequisites

- Lab 025 complete: `quips/.claude/settings.json` exists with a valid `fs-scoped` entry
- The `quips` directory has at least one git commit (`git -C quips log -1 --oneline` exits 0)
- `npx` is on PATH (`npx --version` prints a version)

## What You Will Learn

- How to add a second `mcpServers` entry without disturbing the first
- How Claude resolves which server to call when multiple are active
- How scope arguments differ between a filesystem server and a git server
- How to confirm multi-server startup and observe routing in practice

## Why

One MCP server is an integration. Two is ops. When Claude has both a filesystem server and a git history server active in the same session, it can cross-reference what a file contains right now against which commit introduced the change. That makes Claude useful for audit and blame workflows, not just passive reads. This lab adds the reference `git` MCP server from the MCP servers repository alongside the `fs-scoped` server from Lab 025, then drives both in one session to answer a real question: which commit last changed a source file?

## Walkthrough

Claude Code loads all `mcpServers` entries from `settings.json` at session start. Each entry launches a separate process and registers its tool set under a distinct server name. When you type a prompt, Claude reads the tool descriptions from every active server and chooses the one whose description best matches the task.

The two servers in this lab expose complementary tool sets:

| Prompt pattern | Which server Claude picks | Why |
|---|---|---|
| "list files in src/" | `fs-scoped` | The filesystem server exposes `list_directory` |
| "read the contents of src/server.js" | `fs-scoped` | The filesystem server exposes `read_file` |
| "show recent commits" | `git-read` | The git server exposes `git_log` |
| "who last changed this file?" | `git-read` | The git server exposes `git_blame` |
| "what changed in the last commit?" | `git-read` | The git server exposes `git_diff` |
| "search for a string in working files" | `fs-scoped` | The filesystem server exposes `search_files` |

The scope arguments are what make this safe. `fs-scoped` receives the absolute path to `quips/src` as its last argument — it cannot read files outside that directory. `git-read` receives `--repository <absolute path to quips>` — it can read git metadata for that repo only. Neither server has write access unless you explicitly configure it.

When a prompt is ambiguous — for example "tell me about server.js" — Claude picks based on which server's tool description matches most closely. You can always override the router by naming the server explicitly in your prompt: "use git-read to show the last commit that touched src/server.js."

At session start, Claude Code prints a line for each MCP server it successfully loaded. If a server fails to start, Claude still launches but that server's tools are silently unavailable. Checking `settings.json` after the fact confirms configuration; checking the startup log confirms runtime availability.

## Check

```bash
./scripts/doctor.sh 027
```

Expected output: `OK lab 027 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before configuring anything, predict which of the two servers (`fs-scoped` or `git-read`) has a larger blast radius if compromised. Write one sentence justifying your choice.

   Verify your prediction is recorded:
   ```bash
   echo "prediction recorded"
   ```
   Expected: `prediction recorded`

2. **Run** — verify the quips repo has at least one commit and that `fs-scoped` is already wired correctly from Lab 025.

   ```bash
   git -C quips log -1 --oneline
   ```
   Expected: a short hash followed by a commit message.

   ```bash
   python3 -c "import json; s=json.load(open('quips/.claude/settings.json')); assert 'fs-scoped' in s.get('mcpServers',{}); print('fs-scoped present')"
   ```
   Expected: `fs-scoped present`

3. **Investigate** — plan the second `mcpServers` entry before editing any file. The server name will be `git-read`, the command is `npx`, and the args are `["-y", "@modelcontextprotocol/server-git", "--repository", "<absolute path to quips>"]`. Confirm the absolute path you will use.

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
   python3 -c "import json; s=json.load(open('quips/.claude/settings.json')); assert {'fs-scoped','git-read'} <= set(s.get('mcpServers',{}).keys()); print('both servers present')"
   ```
   Expected: `both servers present`

5. **Make** — launch a fresh Claude session inside quips. MCP servers load at session start, so exit any existing session first.

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
| `git-read` server fails to start | Package name or `--repository` arg is wrong | Confirm the package is `@modelcontextprotocol/server-git`; pass `--repository` with an absolute path, not a relative one | https://github.com/modelcontextprotocol/servers |
| Claude uses `fs-scoped` when you wanted `git-read` | Router matched the filesystem server on ambiguous prompt wording | Be explicit: "use the git-read server to show the last commit that touched src/server.js" | https://docs.claude.com/en/docs/claude-code/mcp |
| Both servers seem to see your home directory | Scope args missing on at least one server | Every server must carry its own scope arg — directory path for `fs-scoped`, `--repository` path for `git-read` | https://modelcontextprotocol.io/introduction |
| Claude session loads but neither server is available | `settings.json` was edited while the session was already open | Exit the session and re-launch; MCP servers are read once at startup | https://docs.claude.com/en/docs/claude-code/mcp |

## Tasks

Click the checkbox next to each task to mark it done — your progress is saved locally.

### Task 1 — Confirm both servers appear in settings.json

**Scenario:** Before launching a session, you want to mechanically verify that both server names are present and that the JSON is syntactically valid — no guessing.

**Hint:** `python3 -c` with `json.load` and a set membership check gives a zero-exit verification without needing a linter.

??? success "Solution"

    ```bash
    python3 -c "
    import json
    s = json.load(open('quips/.claude/settings.json'))
    servers = set(s.get('mcpServers', {}).keys())
    assert 'fs-scoped' in servers, 'fs-scoped missing'
    assert 'git-read' in servers, 'git-read missing'
    print('both present:', servers)
    "
    ```

### Task 2 — Ask Claude about recent commits via git-read

**Scenario:** You want to see the five most recent commit messages in the quips repo, pulled through the MCP layer rather than a bare `git log`.

**Hint:** Name the server explicitly in your prompt so Claude does not route to `fs-scoped` by accident.

??? success "Solution"

    Inside the Claude REPL (`cd quips && claude`), type:

    ```
    Use git-read to show the five most recent commits in this repo — hash, author, and message.
    ```

    Claude calls `git_log` on the `git-read` server and returns structured commit data.

### Task 3 — Read a file via fs-scoped and observe the server name

**Scenario:** You want to confirm that file-content requests land on `fs-scoped`, not `git-read`, so routing is working as expected.

**Hint:** Ask Claude to read a specific file and to tell you which server it used.

??? success "Solution"

    Inside the Claude REPL, type:

    ```
    Use fs-scoped to read src/server.js and summarise the routes you find. Tell me which MCP server you called.
    ```

    Claude's response should name `fs-scoped` and return file content. If it names `git-read`, your prompt wording pulled it toward git tools — rephrase to emphasise "file contents."

### Task 4 — Send an ambiguous prompt and observe the router choice

**Scenario:** You want to understand how Claude resolves ambiguity when a prompt could match either server. Ask something that fits both.

**Hint:** A prompt like "tell me about src/server.js" has no explicit server name — watch which tool Claude reaches for first.

??? success "Solution"

    Inside the Claude REPL, type:

    ```
    Tell me about src/server.js
    ```

    Observe whether Claude opens the file (fs-scoped → `read_file`) or checks git history (git-read → `git_log` or `git_blame`). Either is a valid first move. The point is to see how Claude interprets intent without an explicit cue, and to note that you can override it by restating with a server name.

### Task 5 — Verify that fs-scoped refuses git metadata reads

**Scenario:** You want to confirm that the scope boundary is real: `fs-scoped` cannot answer questions about commit history because it has no git tools registered.

**Hint:** Ask Claude to use `fs-scoped` specifically for something only git can answer.

??? success "Solution"

    Inside the Claude REPL, type:

    ```
    Use only fs-scoped (no git-read) to tell me who authored the last commit to src/server.js.
    ```

    Claude should respond that `fs-scoped` does not have tools to read git history, or it will read the file contents and note that commit metadata is unavailable through that server. This confirms the scope boundary is enforced at the tool-description level, not just by convention.

### Task 6 — Inspect settings.json to confirm the scope args are correct

**Scenario:** A colleague claims that if the scope arg is missing from a server entry, the server starts but with broader-than-intended access. Verify that your entries each carry their scope argument.

**Hint:** Load the JSON with Python and inspect the `args` arrays directly.

??? success "Solution"

    ```bash
    python3 -c "
    import json
    s = json.load(open('quips/.claude/settings.json'))
    servers = s['mcpServers']

    fs_args = servers['fs-scoped']['args']
    git_args = servers['git-read']['args']

    # fs-scoped: last arg is the scoped directory
    assert any(arg.startswith('/') for arg in fs_args), 'fs-scoped missing absolute path arg'

    # git-read: --repository flag must be present
    assert '--repository' in git_args, 'git-read missing --repository flag'

    print('scope args verified')
    "
    ```

    Expected: `scope args verified`

## Quiz

<div class="ccg-quiz" data-lab="027">
  <div class="ccg-q" data-answer="c">
    <p><strong>Q1.</strong> Why run a separate <code>git-read</code> server instead of giving <code>fs-scoped</code> access to the <code>.git</code> directory?</p>
    <label><input type="radio" name="027-q1" value="a"> **a.** There is no technical reason — it is purely a naming convention.</label>
    <label><input type="radio" name="027-q1" value="b"> **b.** The filesystem server cannot read hidden directories at all.</label>
    <label><input type="radio" name="027-q1" value="c"> **c.** Separate servers give separate tool descriptions, so Claude routes by intent rather than by file path, and each server's access is independently scoped.</label>
    <label><input type="radio" name="027-q1" value="d"> **d.** Claude Code only supports one MCP server per session, so the git server must be a separate process to avoid conflicts.</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Each MCP server registers its own tool set with distinct names and descriptions. A dedicated git server exposes tools like <code>git_log</code> and <code>git_blame</code>, which Claude can match by intent. Letting <code>fs-scoped</code> read <code>.git/</code> would give raw file access to git internals but no structured git tools, and it would widen the blast radius of the filesystem server.</p>
  </div>
  <div class="ccg-q" data-answer="b">
    <p><strong>Q2.</strong> The <code>git-read</code> server entry uses <code>--repository /absolute/path/to/quips</code>. What happens if you omit that argument?</p>
    <label><input type="radio" name="027-q2" value="a"> **a.** The server refuses to start and logs an error.</label>
    <label><input type="radio" name="027-q2" value="b"> **b.** The server may default to a broader scope (such as the process working directory), potentially exposing repos you did not intend to share.</label>
    <label><input type="radio" name="027-q2" value="c"> **c.** Claude automatically infers the repository path from the session working directory.</label>
    <label><input type="radio" name="027-q2" value="d"> **d.** The server starts in read-only mode across all repositories on the machine.</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">The <code>--repository</code> argument tells the git MCP server which repository to operate on. Without it the server may fall back to whatever directory it was launched from, which could be the root of your home directory or the Claude Code working directory — a wider scope than intended. Always pass an absolute path to guarantee the boundary.</p>
  </div>
  <div class="ccg-q" data-answer="a">
    <p><strong>Q3.</strong> You send the prompt "show me the diff for the last commit." Both <code>fs-scoped</code> and <code>git-read</code> are active. How does Claude decide which server to call?</p>
    <label><input type="radio" name="027-q3" value="a"> **a.** Claude compares the prompt to each server's registered tool descriptions and picks the server whose tools best match the intent — here, <code>git_diff</code> on <code>git-read</code>.</label>
    <label><input type="radio" name="027-q3" value="b"> **b.** Claude always calls both servers and merges the results.</label>
    <label><input type="radio" name="027-q3" value="c"> **c.** Claude picks the server listed first in <code>settings.json</code>.</label>
    <label><input type="radio" name="027-q3" value="d"> **d.** Claude asks you to disambiguate before making any tool call.</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Claude reads the tool descriptions that each MCP server registers at startup and uses them as a routing signal. "Show me the diff for the last commit" maps clearly onto <code>git_diff</code> or <code>git_show</code>, which are registered by <code>git-read</code>, not by <code>fs-scoped</code>. Ordering in <code>settings.json</code> does not determine priority — tool-description relevance does.</p>
  </div>
  <div class="ccg-q" data-answer="d">
    <p><strong>Q4.</strong> When should you name the server explicitly in your prompt (e.g., "use git-read to …") rather than letting Claude route automatically?</p>
    <label><input type="radio" name="027-q4" value="a"> **a.** Always — automatic routing is unreliable and should never be trusted.</label>
    <label><input type="radio" name="027-q4" value="b"> **b.** Never — explicit server names are not supported in Claude Code prompts.</label>
    <label><input type="radio" name="027-q4" value="c"> **c.** Only when more than three MCP servers are active at once.</label>
    <label><input type="radio" name="027-q4" value="d"> **d.** When the prompt is ambiguous and you need a predictable outcome, or when you are verifying that a specific server handles a specific task correctly.</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Automatic routing works well when prompts clearly imply a tool type. Explicit server naming is valuable when a prompt could legitimately match multiple servers, when you are testing routing behavior, or when you need deterministic output for a script. Think of it as the difference between letting Claude interpret intent freely versus asserting exactly which tool to use.</p>
  </div>
</div>

## Stretch (optional, ~10 min)

Ask Claude to use `git-read` to list the five most recent commits that touched any file under `src/`, then append the list to `quips/.claude/mcp-git-log.md` under a `## Recent src/ commits` heading. Verify the heading appears in the log:

```bash
grep -q '## Recent src/ commits' quips/.claude/mcp-git-log.md && echo "heading found" || echo "heading missing"
```

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
