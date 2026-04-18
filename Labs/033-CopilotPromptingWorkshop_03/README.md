# Lab 03: Inline Chat

- In this lab, we will explore the **Inline Chat** feature of GitHub Copilot.

## Overview

- Inline Chat allows you to ask Copilot to generate code, refactor existing code, or explain code directly within the editor, without switching to a separate chat window.
- This feature enhances productivity by providing context-aware assistance right where you need it.
- You will learn how to effectively use Inline Chat to improve your coding workflow.

---

<img src="../assets/images/tldr.png" alt="Inline Chat Overview" style="width:100px; border-radius:25px;"/>

1.  **Open Inline Chat**.
2.  **Generate Code**.
3.  **Refactor Code**.

---

## Steps to Use Inline Chat

### 01. Open Inline Chat:

- This can be done in several ways.
  - Press `Cmd+I` (macOS) or `Ctrl+I` (Windows/Linux).
  - Use the Icon from the `Github Copilot` top icon.
  - Right-click in the editor and select `GitHub Copilot: Open Inline Chat`.
- Once the Inline Chat panel is open, you can type your request in the input box at the bottom.

---

### 02. Use Inline Chat

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

---

### 03. Task: Improve Code Quality

- Let's use Inline Chat to make our code more robust and readable.

### 03.01. Add Type Hints:

- Select all the code in `calculator/calculator.py` (`Cmd+A` / `Ctrl+A`).
- Open Inline Chat (`Cmd+I` / `Ctrl+I`).
- Type: `Add type hints to all functions`.
- Review the changes (Copilot will show a diff view).
- Accept the changes.
    <details>
    <summary>Expected Code After Type Hints</summary>
        ```python
        # calculator.py

        def add(a: float, b: float) -> float:
            return a + b

        # Add subtract function
        def subtract(a: float, b: float) -> float:
            return a - b

        # Add function to multiply two numbers
        # Add function to divide two numbers
        def multiply(a: float, b: float) -> float:
            return a * b

        def divide(a: float, b: float) -> float:
            if b == 0:
                raise ValueError("Cannot divide by zero.")
            return a / b
        ```

    </details>

### 03.02. Add Docstrings

- Select all the code again.
- Open Inline Chat.
- Type: `Add Google-style docstrings to all functions`.
- Accept the changes.
    <details>
    <summary>Expected Code After Docstrings</summary>
        ```python 
        # calculator.py
        def add(a: float, b: float) -> float:
            """Add two numbers.

            Args:
                a: First number.
                b: Second number.

            Returns:
                The sum of a and b.
            """
            return a + b

        ... (similar docstrings for other functions) ...
        ``` 
      </details>

### 03.03. Task: Error Handling

- Ensure our calculator handles edge cases gracefully.
- **Validate Division**: `("Cannot divide by zero.")`
- Select the `divide` function.
- Open Inline Chat.
- Type: `Update this function to raise a ValueError if dividing by zero, if not already present`.
- Copilot should either confirm it's there or add the check.
- Accept the changes if any.
    <details>
    <summary>Expected Code After Error Handling</summary>
      ```python
      def divide(a: float, b: float) -> float:
          """Divide two numbers.

          Args:
              a: Numerator.
              b: Denominator.

          Raises:
              ValueError: If b is zero.

          Returns:
              The result of a divided by b.
          """
          if b == 0:
              raise ValueError("Cannot divide by zero.")
          return a / b
      ```
      </details>


