# Lab 08 - Building a CLI with Copilot Agent

* In this lab, we will leverage the power of GitHub Copilot Agent to expand our calculator project. 
* We will create a command-line interface (CLI) that interacts with our existing `Calculator` class. 
* This demonstrates how Agent mode can understand project structure (importing existing classes) and implement new functionality (user input handling) based on high-level instructions.

## Objectives

1.  **Use Copilot Agent** to generate a new Python script `cli_calculator.py`.
2.  **Implement an interactive CLI** that prompts users for operations and inputs.
3.  **Integrate** with the existing `calculator/calculator.py` module.
4.  **Ensure robust error handling** and detailed output logging.

---

## Step-by-Step Instructions

### 1. Create the Prompt

- **Copy and paste the following prompt into Copilot Chat:**

    !!! example "Prompt to use in Copilot Chat"
        Create a new file `cli_calculator.py` in the calculator directory.   
        This script should import the `Calculator` class from `calculator/calculator.py`.   
        It should run an interactive loop asking the user to choose an operation (add, subtract, power, modulus) and enter numbers.   
        It should print detailed information about the operation being performed and the result.   
        Handle invalid inputs gracefully.

---
    
### 2. Review the Generated Code

- Copilot should generate a plan to create `cli_calculator.py`. 
  
    <details>
    <summary>Cli Calculator - Review Generated Code</summary>
    ```python
        import sys
        import os

        # Add the current directory to sys.path to ensure we can import the local module
        sys.path.append(os.path.dirname(os.path.abspath(__file__)))

        from calculator import Calculator

        def get_numbers_list(prompt: str) -> list[float]:
            """Get a list of numbers from user input."""
            while True:
                try:
                    user_input = input(prompt)
                    # Split by comma or space
                    parts = user_input.replace(',', ' ').split()
                    numbers = [float(x) for x in parts]
                    return numbers
                except ValueError:
                    print("Invalid input. Please enter numeric values separated by spaces or commas.")

        def get_number(prompt: str) -> float:
            """Get a single number from user input."""
            while True:
                try:
                    return float(input(prompt))
                except ValueError:
                    print("Invalid input. Please enter a numeric value.")

        def main():
            calc = Calculator()
            print("Welcome to the CLI Calculator!")
            print("Available operations: add, subtract, power, modulus")

            while True:
                print("\n----------------------------------------")
                operation = input("Enter operation (or 'quit' to exit): ").lower().strip()

                if operation in ['quit', 'exit']:
                    print("Goodbye!")
                    break

                if operation not in ['add', 'subtract', 'power', 'modulus']:
                    print("Unknown operation. Please choose from: add, subtract, power, modulus")
                    continue

                try:
                    if operation == 'add':
                        nums = get_numbers_list("Enter numbers separated by spaces: ")
                        print(f"Performing addition on {nums}...")
                        result = calc.add(nums)
                        print(f"Result: {result}")

                    elif operation == 'subtract':
                        nums = get_numbers_list("Enter numbers separated by spaces: ")
                        print(f"Performing subtraction on {nums}...")
                        result = calc.subtract(nums)
                        print(f"Result: {result}")

                    elif operation == 'power':
                        base = get_number("Enter base: ")
                        exponent = get_number("Enter exponent: ")
                        print(f"Calculating {base} raised to the power of {exponent}...")
                        result = calc.power(base, exponent)
                        print(f"Result: {result}")

                    elif operation == 'modulus':
                        dividend = get_number("Enter dividend: ")
                        divisor = get_number("Enter divisor: ")
                        print(f"Calculating modulus of {dividend} and {divisor}...")
                        result = calc.modulus(dividend, divisor)
                        print(f"Result: {result}")

                except Exception as e:
                    print(f"An error occurred: {e}")

        if __name__ == "__main__":
            main()

    ```
    </details>

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

* Once the file is created, run it in the terminal to test it out.

```bash
python3 cli_calculator.py
```

### 4. Example Interaction

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

---

#### What is happening behind the scenes?

| Feature               | Description                                                                                                                                                                                                                                                               |
|:----------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Context Awareness** | By using `@workspace`, Copilot scans your project structure. <br/>It reads `calculator/calculator.py` to understand the `Calculator` class methods (`add`, `subtract`, `power`, `modulus`) and their specific signatures (e.g., `add` takes a list, `power` takes two floats). |
| **Code Generation**   | Copilot generates the boilerplate code for the command-line interface, including the `while` loop for continuous operation and `input()` calls for user interaction.                                                                                                      |
| **Logic Mapping**     | It maps the user's string input (e.g., "add") to the specific method call `calc.add(...)`.                                                                                                                                                                                |
| **Error Handling**    | A good agent response will include `try-except` blocks to handle cases where the user enters text instead of numbers, preventing the program from crashing.                                                                                                               |

