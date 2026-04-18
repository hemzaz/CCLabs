```python
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

if __name__ == "__main__":
    test_suite = TestCalculator()
    test_methods = [method for method in dir(test_suite) if method.startswith('test_')]
    
    print(f"Running {len(test_methods)} tests from TestCalculator...\n")
    
    passed_count = 0
    for method_name in test_methods:
        method = getattr(test_suite, method_name)
        print(f"Running {method_name}...", end=" ")
        try:
            method()
            print("✅ PASSED")
            passed_count += 1
        except AssertionError:
            print("❌ FAILED")
        except Exception as e:
            print(f"❌ ERROR: {e}")
            
    print(f"\nSummary: {passed_count}/{len(test_methods)} tests passed.")
    if passed_count == len(test_methods):
        print("All tests passed successfully!")
    else:
        print("Some tests failed. Please check the output above for details.")
```        