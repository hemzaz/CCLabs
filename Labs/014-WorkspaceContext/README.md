# Lab 014 - Workspace Context & @workspace

!!! hint "Overview"

    - GitHub Copilot can analyze your entire workspace to generate code that fits your project's specific structure and conventions.
    - In this lab, you will master the `@workspace` context variable, `#file`, `#editor`, and `.copilotignore` to control context.
    - You will learn how Copilot indexes your codebase and how to shape what it sees to get the most relevant responses.
    - By the end of this lab, you will be able to use context variables precisely to target Copilot's attention to the right files.

## Prerequisites

- Completed [Lab 013 - Copilot Extensions](../013-CopilotExtensions/README.md)

## What You Will Learn

- How `@workspace` indexes and searches your codebase
- How to ask architectural questions about your project
- How to find code patterns and usages across the whole repo
- How to use `#file`, `#selection`, `#editor` context variables
- How to scope context for better, more accurate answers

---

## Lab Steps

## Step 1 - Basic Workspace Questions

Open any project and use `@workspace` to explore it:

```
@workspace What does this project do? Give me a high-level architecture overview.
```

```
@workspace What frameworks and libraries does this project use? What versions?
```

```
@workspace How is authentication implemented in this codebase?
```

## Step 2 - Finding Code Patterns

```
@workspace Find all places where database connections are created.
Are we using connection pooling consistently?
```

```
@workspace Which files handle error responses? Are we returning consistent error formats?
```

```
@workspace Find all TODO comments in the codebase and group them by priority or theme.
```

## Step 3 - Context Variables

| Variable                | What it includes                   |
| :---------------------- | :--------------------------------- |
| `@workspace`            | All indexed files in the workspace |
| `#file:path/to/file.ts` | Specific file content              |
| `#selection`            | Currently selected code            |
| `#editor`               | Active editor's full content       |
| `#terminalSelection`    | Selected terminal output           |
| `#terminalLastCommand`  | Last terminal command + output     |
| `@vscode`               | VS Code API and settings knowledge |

## Step 4 - Targeted File Context

Rather than using the full workspace, attach specific files:

```
Using #file:src/auth/middleware.ts and #file:src/auth/jwt.ts,
explain how JWT verification works and identify any security gaps.
```

```
Compare #file:src/services/UserService.ts with #file:src/services/OrderService.ts.
Are they following the same patterns? What inconsistencies exist?
```

## Step 5 - Cross-File Refactoring with Context

```
@workspace I need to add soft-delete support to all models.
Which models exist, and what's the best approach given our current ORM setup?
```

```
@workspace We're migrating from callbacks to async/await.
Find all callback-style async functions and create a migration plan.
```

## Step 6 - Using Terminal Context

Run a failing test, then ask:

```
#terminalLastCommand The test is failing. What's wrong and how do I fix it?
```

Or after a build error:

```
#terminalSelection Explain this error and provide a fix.
```

## Step 7 - Improving Context Quality

Tips for better `@workspace` answers:

1. **Keep an up-to-date `README.md`** - Copilot reads it to understand project purpose
2. **Use descriptive file/folder names** - `userAuthService.ts` > `uas.ts`
3. **Add a `.github/copilot-instructions.md`** file with project conventions
4. **Break large files** into focused modules - context window limits apply
5. **Exclude irrelevant files** via `.copilotignore` (same syntax as `.gitignore`)

---

## Create a `.copilotignore` File

```gitignore
# Exclude generated files from Copilot context
dist/
build/
*.min.js
*.bundle.js
coverage/
node_modules/
*.lock
migrations/
```

---

## Summary

Mastering workspace context is the key to getting Copilot answers that are accurate and consistent with your specific codebase - not generic examples.

## Next Steps

Continue with [Lab 015 - Multi-File Editing](../015-MultiFileEditing/README.md)

---

## Tasks

## Task 01 - Ask an Architecture Question with `@workspace`

**Scenario:** Find where authentication middleware is defined and which routes bypass it.

**Hint:** `@workspace` searches across all files.

??? success "Solution"

    `     @workspace Where is the authentication middleware defined?
    Which routes currently bypass it (don't use it)?
    `

---

## Task 02 - Reference Multiple Files

**Scenario:** Compare the OrderService and PaymentService to find inconsistent error handling.

**Hint:** Use `#file:` for each file you want to include.

??? success "Solution"

    ```
    #file:src/services/OrderService.ts
    #file:src/services/PaymentService.ts

    Compare the error handling patterns in these two services.
    Are they consistent? What should be standardized?
    ```

---

## Task 03 - Use `#editor` for the Open File

**Scenario:** Refactor the function you currently have open without typing the file path.

**Hint:** `#editor` always refers to the currently active file.

??? success "Solution"

    1. Open the file you want to refactor
    2. Chat:
    ```
    #editor

       Identify all functions longer than 20 lines and suggest how to split them.
       ```

---

## Task 04 - Use `#selection` for a Specific Block

**Scenario:** Get a code review of only 10 lines, not the entire file.

**Hint:** Select the 10 lines, then use `#selection`.

??? success "Solution"

    1. Highlight the 10-line block you want reviewed
    2. Chat:
    ```
    #selection

       Review this for correctness, edge cases, and potential null pointer exceptions.
       ```

---

## Task 05 - Create a `.copilotignore` File

**Scenario:** Prevent Copilot from including generated files and secrets in workspace context.

**Hint:** `.copilotignore` uses the same syntax as `.gitignore`.

??? success "Solution"

    Create `.copilotignore` at the root:
    ``` # Generated files
    dist/
    build/
    .next/
    coverage/

    # Dependencies
    node_modules/

    # Secrets and local config
    .env
    .env.local
    *.pem
    *.key

    # Large data files
    *.csv
    *.sql
    fixtures/
    ```

---

## Task 06 - Use `#terminalLastCommand` for Debugging

**Scenario:** After a failing test run, paste the error into Copilot using terminal context.

**Hint:** Run the failing command, then in Chat use `#terminalLastCommand`.

??? success "Solution"

    1. Run your tests: `npm test` (some fail)
    2. In Copilot Chat:
    ```
    #terminalLastCommand

       Explain these test failures. What is the root cause and how do I fix it?
       ```
