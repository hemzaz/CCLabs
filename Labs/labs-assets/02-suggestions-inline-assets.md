# Lab 02 Assets

## Subtract Function

```python
# calculator.py
def add(x, y):
    """Add two numbers."""
    return x + y

def subtract(x, y):
    """Subtract two numbers."""
    return x - y
```

## Multiply and Divide Functions

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

## Power Function

```python
def power(a, b):
    return a ** b
```
