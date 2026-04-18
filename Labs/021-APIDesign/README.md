# Lab 021 - API Design with Copilot

!!! hint "Overview"

    - In this lab, you will use GitHub Copilot to design, scaffold, document, and test REST and GraphQL APIs.
    - Copilot excels at generating consistent, well-structured API code including routes, controllers, validation, and error handling.
    - You will generate OpenAPI specs, mock servers, and integration tests as part of a complete API development workflow.
    - By the end of this lab, you will be able to use Copilot to prototype and document APIs in a fraction of the usual time.

## Prerequisites

- Completed [Lab 020 - Database Queries](../020-DatabaseQueries/README.md)

## What You Will Learn

- How to design REST endpoints from a requirements description
- How to generate OpenAPI/Swagger documentation
- How to scaffold a full CRUD API with validation and error handling
- How to design GraphQL schemas and resolvers
- How to generate Postman/HTTPie test collections

---

## Lab Steps

## Step 1 - Design from Requirements

Give Copilot your requirements and let it propose the API design:

```
Design a REST API for an e-commerce order management system with these requirements:
- Users can create, view, update, and cancel orders
- Each order has items, quantities, and a shipping address
- Admins can view all orders, filter by status, and update order status
- Orders go through states: pending → confirmed → shipped → delivered → cancelled

Return:
1. HTTP method + path for each endpoint
2. Request body schema (JSON)
3. Response schema
4. Status codes
```

## Step 2 - Scaffold a Full CRUD API

```
@workspace Scaffold a complete Express.js REST API for a Blog resource with:
- TypeScript
- Zod validation for request bodies
- Proper HTTP status codes
- Consistent error response format: { error: string, details?: any }
- JSDoc comments on each route handler
- Routes: GET /posts, GET /posts/:id, POST /posts, PUT /posts/:id, DELETE /posts/:id
```

## Step 3 - Generate OpenAPI Documentation

```
#file:src/routes/posts.ts
#file:src/schemas/post.schema.ts

Generate a complete OpenAPI 3.0 specification (YAML) for these routes.
Include: operation IDs, descriptions, request bodies, response schemas,
error responses, and authentication (Bearer JWT).
```

## Step 4 - Add API Versioning

```
@workspace Our API is at v1. We need to add v2 of the /products endpoint
that:
- Returns paginated results (cursor-based) instead of the current offset pagination
- Adds a `categories` array to each product
- Deprecates the v1 endpoint with a Sunset header

Add the v2 route, keeping v1 fully functional.
```

## Step 5 - Design a GraphQL Schema

```
Design a GraphQL schema for a social media app with:
- Users, Posts, Comments, Likes, and Followers
- Queries: getUser, getFeed, getPost, searchUsers
- Mutations: createPost, likePost, followUser, addComment
- Subscriptions: newComment (for a post), newFollower (for a user)

Include proper input types, connection types for pagination,
and clear field descriptions.
```

## Step 6 - Generate Resolvers

```
#file:schema.graphql

Generate TypeScript GraphQL resolvers for the User and Post types
using Apollo Server. Use DataLoader for batching user lookups
to avoid the N+1 problem.
```

## Step 7 - Generate API Tests

```
#file:src/routes/orders.ts

Generate a complete test suite for the Orders API using supertest and Jest.
Test all routes including:
- Authentication required (401 for unauthenticated requests)
- Valid request/response cycles
- Validation errors (400 with descriptive messages)
- Not found cases (404)
- Forbidden access (403 when non-admin accesses admin routes)
```

## Step 8 - Generate a Postman Collection

```
#file:openapi.yaml

Convert this OpenAPI spec into a Postman Collection v2.1 JSON file.
Include:
- Environment variables for base URL and auth token
- Pre-request scripts for JWT auth
- Test scripts that validate status codes and response schemas
```

---

## REST API Best Practices Reference

| Concern      | Best Practice                                                                  |
| :----------- | :----------------------------------------------------------------------------- |
| Naming       | Plural nouns: `/users`, `/orders`                                              |
| Methods      | GET (read), POST (create), PUT (replace), PATCH (update), DELETE               |
| Status codes | 200 OK, 201 Created, 400 Bad Request, 401 Unauth, 403 Forbidden, 404 Not Found |
| Errors       | Consistent JSON format with `error` and optional `details`                     |
| Pagination   | Cursor-based for large datasets, offset for small                              |
| Versioning   | URL prefix (`/v1/`, `/v2/`) or `Accept` header                                 |

---

## Summary

Copilot can take you from requirements to a fully documented, tested API in a fraction of the time - while enforcing consistent patterns and best practices throughout.

## Next Steps

Continue with [Lab 022 - Docker and Containers](../022-DockerAndContainers/README.md)

---

## Tasks

## Task 01 - Design Endpoints from Requirements

**Scenario:** Describe your domain in plain English and let Copilot propose the REST API design.

**Hint:** List your entities and operations, ask for HTTP methods + paths.

??? success "Solution"

    ```
    Design a REST API for a library management system: - Manage books (search, borrow, return) - Track members and their borrowing history - Librarians can add/remove books and suspend members

    Provide: HTTP method + path, request body schema, response schema, status codes.
    ```

---

## Task 02 - Scaffold a CRUD API

**Scenario:** Generate a complete Express.js CRUD API for a `Product` resource.

**Hint:** Specify the framework, validation library, and error format.

??? success "Solution"

    `     Scaffold a complete TypeScript Express.js CRUD API for a Product resource.
    Use Zod for request validation. Error format: { error: string, details?: object }.
    Routes: GET /products, GET /products/:id, POST /products, PUT /products/:id, DELETE /products/:id.
    Include proper HTTP status codes.
    `

---

## Task 03 - Generate an OpenAPI Spec

**Scenario:** Generate an OpenAPI 3.0 YAML specification from an existing route file.

**Hint:** Reference the route file with `#file:`.

??? success "Solution"

    ```
    #file:src/routes/products.ts
    #file:src/schemas/product.schema.ts

    Generate a complete OpenAPI 3.0 YAML spec for these routes.
    Include: operation IDs, request/response schemas, error responses, Bearer JWT auth.
    ```

---

## Task 04 - Design API Versioning

**Scenario:** Add a v2 endpoint while keeping v1 fully functional.

**Hint:** Describe the breaking change and what makes it a new version.

??? success "Solution"

    `     @workspace Our GET /products uses offset pagination (v1).
    Add a v2 endpoint at /v2/products using cursor-based pagination.
    Keep /v1/products unchanged. Add a Sunset header to v1 with a deprecation date.
    `

---

## Task 05 - Design a GraphQL Schema

**Scenario:** Design a GraphQL schema for a task management app.

**Hint:** Describe types, queries, mutations, and subscriptions.

??? success "Solution"

    `     Design a GraphQL schema for a task management app with:
    - Users, Projects, Tasks, Comments
    - Queries: getProject, getUserTasks, searchTasks
    - Mutations: createTask, assignTask, completeTask, addComment
    - Subscriptions: taskStatusChanged (for a project)
    Include connection types for pagination and proper input types.
    `

---

## Task 06 - Generate API Tests

**Scenario:** Generate a test suite for your API using supertest.

**Hint:** Reference the route file and ask for authentication, validation, and error tests.

??? success "Solution"

    ```
    #file:src/routes/products.ts

    Generate a supertest + Jest test suite for the Products API. Test:
    - 401 for unauthenticated requests
    - 200/201 for valid requests
    - 400 with descriptive errors for invalid input
    - 404 for non-existent resources
    - 403 for unauthorized access
    ```
