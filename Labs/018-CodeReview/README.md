# Lab 018 - Code Review with Copilot

!!! hint "Overview"

    - GitHub Copilot can perform automated code reviews and catch issues before human reviewers see them.
    - In this lab, you will build a code review workflow using Copilot to check for bugs, security issues, and style violations.
    - You will use Copilot both in VS Code before committing and on GitHub.com during an active review to respond to feedback.
    - By the end of this lab, you will have a pre-submit and in-review Copilot workflow that raises your code review standards.

## Prerequisites

- Completed [Lab 017 - Pull Requests](../017-PullRequests/README.md)

## What You Will Learn

- How to use Copilot for self-review before submitting a PR
- How to automate code review with custom review agents
- How to use `/fix` for common code quality issues
- How to configure Copilot code review rules on GitHub.com

---

## Lab Steps

## Step 1 - Pre-Submit Self Review

Before opening a PR, select all changed files and ask:

```
@workspace Review the changes I'm about to submit.
Check for:
1. Missing error handling
2. Functions that are too long (>50 lines)
3. Any hardcoded values that should be constants or config
4. Missing tests for new functions
5. Inconsistency with the existing code style
```

## Step 2 - Enable Copilot Code Review on GitHub

1. Go to your repository settings on GitHub.com
2. Navigate to **Code and automation** → **Code review**
3. Enable **Copilot code review**

Now Copilot will automatically review every PR and leave comments on:

- Potential bugs and logic errors
- Security vulnerabilities
- Performance issues
- Style inconsistencies

## Step 3 - Review for Specific Concerns

**Performance review:**

```
@workspace Review this module for performance issues.
Look for unnecessary database queries in loops (N+1 problem),
missing memoization, and synchronous operations that should be async.
```

**Security review:**

```
@workspace Perform a security review of the authentication module.
Check for: JWT validation issues, session fixation, missing rate limiting,
improper password handling, and CORS misconfigurations.
```

**Accessibility review:**

```
@workspace Review the React components in src/components/ for accessibility issues.
Check for: missing aria labels, keyboard navigation, color contrast, and
semantic HTML usage.
```

## Step 4 - Create a Review Checklist Agent

Create `.github/copilot/agents/reviewer.agent.md`:

```markdown
---
name: Reviewer
description: Performs automated pre-commit code review
model: gpt-4o
tools:
  - codebase
  - problems
---

You are a meticulous code reviewer. For every review:

## Security

- [ ] No hardcoded credentials or secrets
- [ ] SQL queries use parameterization
- [ ] User input is sanitized before use
- [ ] Authentication is required where needed

## Code Quality

- [ ] Functions are single-responsibility (<30 lines)
- [ ] No magic numbers (use named constants)
- [ ] Error cases are handled explicitly
- [ ] No dead code or commented-out blocks

## Testing

- [ ] New functions have unit tests
- [ ] Edge cases are tested
- [ ] Test descriptions clearly state what is being tested

Report issues as: [SEVERITY: CRITICAL/HIGH/MEDIUM/LOW] Description
```

## Step 5 - Fix Review Comments Automatically

When you receive review feedback, paste it into Copilot Chat with the file:

```
#file:src/api/users.ts

A reviewer left this comment:
"The getUserById function makes a database call without checking if the user
has permissions to view this resource. Add authorization check."

Implement this fix.
```

## Step 6 - Review Diff Before Committing

```bash
git diff --staged
```

Then in Chat:

```
#terminalLastCommand

Review these staged changes. Are there any issues I should fix before committing?
```

---

## Code Review Severity Guide

| Level        | Examples                                               |
| :----------- | :----------------------------------------------------- |
| **Critical** | SQL injection, exposed secrets, auth bypass            |
| **High**     | Unhandled errors, data loss risk, broken logic         |
| **Medium**   | Performance issues, poor error messages, missing tests |
| **Low**      | Style inconsistencies, minor naming issues             |

---

## Summary

Building a Copilot-assisted code review workflow catches issues earlier, reduces review cycles, and lets human reviewers focus on higher-level concerns.

## Next Steps

Continue with [Lab 019 - Debugging](../019-Debugging/README.md)

---

## Tasks

## Task 01 - Pre-Submit Self-Review

**Scenario:** Before creating a PR, do a self-review of your staged changes.

**Hint:** Show the git diff to Copilot and ask for a review.

??? success "Solution"

    ````
    Here is my git diff. Review it as a senior developer would before I submit a PR.
    Focus on: correctness, edge cases, security, and anything that might cause issues in production.

    [paste git diff output]
    ```

---

## Task 02 - Review for Performance Issues

**Scenario:** Your PR adds a new database query. Check if it could slow things down.

**Hint:** Show the query and surrounding code.

??? success "Solution"

    ````

    #file:src/services/ReportService.ts

    Review the generateMonthlyReport function for performance issues:
    - N+1 query problems
    - Missing indexes
    - Large result sets loaded into memory
    - Missing pagination
    ```

---

## Task 03 - Generate Review Comments

**Scenario:** You're reviewing a teammate's PR. Use Copilot to draft your review comments.

**Hint:** Show the PR diff and ask Copilot to generate review comments.

??? success "Solution"

    ````
    I'm reviewing this code change. Generate professional, constructive review comments
    for each issue you find:

    [paste the diff]

    Format: file:line - Issue type - Comment
    ```

---

## Task 04 - Create a Custom Reviewer Agent

**Scenario:** Create a `.agent.md` that does code reviews focused on your team's standards.

**Hint:** Reference Lab 012 patterns and specific team conventions.

??? success "Solution"

    Create `.github/copilot/agents/code-reviewer.agent.md`:

    ```markdown
    ---
    name: Code Reviewer
    description: Reviews PRs against team coding standards
    tools: [read_file, search_workspace]
    ---
    Review code for violations of our standards:
    - All functions must have TypeScript return types
    - No console.log in production code
    - Services must return Result<T, AppError>, not throw exceptions
    - Tests required for all service methods
    Rate each issue P0/P1/P2 (blocker/important/suggestion).
    ```

---

## Task 05 - Fix a Review Comment Automatically

**Scenario:** A reviewer says "missing input validation on the userId parameter."

**Hint:** Show the comment and the relevant code, ask Copilot to implement the fix.

??? success "Solution"

    ````

    The code review says: "userId parameter has no validation - could be any string."

    #file:src/controllers/UserController.ts

    Add UUID format validation to the userId parameter in the getUser endpoint.
    Return 400 Bad Request with a descriptive error if the format is invalid.
    ```

---

## Task 06 - Summarize All Review Feedback

**Scenario:** You received 12 review comments. Ask Copilot to group and prioritize them.

**Hint:** Paste all comments into Chat and ask for a prioritized action plan.

??? success "Solution"

    ````
    I received these 12 review comments on my PR. Group them by: 1. Critical (must fix before merge) 2. Important (should fix) 3. Suggestions (optional improvements)
    Then give me an ordered action plan to address them.

    [paste all comments]
    ```
    ````
