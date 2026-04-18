# Lab 05 - BuiltIn Prompts

* In this lab, we will explore how to use `GitHub Copilot's` built-in prompts to upgrade and maintain our calculator code.
* Those built-in prompts help you quickly generate explanations, documentation, and tests for your code.
* Those commands are available in both Chat and Inline Chat modes and known as `Slash commands`

---

## Overview

* GitHub Copilot provides several slash commands that act as shortcuts for common tasks:

    | Command     | Description                                          |
    |:------------|:-----------------------------------------------------|
    | `/clear`    | Clear the session context.                           |
    | `/doc`      | Generate documentation for the selected code.        |
    | `/explain`  | Explain how the selected code works.                 |
    | `/ext`      | Commands for VS Code extension development.          |
    | `/fix`      | Propose a fix for the problems in the selected code. |
    | `/help`     | Get help about using GitHub Copilot.                 |
    | `/notebook` | Commands for working with Jupyter Notebooks.         |
    | `/tests`    | Generate unit tests for the selected code.           |
    | `/vscode`   | Commands for VS Code specific questions.             |

----

## Exercises

### 1. Explain Code

1.  Open `calculator/calculator.py`.
2.  Select the `divide` function.
3.  Open the Chat view and type `/explain`.
4.  Review the explanation provided by Copilot.

### 2. Generate Documentation

1.  Select the `subtract` function in `calculator/calculator.py`.
2.  Type `/doc` in the Chat or right-click inside the `calculator.py`  and select **Copilot > Generate Docs**.
3.  Observe how Copilot adds docstrings to your function.

### 3. Generate Tests

1.  Select the entire content of `calculator/calculator.py`.
2.  Type `/tests` in the Chat.
3.  Copilot will suggest a new test file or add tests to an existing one.
4.  Review the generated tests and ensure they cover edge cases (like division by zero).

