# Lab 016 - Commit Messages & Git Workflow

!!! hint "Overview"

    - GitHub Copilot integrates with VS Code's Source Control panel to help you write meaningful commit messages.
    - It analyzes your staged diff and suggests a structured commit message following conventions like Conventional Commits.
    - In this lab, you will use Copilot to generate, refine, and customize commit messages for a variety of change types.
    - By the end of this lab, you will have a consistent, AI-assisted commit workflow that improves your Git history quality.

## Prerequisites

- Completed [Lab 015 - Multi-File Editing](../015-MultiFileEditing/README.md)
- A Git repository with some staged changes

## What You Will Learn

- How Copilot generates commit messages from staged diffs
- How to write conventional commits with Copilot
- How Copilot can explain `git log`, `git diff`, and `git blame` output
- Using Copilot to write meaningful PR descriptions

---

## Lab Steps

## Step 1 - Auto-Generate Commit Messages

1. Make some changes to files in your workspace
2. Stage the changes (`git add`)
3. Open the **Source Control** panel in VS Code (`Ctrl+Shift+G`)
4. Click the **✨ Generate commit message** sparkle icon

Copilot analyzes the full diff and writes a commit message following the staged changes.

## Step 2 - Conventional Commits

Ask Copilot Chat to format commit messages as [Conventional Commits](https://www.conventionalcommits.org/):

```
Write a conventional commit message for these changes:
- Added email validation to the registration form
- Fixed the error message not showing on invalid input
- Removed the deprecated validateLegacyEmail() function
```

Expected format:

```
feat(auth): add email validation to registration form

- Add Zod schema validation for email format
- Display inline error message on invalid input
- Remove deprecated validateLegacyEmail() (replaced by Zod)

BREAKING CHANGE: validateLegacyEmail() removed from auth utils
```

## Step 3 - Explain a Git Diff

Paste or pipe a diff into Copilot:

```bash
git diff HEAD~1 | pbcopy  # macOS
```

Then in Chat:

```
Explain what changed in this diff and what the impact might be:
[paste diff here]
```

## Step 4 - Explain Git Blame Output

```
#terminalLastCommand
I ran `git blame src/payment/processor.ts`.
Who introduced the retry logic and roughly when?
Should any of these sections be refactored?
```

## Step 5 - Write a Pull Request Description

After implementing a feature, ask:

```
@workspace I just implemented JWT refresh token support.
The changes are in src/auth/. Write a pull request description with:
- Summary of what changed and why
- Testing instructions
- Screenshots placeholder
- Breaking changes (if any)
- Related issues checklist
```

## Step 6 - Automate with `.github/copilot-instructions.md`

Add commit message guidelines to your Copilot instructions file:

```markdown
## Git Conventions

- Use Conventional Commits format: type(scope): description
- Types: feat, fix, docs, style, refactor, test, chore
- Scope is the module/component name
- Keep subject line under 72 characters
- Reference Jira ticket in footer: Refs: PROJ-123
```

Now Copilot's auto-generated commit messages will follow your team's conventions.

---

## Commit Message Patterns Reference

| Type       | When to Use                       |
| :--------- | :-------------------------------- |
| `feat`     | New feature                       |
| `fix`      | Bug fix                           |
| `docs`     | Documentation only                |
| `refactor` | Code change with no feature/fix   |
| `test`     | Adding or fixing tests            |
| `chore`    | Build process, dependency updates |
| `perf`     | Performance improvement           |
| `ci`       | CI configuration changes          |
| `revert`   | Reverting a previous commit       |

---

## Summary

AI-assisted commit messages and PR descriptions reduce cognitive overhead and help maintain a clean, readable Git history that serves as living documentation.

## Next Steps

Continue with [Lab 017 - Pull Requests](../017-PullRequests/README.md)

---

## Tasks

## Task 01 - Generate a Commit Message from Staged Diff

**Scenario:** Stage some changes and use Copilot to write the commit message.

**Hint:** Stage files in Source Control, then click the Copilot sparkle icon in the message box.

??? success "Solution"

    1. Make changes to 2-3 files
    2. Stage them in the Source Control panel (`Cmd+Shift+G`)
    3. Click the **Generate Commit Message** (sparkle ✨) button next to the message input
    4. Review and edit if needed, then commit

---

## Task 02 - Configure Conventional Commits Format

**Scenario:** Make Copilot always generate commit messages in Conventional Commits format.

**Hint:** Add an instruction to `.github/copilot-instructions.md`.

??? success "Solution"

    Add to `.github/copilot-instructions.md`:
    ``markdown
    ## Commit Messages
    Always use Conventional Commits format:
    `type(scope): description`
    Types: feat, fix, docs, style, refactor, test, chore, perf
    Scope: optional, use the module/area affected (e.g., auth, orders, db)
    Example: `feat(orders): add bulk import endpoint`
    ``

---

## Task 03 - Write a Commit for a Bug Fix

**Scenario:** You fixed a null pointer exception. Write an appropriate commit message.

**Hint:** Stage the fix, use `git commit` with `--message` flag or the Copilot button.

??? success "Solution"

    After staging the fix, Copilot should generate something like:
    ```
    fix(user-service): prevent null pointer when user has no profile

    Guard against missing profile object in getUserDisplayName() when
    the user record exists but the profile relation is null.
    ```

---

## Task 04 - Write a Multi-Scope Commit Message

**Scenario:** One commit touches the API, the database, and the tests.

**Hint:** Ask Copilot to summarize all three changes in one message.

??? success "Solution"

    If Copilot's auto-generate is too short, follow up:
    `     The staged changes touch three areas: the API route, the database schema, and tests.
    Write a commit message that covers all three with a summary line and bullet points.
    `

---

## Task 05 - Compare AI vs Manual Commit Messages

**Scenario:** Write a manual commit message, then compare it with Copilot's version.

**Hint:** Write yours first, then ask Copilot to improve it.

??? success "Solution"

    Your version: `"updated user stuff"`

    Ask:
    ```
    Improve this commit message to follow Conventional Commits:
    "updated user stuff"

    The actual change: added email verification step to the registration flow,
    requiring users to confirm their email before logging in.
    ```

---

## Task 06 - Generate a Squash Commit Message

**Scenario:** You have 8 commits on a feature branch. Generate a single squash commit message.

**Hint:** Paste the 8 individual commit messages and ask Copilot to consolidate.

??? success "Solution"

    ```
    I'm squashing these 8 commits into one. Write a single Conventional Commits
    message that summarizes all of them:

    - "wip: start user profile feature"
    - "add profile model"
    - "fix typo in migration"
    - "add profile service"
    - "add profile controller"
    - "add tests for profile service"
    - "fix failing test"
    - "add profile to user response"

    The final commit name should follow: feat(scope): description
    ```
