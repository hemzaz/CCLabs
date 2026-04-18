# Lab 009 - Security

!!! hint "Overview"

    - In this lab, you will use GitHub Copilot to identify and fix common security vulnerabilities in code.
    - You will address issues such as SQL injection, XSS, insecure deserialization, hardcoded secrets, and improper error handling.
    - Copilot can suggest defensive coding patterns, safe library alternatives, and input sanitization strategies.
    - By the end of this lab, you will be able to integrate Copilot into your security review workflow to catch issues early.

## Prerequisites

- Completed [Lab 008 - Documentation](../008-Documentation/README.md)

## What You Will Learn

- How Copilot identifies potential security vulnerabilities
- How to fix SQL injection, XSS, and path traversal issues
- How to use Copilot to review code for OWASP Top 10 vulnerabilities
- How to generate secure code from the start

---

## Lab Steps

## Step 1 - Fix SQL Injection

Copilot can identify and fix SQL injection vulnerabilities:

```python
# VULNERABLE: Don't do this!
def get_user(username):
    query = f"SELECT * FROM users WHERE username = '{username}'"
    return db.execute(query)
```

Select the code and ask:

```
This code has a SQL injection vulnerability. Fix it using parameterized queries.
```

## Step 2 - Fix Cross-Site Scripting (XSS)

```javascript
// VULNERABLE: Don't do this!
function renderUserComment(comment) {
  document.getElementById("comments").innerHTML = comment;
}
```

Ask Copilot:

```
This code is vulnerable to XSS. Fix it to safely render user-provided content.
```

## Step 3 - Secure Password Handling

```python
# INSECURE: Don't store passwords like this!
def create_user(username, password):
    db.insert("INSERT INTO users VALUES (?, ?)", (username, password))
```

Ask:

```
Fix this code to properly hash passwords before storing them using bcrypt.
```

## Step 4 - Scan Code for Security Issues

Select an entire file or function and ask:

```
Review this code for security vulnerabilities based on OWASP Top 10.
List any issues found and suggest fixes.
```

## Step 5 - Generate Secure Code from Scratch

Ask Copilot to generate secure implementations:

```
Write a secure file upload handler in Python that:
- Validates file type (only allow images)
- Limits file size to 5MB
- Sanitizes the filename
- Stores files outside the web root
```

---

## Security Checklist with Copilot

| Vulnerability     | Prompt to Use                                              |
| :---------------- | :--------------------------------------------------------- |
| SQL Injection     | `Fix SQL injection using parameterized queries`            |
| XSS               | `Sanitize HTML output to prevent XSS`                      |
| Path Traversal    | `Fix path traversal vulnerability`                         |
| Hardcoded Secrets | `Replace hardcoded credentials with environment variables` |
| Weak Crypto       | `Replace MD5/SHA1 with a secure hashing algorithm`         |

---

## Summary

GitHub Copilot is a valuable security assistant - always review its suggestions critically and test thoroughly.

## Next Steps

Continue with [Lab 010 - Agent Mode](../010-AgentMode/README.md)

---

## Tasks

## Task 01 - Find SQL Injection Vulnerabilities

**Scenario:** Review a data access layer for SQL injection risks.

**Hint:** Show the query-building code, ask for a security review.

??? success "Solution"

    ```
    #file:src/db/queries.py

    Review for SQL injection vulnerabilities.
    Rate each issue Critical/High/Medium/Low and provide a fixed version.
    ```
    Look for: string formatting in SQL, missing parameterized queries.

---

## Task 02 - Remove Hardcoded Credentials

**Scenario:** A secret key is hardcoded in the source code.

**Hint:** Ask Copilot to move it to environment variables with a startup validation.

??? success "Solution"

    Show: `API_KEY = "sk-abc123hardcoded"` then ask:
    ```
    Refactor this to load from an environment variable.
    Add a startup check that raises an error if the variable is not set.
    ```

---

## Task 03 - Audit Input Validation

**Scenario:** A registration endpoint accepts raw input. Find missing validation.

**Hint:** Show the endpoint and ask for a security audit.

??? success "Solution"

    ```
    #file:src/controllers/AuthController.ts

    Audit the register endpoint for missing input validation:
    - Email format, password strength, field length limits
    - Mass assignment protection (unexpected fields)
    - Rate limiting
    ```

---

## Task 04 - Fix an IDOR Vulnerability

**Scenario:** An API lets users fetch any record by ID without ownership checks.

**Hint:** Show the route, ask Copilot to add an authorization check.

??? success "Solution"

    ```
    #selection

    This endpoint fetches an order by ID without verifying the authenticated user
    owns it. Add an ownership check that returns 403 Forbidden if the order belongs
    to a different user.
    ```

---

## Task 05 - Identify XSS Risks

**Scenario:** A React component uses `dangerouslySetInnerHTML`.

**Hint:** Show the component and ask for XSS analysis.

??? success "Solution"

    ```
    #file:src/components/UserBio.tsx

    Analyze the XSS risk of using dangerouslySetInnerHTML here.
    Suggest: using DOMPurify for sanitization, or an alternative safe renderer.
    ```

---

## Task 06 - Generate a Security Checklist

**Scenario:** Before deploying the API, create a pre-deployment security checklist.

**Hint:** `@workspace Generate a security checklist`

??? success "Solution"

    ```
    @workspace Generate a pre-deployment security checklist for this API covering:
    authentication, authorization, input validation, secrets management,
    HTTPS, rate limiting, logging (no PII leakage), dependency vulnerabilities,
    and error handling.
    ```
