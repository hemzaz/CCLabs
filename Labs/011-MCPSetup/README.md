# Lab 011 - Setting Up MCP (Model Context Protocol)

!!! hint "Overview"

    - Model Context Protocol (MCP) is an open standard that allows GitHub Copilot to connect to external tools and services.
    - In this lab, you will configure MCP servers in VS Code, enabling Copilot to access live data from databases, APIs, and filesystems.
    - You will install MCP server extensions, configure connection settings, and verify that Copilot can query external data sources.
    - By the end of this lab, you will understand how MCP extends Copilot beyond static code knowledge into dynamic, real-world data.

## Prerequisites

- Completed [Lab 010 - Agent Mode](../010-AgentMode/README.md)
- VS Code with GitHub Copilot Chat (latest version)
- Node.js 18+ installed

## What You Will Learn

- What MCP is and why it matters for AI-assisted development
- How to configure MCP servers in VS Code
- How to use built-in MCP servers (filesystem, fetch, GitHub)
- How to connect Copilot to a database via MCP
- How to verify and debug MCP connections

---

## Background: What is MCP?

MCP is a protocol that lets AI models (like Copilot) call external **tools** at runtime. Instead of Copilot only knowing what's in your code files, MCP lets it:

- Query a live database
- Fetch content from the web
- Read/write files outside the workspace
- Call GitHub APIs
- Access Jira, Confluence, Slack, and hundreds of other services

```
Copilot ←→ MCP Client (VS Code) ←→ MCP Server ←→ External Resource
```

---

## Lab Steps

## Step 1 - Enable MCP in VS Code

Open your VS Code settings (`Cmd+,` / `Ctrl+,`) and enable:

```json
{
  "github.copilot.chat.experimental.agent.mcp.enabled": true
}
```

Or add it to your workspace `.vscode/settings.json`.

## Step 2 - Configure Your First MCP Server (Filesystem)

Create or open `.vscode/mcp.json` in your workspace:

```json
{
  "servers": {
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/Users/yourname/Documents"
      ]
    }
  }
}
```

This gives Copilot the ability to read and write files in `~/Documents`.

!!! note

    MCP servers run as local processes. They are sandboxed to what you configure - Copilot cannot access paths you haven't explicitly granted.

## Step 3 - Configure the GitHub MCP Server

```json
{
  "servers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${env:GITHUB_TOKEN}"
      }
    }
  }
}
```

Set your token in shell: `export GITHUB_TOKEN=ghp_yourtoken`

Now ask Copilot in Agent mode:

```
@github List the last 5 open issues in this repository.
```

## Step 4 - Configure the Fetch MCP Server

```json
{
  "servers": {
    "fetch": {
      "command": "uvx",
      "args": ["mcp-server-fetch"]
    }
  }
}
```

Then ask Copilot:

```
Fetch the content from https://docs.github.com/en/copilot and summarize the key features.
```

## Step 5 - Configure a PostgreSQL MCP Server

```json
{
  "servers": {
    "postgres": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-postgres",
        "postgresql://localhost/mydb"
      ]
    }
  }
}
```

Ask Copilot:

```
Show me the schema of the users table and write a query to find all users who signed up in the last 30 days.
```

## Step 6 - Verify MCP Server Status

Open the Copilot Chat panel → click the **Tools** icon (🔧) to see all available MCP tools and their status.

To restart a server:

```
@workspace /mcp restart filesystem
```

---

## Common MCP Servers Reference

| Server       | Package                                     | Use Case               |
| :----------- | :------------------------------------------ | :--------------------- |
| Filesystem   | `@modelcontextprotocol/server-filesystem`   | Read/write local files |
| GitHub       | `@modelcontextprotocol/server-github`       | Issues, PRs, repos     |
| PostgreSQL   | `@modelcontextprotocol/server-postgres`     | SQL databases          |
| Fetch        | `mcp-server-fetch`                          | Web content retrieval  |
| Brave Search | `@modelcontextprotocol/server-brave-search` | Web search             |
| Slack        | `@modelcontextprotocol/server-slack`        | Slack messages         |
| Memory       | `@modelcontextprotocol/server-memory`       | Persistent memory      |
| Puppeteer    | `@modelcontextprotocol/server-puppeteer`    | Browser automation     |

---

## Summary

MCP transforms Copilot from a code-aware assistant into a system that can interact with your entire development ecosystem in real time.

## Next Steps

Continue with [Lab 012 - Custom Agents](../012-CustomAgents/README.md)

---

## Tasks

## Task 01 - Create an MCP Configuration File

**Scenario:** Set up the MCP configuration for the filesystem server.

**Hint:** Create `.vscode/mcp.json` with the filesystem server entry.

??? success "Solution"

    Create `.vscode/mcp.json`:

    ```json
    {
      "servers": {
        "filesystem": {
          "command": "npx",
          "args": ["-y", "@modelcontextprotocol/server-filesystem", "${workspaceFolder}"]
        }
      }
    }
    ```

    Restart VS Code - the server should appear in Copilot Agent's tool list.

---

## Task 02 - Add the GitHub MCP Server

**Scenario:** Connect Copilot to your GitHub repositories via MCP.

**Hint:** Add the `@modelcontextprotocol/server-github` entry with your token.

??? success "Solution"

    Add to `.vscode/mcp.json`:

    ```json
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${env:GITHUB_TOKEN}"
      }
    }
    ```

    Then in Agent mode: "List my open GitHub issues from the last 7 days."

---

## Task 03 - Connect to a PostgreSQL Database

**Scenario:** Let the agent read your database schema and query data directly.

**Hint:** Use `@modelcontextprotocol/server-postgres` with a DATABASE_URL env var.

??? success "Solution"

    ```json
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres", "${env:DATABASE_URL}"]
    }
    ```

    Then ask: "What tables exist in the database and what are their schemas?"

---

## Task 04 - Add a Fetch/Web Search Server

**Scenario:** Let Copilot fetch documentation or URLs during a conversation.

**Hint:** Use `@modelcontextprotocol/server-fetch`.

??? success "Solution"

    ```json
    "fetch": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-fetch"]
    }
    ```

    Then ask: "Fetch the Node.js 20 release notes from https://nodejs.org/en/blog/release/v20.0.0 and summarize what changed."

---

## Task 05 - Verify MCP Servers Are Active

**Scenario:** Confirm your MCP servers started successfully.

**Hint:** In Agent mode, ask Copilot which MCP tools are available.

??? success "Solution"

    In Copilot Chat (Agent mode):
    `     Which MCP tools do you have available right now?
    List them by server name.
    `
    You should see tools from: filesystem, github, postgres, fetch (depending on your config).

---

## Task 06 - Use MCP to Audit the Codebase via GitHub

**Scenario:** Use the GitHub MCP server to list all open PRs and summarize what each changes.

**Hint:** Agent mode + GitHub MCP server.

??? success "Solution"

    `     Using the GitHub MCP tools, list all open pull requests in this repository.
    For each PR, provide: title, author, what it changes (1 sentence), and its current review status.
    `
