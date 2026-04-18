# Lab 08 Part 01 Assets

## Agent Prompt

```text
Create a new file `cli_calculator.py` in the calculator directory.   
This script should import the `Calculator` class from `calculator/calculator.py`.   
It should run an interactive loop asking the user to choose an operation (add, subtract, power, modulus) and enter numbers.   
It should print detailed information about the operation being performed and the result.   
Handle invalid inputs gracefully.
```

## Calculator Code

`calculator/calculator.py`

```python
"""Calculator module providing basic operations using a class-based approach."""

class Calculator:
    """A simple calculator class."""

    def add(self, numbers: list[float]) -> float:
        """Add a list of numbers.
        
        Args:
            numbers: List of numbers to add.
            
        Returns:
            Sum of the numbers.
        """
        return sum(numbers)

    def subtract(self, numbers: list[float]) -> float:
        """Subtract numbers from the first number in the list.
        
        Args:
            numbers: List of numbers.
            
        Returns:
            Result of subtracting subsequent numbers from the first.
        """
        if not numbers:
            return 0.0
        if len(numbers) == 1:
            return numbers[0]
        
        result = numbers[0]
        for num in numbers[1:]:
            result -= num
        return result

    def power(self, x: float, y: float) -> float:
        """Calculate x raised to the power of y.
        
        Args:
            x: The base.
            y: The exponent.
            
        Returns:
            x raised to the power of y.
        """
        return x ** y

    def modulus(self, x: float, y: float) -> float:
        """Calculate the modulus of x and y.
        
        Args:
            x: The dividend.
            y: The divisor.
            
        Raises:
            ValueError: If y is zero.
            
        Returns:
            The remainder of x divided by y.
        """
        if y == 0:
            raise ValueError("Cannot calculate modulus with zero divisor.")
        return x % y

def main():
    """Run calculator with user input."""
    calc = Calculator()
    print("Simple Calculator (Class-based)")
    # Simple demo
    print("Adding [1, 2, 3]:", calc.add([1, 2, 3]))
    print("Subtracting [10, 2, 3]:", calc.subtract([10, 2, 3]))

if __name__ == "__main__":
    main()
```
