# Lab 030 - Agent Tools and Tool Calling

!!! hint "Overview"

    - GitHub Copilot in Agent Mode has access to a set of built-in tools that go beyond simple text generation.
    - Agents can read and write files, execute terminal commands, search the web, and call external APIs via MCP.
    - In this lab, you will learn how tool calling works under the hood and how to configure which tools an agent may use.
    - By the end of this lab, you will understand how to build, constrain, and extend agent tool sets for safe and effective automation.

## Prerequisites

- Completed [Lab 029 - Context Variables](../029-ContextVariables/README.md)

## What You Will Learn

- How Copilot Agent uses tools under the hood
- Which tools are available in agent mode
- How to approve, reject, and monitor tool calls
- How to chain multi-step agent tasks with tool calls
- How to extend agent capabilities with MCP tools

---

## Lab Steps

## Step 1 - Enable Agent Mode

1. Open Copilot Chat (`Cmd+Shift+I`)
2. Click the mode selector at the bottom of the chat
3. Select **Agent**
4. You will see the tools indicator showing available tools

## Step 2 - Understand Built-in Agent Tools

The built-in agent tools include:

| Tool               | What it does                          |
| :----------------- | :------------------------------------ |
| `read_file`        | Reads file contents                   |
| `list_directory`   | Lists directory contents              |
| `run_in_terminal`  | Executes shell commands               |
| `write_file`       | Creates or modifies files             |
| `search_workspace` | Searches codebase with semantic index |
| `get_errors`       | Gets current lint/compile errors      |
| `grep_search`      | Searches files with regex             |
| `file_search`      | Finds files by name pattern           |

## Step 3 - Tool Approval Workflow

By default, Copilot asks for approval before:

- Running terminal commands
- Writing or modifying files
- Calling external services

**Approve carefully:** Read what the agent plans to do before confirming.

```
Fix all TypeScript compilation errors in the project.
```

The agent will:

1. Call `get_errors` to list all errors
2. Call `read_file` on each file with errors
3. Propose edits (ask for approval)
4. Call `run_in_terminal` to run `tsc --noEmit` (ask for approval)
5. Verify errors are resolved

## Step 4 - Multi-Tool Chain Example

A single agent request can trigger a chain of tool calls:

```
Add a new `UserPreferences` feature:
1. Create the Prisma model
2. Generate and run the migration
3. Create the TypeScript types
4. Create the CRUD service
5. Add the controller routes
6. Write unit tests for the service
```

Watch the agent:

- Use `list_directory` to understand the project structure
- Use `read_file` to understand existing patterns
- Use `write_file` to create new files following those patterns
- Use `run_in_terminal` to run `npx prisma migrate dev`
- Use `get_errors` to verify no TypeScript errors

## Step 5 - Configure Tool Permissions

In `.vscode/settings.json`:

```json
{
  "github.copilot.chat.agent.runTasks": true,
  "github.copilot.chat.agent.autoFix": true,
  "github.copilot.chat.editor.iterativeFixing": true
}
```

For more fine-grained control, your `.github/instructions/agent-mode.instructions.md` can guide behavior:

```markdown
---
applyTo: "agent"
---

When in agent mode:

- Always run `npm run lint` and `npm run typecheck` after modifying TypeScript files
- Never run `npm run build` unless explicitly asked
- Always run tests for any file you modify
- Do NOT modify files in generated/ or dist/ directories
- Ask before running any database migrations
```

## Step 6 - Add MCP Tools to the Agent

MCP servers dramatically extend what the agent can do. Configure in `.vscode/mcp.json`:

```json
{
  "servers": {
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "${workspaceFolder}"
      ]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${env:GITHUB_TOKEN}"
      }
    },
    "postgres": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-postgres",
        "${env:DATABASE_URL}"
      ]
    }
  }
}
```

With GitHub MCP, the agent can:

```
Create a GitHub issue for each TODO comment in the codebase.
Label them `tech-debt`, assign to me, and link to the relevant file and line.
```

## Step 7 - Tool Chaining Pattern: Refactor + Test + Validate

```
Refactor the authentication system to use JWT instead of sessions:
1. Search for all session-related code
2. Replace with JWT implementation (jose library)
3. Update all affected tests
4. Run the test suite
5. Fix any remaining errors
6. Report what was changed
```

The agent will systematically work through each step, using `search_workspace`, `write_file`, `run_in_terminal`, and `get_errors` in sequence.

## Step 8 - Monitor and Review Agent Actions

