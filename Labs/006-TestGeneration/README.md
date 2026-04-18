# Lab 006 - Test Generation

!!! hint "Overview"

    - In this lab, you will use GitHub Copilot to automatically generate unit tests for existing code.
    - You will learn how to prompt Copilot for edge cases, negative paths, and boundary conditions that are easy to overlook.
    - You will generate tests for multiple frameworks including Jest, pytest, and JUnit depending on your stack.
    - By the end of this lab, you will have a test-generation workflow that significantly speeds up your TDD cycle.

## Prerequisites

- Completed [Lab 005 - Prompting Techniques](../005-Prompting/README.md)

## What You Will Learn

- How to generate unit tests with the `/tests` command
- How to prompt Copilot for edge cases
- How to generate tests for multiple frameworks (Jest, pytest, JUnit)

---

## Lab Steps

## Step 1 - Create a Sample Function

Create a file `calculator.py` with this code:

```python
def divide(a: float, b: float) -> float:
    """Divide a by b and return the result."""
    if b == 0:
        raise ValueError("Cannot divide by zero")
    return a / b
```

## Step 2 - Use the `/tests` Slash Command

1. Select the `divide` function
2. Open Copilot Chat and type `/tests`
3. Review the generated test cases

## Step 3 - Ask for Edge Cases

In the Chat panel, type:

```
Generate additional edge case tests for the divide function,
including very large numbers, floating point precision, and negative numbers.
```

## Step 4 - Generate Tests for a JavaScript Function

Create `validator.js`:

```javascript
function isValidEmail(email) {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
}
```

Then ask:

```
Generate Jest unit tests for the isValidEmail function,
covering valid emails, invalid formats, edge cases like empty string and null.
```

## Step 5 - Test-Driven Development (TDD) with Copilot

Write the test first, then ask Copilot to implement the function:

```python
# Tests for a password validator function
def test_valid_password():
    assert validate_password("Secure@123") == True

def test_short_password():
    assert validate_password("short") == False

def test_no_special_char():
    assert validate_password("Password123") == False
```

Select the tests and ask Copilot to implement `validate_password`.

---

## Summary

Copilot can dramatically speed up test writing and help you think of edge cases you might miss manually.

## Next Steps

Continue with [Lab 007 - Refactoring](../007-Refactoring/README.md)

---

## Tasks

## Task 01 - Generate Tests with `/tests`

**Scenario:** Use the `/tests` slash command to generate a test suite for a function.

**Hint:** Select the function, open Chat, type `/tests`.

??? success "Solution"

    1. Select the `divide` function
    2. Chat → `/tests`
    3. Copilot generates: happy path, division-by-zero, negative numbers, float precision

---

## Task 02 - Request Missing Edge Cases

**Scenario:** Copilot's initial tests missed some edge cases. Request more.

**Hint:** Follow up: "What edge cases are missing?"

??? success "Solution"

    ```
    What edge cases are NOT covered by the tests you just generated?
    Consider: very large numbers, float precision, division of a number by itself,
    and division by a very small non-zero float.
    ```

---

## Task 03 - Parametrize Tests

**Scenario:** Replace multiple similar test functions with a single parametrized test.

**Hint:** Ask Copilot to refactor existing tests using `pytest.mark.parametrize`.

??? success "Solution"

    ```
    #selection

    Refactor these three separate test functions into one parametrized test
    using @pytest.mark.parametrize. Keep all test cases.
    ```

---

## Task 04 - Mock External Dependencies

**Scenario:** A function calls an HTTP API. Generate tests that mock the call.

**Hint:** Ask Copilot to mock `requests.get` with `unittest.mock.patch`.

??? success "Solution"

    ```
    #file:src/services/UserService.py

    Generate pytest tests for fetch_user_profile.
    Mock requests.get using unittest.mock.patch.
    Test: 200 response, 404 response, network timeout, invalid JSON response.
    ```

---

## Task 05 - Generate Tests for a JavaScript Function

**Scenario:** Create a Jest test suite for a form validator.

**Hint:** Specify Jest and use `describe`/`it` blocks.

??? success "Solution"

    ```
    #file:src/utils/validator.js

    Generate a Jest test suite for isValidEmail.
    Use describe/it blocks and test.each for parametrized cases.
    Include at least 5 valid and 5 invalid email examples.
    ```

---

## Task 06 - Improve Test Coverage

**Scenario:** Coverage is at 65%. Ask Copilot to target the uncovered lines.

**Hint:** Show the coverage report and the source file.

??? success "Solution"

    ```
    My coverage report shows these lines are not covered in calculator.py: 14, 23-26, 41.

    #file:calculator.py

    Generate tests that specifically cover lines 14, 23-26, and 41.
    Explain what scenario each test exercises.
    ```
