# Lab 020 - Database Queries with Copilot

!!! hint "Overview"

    - In this lab, you will use GitHub Copilot to write, optimize, and debug SQL queries and ORM operations.
    - You will generate schema-aware queries with joins, aggregations, and window functions using natural language descriptions.
    - You will also connect Copilot to a live database via MCP for real-time, schema-aware SQL assistance.
    - By the end of this lab, you will be able to generate and refine complex database queries significantly faster than before.

## Prerequisites

- Completed [Lab 019 - Debugging](../019-Debugging/README.md)
- Basic SQL knowledge

## What You Will Learn

- How to generate SQL queries from natural language
- How Copilot understands your schema context
- How to optimize slow queries with Copilot's help
- How to write ORM queries (Prisma, TypeORM, SQLAlchemy)
- How to use MCP for live database interaction

---

## Lab Steps

## Step 1 - Schema-Aware Query Generation

Create a schema file `schema.sql` and reference it:

```sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    role VARCHAR(20) DEFAULT 'user',
    created_at TIMESTAMP DEFAULT NOW(),
    last_login_at TIMESTAMP
);

CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    total DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
    product_name VARCHAR(255) NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL
);
```

With this file open (`#file:schema.sql`), ask:

```
#file:schema.sql

Write a query to find the top 10 customers by total spend in the last 90 days,
including their email, total amount spent, and number of orders.
```

## Step 2 - Query Optimization

Paste a slow query:

```sql
SELECT u.*, COUNT(o.id) as order_count
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
WHERE u.role = 'premium'
GROUP BY u.id
ORDER BY order_count DESC;
```

Ask:

```
This query is running slowly on a table with 500k users and 2M orders.
Analyze it for performance issues and suggest optimizations,
including which indexes to add.
```

## Step 3 - ORM Query Generation (Prisma)

```
#file:prisma/schema.prisma

Write a Prisma query to:
1. Find all users who have placed more than 5 orders
2. Include their most recent order with its items
3. Filter to only active users (status = 'active')
4. Sort by total order count descending
5. Paginate (page size 20)
```

## Step 4 - ORM Query Generation (SQLAlchemy)

```python
# Given these SQLAlchemy models:
class User(Base):
    __tablename__ = 'users'
    id = Column(UUID, primary_key=True)
    email = Column(String(255), unique=True)
    orders = relationship('Order', back_populates='user')

class Order(Base):
    __tablename__ = 'orders'
    id = Column(UUID, primary_key=True)
    user_id = Column(UUID, ForeignKey('users.id'))
    total = Column(Numeric(10, 2))
    user = relationship('User', back_populates='orders')
```

Ask:

```
Write a SQLAlchemy query for the monthly revenue report:
total revenue per month for the last 12 months,
grouped by month and ordered chronologically.
```

## Step 5 - Generate Migration Scripts

```
Add a `subscription_tier` enum column to the users table with values:
'free', 'basic', 'premium', 'enterprise'.
Default existing users to 'free'.
Create a database migration for both PostgreSQL (raw SQL) and Prisma.
```

## Step 6 - Connect to Live Database via MCP

Add to `.vscode/mcp.json`:

```json
{
  "servers": {
    "postgres": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-postgres",
        "${env:DATABASE_URL}"
      ]
    }
  }
}
```

Then in Agent mode:

```
Show me the 5 largest tables in the database and their row counts.
Are there any tables missing indexes on foreign key columns?
```

## Step 7 - Explain Query Plans

```sql
EXPLAIN ANALYZE SELECT ...
```

Paste the EXPLAIN ANALYZE output into Chat:

```
Analyze this PostgreSQL EXPLAIN ANALYZE output and tell me
where the bottleneck is and how to fix it.
[paste output]
```

---

## Summary

Copilot dramatically accelerates database work - from schema-aware query generation to performance optimization - especially when combined with live database access via MCP.

## Next Steps

Continue with [Lab 021 - API Design](../021-APIDesign/README.md)

---

## Tasks

## Task 01 - Schema-Aware Query Generation

**Scenario:** Generate a complex query using your schema file as context.

**Hint:** Reference the schema file with `#file:`.

??? success "Solution"

    ```
    #file:schema.sql

    Write a query to find the top 10 customers by total spend in the last 90 days.
    Include: email, total amount spent, number of orders.
    ```

---

## Task 02 - Optimize a Slow Query

**Scenario:** A query runs slow on a large table. Ask Copilot to optimize it.

**Hint:** Paste the query and describe the table sizes.

??? success "Solution"

    ```
    This query is slow on 500k users and 2M orders:

    SELECT u.*, COUNT(o.id) as order_count
    FROM users u LEFT JOIN orders o ON u.id = o.user_id
    WHERE u.role = 'premium'
    GROUP BY u.id ORDER BY order_count DESC;

    Analyze and suggest optimizations, including indexes to add.
    ```

---

## Task 03 - Write a Prisma Query

**Scenario:** Generate a Prisma query with filtering, sorting, and pagination.

**Hint:** Reference your Prisma schema.

??? success "Solution"

    ```
    #file:prisma/schema.prisma

    Write a Prisma query to find all users who have placed more than 5 orders.
    Include their most recent order. Filter to active users only.
    Sort by order count descending. Paginate (page size 20, cursor-based).
    ```

---

## Task 04 - Generate a Database Migration

**Scenario:** Add a new enum column to the users table.

**Hint:** Describe the column and ask for both raw SQL and Prisma migration.

??? success "Solution"

    `     Add a subscription_tier enum column to the users table.
    Values: 'free', 'basic', 'premium', 'enterprise'. Default for existing rows: 'free'.
    Generate both: raw SQL migration and Prisma schema change.
    `

---

## Task 05 - Configure the PostgreSQL MCP Server

**Scenario:** Connect Copilot to your live database for real-time schema-aware queries.

**Hint:** Add the postgres MCP server to `.vscode/mcp.json`.

??? success "Solution"

    Add to `.vscode/mcp.json`:

    ```json
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres", "${env:DATABASE_URL}"]
    }
    ```

    Then: "Show me the 5 largest tables and their row counts."

---

## Task 06 - Explain a Query Execution Plan

**Scenario:** Paste the output of `EXPLAIN ANALYZE` and ask Copilot to interpret it.

**Hint:** Run `EXPLAIN ANALYZE` on the slow query and paste the output.

??? success "Solution"

    ```
    Analyze this PostgreSQL EXPLAIN ANALYZE output.
    Where is the bottleneck? What should I optimize?

    [paste EXPLAIN ANALYZE output]
    ```
