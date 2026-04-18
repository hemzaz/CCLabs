## Lab 03 - Inline Chat Hands-On

## Steps to Use Inline Chat

### 01. Open Inline Chat:

??? question "Task: Open Inline Chat"

    - This can be done in several ways.
        - Press `Cmd+I` (macOS) or `Ctrl+I` (Windows/Linux).
        - Use the Icon from the `Github Copilot` top icon.
        - Right-click in the editor and select `GitHub Copilot: Open Inline Chat`.
    - Once the Inline Chat panel is open, you can type your request in the input box at the bottom.

### 02. Use Inline Chat

??? question "Task: Use Inline Chat"

    - Mark the multiply function in the code editor.
    - Open Inline Chat using one of the methods described above.
    - In the Inline Chat input box, Here are few example prompts you can use:

        ```
        Refactor this function to use arrow function syntax.
        ```

        ```
        Explain what this function does.
        ```

        ```
        Add documentation comments to this function.
        ```

### 03. Task: Improve Code Quality

- Let's use Inline Chat to make our code more robust and readable.

### 03.01. Add Type Hints:

??? question "Task: Add Type Hints"

    - Select all the code in `calculator/calculator.py` (`Cmd+A` / `Ctrl+A`).
    - Open Inline Chat (`Cmd+I` / `Ctrl+I`).
    - Type: `Add type hints to all functions`.
    - Review the changes (Copilot will show a diff view).
    - Accept the changes.

### 03.02. Add Docstrings

??? question "Task: Add Docstrings"

    - Select all the code again.
    - Open Inline Chat.
    - Type: `Add Google-style docstrings to all functions`.
    - Accept the changes.

### 03.03. Task: Error Handling

??? question "Task: Error Handling"

    - Ensure our calculator handles edge cases gracefully.
    - **Validate Division**: `("Cannot divide by zero.")`
    - Select the `divide` function.
    - Open Inline Chat.
    - Type: `Update this function to raise a ValueError if dividing by zero, if not already present`.
    - Copilot should either confirm it's there or add the check.
    - Accept the changes if any.
