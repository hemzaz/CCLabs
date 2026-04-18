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