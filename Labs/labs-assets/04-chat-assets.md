# Lab 04 Assets

## Initial main.py

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

## Updated calculator.py (Square and Sqrt)

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
```

## Updated main.py (New Tests)

```python
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
