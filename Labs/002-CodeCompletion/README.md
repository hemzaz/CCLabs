# Lab 002 - Code Completion

!!! hint "Overview"

    - In this lab, you will explore GitHub Copilot's code completion capabilities in depth.
    - You will work with Ghost Text, multi-line completions, and learn how to control the suggestions Copilot shows.
    - You will discover how cursor position, surrounding code, and comments all influence the quality of completions.
    - By the end of this lab, you will be able to use Copilot's completion engine efficiently in your everyday coding workflow.

## Prerequisites

- Completed [Lab 001 - Getting Started](../001-GettingStarted/README.md)
- GitHub Copilot extension active

## What You Will Learn

- How to trigger and control Ghost Text suggestions
- How Copilot uses context (comments, function names, surrounding code)
- Multi-line completions and whole-function generation
- Keyboard shortcuts for managing suggestions

---

## Lab Steps

## Step 1 - Context-Driven Completions

Copilot reads the context around your cursor. Try this:

```python
# Parse a CSV file and return a list of dictionaries
def parse_csv(file_path):
```

Observe how Copilot generates a complete function body.

## Step 2 - Comment-to-Code

Write a descriptive comment and let Copilot generate the implementation:

```javascript
// Function to validate an email address using regex
```

## Step 3 - Multi-Line Completions

1. Open a new file `sorting.py`
2. Type the following and wait for completion:

```python
# Implement merge sort algorithm
def merge_sort(arr):
```

Copilot should generate the entire recursive merge sort implementation.

## Step 4 - Keyboard Shortcuts

| Action                 | Windows/Linux | macOS        |
| :--------------------- | :------------ | :----------- |
| Accept suggestion      | `Tab`         | `Tab`        |
| Dismiss suggestion     | `Escape`      | `Escape`     |
| Next suggestion        | `Alt+]`       | `Option+]`   |
| Previous suggestion    | `Alt+[`       | `Option+[`   |
| Open completions panel | `Ctrl+Enter`  | `Ctrl+Enter` |

## Step 5 - Open Completions Panel

1. Type the beginning of a function
2. Press `Ctrl+Enter` to open the **Copilot Completions Panel**
3. Browse through multiple generated completions side by side

---

## Summary

You now understand how Copilot's code completion works and how to control suggestions effectively.

## Next Steps

Continue with [Lab 003 - Chat Features](../003-ChatFeatures/README.md)

---

## Tasks

## Task 01 - Single-Line Completion

**Scenario:** Use Ghost Text to complete a one-line utility function.

**Hint:** Type the function signature and let Copilot fill the body.

??? success "Solution"

    1. Create `string_utils.py`
    2. Type:


    ```python
    def reverse_string(s: str) -> str:

    ```
    3. Press `Enter` - Copilot suggests `return s[::-1]`
    4. Accept with `Tab`

---

## Task 02 - Multi-Line Completion from a Docstring

**Scenario:** Write a docstring, then let Copilot generate the entire function body.

**Hint:** Write the signature + docstring, press Enter, accept completions line by line.

??? success "Solution"

    1. Type:


    ```python
    def classify_bmi(weight_kg: float, height_m: float) -> str:
        """Return Underweight, Normal, Overweight, or Obese based on BMI."""

    ```
    2. Press Enter - Copilot generates the full body including the BMI formula
    3. If the first suggestion isn't ideal, press `Alt+]` for alternatives

---

## Task 03 - Complete a Data Structure

**Scenario:** Start a dictionary with one entry and let Copilot fill in the rest.

**Hint:** Type the first key-value, press Enter, Copilot extrapolates the pattern.

??? success "Solution"

    ```python
    HTTP_STATUS_CODES = {
        200: "OK",
        201: "Created",
        # Continue typing to let Copilot fill: 400, 401, 403, 404, 500, etc.
    }
    ```

---

## Task 04 - Test-Driven Completion

**Scenario:** Write a failing test first, then let Copilot generate the implementation.

**Hint:** Create the test file, then open the implementation file - Copilot reads the test.

??? success "Solution"

    1. Create `test_fibonacci.py`:


    ```python
    from fibonacci import fibonacci
    assert fibonacci(0) == 0
    assert fibonacci(1) == 1
    assert fibonacci(10) == 55

    ```
    2. Create `fibonacci.py` and type `def fibonacci(n:`
    3. Copilot sees the test and suggests the correct recursive/iterative implementation

---

## Task 05 - Accept One Word at a Time

**Scenario:** A completion is mostly right but you want to accept it word by word.

**Hint:** `Ctrl+Right Arrow` accepts one word token from the Ghost Text.

??? success "Solution"

    1. Type a partial expression:


    ```python
    result = sorted(items, key=lambda

    ```
    2. When Ghost Text shows `x: x.price, reverse=True)`, press `Ctrl+→` to accept just `x:`
    3. Keep pressing `Ctrl+→` to accept token by token

---

## Task 06 - Fill in the Middle

**Scenario:** You have code before AND after the cursor - confirm Copilot fills the gap.

**Hint:** Place cursor between setup and return, let Copilot generate the middle.

??? success "Solution"

    ```python
    def process_items(items: list) -> dict:
        result = {}
        # Place cursor here - Copilot fills in the loop consistent with result={} and return result
        return result
    ```

    Copilot's fill-in-the-middle model generates code that is coherent with both sides.
