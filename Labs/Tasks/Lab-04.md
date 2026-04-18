## Lab 04 - Chat Hands-On

## 01 - Open Chat

??? question "Task: Open the Chat Panel"

    Open the Chat panel using one of these methods:

    - Press `Cmd+Shift+C` (macOS) or `Ctrl+Shift+C` (Windows/Linux).
    - Click the **GitHub Copilot** icon in the top bar.
    - Right-click in the editor and select **GitHub Copilot: Open Chat**.

---

## 02 - Use Chat to Generate Code

??? question "Task: Generate a Test File"

    1. In the Chat input box, write the following prompt:

        ```text
        1. Generate a main.py file that tests all functions in calculator.py
        2. Explain how to use the add function in calculator.py
        3. Print out instructions on how to run the tests
        ```

    2. Review the generated `main.py` file.
    3. Verify it imports from `calculator.py` and tests each function.
    4. Run the generated file:

        ```bash
        python3 calculator/main.py
        ```

---

## 03 - Adding Functions via Agent Mode

??? question "Task: Extend the Calculator"

    1. In the Chat window, switch to **Agent Mode**.
    2. Open `calculator/calculator.py` or add it as context.
    3. Type the following prompt:

        ```text
        1. Add square and root functions to the calculator.py file
        2. Add tests for power and square root functions in main.py
        3. Ensure the square root function handles negative inputs by raising a ValueError
        4. Print out instructions on how to run the tests
        ```

    4. Let Agent mode make the changes across files.
    5. Run the tests to verify:

        ```bash
        python3 calculator/main.py
        ```

    6. Verify the square root function raises `ValueError` for negative inputs.
