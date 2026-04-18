# Lab 017 - Pull Requests with Copilot

!!! hint "Overview"

    - GitHub Copilot integrates with the GitHub Pull Request extension and GitHub.com to assist with the PR workflow.
    - In this lab, you will use Copilot to generate PR summaries, suggest fixes for review comments, and create PR templates.
    - You will also explore Copilot's ability to answer questions about a PR's diff and automatically address reviewer feedback.
    - By the end of this lab, you will be able to use Copilot to accelerate the full pull request lifecycle from opening to merging.

## Prerequisites

- Completed [Lab 016 - Commit Messages](../016-CommitMessages/README.md)
- GitHub Pull Request and Issues extension installed in VS Code

## What You Will Learn

- How Copilot summarizes pull request changes
- How Copilot suggests fixes for PR review comments
- How to use Copilot on GitHub.com for PR review
- How to generate automated PR descriptions and checklists

---

## Lab Steps

## Step 1 - Install the GitHub Pull Requests Extension

1. Open Extensions (`Ctrl+Shift+X`)
2. Search for **GitHub Pull Requests**
3. Install and authenticate with your GitHub account

## Step 2 - Open a PR in VS Code

1. Open the **GitHub Pull Requests** panel
2. Click on any open PR to check it out locally
3. Copilot now has full context of the PR diff

## Step 3 - Summarize a PR

With a PR checked out in VS Code, open Copilot Chat:

```
@workspace Summarize the changes in this pull request.
What is the intent of these changes? Are there any risks?
```

On GitHub.com, click **Copilot** → **Summary** to get an auto-generated PR summary.

## Step 4 - Address Review Comments with Copilot

When a reviewer leaves a comment like:

> "This function is too long, please extract the validation logic"

Click the **Copilot** button next to the review comment → **Suggest Fix**.

Copilot will generate a code change addressing the comment, which you can apply with one click.

## Step 5 - Generate a PR Template

Ask Copilot to create a PR template for your repo:

```
Create a GitHub pull request template (.github/pull_request_template.md)
for a Node.js/TypeScript REST API project. Include sections for:
- Change type (feature/bug/refactor/etc.)
- Description
- Testing done (unit, integration, manual)
- Screenshots
- Breaking changes
- Checklist (tests pass, docs updated, reviewed security)
```

## Step 6 - PR Description from Diff

After making changes, run:

```bash
git diff main...HEAD > /tmp/pr-diff.txt
```

Then in Copilot Chat:

```
#file:/tmp/pr-diff.txt

Using this diff, write a PR description with:
1. "What" - what was changed
2. "Why" - business/technical reason
3. "How" - technical approach taken
4. "Testing" - how to verify the changes work
```

## Step 7 - Automate PR Quality Checks

Create `.github/copilot-instructions.md`:

```markdown
## Pull Request Guidelines

When reviewing or creating PRs:

- Check that every new function has a corresponding unit test
- Flag any hardcoded credentials or API keys
- Verify that database queries use parameterized inputs
- Ensure new API endpoints have OpenAPI documentation
- Check that error responses follow our standard format: { error: string, code: string }
```

---

## Summary

Copilot accelerates the entire PR lifecycle - from writing descriptions to addressing review feedback - reducing the friction of code review and improving PR quality.

## Next Steps

Continue with [Lab 018 - Code Review](../018-CodeReview/README.md)

---

## Tasks

## Task 01 - Generate a PR Summary

**Scenario:** You've pushed a feature branch. Generate a PR description using Copilot.

**Hint:** In the GitHub Pull Requests extension, use the Copilot button to auto-generate.

??? success "Solution"

    1. Install **GitHub Pull Requests** extension in VS Code
    2. Open the **GitHub Pull Requests** panel
    3. Click **Create Pull Request**
    4. Click the **✨ Generate description** button
    5. Edit if needed, then submit

---

## Task 02 - Write a PR Template

**Scenario:** Create a PR template that Copilot and humans will fill in consistently.

**Hint:** Create `.github/pull_request_template.md`

??? success "Solution"

    `     @workspace Generate a .github/pull_request_template.md with sections for:
    - Summary (what changed and why)
    - Type of change (feat/fix/docs/refactor/chore checkboxes)
    - Testing (what tests were added/updated)
    - Checklist (lint, tests pass, docs updated, no secrets)
    - Screenshots (if UI changes)
    `

---

## Task 03 - Address a Review Comment In-Line

**Scenario:** A reviewer commented "this could throw a NullPointerException". Fix it with Copilot.

**Hint:** In the PR diff view, right-click the line → **Copilot: Fix**.

??? success "Solution"

    1. Open the PR review in the GitHub Pull Requests panel
    2. Find the review comment about the NPE
    3. Select the flagged line → `Cmd+I` → "Fix the potential null pointer exception here"
    4. Accept the fix → commit with: `fix: guard against null in UserService per review`

---

## Task 04 - Generate a PR Description from Commits

**Scenario:** Your 5 commits don't have great messages. Generate a PR description from the diff.

**Hint:** Show the git log or diff to Copilot and ask for a PR summary.

??? success "Solution"

    ```
    I have these commits on my feature branch: - 3a1b: wip - 3a2c: more changes - 3a3d: fix - 3a4e: final - 3a5f: done

    The actual changes add user profile pictures with S3 upload.

    Write a clear pull request description including: summary, what changed,
    how to test, and any migration steps.
    ```

---

## Task 05 - Summarize a PR You're Reviewing

**Scenario:** You're assigned to review a large PR. Get a quick summary of what it does.

**Hint:** `@github` extension or GitHub Copilot on GitHub.com.

??? success "Solution"

    In Copilot Chat with GitHub MCP enabled:
    `     @github Summarize pull request #42 in this repository.
    What are the key changes? What should I pay special attention to during review?
    `

---

## Task 06 - Check for Breaking Changes

**Scenario:** Before approving a PR, check if it introduces any breaking API changes.

**Hint:** Show both the old and new API code and ask for a breaking change analysis.

??? success "Solution"

    ```
    #file:src/routes/users.ts

    Compare the current API endpoints with the PR diff below.
    Identify any breaking changes: removed endpoints, changed response shapes,
    new required parameters, or changed status codes.

    [paste the PR diff]
    ```
