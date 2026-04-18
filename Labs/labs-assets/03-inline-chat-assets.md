# Lab 03 Assets

## Type Hints

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

## Docstrings

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

## Error Handling

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
