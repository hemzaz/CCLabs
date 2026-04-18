## Lab 02 - Inline Suggestions Hands-On

## 01 - Single Inline Suggestion

??? question "Task: Single Inline Suggestion"

    * In this step, we will use `GitHub Copilot` to help us add a new function to our calculator.

    - Open `calculator/calculator.py` in VS Code.
    - Use `GitHub Copilot` to help you add a new function `subtract(x, y)` that subtracts two numbers.

        !!! tip "Using GitHub Copilot to add subtract function"
            - Place your cursor below the `add` function.
            - Type a comment describing the function you want to create:
                ```python
                # Add function to subtract two numbers
                ```
            - Wait for `GitHub Copilot` to suggest the implementation of the `subtract` function.
            - Accept the suggestion by pressing `Tab` or `Enter`.


    - After adding the function, your `calculator.py` should look like this:
        ```python
        # calculator.py
        def add(x, y):
            """Add two numbers."""
            return x + y

        def subtract(x, y):
            """Subtract two numbers."""
            return x - y
        ```

## 02 - Multiple Inline Suggestion

??? question "Task: Multiple Inline Suggestion"

    * Now, Based upon what we used above, add 2 more methods for multiply and divide.
      
    * Use `GitHub Copilot` to help you add a new function `multiply(x, y)` that multiplies two numbers.
    * Use `GitHub Copilot` to help you add a new function `divide(x, y)` that divides two numbers.
    * **This time we will add both functions together.**

        !!! tip "Using GitHub Copilot to add multiply and divide functions"
            * Place your cursor below the `subtract` function.
            * Type a comment describing the function you want to create:
                ```python
                # Add function to multiply two numbers
                # Add function to divide two numbers
                ```
            * Wait for `GitHub Copilot` to suggest the implementation of the `multiply` and `divide` functions.
            * Accept the suggestion by pressing `Tab` or `Enter`.
      
    * After adding the functions, your `calculator.py` should look like this:
        ```python
        # calculator.py

        def add(a, b):
            return a + b

        # Add subtract function
        def subtract(a, b):
            return a - b
            
        # Add function to multiply two numbers
        # Add function to divide two numbers
        def multiply(a, b):
            return a * b

        def divide(a, b):
            if b == 0:
                raise ValueError("Cannot divide by zero.")
            return a / b
        ```
        
    * If the code does not match, for example the divide by zero check is missing, we will handle it in the next lab.  
    * Congratulations! 
        * You have successfully used GitHub Copilot to add multiple functions to your calculator using inline suggestions.

## 03 - Contextual Suggestions

??? question "Task: Contextual Suggestions"

    * GitHub Copilot understands the context of your code. Since we are building a calculator with arithmetic operations, it can anticipate other common mathematical functions.

    * Let's add a power function.
    * Place your cursor at the end of the file.
    * Start typing `def power` and pause.

        !!! tip "Adding power function"
            Type:
                ```python
                def power
                ```
            * Copilot will likely suggest:
                ```python
                def power(a, b):
                    return a ** b
                ```
            * Accept the suggestion.

    * Now, let's try to add a square root function.
    * Start typing `def sq`.

        !!! tip "Adding square root function"
            * Type:
                ```python
                def sq
                ```
            * Copilot should suggest a square root implementation. 
            * Note that it might suggest importing `math` or using `** 0.5`.
            * If it suggests `math.sqrt`, make sure to add `import math` at the top of the file if it's not there, or let Copilot handle it.
