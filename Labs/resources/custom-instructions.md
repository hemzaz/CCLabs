# Calculator Project - Copilot Instructions

## Project Context

This is an educational calculator application built to demonstrate Python best practices and serve as a teaching tool for GitHub Copilot prompting techniques. The project emphasizes clean code, comprehensive testing, and modular design.

## Code Style Requirements

### Type Hints
- **REQUIRED**: Use type hints for all function parameters and return values
- Use Python 3.12+ syntax: `list[int]`, `dict[str, any]`, `str | None` (pipe operator)
- For complex types, use `typing` module: `Callable`, `Optional`, `Union`, `TypeVar`

Example:
```python
def calculate(x: float, y: float, operation: str) -> float | None:
    """Calculate result based on operation."""
    ...
```

### Docstrings
- **REQUIRED**: Google-style docstrings for all public functions and classes
- Include: description, Args, Returns, Raises, Example
- Keep descriptions concise but complete

Example:
```python
def add(x: float, y: float) -> float:
    """Add two numbers together.
    
    Args:
        x: First number to add
        y: Second number to add
        
    Returns:
        Sum of x and y
        
    Example:
        >>> calc.add(2, 3)
        5.0
    """
    return x + y
```

### Code Formatting
- Maximum line length: 100 characters
- Use descriptive variable names (no single-letter vars except `i`, `j` in loops)
- Follow PEP 8 guidelines
- Use f-strings for string formatting
- Prefer list comprehensions over map/filter when readable

### Error Handling
- Use specific exception types (ValueError, TypeError, ZeroDivisionError)
- Provide helpful error messages
- Document exceptions in docstrings (Raises section)

## Architecture Principles

### Design Patterns
- **Class-based design**: Use `Calculator` class as main interface
- **Single Responsibility**: Each class/function does one thing well
- **Separation of Concerns**: 
  - Calculation logic in Calculator class
  - I/O operations in separate CLI/GUI modules
  - History management in dedicated component
- **Composition over Inheritance**: Prefer composing behavior

### Modularity
- Keep functions small and focused (< 25 lines ideally)
- Extract common patterns into reusable functions
- Use helper methods for complex operations

### Extensibility
- Plugin system for custom operations
- Support for multiple interfaces (CLI, GUI, API)
- Configuration-driven behavior where appropriate

## Testing Requirements

### Coverage Goals
- Target: **90%+ code coverage**
- All public methods must have tests
- Include edge cases and error scenarios

### Test Structure
- Use pytest framework
- Organize tests by feature/class
- Use parametrized tests for similar scenarios
- Use fixtures for common setup

Example:
```python
@pytest.mark.parametrize("x,y,expected", [
    (2, 3, 5),
    (-1, 1, 0),
    (0, 0, 0),
])
def test_add_various_inputs(x, y, expected):
    calc = Calculator()
    assert calc.add(x, y) == expected
```

### Test Naming
Convention: `test_<method>_<scenario>_<expected>`
- `test_divide_by_zero_raises_error`
- `test_add_positive_numbers_returns_sum`

## Documentation Standards

### README Requirements
- Installation instructions
- Usage examples
- API documentation
- Contributing guidelines

### Code Comments
- Explain **why**, not what
- Document complex algorithms
- Mark TODOs clearly: `# TODO: Add caching for repeated calculations`

### Module Docstrings
Every .py file should start with a module-level docstring:
```python
"""Calculator module providing basic and scientific operations.

This module implements a Calculator class that performs arithmetic and
scientific calculations with history tracking and error handling.
"""
```

## When Suggesting Code

### Best Practices
- Always consider **backwards compatibility**
- Prefer **composition over inheritance**
- Suggest **tests alongside new functions**
- Highlight **potential edge cases** and error scenarios
- Consider **performance implications** for large datasets
- Follow **DRY principle** (Don't Repeat Yourself)

### Code Review Focus
When reviewing or generating code, prioritize:
1. Correctness and functionality
2. Type safety and error handling
3. Test coverage
4. Documentation completeness
5. Code readability and maintainability
6. Performance (if relevant)

## Python 3.12+ Features

Leverage modern Python features:
- Match/case statements for complex conditionals
- Exception groups (`ExceptionGroup`, `except*`)
- New generic syntax: `class Stack[T]:`
- Improved error messages and debugging
- `tomllib` for TOML config files (built-in)

## Security Considerations

- Validate all user inputs
- Sanitize file paths for history export
- Use parameterized queries if adding database support
- Avoid `eval()` or `exec()` for user-provided operations
- Handle resource cleanup properly (use context managers)

## Example: Complete Function

Here's a complete example following all guidelines:

```python
def divide(self, x: float, y: float) -> float:
    """Divide first number by second number.
    
    Args:
        x: Dividend (number to be divided)
        y: Divisor (number to divide by)
        
    Returns:
        Result of x divided by y
        
    Raises:
        ZeroDivisionError: If y is zero
        TypeError: If x or y are not numeric
        
    Example:
        >>> calc = Calculator()
        >>> calc.divide(10, 2)
        5.0
        >>> calc.divide(10, 0)
        Traceback (most recent call last):
        ...
        ZeroDivisionError: Cannot divide by zero
    """
    if not isinstance(x, (int, float)) or not isinstance(y, (int, float)):
        raise TypeError("Both arguments must be numeric")
    
    if y == 0:
        raise ZeroDivisionError("Cannot divide by zero")
    
    return x / y
```

## Version History

**Last Updated**: Workshop Creation  
**Python Version**: 3.12+  
**Maintainer**: Workshop Instructor

---

Following these instructions ensures consistency, quality, and maintainability across the entire calculator project. All Copilot suggestions should align with these standards.
