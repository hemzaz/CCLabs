# Lab 013 - Copilot Extensions (GitHub Marketplace)

!!! hint "Overview"

    - Copilot Extensions are third-party integrations available on the GitHub Marketplace that extend Copilot Chat with external services.
    - In this lab, you will discover, install, and interact with extensions for tools like Jira, Sentry, Datadog, and Docker.
    - Extensions are invoked using `@extension-name` syntax directly in the Chat panel, keeping your workflow centralized.
    - By the end of this lab, you will know how to evaluate, install, and effectively use Copilot Extensions in your projects.

## Prerequisites

- Completed [Lab 012 - Custom Agents](../012-CustomAgents/README.md)
- GitHub account with Copilot subscription

## What You Will Learn

- The difference between MCP servers and Copilot Extensions
- How to browse and install Copilot Extensions from the Marketplace
- How to use popular extensions: Sentry, Datadog, Jira, Docker
- How to build a simple Copilot Extension

---

## Background: Extensions vs. MCP

| Feature      | Copilot Extensions   | MCP Servers       |
| :----------- | :------------------- | :---------------- |
| Distribution | GitHub Marketplace   | Self-hosted / npm |
| Setup        | OAuth install        | Config file       |
| Scope        | GitHub.com + VS Code | VS Code only      |
| Auth         | GitHub OAuth         | Token / local     |
| Use cases    | SaaS integrations    | Local tools, DBs  |

---

## Lab Steps

## Step 1 - Browse the Copilot Extensions Marketplace

1. Go to [github.com/marketplace?type=apps&copilot_app=true](https://github.com/marketplace?type=apps&copilot_app=true)
2. Browse available extensions
3. Note the categories: Monitoring, Issue Tracking, Cloud, Security, etc.

## Step 2 - Install the Sentry Extension

1. Find **Sentry** in the Marketplace
2. Click **Install** and authorize via GitHub OAuth
3. In VS Code Copilot Chat, type:

```
@sentry Show me the last 10 errors in production for the checkout service.
```

```
@sentry What's the root cause of error CHECKOUT-3X2F? Give me the stack trace and affected users.
```

## Step 3 - Install the Docker Extension

1. Install the **Docker** extension from Marketplace
2. Try these queries:

```
@docker Analyze my Dockerfile for security best practices and size optimization.
```

```
@docker What's the difference between my local image and the latest published image nirgeier/myapp?
```

## Step 4 - Using the Jira Extension

After installing the Jira extension:

```
@jira Create a new bug ticket: "Login button unresponsive on mobile Safari",
priority: High, assign to me, add to current sprint.
```

```
@jira What tickets are blocking the Q2 release? List the blockers with their owners.
```

## Step 5 - Using the Datadog Extension

```
@datadog Show memory usage for the API service over the last 24 hours.
Are there any anomalies?
```

```
@datadog Create a monitor alert for when p99 latency exceeds 500ms on the payment service.
```

## Step 6 - Building a Simple Copilot Extension

A Copilot Extension is a GitHub App that responds to Copilot Chat messages.

**Minimal Node.js extension skeleton:**

```javascript
import { Octokit } from "@octokit/core";
import { createNodeMiddleware, createServer } from "@octokit/webhooks";

// A Copilot Extension that answers questions about your company wiki
export async function handleCopilotMessage(req, res) {
  const { messages } = req.body;
  const userMessage = messages[messages.length - 1].content;

  // Your logic: query wiki, database, API, etc.
  const answer = await queryWiki(userMessage);

  // Return streaming SSE response
  res.write(
    `data: ${JSON.stringify({
      type: "message",
      content: answer,
    })}\n\n`,
  );
  res.end();
}
```

Key requirements for a Copilot Extension:

- Must be a GitHub App with `copilot` permission
- Must handle Server-Sent Events (SSE) for streaming
- Must be publicly accessible (use ngrok for development)

---

## Popular Extensions Reference

| Extension          | Use Case                                |
| :----------------- | :-------------------------------------- |
| **Sentry**         | Error tracking and production debugging |
| **Datadog**        | Metrics, logs, and APM monitoring       |
| **Jira**           | Issue tracking and sprint management    |
| **Docker**         | Container image analysis                |
| **LaunchDarkly**   | Feature flag management                 |
| **Octopus Deploy** | Deployment pipeline management          |
| **Swimm**          | Code documentation sync                 |
| **Stripe**         | Payment API assistance                  |

---

## Summary

Copilot Extensions integrate your entire toolchain - from issue trackers to monitoring platforms - directly into your development workflow through natural language.

## Next Steps

Continue with [Lab 014 - Workspace Context](../014-WorkspaceContext/README.md)

---

## Tasks

## Task 01 - Install a Copilot Extension

**Scenario:** Install the Docker Copilot Extension from the VS Code Marketplace.

**Hint:** Extensions panel → search "Copilot Extensions" or the specific extension name.

??? success "Solution"

    1. Open Extensions (`Cmd+Shift+X`)
    2. Search for **Docker for GitHub Copilot**
    3. Click **Install**
    4. Open Copilot Chat and type `@docker` - the extension responds

---

## Task 02 - Use the `@docker` Extension

**Scenario:** Generate a Dockerfile using the Docker Copilot Extension.

**Hint:** Type `@docker` in Copilot Chat to activate it.

??? success "Solution"

    In Copilot Chat:
    `     @docker Create a production-optimized Dockerfile for a Node.js 20 Express app.
    Use multi-stage builds and a non-root user.
    `

---

## Task 03 - Understand Extension vs MCP

**Scenario:** Explain to a teammate when to use a Copilot Extension vs an MCP server.

**Hint:** Think about GitHub.com integration vs local tool access.

??? success "Solution"

    Ask Copilot:
    `     Explain the difference between GitHub Copilot Extensions and MCP servers.
    When should I use each? Give one concrete example for each.
    `
    Key answer: Extensions work on GitHub.com and in VS Code as `@name` participants.
    MCP servers provide tool capabilities to the local Agent.

---

## Task 04 - Use `@github` Extension

**Scenario:** Use the built-in `@github` extension to search issues without leaving VS Code.

**Hint:** `@github` is always available - no installation needed.

??? success "Solution"

    In Copilot Chat:
    `     @github Search for open issues in this repository labeled 'bug' from the last 30 days.
    Summarize the top 3 by comment count.
    `

---

## Task 05 - Install and Use the Sentry Extension

**Scenario:** Connect Copilot to your Sentry error tracking to get AI-assisted fixes.

**Hint:** Search the Marketplace for "Sentry" Copilot Extension.

??? success "Solution"

    1. Install **Sentry** from VS Code Marketplace (GitHub Copilot Extension)
    2. Authenticate with your Sentry account
    3. In Chat:
    `        @sentry Show me the most recent unresolved JavaScript errors in my project.
       For the top error, suggest a fix.
       `

---

## Task 06 - List All Active Extensions

**Scenario:** Find out which Copilot Extensions are currently active in your environment.

**Hint:** In Copilot Chat, type `@` to see all available participants.

??? success "Solution"

    1. In Copilot Chat, type `@` (just the @ symbol)
    2. A dropdown appears with all available chat participants/extensions
    3. Each `@name` entry is either a built-in participant or an installed extension
    4. Hover over each to see its description and capabilities
