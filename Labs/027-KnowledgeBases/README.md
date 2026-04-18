# Lab 027 - Knowledge Bases with `.github/copilot-instructions.md`

!!! hint "Overview"

    - The `.github/copilot-instructions.md` file gives GitHub Copilot permanent, repository-wide context about your project.
    - In this lab, you will write instruction files that document your architecture, coding standards, domain vocabulary, and conventions.
    - Copilot reads this file automatically on every interaction, ensuring it always understands your project's specific requirements.
    - By the end of this lab, you will have a knowledge base that consistently steers Copilot toward responses that fit your codebase.

## Prerequisites

- Completed [Lab 026 - Copilot in CLI](../026-CopilotInCLI/README.md)

## What You Will Learn

- How to write effective repository-level instructions
- What content belongs in the instructions file (and what doesn't)
- How to structure domain knowledge for best Copilot performance
- How to combine instructions with per-file `.instructions.md` files

---

## Lab Steps

## Step 1 - Create Your Instructions File

```bash
mkdir -p .github
touch .github/copilot-instructions.md
```

## Step 2 - Write Your First Instructions File

Here is a well-structured example for a full-stack TypeScript project:

```markdown
# GitHub Copilot Instructions

## Project Overview

This is a multi-tenant SaaS application for restaurant order management.
Backend: Node.js 20 + Express + TypeScript
Frontend: React 18 + Vite + TypeScript
Database: PostgreSQL 16 with Prisma ORM
Cache: Redis 7
Message queue: BullMQ

## Architecture

- `/apps/api` - Express REST API (port 4000)
- `/apps/web` - React frontend (port 3000)
- `/packages/shared` - Shared TypeScript types and utilities
- `/packages/db` - Prisma client and migrations

## Coding Standards

- Use TypeScript strict mode. Never use `any`; use `unknown` and narrow types.
- Functions under 30 lines. Classes under 200 lines. Files under 400 lines.
- Error handling: always return `Result<T, AppError>` from service layer functions.
- Test coverage: minimum 80% for service layer, 60% for controllers.
- Async patterns: always use async/await, never .then() chains.

## Domain Vocabulary

- **Tenant**: A restaurant group (may own multiple locations)
- **Location**: A single restaurant branch
- **Shift**: A working period at a location
- **Table Order**: Order placed by a diner at a table
- **Takeout Order**: Order for collection or delivery
- **Ticket**: A kitchen print request for one or more items

## Naming Conventions

- Database tables: snake_case, plural (e.g., `order_items`)
- TypeScript types/interfaces: PascalCase (e.g., `OrderItem`)
- Services: PascalCase + "Service" suffix (e.g., `OrderService`)
- Controllers: PascalCase + "Controller" suffix
- Variables/functions: camelCase
- Constants: SCREAMING_SNAKE_CASE

## API Conventions

- All endpoints prefixed with `/api/v1/`
- Error responses: `{ error: string, code: string, details?: object }`
- Pagination: `{ data: T[], total: number, page: number, pageSize: number }`
- Auth: JWT Bearer token in Authorization header
- Tenant context: `X-Tenant-ID` header (required on all tenant-scoped endpoints)

## Testing

- Unit tests: Vitest (`*.test.ts` in `__tests__/` directories)
- Integration tests: Supertest against test database
- Mock external services with `vi.mock()`
- Test database: use `@testcontainers/postgresql` for integration tests
```

## Step 3 - Add Domain Knowledge Sections

Effective knowledge bases include:

````markdown
## Known Patterns

## Creating a Service Method

All service methods follow this pattern:

```typescript
async methodName(input: ValidatedInput): Promise<Result<Output, AppError>> {
  try {
    // validate business rules
    // interact with database/external services
    return ok(result);
  } catch (error) {
    return err(AppError.from(error));
  }
}
```
````

## Database Queries

Always use Prisma client from `@repo/db`. Never import a second Prisma client.
Use `db.tenant` scope for all tenant queries.

````

## Step 4 - Use Per-File Instructions

For directory-level overrides, create `.instructions.md` files in subdirectories:

```bash
cat > apps/api/src/services/.instructions.md << 'EOF'
---
applyTo: "**/*.ts"
---
All service files in this directory:
- Must extend `BaseService` from `./base.service.ts`
- Must inject `Logger` via constructor
- All public methods must return `Promise<Result<T, AppError>>`
- Never throw exceptions - catch and convert to AppError
EOF
````

## Step 5 - What to Include vs Exclude

**Include:**

- Architecture overview and tech stack
- Coding standards and conventions
- Domain vocabulary and definitions
- Naming conventions
- Error handling patterns
- API conventions
- Testing requirements

**Exclude:**

- Secrets, tokens, or credentials
- Personal preferences (use `.copilotignore` for exclusions)
- Content that applies to only one file (use inline comments instead)
- Very long documents (under 2,000 words is ideal)

## Step 6 - Verify Instructions are Active

After saving, in Copilot Chat:

```
@workspace What are the naming conventions for this project's services?
```

Copilot should answer based on your instructions file, demonstrating it is being read.

---

## Instructions File Hierarchy

| File Location                               | Scope                      |
| :------------------------------------------ | :------------------------- |
| `.github/copilot-instructions.md`           | Entire repository          |
| `src/.instructions.md` with `applyTo: "**"` | All files under `src/`     |
| `src/api/.instructions.md`                  | All files under `src/api/` |
| VS Code User Settings                       | All workspaces (personal)  |

---

## Summary

A well-written `copilot-instructions.md` is like briefing a new developer on your codebase before every session - Copilot will consistently follow your conventions and use your domain vocabulary without repeated prompting.

## Next Steps

Continue with [Lab 028 - Custom Instructions](../028-CustomInstructions/README.md)

---

## Tasks

## Task 01 - Create the Instructions File

**Scenario:** Create `.github/copilot-instructions.md` with your project's tech stack.

**Hint:** Start with the Project Overview and Tech Stack sections.

??? success "Solution"

    ```bash
    mkdir -p .github
    ```

    Create `.github/copilot-instructions.md`:
    ```markdown # Copilot Instructions

    ## Tech Stack
    Backend: Node.js 20 + Express + TypeScript
    Frontend: React 18 + Vite + TypeScript
    Database: PostgreSQL 16 + Prisma ORM
    Cache: Redis 7
    ```

---

## Task 02 - Add Coding Standards

**Scenario:** Ensure Copilot always follows your team's coding conventions.

**Hint:** Add a Coding Standards section with specific rules.

??? success "Solution"

    Add to your instructions file:
    ``markdown
    ## Coding Standards
    - TypeScript strict mode. Never use `any`; use `unknown` and narrow types.
    - Functions under 30 lines. Files under 400 lines.
    - Error handling: always return Result<T, AppError> from service methods.
    - Async: always async/await, never .then() chains.
    - Tests required: 80% coverage minimum for the service layer.
    ``

---

## Task 03 - Add Domain Vocabulary

**Scenario:** Your app has domain-specific terms that differ from everyday language.

**Hint:** Add a Domain Vocabulary section with definitions.

??? success "Solution"

    Add to your instructions file:

    ```markdown
    ## Domain Vocabulary
    - **Tenant**: A company account (may have multiple Users and Projects)
    - **Workspace**: A container for related Projects within a Tenant
    - **Project**: A collection of Tasks
    - **Task**: A unit of work with status, assignee, and due date
    ```

---

## Task 04 - Add API Conventions

**Scenario:** Ensure consistent API design across all generated endpoints.

**Hint:** Document your URL prefix, error format, and pagination scheme.

??? success "Solution"

    Add to your instructions file:

    ```markdown
    ## API Conventions
    - All endpoints prefixed with /api/v1/
    - Error responses: { error: string, code: string, details?: object }
    - Auth: JWT Bearer token in Authorization header
    - Pagination: { data: T[], total: number, page: number, pageSize: number }
    ```

---

## Task 05 - Verify Instructions are Active

**Scenario:** Confirm Copilot is reading your instructions file.

**Hint:** Ask a question whose answer is in your instructions.

??? success "Solution"

    `     @workspace What error format does this project use for API responses?
    What is the minimum test coverage requirement for service methods?
    `
    Copilot should answer from your `copilot-instructions.md` without you specifying the file.

---

## Task 06 - Add Common Code Patterns

**Scenario:** Document the patterns Copilot should follow when generating service methods.

**Hint:** Add a "Known Patterns" section with a code template.

??? success "Solution"

    Add to your instructions:
    ````markdown ## Known Patterns

    ### Service Method Template
    All service methods follow this pattern:
    ```typescript
    async methodName(input: ValidatedInput): Promise<Result<Output, AppError>> {
      try {
        // validate business rules
        // interact with database
        return ok(result);
      } catch (error) {
        return err(AppError.from(error));
      }
    }
    ```
    ````
