# Lab 003 - Chat Features

!!! hint "Overview"

    - In this lab, you will explore the GitHub Copilot Chat panel
    - a conversational interface built into VS Code.
    - You will learn how to ask questions about code, request explanations of unfamiliar functions, and get contextual guidance.
    - You will use slash commands such as `/explain`, `/fix`, `/tests`, and `/doc` to trigger targeted AI actions.
    - By the end of this lab, you will be comfortable using Chat as a pair-programming companion without leaving your editor.

## Prerequisites

- Completed [Lab 002 - Code Completion](../002-CodeCompletion/README.md)
- GitHub Copilot Chat extension installed

## What You Will Learn

- How to open and use the Copilot Chat panel
- Asking questions about code and concepts
- Using `/` commands (slash commands) in chat
- Using `@` context variables to include files and workspaces

---

## Lab Steps

## Step 1 - Open Copilot Chat

1. Click the **GitHub Copilot Chat** icon in the Activity Bar (or press `Ctrl+Alt+I` / `Cmd+I`)
2. The Chat panel opens on the right side

## Step 2 - Ask a Question

Try asking a general programming question:

```
What is the difference between a stack and a queue?
```

Then ask something specific to your code:

```
How do I read a JSON file in Python?
```

## Step 3 - Explain Code

1. Select a block of code in your editor
2. Right-click and choose **Copilot > Explain This**
   (or type `/explain` in the chat panel)

Copilot will explain what the selected code does in plain English.

## Step 4 - Slash Commands

| Command     | Description                              |
| :---------- | :--------------------------------------- |
| `/explain`  | Explain selected code                    |
| `/fix`      | Fix errors in selected code              |
| `/tests`    | Generate unit tests for selected code    |
| `/doc`      | Generate documentation for selected code |
| `/simplify` | Simplify selected code                   |
| `/optimize` | Suggest optimizations                    |

Try each command on different code snippets.

## Step 5 - Context Variables

Use `@` to include context in your chat:

- `@workspace` - Ask questions about your entire workspace
- `@vscode` - Ask about VS Code features and settings
- `@terminal` - Reference terminal output

Example:

```
@workspace What files handle authentication in this project?
```

---

## Summary

You can now use the Copilot Chat panel effective for code explanation, debugging, and learning.

## Next Steps

Continue with [Lab 004 - Inline Chat](../004-InlineChat/README.md)

---

## Tasks

## Task 01 - Explain Code

**Scenario:** You open a one-liner you don't understand and want a plain-English explanation.

**Hint:** Select the code, open Chat, type `/explain`.

??? success "Solution"

    1. Select:


    ```python
    result = list(map(lambda x: x**2, filter(lambda x: x % 2 == 0, range(20))))

    ```
    2. Chat → `/explain`
    3. Follow up: "Rewrite this as a list comprehension for readability"

---

## Task 02 - Ask a Conceptual Question

**Scenario:** You want to understand the difference between `==` and `is` in Python.

**Hint:** Ask as a plain question in the Chat panel.

??? success "Solution"

    `     What is the difference between == and is in Python?
    Give me a code example where they produce different results.
    `

---

## Task 03 - Fix Broken Code with `/fix`

**Scenario:** Find and fix a syntax error on a function with a missing comma.

**Hint:** Select the broken code and use `/fix`.

??? success "Solution"

    1. Paste:


    ```python
    def calculate(x y):
        return x + y

    ```
    2. Select it → Chat → `/fix`
    3. Copilot identifies the missing comma and generates the fix

---

## Task 04 - Request a Code Example

**Scenario:** You want to see how to read a CSV file without remembering the exact API.

**Hint:** Ask a natural language question.

??? success "Solution"

    `     Show me how to read a CSV file into a list of dictionaries in Python.
    Assume the first row is the header. Handle file-not-found gracefully.
    `

---

## Task 05 - Compare Two Approaches

**Scenario:** Decide whether to use a list comprehension vs a for loop.

**Hint:** Ask Copilot to compare both.

??? success "Solution"

    `     Compare list comprehensions vs for loops in Python:
    1. Performance
    2. Readability
    3. When to prefer each
    Show a side-by-side example converting a list of strings to uppercase.
    `

---

## Task 06 - Diagnose an Error Message

**Scenario:** You get a cryptic `ValueError` and don't understand the cause.

**Hint:** Paste the full error message into Chat.

??? success "Solution"

    ```
    I'm getting this error:
    ValueError: too many values to unpack (expected 2)

    Code: a, b = get_coordinates()

    What causes this and how do I fix it?
    ```
