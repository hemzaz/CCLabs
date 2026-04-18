## Lab 08 - Building a CLI with Copilot Agent Hands-On

### 1. Create the Prompt

??? question "Task: Create the Prompt"

    - **Copy and paste the following prompt into Copilot Chat:**

        !!! example "Prompt to use in Copilot Chat"
            Create a new file `cli_calculator.py` in the calculator directory.   
            This script should import the `Calculator` class from `calculator/calculator.py`.   
            It should run an interactive loop asking the user to choose an operation (add, subtract, power, modulus) and enter numbers.   
            It should print detailed information about the operation being performed and the result.   
            Handle invalid inputs gracefully.

### 2. Review the Generated Code

??? question "Task: Review the Generated Code"

    - Copilot should generate a plan to create `cli_calculator.py`. 
    - **Look for the following features in the generated code:**

    <div class="grid cards" markdown>

      - **Imports**
        * Does it correctly import `sys` (for path manipulation if needed) or just `from calculator.calculator import Calculator`?

      - **Input Handling**
        * Does it ask for the operation first?

      - **Argument Handling**
        *   For `add` and `subtract`, it should accept a list of numbers (e.g., comma-separated).
        *   For `power` and `modulus`, it should ask for two specific numbers.

      - **Loop**
        * Does it allow the user to perform multiple calculations without restarting?

    </div>

### 3. Run the Calculator CLI

??? question "Task: Run the Calculator CLI"

    * Once the file is created, run it in the terminal to test it out.

        ```bash
        python3 cli_calculator.py
        ```

### 4. Example Interaction

??? question "Task: Example Interaction"

    ```text
    Welcome to the CLI Calculator!
    Available operations: add, subtract, power, modulus

    Enter operation (or 'quit' to exit): add
    Enter numbers separated by spaces: 10 20 30
    Performing addition on [10.0, 20.0, 30.0]...
    Result: 60.0

    Enter operation (or 'quit' to exit): power
    Enter base: 2
    Enter exponent: 3
    Calculating 2.0 raised to the power of 3.0...
    Result: 8.0
    ```
