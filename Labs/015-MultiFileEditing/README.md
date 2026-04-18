# Lab 015 - Multi-File Editing with Copilot Edits

!!! hint "Overview"

    - Copilot Edits (the Edits panel) allows you to apply coordinated changes across multiple files simultaneously.
    - This feature is ideal for large refactors, adding new features that span the codebase, or enforcing standards everywhere at once.
    - In this lab, you will use the Edits panel to make synchronized changes across a real multi-file project.
    - By the end of this lab, you will understand how to scope, review, and accept or reject Copilot Edits across an entire change set.

## Prerequisites

- Completed [Lab 014 - Workspace Context](../014-WorkspaceContext/README.md)

## What You Will Learn

- How to open and use the Copilot Edits panel
- How to add files to an edit session
- How to request coordinated multi-file changes
- How to review, accept, and undo proposed diffs
- Practical patterns: adding a feature end-to-end, schema changes, API versioning

---

## Lab Steps

## Step 1 - Open the Copilot Edits Panel

1. Press `Ctrl+Shift+I` (Windows/Linux) or `Cmd+Shift+I` (macOS)
2. The **Copilot Edits** panel opens (separate from Chat)
3. You'll see a file list and a prompt input

## Step 2 - Add Files to the Edit Session

Click the **+** button (or drag files) to add files to the edit context:

- Add all files related to a feature (model, service, controller, tests)
- You can add up to **10 files** per edit session

## Step 3 - Add a Feature Across Files

With `UserModel.ts`, `UserService.ts`, `UserController.ts`, and `user.test.ts` added:

```
Add a `lastLoginAt` timestamp field to the User model.
Update the service to set it on every successful login.
Update the controller to include it in the API response.
Update the tests to cover the new field.
```

Copilot will show **diffs across all 4 files simultaneously**.

## Step 4 - Review and Accept Changes

1. Each file shows a diff with green (additions) and red (removals)
2. Use **Accept All** to apply all changes, or **Accept** per-file
3. Use **Discard** to reject unwanted changes
4. Use **Undo** (`Ctrl+Z` / `Cmd+Z`) to revert after accepting

## Step 5 - Schema-Driven Changes

Add your database schema and migration files, then:

```
The `orders` table needs a new `discount_code` varchar(50) nullable column.
Update the schema definition, create a migration, update the Order model,
update the OrderService to accept and validate discount codes, and update tests.
```

## Step 6 - API Versioning

Add your routes, controllers, and API tests:

```
Add a v2 version of the /users endpoint that returns paginated results
instead of a flat array. Keep v1 working. Update the router and add v2 tests.
```

## Step 7 - Enforce a New Standard Across Files

```
All our service classes are missing input validation.
Add Zod schema validation to every public method in all service files
that currently accept plain objects as parameters.
```

---

## Tips for Effective Multi-File Editing

| Tip                           | Why                                        |
| :---------------------------- | :----------------------------------------- |
| Keep edit sessions focused    | One feature/concern per session            |
| Include test files            | Copilot writes tests to match the changes  |
| Include the schema/model file | Gives Copilot the ground truth for types   |
| Review each diff carefully    | Multi-file changes can have ripple effects |
| Use `/undo` in chat           | Reverts the entire edit session            |

---

## Summary

The Edits panel is your power tool for large-scale refactors. It transforms what used to take hours of manual find-and-replace into a single natural-language request reviewed through an intuitive diff interface.

## Next Steps

Continue with [Lab 016 - Commit Messages](../016-CommitMessages/README.md)

---

## Tasks

## Task 01 - Open the Copilot Edits Panel

**Scenario:** Locate and open the Copilot Edits panel in VS Code.

**Hint:** `Cmd+Shift+I` or look for the Copilot Edits icon in the activity bar.

??? success "Solution"

    1. Press `Cmd+Shift+I` to open Copilot Chat
    2. Click the mode selector at the top → select **Edit**
    3. The Edits panel opens - you can now make multi-file changes
    4. Add files to the working set using the **+** button or by referencing them in your prompt

---

## Task 02 - Rename a Symbol Across Files

**Scenario:** Rename `UserService` to `AccountService` in all files that reference it.

**Hint:** Use the Edits panel and describe the rename across the entire codebase.

??? success "Solution"

    In the Copilot Edits panel:
    `     Rename UserService to AccountService in all files. Update:
    - The class definition
    - All import statements
    - All usage sites
    - Any string references in comments and docs
    `
    Review each file diff before accepting.

---

## Task 03 - Add a Field Consistently Across Files

**Scenario:** Add a `createdBy: string` field to the Order model and update all related files.

**Hint:** Describe the change; the agent identifies all affected files.

??? success "Solution"

    `     Add a createdBy field (string, required) to the Order model.
    Update: the Prisma schema, TypeScript types, service layer (set createdBy from auth context),
    controller validation, and any tests that create Order objects.
    `

---

## Task 04 - Move a Module

**Scenario:** Move `src/utils/dateHelpers.ts` to `src/shared/date.utils.ts` and fix all imports.

**Hint:** Describe the move and the path change.

??? success "Solution"

    `     Move src/utils/dateHelpers.ts to src/shared/date.utils.ts.
    Update every import statement in the codebase to use the new path.
    Do not change the exported function signatures.
    `

---

## Task 05 - Accept and Reject Individual File Changes

**Scenario:** The agent made changes to 5 files. Accept 3 and reject 2.

**Hint:** The Edits panel shows a diff per file with Accept/Reject buttons.

??? success "Solution"

    1. Review each file in the Edits panel diff view
    2. For files you want to keep: click **Accept** (or `Cmd+Enter`)
    3. For files you want to discard: click **Discard** (or `Cmd+Backspace`)
    4. You can also accept individual hunks within a file using the inline diff controls

---

## Task 06 - Undo an Accepted Edit

**Scenario:** You accepted all edits but realized one file has a bug. Undo just that file.

**Hint:** Standard `Cmd+Z` (Undo) works per-file in the editor.

??? success "Solution"

    1. Open the file with the bug
    2. Press `Cmd+Z` multiple times to undo the Copilot edits
    3. The file reverts to its pre-edit state
    4. Alternatively: use **Git: Discard Changes** on that specific file in Source Control
