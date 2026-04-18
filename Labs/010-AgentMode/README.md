# Lab 010 - Agent Mode

!!! hint "Overview"

    - In this lab, you will explore GitHub Copilot Agent Mode
    - an advanced feature that lets Copilot autonomously complete multi-step tasks.
    - Unlike Chat mode, Agent Mode can plan a sequence of actions, read and write files, and run terminal commands on your behalf.
    - You will assign complex tasks to the agent and observe how it iterates on its own output to reach a working solution.
    - By the end of this lab, you will understand when to use Agent Mode and how to guide it effectively with clear task definitions.

## Prerequisites

- Completed [Lab 009 - Security](../009-Security/README.md)
- VS Code with GitHub Copilot Chat (latest version)

## What You Will Learn

- What Agent Mode is and how it differs from Chat Mode
- How to enable and use Agent Mode
- How Agent Mode can plan and execute multi-step tasks
- Practical use cases for Agent Mode

---

## Lab Steps

## Step 1 - Enable Agent Mode

1. Open the Copilot Chat panel
2. Click the **dropdown arrow** next to the chat input
3. Select **Agent** mode (or look for the `@github` agent option)
4. You can also use the `#` prefix for specific agents

## Step 2 - Multi-File Task

Ask Copilot Agent to create a complete feature:

```
Create a complete REST API endpoint for user registration:
1. A POST /register route in Express.js
2. Input validation using express-validator
3. Password hashing with bcrypt
4. Save to MongoDB using Mongoose
5. Return appropriate success/error responses
6. Write unit tests for the endpoint
```

Agent Mode will plan the task, create multiple files, and execute the steps sequentially.

## Step 3 - Iterative Development

Ask Agent to build and iterate:

```
Create a Python CLI tool that:
1. Reads a CSV file path from command line arguments
2. Displays summary statistics (count, min, max, mean) for numeric columns
3. Export results to a JSON file
4. Add argument parsing with --help documentation
Run the tool to verify it works correctly.
```

## Step 4 - Project Scaffolding

Use Agent Mode to scaffold a full project:

```
@workspace Scaffold a new Node.js Express API project with:
- TypeScript configuration
- ESLint and Prettier setup
- Jest for testing
- Docker support
- GitHub Actions CI workflow
```

## Step 5 - Debug and Fix with Agent

```
@workspace The tests in this project are failing. Analyze the errors,
identify the root cause, fix the code, and verify the tests pass.
```

---

## Agent Mode vs. Chat Mode

| Feature                    | Chat Mode | Agent Mode |
| :------------------------- | :-------- | :--------- |
| Responds to questions      | ✅        | ✅         |
| Generates code snippets    | ✅        | ✅         |
| Modifies multiple files    | ❌        | ✅         |
| Runs terminal commands     | ❌        | ✅         |
| Iterates on its own output | ❌        | ✅         |
| Plans multi-step tasks     | Limited   | ✅         |

---

## Summary

Agent Mode transforms Copilot from an assistant into an autonomous collaborator capable of completing complex, multi-step development tasks.

---

## Congratulations!

You have completed all 10 GitHub Copilot Labs. You now have hands-on experience with:

- Code completion and Ghost Text
- Chat and Inline Chat
- Prompt engineering
- Test generation
- Refactoring and documentation
- Security reviews
- Agent Mode

Continue exploring and practicing to become proficient in AI-assisted development!

---

## Tasks

## Task 01 - Explore Available Tools

**Scenario:** Switch to Agent mode and discover all available tools.

**Hint:** Mode selector at the bottom of the Chat panel.

??? success "Solution"

    1. Open Copilot Chat (`Cmd+Shift+I`)
    2. Click the mode dropdown → select **Agent**
    3. Ask: "What tools do you have available?"
    4. Copilot lists: read_file, write_file, run_in_terminal, search_workspace, get_errors, etc.

---

## Task 02 - Cross-File Change with Agent

**Scenario:** Add a `phone_number` field to the User model and update all creation sites.

**Hint:** Describe the task - the agent finds all relevant files.

??? success "Solution"

    `     Add an optional phone_number (string) field to the User model.
    Find every place in the codebase that creates a User object and add
    phone_number as an optional parameter. Run lint after all changes.
    `

---

## Task 03 - Auto-Fix All Lint Errors

**Scenario:** The project has 15 ESLint errors. Let the agent fix them all.

**Hint:** Tell the agent to run the linter and fix all errors.

??? success "Solution"

    `     Run npm run lint, fix all reported errors, then run lint again to confirm
    zero errors remain.
    `

---

## Task 04 - Scaffold a Feature End-to-End

**Scenario:** Create a complete `Tags` feature: model, migration, service, controller, tests.

**Hint:** Describe the full feature, reference existing patterns.

??? success "Solution"

    `     Scaffold a Tags feature following patterns from the existing Category feature:
    1. Prisma model: Tag (id, name, slug, createdAt)
    2. Many-to-many relation with Post
    3. Service: createTag, getTagBySlug, getPostsByTag, deleteTag
    4. REST controller: GET /tags, POST /tags, DELETE /tags/:id
    5. Unit tests for the service layer
    `

---

## Task 05 - Database Migration with Approval Gate

**Scenario:** Add soft-delete (deletedAt column) to three tables but don't run the migration automatically.

**Hint:** Ask the agent to generate migration SQL first, then wait for approval.

??? success "Solution"

    `     Add soft-delete support (nullable deletedAt timestamp) to User, Post, and Comment.
    Generate the migration SQL but do NOT run it - show me first.
    `
    Review the SQL, then: "OK, run the migration now."

---

## Task 06 - Iterate Until Tests Pass

**Scenario:** Make a refactoring change and let the agent fix any broken tests automatically.

**Hint:** End your prompt with "run the tests and fix any failures".

??? success "Solution"

    `     Refactor OrderService to use the Repository pattern.
    After refactoring, run npm test.
    If any tests fail, fix them and re-run. Repeat until all tests pass.
    `
