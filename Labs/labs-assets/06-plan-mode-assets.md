# Lab 06 Assets

## Plan Prompt

```text
Plan a better calculator which will be based upon python 
class and will replace the current calculator code.
The calculator should only support add and subtract, 
but will have the ability to pass arguments as a list as well.
The plan should include the necessary changes to the existing files 
and any new files that need to be created.
```

## Expected Test Code (Class Based)

```python
### This line will not work, as the code is now class based.
### You need to install pytest to run the tests.
### Use Github copilot to "fix" it for you so the code will 
### works with the new class based calculator.

### ERROR:
###
### Traceback (most recent call last):
### File ".../main.py", line 1, in <module>
###   import pytest
### ModuleNotFoundError: No module named 'pytest'
import pytest

from calculator import Calculator

class TestCalculator:
    def test_add_list(self):
        calc = Calculator()
        assert calc.add([1.0, 2.0, 3.0]) == 6.0
        assert calc.add([]) == 0.0
        assert calc.add([-1.0, 1.0]) == 0.0

    def test_subtract_list(self):
        calc = Calculator()
        # 10 - 2 - 3 = 5
        assert calc.subtract([10.0, 2.0, 3.0]) == 5.0
        # 10 - (-2) = 12
        assert calc.subtract([10.0, -2.0]) == 12.0
        assert calc.subtract([5.0]) == 5.0
        assert calc.subtract([]) == 0.0
```
