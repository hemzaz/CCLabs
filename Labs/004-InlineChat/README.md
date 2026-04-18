# Lab 004 - Inline Chat

!!! hint "Overview"

    - In this lab, you will learn to use GitHub Copilot's Inline Chat to request changes directly inside the editor.
    - Unlike the Chat panel, Inline Chat lets you highlight a block of code and ask Copilot to refactor or explain it in place.
    - You will practice triggering Inline Chat with `Ctrl+I` / `Cmd+I` and iterating on AI-generated diffs.
    - By the end of this lab, you will understand when to use Inline Chat versus the Chat panel for maximum productivity.

## Prerequisites

- Completed [Lab 003 - Chat Features](../003-ChatFeatures/README.md)

## What You Will Learn

- How to invoke Inline Chat with a keyboard shortcut
- How to ask Copilot to generate, modify, or explain code inline
- How to accept, discard, or regenerate inline responses

---

## Lab Steps

## Step 1 - Open Inline Chat

1. Place your cursor in the editor (or select some code)
2. Press `Ctrl+I` (Windows/Linux) or `Cmd+I` (macOS)
3. An inline input box appears at the cursor position

## Step 2 - Generate Code Inline

Without selecting anything, type a request:

```
write a function to calculate fibonacci numbers
```

Copilot will generate code directly at the cursor. Review it and click **Accept** or **Discard**.

## Step 3 - Modify Selected Code

1. Select an existing function
2. Press `Ctrl+I` / `Cmd+I`
3. Type:

```
add input validation and error handling to this function
```

Copilot will show a diff of the proposed changes. Accept or reject.

## Step 4 - Ask Questions About Code

1. Select a block of code
2. Open Inline Chat and type:

```
explain what this code does line by line
```

The explanation will appear inline without cluttering the Chat panel.

## Step 5 - Regenerate Responses

If you don't like the first suggestion:

1. Click the **↻ Regenerate** button inside the inline response
2. Copilot will generate an alternative

---

## Summary

Inline Chat lets you stay in flow by interacting with Copilot without leaving the editor context.

## Next Steps

Continue with [Lab 005 - Prompting Techniques](../005-Prompting/README.md)

---

## Tasks

## Task 01 - Refactor with Inline Chat

**Scenario:** Flatten a deeply nested `if` block using guard clauses.

**Hint:** Select the code, `Cmd+I`, describe the refactoring.

??? success "Solution"

    1. Select:


    ```python
    if status == "active":
        if balance > 0:
            if not is_suspended:
                return process(user)

    ```
    2. `Cmd+I` → "Refactor using early returns / guard clauses"
    3. Review the diff and click **Accept**

---

## Task 02 - Translate to Another Language

**Scenario:** Convert a Python function to JavaScript without leaving the editor.

**Hint:** Select the Python function, `Cmd+I`, "Convert to JavaScript"

??? success "Solution"

    1. Select a Python function
    2. `Cmd+I` → "Convert this to JavaScript ES2022, using async/await where applicable"
    3. Review - logic should be preserved, syntax updated

---

## Task 03 - Add Error Handling Inline

**Scenario:** Add try/except to a function that currently has no error handling.

**Hint:** Select the function and describe what errors to handle.

??? success "Solution"

    1. Select:


    ```python
    def fetch_user(user_id):
        response = requests.get(f"/api/users/{user_id}")
        return response.json()["user"]

    ```
    2. `Cmd+I` → "Add error handling: HTTP 4xx/5xx, network timeout, missing 'user' key"
    3. Accept the enhanced version

---

## Task 04 - Generate Code on an Empty Line

**Scenario:** Use `Cmd+I` on an empty line to generate a function from scratch.

**Hint:** Place cursor on empty line → `Cmd+I` → describe what you need.

??? success "Solution"

    1. Place cursor on an empty line in a Python file
    2. `Cmd+I` → "Write a function that takes a list of date strings (YYYY-MM-DD) and returns the most recent one"
    3. Accept the generated function

---

## Task 05 - Explain Code Inline

**Scenario:** Get an explanation of a selected expression without opening the Chat panel.

**Hint:** Select → `Cmd+I` → `/explain`

??? success "Solution"

    1. Select a complex lambda or generator expression
    2. `Cmd+I` → `/explain`
    3. Read the explanation below your code
    4. Press `Escape` to dismiss without inserting anything

---

## Task 06 - Optimize a Function Inline

**Scenario:** A function works but is slow. Ask Copilot to optimize it in place.

**Hint:** Select the function → `Cmd+I` → describe the performance goal.

??? success "Solution"

    1. Select a function with a nested loop
    2. `Cmd+I` → "Optimize this function - it's O(n²). Use a set or dict to improve to O(n) if possible"
    3. Review the change and verify the behavior is the same
