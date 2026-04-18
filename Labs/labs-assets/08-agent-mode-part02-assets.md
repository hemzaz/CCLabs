# Lab 08 Part 02 Assets

## Generated CLI Calculator Code

`calculator/cli_calculator.py`

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

## Run Command

```bash
python3 calculator/cli_calculator.py
```
