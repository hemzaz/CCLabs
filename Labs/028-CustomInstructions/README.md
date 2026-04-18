# Lab 028 - Custom Instructions

!!! hint "Overview"

    - GitHub Copilot supports multiple types of custom instruction files that tailor its behavior at different scopes.
    - In this lab, you will configure user-level preferences, repository-level conventions, and pattern-matched instruction files.
    - You will explore `.prompt.md` files for reusable prompt templates and understand the precedence rules between instruction types.
    - By the end of this lab, you will have a layered instruction strategy that makes Copilot behave consistently across all contexts.

## Prerequisites

- Completed [Lab 027 - Knowledge Bases](../027-KnowledgeBases/README.md)

## What You Will Learn

- The difference between user-level and repo-level instructions
- How `.instructions.md` files work with `applyTo` patterns
- How to create prompt files (`.prompt.md`) for reusable tasks
- How to configure instructions in VS Code user settings

---

## Lab Steps

## Step 1 - User-Level Instructions (VS Code Settings)

These apply to all your conversations across all projects.

1. Open VS Code Settings (`Cmd+,`)
2. Search for "copilot instructions"
3. Add to `settings.json`:

```json
{
  "github.copilot.chat.codeGeneration.instructions": [
    {
      "text": "Always add return type annotations to all functions."
    },
    {
      "text": "Prefer functional approaches over imperative ones when practical."
    },
    {
      "text": "When generating tests, use AAA pattern (Arrange, Act, Assert) with descriptive test names."
    }
  ],
  "github.copilot.chat.reviewSelection.instructions": [
    {
      "text": "Review for security vulnerabilities (XSS, injection, path traversal) as well as logic errors."
    }
  ],
  "github.copilot.chat.commitMessageGeneration.instructions": [
    {
      "text": "Use Conventional Commits format: type(scope): description. Types: feat, fix, docs, style, refactor, test, chore."
    }
  ]
}
```

## Step 2 - Repo-Level Instructions with `applyTo`

Create instruction files that apply only to specific file patterns:

```bash
# Instructions for all TypeScript files
mkdir -p .github/instructions
cat > .github/instructions/typescript.instructions.md << 'EOF'
---
applyTo: "**/*.ts,**/*.tsx"
---
- Use TypeScript strict mode (as per tsconfig.json)
- Prefer interfaces over type aliases for object shapes
- Always handle null/undefined explicitly; avoid non-null assertions (!)
- Use readonly for properties that should not be mutated
EOF

# Instructions for test files
cat > .github/instructions/testing.instructions.md << 'EOF'
---
applyTo: "**/*.test.ts,**/*.spec.ts,**/*.test.tsx"
---
- Use Vitest, not Jest
- Group related tests with describe blocks
- Use vi.mock() for external module mocking
- Use @testing-library/user-event for simulating user interactions (not fireEvent)
- Test filenames must match source file: Button.tsx → Button.test.tsx
EOF

# Instructions for React components
cat > .github/instructions/react.instructions.md << 'EOF'
---
applyTo: "src/components/**/*.tsx"
---
- Use functional components only, never class components
- Use named exports, never default exports
- Declare prop types as an interface named `{ComponentName}Props`
- Place prop destructuring in function signature
- Use Tailwind CSS for styling, never inline styles or CSS modules
EOF
```

## Step 3 - Create Reusable Prompt Files (`.prompt.md`)

Prompt files are saved, parameterized prompts you can invoke by name:

```bash
mkdir -p .github/prompts

cat > .github/prompts/code-review.prompt.md << 'EOF'
---
mode: ask
description: Perform a thorough code review on the selection
---
Review the selected code for:

1. **Correctness** - Logic errors, edge cases, off-by-one errors
2. **Security** - Injection, XSS, insecure dependencies, hardcoded secrets
3. **Performance** - N+1 queries, unnecessary re-renders, inefficient algorithms
4. **Maintainability** - Naming clarity, function length, single responsibility
5. **Test coverage** - Missing test cases, untested edge cases

Format your response as:
## Summary
[1-2 sentence overall assessment]

## Issues Found (sorted by severity: Critical → High → Medium → Low)
For each issue:
- **Severity**: Critical/High/Medium/Low
- **Location**: [file:line]
- **Issue**: [description]
- **Fix**: [suggested fix with code example]
EOF

cat > .github/prompts/generate-tests.prompt.md << 'EOF'
---
mode: edit
description: Generate comprehensive tests for the selected code
---
Generate a complete test file for the selected code using Vitest.

Requirements:
- Test all exported functions and classes
- Cover: happy path, edge cases, error cases
- Use descriptive test names that read as sentences
- Mock all external dependencies
- Aim for 90%+ branch coverage
- Include a `describe` block per function/class
EOF
```

Use prompt files by typing `/` in Copilot Chat and selecting from the list.

## Step 4 - Agent Instruction Files (`.agent.md`)

