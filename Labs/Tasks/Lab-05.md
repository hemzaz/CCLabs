## Lab 05 - Built-in Prompts Hands-On

## 01 - Explain Code

??? question "Task: Use /explain"

    1. Open `calculator/calculator.py`.
    2. Select the `divide` function.
    3. Open the Chat view and type `/explain`.
    4. Review the explanation provided by Copilot.
    5. Verify it mentions the division by zero handling.

---

## 02 - Generate Documentation

??? question "Task: Use /doc"

    1. Select the `subtract` function in `calculator/calculator.py`.
    2. Type `/doc` in the Chat or right-click inside `calculator.py` and select **Copilot > Generate Docs**.
    3. Observe how Copilot adds docstrings to your function.
    4. Accept the changes and verify the docstring follows a standard format (Google, NumPy, etc.).

---

## 03 - Generate Tests

??? question "Task: Use /tests"

    1. Select the entire content of `calculator/calculator.py`.
    2. Type `/tests` in the Chat.
    3. Copilot will suggest a new test file or add tests to an existing one.
    4. Review the generated tests and ensure they cover:
        - Normal operation for each function
        - Edge cases (e.g., division by zero)
        - Negative numbers and zero inputs
    5. Run the tests to verify they pass:

        ```bash
        pytest tests/
        ```