The agent logs every tool call in the Chat panel. Review the tool call log to:

- Understand what the agent is doing
- Catch any unintended actions before they happen
- Learn patterns for more effective prompting

**Best Practices:**

- Start with smaller scopes (single file) before large multi-file tasks
- Always review proposed file changes before approving
- Use `undo` (`Cmd+Z`) if the agent makes unwanted changes
- Provide explicit constraints: "only modify files in `src/services/`"

---

## Agent Tool Selection Strategy

| Task Type          | Expected Tools Used                                            |
| :----------------- | :------------------------------------------------------------- |
| Bug fix            | `get_errors`, `read_file`, `write_file`                        |
| New feature        | `list_directory`, `read_file`, `write_file`, `run_in_terminal` |
| Refactoring        | `search_workspace`, `read_file`, `write_file`, `get_errors`    |
| Database migration | `read_file`, `write_file`, `run_in_terminal` (prisma migrate)  |
| Test generation    | `read_file`, `write_file`, `run_in_terminal` (test runner)     |
| Code search        | `grep_search`, `file_search`, `search_workspace`               |

---

## Summary

Agent mode with tool calling transforms Copilot from a code suggestion engine into an autonomous programming agent - capable of reading your codebase, making changes, running commands, and iterating until the task is complete.

You have now completed all 30 labs. Congratulations!

## What's Next?

- Return to [Lab Index](../index.md) to review key concepts
- Explore [Lab 011 - MCP Setup](../011-MCPSetup/README.md) to extend agent capabilities further
- Check the [GitHub Copilot documentation](https://docs.github.com/copilot) for new features

---

## Tasks

## Task 01 - Discover Available Tools

**Scenario:** Switch to Agent mode and list all available tools.

**Hint:** Ask "What tools do you have available?" in Agent mode.

??? success "Solution"

    1. Open Copilot Chat → mode selector → **Agent**
    2. Ask: "What tools do you have available? List them by category."
    3. Agent responds with: read_file, write_file, run_in_terminal, search_workspace, get_errors, grep_search, etc.

---

## Task 02 - Approve and Reject Tool Calls

**Scenario:** The agent wants to run a terminal command. Approve one and reject another.

**Hint:** The agent shows a confirmation prompt before each tool call.

??? success "Solution"

    Ask: "Run the tests and fix any lint errors."
    When the agent prompts to run `npm test` → click **Allow**
    When the agent prompts to run `npm run build` → click **Block**
    Observe how the agent adapts to the rejection.

---

## Task 03 - Watch a Multi-Tool Chain

**Scenario:** Ask the agent to add a new endpoint and watch its tool-calling sequence.

**Hint:** Give the agent a full task and observe each tool call in sequence.

??? success "Solution"

    `     Add a GET /users/:id/orders endpoint that returns all orders for a user.
    Follow the existing patterns in this codebase.
    After adding the endpoint and any required changes, run the tests.
    `
    Watch: search_workspace → read_file → write_file → run_in_terminal → get_errors

---

## Task 04 - Constrain Agent File Access

**Scenario:** Prevent the agent from modifying files outside `src/tests/`.

**Hint:** Add a constraint to `.github/instructions/agent-mode.instructions.md`

??? success "Solution"

    Add to `.github/instructions/agent-mode.instructions.md`:

    ```markdown
    ---
    applyTo: "agent"
    ---
    You may read any file. You may ONLY write to files inside src/tests/ or
    files matching *.test.ts and *.spec.ts. Never modify implementation files.
    ```

---

## Task 05 - Extend Agent with MCP Tools

**Scenario:** Add the GitHub MCP server so the agent can create GitHub issues.

**Hint:** Configure `.vscode/mcp.json` then ask the agent to create an issue.

??? success "Solution"

    1. Add GitHub MCP to `.vscode/mcp.json`
    2. Ask the agent:
    `        @workspace Find all TODO comments in the codebase.
       Create a GitHub issue for each one labeled 'tech-debt'.
       Link to the file and line in each issue body.
       `

---

## Task 06 - Iterate Until Tests Pass

**Scenario:** Let the agent make a change and keep fixing until all tests pass.

**Hint:** End your agent prompt with "run tests and fix any failures, repeat until all pass."

??? success "Solution"

    `     Extract the email validation logic from UserService into a standalone
    EmailValidator class in src/validators/.
    After refactoring, run npm test.
    If any tests fail, fix them and re-run. Repeat until all tests pass.
    Report every file you modified in your final summary.
    `
