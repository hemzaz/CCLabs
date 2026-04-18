# Lab 008 - Documentation

!!! hint "Overview"

    - In this lab, you will use GitHub Copilot to auto-generate documentation for your codebase.
    - You will generate JSDoc comments, Python docstrings, README files, and inline explanations for complex logic.
    - Copilot can infer parameter types, return values, and intended behavior directly from function signatures and bodies.
    - By the end of this lab, you will have a documentation workflow that keeps your code self-documenting with minimal effort.

## Prerequisites

- Completed [Lab 007 - Refactoring](../007-Refactoring/README.md)

## What You Will Learn

- How to generate docstrings and JSDoc with the `/doc` command
- How to write README files with Copilot
- How to add inline comments to explain complex logic

---

## Lab Steps

## Step 1 - Generate Docstrings (Python)

Given this function:

```python
def find_duplicates(items: list) -> list:
    seen = set()
    duplicates = []
    for item in items:
        if item in seen:
            duplicates.append(item)
        seen.add(item)
    return list(set(duplicates))
```

Select it and use `/doc` in Chat, or place your cursor above the function and type:

```python
"""
```

Copilot will auto-complete the docstring.

## Step 2 - Generate JSDoc (JavaScript/TypeScript)

```typescript
function calculateCompoundInterest(
  principal: number,
  rate: number,
  time: number,
  n: number,
): number {
  return principal * Math.pow(1 + rate / n, n * time);
}
```

Place your cursor above the function and type `/**` - Copilot will generate a complete JSDoc comment.

## Step 3 - Add Inline Comments

Select a complex piece of code and ask:

```
Add clear inline comments to explain what each step of this algorithm does.
```

## Step 4 - Generate a README

Open Copilot Chat and type:

```
@workspace Generate a README.md for this project with sections for Overview,
Prerequisites, Installation, Usage, and Contributing.
```

## Step 5 - Document an API

Given a REST controller, ask:

```
Generate OpenAPI/Swagger documentation comments for all endpoints in this controller class.
```

---

## Summary

Auto-generating documentation saves time and ensures every function is documented consistently.

## Next Steps

Continue with [Lab 009 - Security](../009-Security/README.md)

---

## Tasks

## Task 01 - Generate a Docstring

**Scenario:** Add a complete docstring to an undocumented function.

**Hint:** Select the function, `Cmd+I` → "Add a Google-style Python docstring"

??? success "Solution"

    1. Select a function without any documentation
    2. `Cmd+I` → "Add a Google-style Python docstring with Args, Returns, Raises, and Example sections"
    3. Verify all parameters and return types are described

---

## Task 02 - Generate a README

**Scenario:** Your project has no README. Generate one from the codebase.

**Hint:** `@workspace Generate a README.md`

??? success "Solution"

    `     @workspace Generate a comprehensive README.md with:
    - Project name and one-paragraph description
    - Prerequisites and installation steps
    - Quick start / usage example
    - Configuration options (environment variables)
    - Contributing guide
    - License section
    `

---

## Task 03 - Document an API Endpoint

**Scenario:** Add JSDoc comments to a REST route handler.

**Hint:** Reference the route file and ask for OpenAPI-style comments.

??? success "Solution"

    ```
    #file:src/routes/users.ts

    Add JSDoc to each route handler with:
    - @route method and path
    - @param description for path/query params
    - @returns description of response shape
    - @throws list of possible HTTP error codes
    ```

---

## Task 04 - Generate a CHANGELOG Entry

**Scenario:** Format 5 merged PR descriptions as a proper CHANGELOG entry.

**Hint:** Paste the PR titles, ask for Keep a Changelog format.

??? success "Solution"

    ```
    Format these PRs as a CHANGELOG.md entry for version 2.4.0 using Keep a Changelog format
    (Added / Changed / Fixed / Removed sections):

    - PR #241: Add bulk import endpoint for users
    - PR #238: Fix race condition in session refresh
    - PR #235: Remove deprecated /v1/legacy endpoint
    - PR #233: Upgrade password hashing to Argon2
    - PR #229: Add dark mode support
    ```

---

## Task 05 - Add Inline Comments to an Algorithm

**Scenario:** A complex sorting algorithm has no inline comments.

**Hint:** Select the algorithm, ask for one comment per logical block.

??? success "Solution"

    ```
    #selection

    Add inline comments explaining each step of this algorithm.
    One comment per logical block. Use plain English - do not restate the code.
    ```

---

## Task 06 - Generate a CONTRIBUTING.md

**Scenario:** New contributors don't know how to submit PRs or set up the project.

**Hint:** `@workspace Generate a CONTRIBUTING.md`

??? success "Solution"

    `     @workspace Generate a CONTRIBUTING.md covering:
    - Development environment setup
    - How to run tests
    - Branching strategy and naming conventions
    - Commit message format (Conventional Commits)
    - Pull request checklist
    - Code review process
    `
