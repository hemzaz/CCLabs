# Lab 029 - Context Variables (Advanced)

!!! hint "Overview"

    - Context variables (`#`-prefixed references) let you precisely control what information Copilot receives in a prompt.
    - In this lab, you will master every available variable: `#file`, `#editor`, `#selection`, `#codebase`, and `@workspace`.
    - You will learn how to combine variables to give Copilot exactly the context it needs without flooding it with irrelevant code.
    - By the end of this lab, you will be able to craft highly targeted prompts that produce accurate, context-aware responses.

## Prerequisites

- Completed [Lab 028 - Custom Instructions](../028-CustomInstructions/README.md)

## What You Will Learn

- Every available context variable and when to use each
- How to combine multiple context variables effectively
- Understanding Copilot's context window and its limits
- Best practices for crafting high-signal, low-noise prompts

---

## Lab Steps

## Step 1 - File Reference (`#file`)

Reference specific files to include in context:

```
#file:src/services/OrderService.ts
#file:src/models/Order.ts
#file:prisma/schema.prisma

Explain how orders are persisted, what validations are applied,
and identify any potential consistency issues between the service
and the schema.
```

**When to use:** When you know exactly which files are relevant. More precise than `@workspace`.

## Step 2 - Editor Reference (`#editor`)

References the currently active editor tab (including unsaved changes):

```
#editor

This function is correct but I want to make it more readable.
Refactor using early returns to reduce nesting, without
changing the behavior.
```

**When to use:** When working on the specific file you have open.

## Step 3 - Selection Reference (`#selection`)

References only the highlighted text in the editor:

```
#selection

Add comprehensive JSDoc for this function. Include @param, @returns,
@throws, and a @example section.
```

**When to use:** When you want Copilot to focus on a specific block, not the whole file.

## Step 4 - Terminal References

```bash
# After running a failing command, in Chat:
```

```
#terminalLastCommand

This command failed. Explain what went wrong and provide the corrected command.
```

For longer terminal context:

```
#terminalSelection

Explain what this output means. Is this a warning I should act on?
```

**When to use:** For debugging CLI errors, explaining build output, analyzing logs.

## Step 5 - Workspace Reference (`@workspace`)

Searches across your entire workspace:

```
@workspace Where is the authentication middleware defined,
and which routes currently bypass it?
```

```
@workspace Find all places where we directly query the database
outside of the service layer (bypassing our repository pattern).
```

**When to use:** Architecture questions, cross-cutting concerns, finding patterns across files.

**Warning:** `@workspace` can be slow on large projects. Prefer `#file` when you know what's relevant.

## Step 6 - Symbol References (Experimental)

Reference specific code symbols:

```
#sym:OrderService.processOrder

Trace all the database operations this method triggers,
including any cascading calls to other services.
```

## Step 7 - Combining Multiple Context Variables

The real power is combining variables:

```
@workspace I'm adding a new `BulkOrder` feature.

Context:
#file:src/services/OrderService.ts     (existing order logic)
#file:src/models/Order.ts              (data model)
#file:src/controllers/OrderController.ts  (existing controller)
#file:src/dto/CreateOrderDto.ts        (validation schema)

What's the minimal set of changes needed to support bulk order creation
(creating up to 100 orders in a single API call)?
List the files to change, what changes to make in each, and any
new files to create.
```

## Step 8 - Context Window Strategy

Copilot's context window has limits. Follow these guidelines:

| Scenario                          | Recommended approach                     |
| :-------------------------------- | :--------------------------------------- |
| Single function question          | `#selection`                             |
| Single file question              | `#editor` or `#file`                     |
| Cross-file question (known files) | Multiple `#file` references              |
| Architecture question             | `@workspace`                             |
| Terminal error                    | `#terminalLastCommand`                   |
| Large file, need specific section | `#selection` after selecting the section |

**Tips:**

- Avoid `@workspace` for questions answerable with specific file references
- Including irrelevant files reduces response quality
- For very large files, select only the relevant section

## Step 9 - Copilot Vision (Images)

In VS Code, you can drag images into the Chat:

1. Take a screenshot of a UI mockup
2. Drag it into the Copilot Chat input
3. Ask: "Generate a React component that matches this design using Tailwind CSS"

---

## All Context Variables Reference

| Variable               | What it includes                  |
| :--------------------- | :-------------------------------- |
| `#file:<path>`         | Specific file contents            |
| `#editor`              | Currently open/active file        |
| `#selection`           | Currently highlighted text        |
| `#terminalLastCommand` | Last terminal command + output    |
| `#terminalSelection`   | Selected text in terminal         |
| `#codebase`            | Workspace index (semantic search) |
| `@workspace`           | Full workspace search             |
| `@vscode`              | VS Code API and settings          |
| `@github`              | Repository metadata, issues, PRs  |
| `#sym:<symbol>`        | Specific code symbol definition   |

---

## Summary

Mastering context variables is the difference between vague, generic Copilot responses and precise, actionable answers. Always provide the most targeted context possible.

## Next Steps

Continue with [Lab 030 - Agent Tools](../030-AgentTools/README.md)

---

## Tasks

## Task 01 - Use `#file` for Targeted Context

**Scenario:** Reference two specific files to compare their error handling patterns.

**Hint:** Use `#file:path/to/file` for each file.

??? success "Solution"

    ````
    #file:src/services/OrderService.ts
    #file:src/services/PaymentService.ts

    Compare the error handling in these two services. Are they consistent?
    What should be standardized?
    ```

---

## Task 02 - Use `#editor` for the Open File

**Scenario:** Ask about the file you have open without typing its path.

**Hint:** `#editor` always refers to the active tab.

??? success "Solution"

    1. Open the file you want to work with
    2. Chat:
    `        #editor
       Identify all exported functions that are missing return type annotations.
       `

---

## Task 03 - Use `#selection` for a Specific Block

**Scenario:** Get review feedback on 10 lines, not the whole file.

**Hint:** Highlight the lines first, then reference `#selection`.

??? success "Solution"

    1. Select the 10-line block
    2. Chat:
    `        #selection
       Review for correctness, null safety, and missing error handling.
       `

---

## Task 04 - Use `#terminalLastCommand` to Debug

**Scenario:** After a failed command, use Copilot to diagnose the error.

**Hint:** Run the failing command first, then use `#terminalLastCommand` in Chat.

??? success "Solution"

    1. Run `npm test` - some tests fail
    2. In Chat:
    `        #terminalLastCommand
       Explain these test failures and tell me how to fix them.
       `

---

## Task 05 - Use `@workspace` for Architecture Questions

**Scenario:** Find all places where the database is queried outside the repository layer.

**Hint:** `@workspace` does a semantic search across all files.

??? success "Solution"

    `     @workspace Find all places where we directly query the database
    outside of the repository pattern (bypassing the service/repository layers).
    List the file:line for each occurrence.
    `

---

## Task 06 - Combine Multiple Context Variables

**Scenario:** Plan a new feature by combining workspace knowledge with specific file context.

**Hint:** Use `@workspace` + multiple `#file:` references in one prompt.

??? success "Solution"

    ````

    @workspace I'm adding a Notifications feature.

    #file:src/services/UserService.ts
    #file:src/models/User.ts
    #file:src/controllers/UserController.ts

    What's the minimal set of changes needed to add email notifications
    when a user's order status changes to 'shipped'?
    List each file to change and what to add.
    ```
