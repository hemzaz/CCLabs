# Lab 09 - Custom Instructions Assets

## Example Custom Instructions File

```markdown
# GitHub Copilot Custom Instructions for Calculator Project

## 1. Code Style
- **Python Version**: Use Python 3.12+ features and syntax.
- **Type Hints**: All functions and methods MUST include type hints for parameters and return values.
- **Formatting**: Follow [PEP 8](https://peps.python.org/pep-0008/). Max line length: 100 characters.
- **Naming**: Use descriptive variable and function names. Classes in `CamelCase`, functions/methods in `snake_case`.
- **Imports**: Group and order imports as per PEP 8. Avoid unused imports.

## 2. Testing
- **Framework**: Use `pytest` for all tests.
- **Coverage**: Target 90%+ code coverage. Include edge cases and error scenarios.
- **Structure**: Organize tests by feature/class. Use parametrized tests for similar scenarios.
- **Fixtures**: Use pytest fixtures for setup/teardown where appropriate.
- **Naming**: Use descriptive test names: `test_<function>_<scenario>_<expected>`.

## 3. Documentation
- **Docstrings**: Use [Google-style docstrings](https://google.github.io/styleguide/pyguide.html#38-comments-and-docstrings) for all public modules, classes, and functions.
- **README**: Provide usage examples, installation instructions, and API documentation.
- **Comments**: Explain *why* for complex logic, not just *what*.

## 4. Architecture
- **Design**: Use a class-based, modular structure. `Calculator` should be the main interface.
- **Separation of Concerns**: Keep calculation logic, I/O, and history management in separate modules/classes.
- **Extensibility**: Design for easy addition of new features (e.g., plugins, interfaces).

## 5. Behavior
- **Responses**: Be concise and professional in explanations and code comments.
- **Consistency**: Ensure code and documentation are consistent throughout the project.

## 6. Error Handling
- **Exceptions**: Raise `ValueError` for invalid inputs, `ZeroDivisionError` for division by zero, and `TypeError` for type mismatches.
- **Messages**: Provide clear, user-friendly error messages.
- **Docstrings**: Document all raised exceptions in the `Raises` section.

## 7. Library Preferences
- **Standard Library**: Use only Python standard library modules unless otherwise specified.
- **Third-Party**: Avoid external dependencies unless required for testing (e.g., `pytest`).

## 8. Performance
- **Efficiency**: Use efficient algorithms and data structures. Avoid unnecessary computations.
- **Scalability**: Consider performance for large input sizes and repeated operations.

## 9. Git Conventions
- **Commits**: Use [Conventional Commits](https://www.conventionalcommits.org/) for commit messages.
- **Branches**: Use feature branches for new features and fixes. Merge via pull requests.

## 10. Security
- **Input Validation**: Validate all user inputs and function arguments.
- **Sanitization**: Sanitize file paths and external data.
- **No Secrets**: Do not hardcode secrets or sensitive information.

---

**All code and documentation generated for this project must adhere to these instructions.**
```

## Checklist

- [ ] **Role Definition**: Does it define Copilot's persona?
- [ ] **Code Style**: Are naming conventions and formatting rules clear?
- [ ] **Type Safety**: Are type hints explicitly required?
- [ ] **Testing Strategy**: Is the testing framework and style specified?
- [ ] **Documentation**: Are docstring formats (e.g., Google, NumPy) defined?
- [ ] **Error Handling**: Are there instructions on how to handle exceptions?
- [ ] **Library Preferences**: Does it mention specific libraries to use or avoid?

