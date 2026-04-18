# Lab 07 Assets

## Test File: `tests/test_advanced_calc.py`

```python
import pytest
from calculator.calculator import Calculator

def test_power():
    calc = Calculator()
    assert calc.power(2, 3) == 8
    assert calc.power(5, 0) == 1
    assert calc.power(2, -1) == 0.5

def test_modulus():
    calc = Calculator()
    assert calc.modulus(10, 3) == 1
    assert calc.modulus(10, 5) == 0
```

## Agent Prompt 1

```text
I have created a new test file `tests/test_advanced_calc.py` with new tests.
Please run these tests to confirm they fail, then implement the missing
methods in `calculator/calculator.py` to make all tests pass.
```

## Agent Prompt 2

```text
Update the `modulus` method to raise a ValueError if the second argument is 0.
Also, add a test case to `tests/test_advanced_calc.py` that verifies this exception is raised.
```
