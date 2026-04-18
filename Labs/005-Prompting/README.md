# Lab 005 - Prompting Techniques

!!! hint "Overview"

    - In this lab, you will learn prompt engineering patterns that help you get the best results from GitHub Copilot.
    - You will discover how specificity, examples, and structured comments dramatically improve code generation quality.
    - You will practice common prompting strategies such as one-shot examples, step-by-step instructions, and role-setting prefixes.
    - By the end of this lab, you will be able to write prompts that reliably produce accurate, production-ready code.

## Prerequisites

- Completed [Lab 004 - Inline Chat](../004-InlineChat/README.md)

## What You Will Learn

- Principles of effective Copilot prompting
- How to use comments as prompts
- How to provide context (types, examples, constraints)
- Common prompt patterns for code generation

---

## Lab Steps

## Step 1 - Be Specific

Vague prompts give vague results. Compare:

**Vague:**

```python
# sort things
```

**Specific:**

```python
# Sort a list of dictionaries by the 'age' key in descending order
```

Try both and compare the generated output.

## Step 2 - Provide Examples (Few-Shot Prompting)

Show Copilot a pattern and have it continue:

```python
# Convert temperature in Celsius to Fahrenheit
# Example: celsius_to_fahrenheit(0) -> 32.0
# Example: celsius_to_fahrenheit(100) -> 212.0
def celsius_to_fahrenheit(celsius):
```

## Step 3 - Specify Input and Output Types

```typescript
// Function that takes an array of User objects and returns
// a Map<string, User> keyed by user.id
// User type: { id: string; name: string; email: string }
function indexUsersById(users: User[]): Map<string, User> {
```

## Step 4 - Use Step-by-Step Instructions

Break complex tasks into steps:

```python
# Step 1: Read the CSV file from the given path
# Step 2: Filter rows where the 'status' column equals 'active'
# Step 3: Sort filtered rows by 'created_at' in ascending order
# Step 4: Return the result as a list of dictionaries
def get_active_users(csv_path: str) -> list[dict]:
```

## Step 5 - Add Constraints

```javascript
// Generate a secure random password
// Constraints:
//   - Length: exactly 16 characters
//   - Must include uppercase, lowercase, numbers, and symbols
//   - Must NOT use ambiguous characters like 0, O, l, 1
function generatePassword(): string {
```

---

## Prompt Patterns Reference

| Pattern               | When to Use                                     |
| :-------------------- | :---------------------------------------------- |
| **Specific + typed**  | Most code generation tasks                      |
| **Few-shot examples** | When you need a specific format or style        |
| **Step-by-step**      | Complex multi-step logic                        |
| **Constraints**       | Security-sensitive or performance-critical code |
| **Role-based**        | `// As a senior Python developer, implement...` |

---

## Summary

Effective prompting significantly improves code quality. Invest time in writing clear, specific prompts.

## Next Steps

Continue with [Lab 006 - Test Generation](../006-TestGeneration/README.md)

---

## Tasks

## Task 01 - Assign a Role

**Scenario:** Improve answer quality by starting with a role assignment.

**Hint:** "You are a senior [role] expert..."

??? success "Solution"

    ```
    You are a senior database engineer.
    I have a PostgreSQL table with 10 million rows frequently queried by email.
    What indexes should I create and why?
    ```
    Compare to the same question without the role assignment.

---

## Task 02 - Use Input/Output Examples

**Scenario:** Describe a transformation with concrete examples instead of abstract requirements.

**Hint:** "Given input X, output should be Y"

??? success "Solution"

    ```
    Write a function matching these input/output examples:
    - Input: "hello world"  → Output: "HELLO WORLD"
    - Input: ""             → Output: ""
    - Input: "  spaces  "   → Output: "  SPACES  " (preserve whitespace)
    ```

---

## Task 03 - Add Constraints

**Scenario:** Generate code under specific constraints.

**Hint:** State each constraint as a bullet point.

??? success "Solution"

    ```
    Write a function to check if a string is a palindrome.
    Constraints:
    - No external imports
    - Maximum 3 lines
    - Case-insensitive
    - Ignores spaces and punctuation
    ```

---

## Task 04 - Iterative Refinement

**Scenario:** Start with a basic prompt and refine through follow-up messages.

**Hint:** Send one refinement request at a time.

??? success "Solution"

    1. "Write a function to parse a log line"
    2. "Now add support for ISO 8601 timestamps"
    3. "Use a dataclass instead of a dict for the return type"
    4. "Add a type guard to validate the parsed result"
    5. Each message builds on the previous output

---

## Task 05 - Vague vs Specific Prompt

**Scenario:** Experience the quality difference between under-specified and well-specified prompts.

**Hint:** Write both versions for the same task.

??? success "Solution"

    **Vague:** `Write a user function`

    **Specific:**
    ```
    Write a Python function get_user_by_email(email: str) -> Optional[User]
    that queries PostgreSQL with psycopg2.
    - Use parameterized queries (never f-strings)
    - Return None if not found, raise ValueError for invalid email format
    - Close connection in finally block
    ```

---

## Task 06 - Chain of Thought Prompting

**Scenario:** Ask Copilot to reason about the approach before writing code.

**Hint:** Add "Think step by step before writing any code" to your prompt.

??? success "Solution"

    ```
    I need to implement rate limiting for a serverless API.
    Think step by step about what algorithm to use before writing any code:
    - What are the options (token bucket, sliding window, leaky bucket)?
    - Which fits a stateless serverless function best?
    - Then implement your chosen approach.
    ```