Create instruction files for agent mode:

```bash
cat > .github/instructions/agent-mode.instructions.md << 'EOF'
---
applyTo: "agent"
---
When running in agent mode:
- Always run tests after making code changes
- Check for lint errors before finishing
- Never modify files in the `dist/` or `build/` directories
- If a migration is required, generate it but do not run it automatically
- Report every file you modified in your final summary
EOF
```

## Step 5 - Instruction Priority Order

When multiple instructions apply, they are merged in this order:

| Priority    | Source                                   | Notes                        |
| :---------- | :--------------------------------------- | :--------------------------- |
| 1 (highest) | VS Code user settings instructions       | Personal, applies everywhere |
| 2           | `.github/copilot-instructions.md`        | Repo-wide                    |
| 3           | `.github/instructions/*.instructions.md` | Pattern-matched              |
| 4           | Inline chat context                      | What you type in the prompt  |

## Step 6 - Test Your Instructions

```
Generate a React component for a UserAvatar that shows the user's profile picture
with a fallback to their initials.
```

Verify that Copilot:

- Uses functional components with named exports
- Uses Tailwind for styling
- Defines a `UserAvatarProps` interface
- Follows all your conventions

---

## Summary

Custom instructions let you codify your team's knowledge and preferences into Copilot's context permanently - turning a generic AI into one that speaks your project's language fluently.

## Next Steps

Continue with [Lab 029 - Context Variables](../029-ContextVariables/README.md)

---

## Tasks

## Task 01 - Add a User-Level Instruction

**Scenario:** Make Copilot always add return type annotations to functions across all projects.

**Hint:** VS Code Settings → `github.copilot.chat.codeGeneration.instructions`

??? success "Solution"

    In `settings.json`:

    ```json
    "github.copilot.chat.codeGeneration.instructions": [
      { "text": "Always add explicit return type annotations to all functions." }
    ]
    ```

---

## Task 02 - Create a TypeScript-Specific Instruction File

**Scenario:** Apply TypeScript conventions only to `.ts` and `.tsx` files.

**Hint:** Create `.github/instructions/typescript.instructions.md` with `applyTo`.

??? success "Solution"

    Create `.github/instructions/typescript.instructions.md`:

    ```markdown
    ---
    applyTo: "**/*.ts,**/*.tsx"
    ---
    - Use TypeScript strict mode
    - Prefer interfaces over type aliases for object shapes
    - Handle null/undefined explicitly; avoid non-null assertions (!)
    - Use readonly for immutable properties
    ```

---

## Task 03 - Create a Test File Instruction

**Scenario:** Apply specific testing conventions only to test files.

**Hint:** Use `applyTo: "**/*.test.ts,**/*.spec.ts"`.

??? success "Solution"

    Create `.github/instructions/testing.instructions.md`:

    ```markdown
    ---
    applyTo: "**/*.test.ts,**/*.spec.ts"
    ---
    - Use Vitest (not Jest)
    - Group related tests with describe blocks
    - Use vi.mock() for external module mocking
    - Use @testing-library/user-event (not fireEvent) for UI interaction tests
    ```

---

## Task 04 - Create a Reusable Prompt File

**Scenario:** Create a `.prompt.md` file for code review that can be re-invoked.

**Hint:** Create `.github/prompts/code-review.prompt.md`.

??? success "Solution"

    Create `.github/prompts/code-review.prompt.md`:

    ````markdown
---
mode: ask
description: Security and quality code review
---

Review the selected code for: 1. Correctness and edge cases 2. Security (injection, XSS, IDOR, hardcoded secrets) 3. Performance (N+1, unnecessary re-renders) 4. Missing tests

    Rate each issue: Critical / High / Medium / Low
    ```
    Invoke with `/code-review` in Chat.

---

## Task 05 - Understand Instruction Priority

**Scenario:** You have conflicting instructions - one says "use semicolons", another says "no semicolons". Which wins?

**Hint:** Ask Copilot to explain instruction priority order.

??? success "Solution"

    Priority (highest to lowest): 1. VS Code user settings instructions (personal, cross-workspace) 2. `.github/copilot-instructions.md` (repo-wide) 3. `.github/instructions/*.instructions.md` (pattern-matched) 4. Inline chat context (your current prompt)

    Later/more specific always overrides earlier/more general.

---

## Task 06 - Create an Agent-Mode Instruction

**Scenario:** Restrict the agent from running migrations automatically.

**Hint:** Use `applyTo: "agent"`.

??? success "Solution"

    Create `.github/instructions/agent-mode.instructions.md`:

    ```markdown
    ---
    applyTo: "agent"
    ---
    When in agent mode:
    - Always run linter and type-check after modifying TypeScript files
    - Never run database migrations automatically - generate them and wait for approval
    - Never modify files in dist/, build/, or generated/ directories
    - Run tests after every code change
    ```

    ````
