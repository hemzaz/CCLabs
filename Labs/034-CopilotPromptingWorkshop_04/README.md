# Lab 04 - Chat

* In this lab we will write prompts in the chat asking it to create main python code which will test our calculator.

## Overview

* The chat feature allows you to have a more interactive experience with GitHub Copilot
* `GitHub Copilot Chat`, enabling you to `ask` questions, `request` code snippets, and much more.
* The chat mode is the core of GitHub Copilot's advanced capabilities, allowing for a more conversational and context-aware coding experience.

---

<img src="../assets/images/tldr.png" alt="Chat Overview" style="width:100px; border-radius:25px;"/>

1.  **Open Chat**.
2.  **Request Code GeneratChangesion**.
3.  **Ask Questions**.

---

## Steps to Use Chat
### 01. Open Chat:
* You can open the Chat panel in several ways:
    * Press `Cmd+Shift+C` (macOS) or `Ctrl+Shift+C` (Windows/Linux).
    * Use the Icon from the `Github Copilot` top icon.
    * Right-click in the editor and select `GitHub Copilot: Open Chat`. 
* Once the Chat panel is open, you can type your requests in the input box at the bottom.

---

### 02. Use Chat

* In this task, we will use Chat to generate a `main.py` file that tests all functions in our `calculator.py` file.
* In the Chat input box, write the following prompt:
    
    ```
    1. Generate a main.py file that tests all functions in calculator.py
    2. Explain how to use the add function in calculator.py
    3. Print out instructions on how to run the tests
    ```

    <details>
    <summary>Possible solution</summary>

    ```python
    import calculator

    def test_add():
        """Test the add function."""
        assert calculator.add(1, 2) == 3
        assert calculator.add(-1, 1) == 0
        assert calculator.add(0, 0) == 0
        print("test_add passed")

    def test_subtract():
        """Test the subtract function."""
        assert calculator.subtract(5, 3) == 2
        assert calculator.subtract(1, 5) == -4
        assert calculator.subtract(0, 0) == 0
        print("test_subtract passed")

    def test_multiply():
        """Test the multiply function."""
        assert calculator.multiply(2, 3) == 6
        assert calculator.multiply(-2, 3) == -6
        assert calculator.multiply(0, 5) == 0
        print("test_multiply passed")

    def test_divide():
        """Test the divide function."""
        assert calculator.divide(6, 2) == 3
        assert calculator.divide(5, 2) == 2.5
        
        # Test division by zero
        try:
            calculator.divide(1, 0)
            print("Error: ZeroDivisionError not raised")
        except ValueError as e:
            assert str(e) == "Cannot divide by zero."
        print("test_divide passed")

    if __name__ == "__main__":
        print("Running tests...")
        test_add()
        test_subtract()
        test_multiply()
        test_divide()
        print("All tests passed!")
    ```
    </details>

---

### 03. Adding tests

* In the chat windows, Choose the `Agent Mode`
* Open the `calculator/calculator.py` file or add it as context to the chat.
* Type the following prompt:
    ```
    1. Add square and root functions to the calculator.py file
    2. Add tests for power and square root functions in main.py
    3. Ensure the square root function handles negative inputs by raising a ValueError
    4. Print out instructions on how to run the tests
    
    ```

    <details>
    <summary>Possible solution</summary>

    ```python
    # calculator.py
    def square(n: float) -> float:
        """Return the square of a number.

        Args:
            n: The number to square.

        Returns:
            The square of n.
        """
        return n * n

    def sqrt(n: float) -> float:
        """Return the square root of a number.

        Args:
            n: The number to find the square root of.

        Returns:
            The square root of n.

        Raises:
            ValueError: If n is negative.
        """
        if n < 0:
            raise ValueError("Cannot calculate square root of a negative number.")
        return math.sqrt(n)

    # --------------------------------
    
    # main.py
    def test_power():
        """Test the power function."""
        assert calculator.power(2, 3) == 8
        assert calculator.power(5, 0) == 1
        assert calculator.power(2, -2) == 0.25
        print("test_power passed")

    def test_square_root():
        """Test the square root function."""
        assert calculator.square_root(9) == 3
        assert calculator.square_root(0) == 0
        try:
            calculator.square_root(-1)
            print("Error: ValueError not raised for negative input")
        except ValueError as e:
            assert str(e) == "Cannot compute square root of negative number."
        print("test_square_root passed")

    if __name__ == "__main__":
        print("Running tests...")
        test_add()
        test_subtract()
        test_multiply()
        test_divide()
        test_power()
        test_square_root()
        print("All tests passed!")
    ```
    </details>
