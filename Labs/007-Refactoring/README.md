# Lab 007 - Refactoring

!!! hint "Overview"

    - In this lab, you will use GitHub Copilot to refactor existing code and improve its structure and readability.
    - You will extract functions, rename symbols for clarity, reduce nesting, and apply common design patterns with AI assistance.
    - Copilot will help you identify code smells and suggest cleaner alternatives while preserving the original behavior.
    - By the end of this lab, you will be able to use Copilot as a refactoring partner to maintain high code quality.

## Prerequisites

- Completed [Lab 006 - Test Generation](../006-TestGeneration/README.md)

## What You Will Learn

- How to use Copilot to identify and fix code smells
- Extract methods and reduce code duplication
- Improve variable and function naming
- Apply SOLID principles with Copilot's help

---

## Lab Steps

## Step 1 - Refactor Long Functions

Given this complex function:

```python
def process_order(order_data):
    # Validate order
    if not order_data.get('customer_id'):
        raise ValueError("Missing customer_id")
    if not order_data.get('items') or len(order_data['items']) == 0:
        raise ValueError("Order must have at least one item")
    total = 0
    for item in order_data['items']:
        if item['quantity'] <= 0:
            raise ValueError(f"Invalid quantity for item {item['id']}")
        total += item['price'] * item['quantity']
    # Apply discount
    if order_data.get('coupon_code') == 'SAVE10':
        total = total * 0.9
    # Calculate tax
    tax = total * 0.17
    total_with_tax = total + tax
    return {'subtotal': total, 'tax': tax, 'total': total_with_tax}
```

Select it and ask Copilot:

```
Refactor this function by extracting validate_order, calculate_subtotal,
apply_discount, and calculate_tax as separate functions.
```

## Step 2 - Rename for Clarity

Select poorly named code and ask:

```
Rename variables and functions in this code to be more descriptive and
follow Python naming conventions.
```

## Step 3 - Remove Code Duplication

```javascript
function getAdminUsers(users) {
  const result = [];
  for (let i = 0; i < users.length; i++) {
    if (users[i].role === "admin") {
      result.push(users[i]);
    }
  }
  return result;
}

function getActiveUsers(users) {
  const result = [];
  for (let i = 0; i < users.length; i++) {
    if (users[i].status === "active") {
      result.push(users[i]);
    }
  }
  return result;
}
```

Ask Copilot:

```
Refactor these two functions to eliminate duplication using a generic filter function.
```

## Step 4 - Apply Design Patterns

Ask Copilot to apply a specific pattern:

```
Refactor this user authentication code to use the Strategy pattern,
allowing different authentication methods (password, OAuth, API key).
```

## Step 5 - Use `/simplify` Command

Select complex or overly verbose code and use the `/simplify` command in Chat to let Copilot propose a cleaner version.

---

## Summary

Copilot is a powerful refactoring partner - use it to improve code quality without changing behavior.

## Next Steps

Continue with [Lab 008 - Documentation](../008-Documentation/README.md)

---

## Tasks

## Task 01 - Extract a Method

**Scenario:** A long function should have its validation logic extracted into a separate function.

**Hint:** Select the block, `Cmd+I` → "Extract into a function called `validate_user_input`"

??? success "Solution"

    1. Select the validation block inside a long `create_user()` function
    2. `Cmd+I` → "Extract this into a separate function called `validate_user_input`"
    3. The original call site is updated automatically

---

## Task 02 - Rename for Clarity

**Scenario:** A variable `d` is used throughout a function and needs a better name.

**Hint:** Ask Copilot to suggest a descriptive name based on usage.

??? success "Solution"

    ```
    #selection

    The variable 'd' is poorly named. Based on how it's used in this function,
    suggest a more descriptive name and apply it to all usages.
    ```

---

## Task 03 - Replace Magic Numbers

**Scenario:** Replace hardcoded `86400`, `3600`, `1024` with named constants.

**Hint:** Ask Copilot to create named constants grouped at the top of the file.

??? success "Solution"

    ```
    #editor

    Replace all magic numbers in this file with named constants.
    Group them at the top of the file.
    Examples: 86400 → SECONDS_PER_DAY, 1024 → BYTES_PER_KB
    ```

---

## Task 04 - Flatten Nested Conditionals

**Scenario:** A function has 4 levels of nested `if` blocks.

**Hint:** Ask for guard clauses / early returns.

??? success "Solution"

    ```
    #selection

    Refactor this nested if-else using early returns (guard clauses).
    Behavior must be identical. Do not change the function signature.
    ```

---

## Task 05 - Convert if/elif to Strategy Pattern

**Scenario:** Replace type-checking `if/elif` chains with polymorphic dispatch.

**Hint:** Describe the target design pattern.

??? success "Solution"

    ```
    #file:src/exporters.py

    This file uses if/elif chains to check the type of 'exporter'.
    Refactor to use the Strategy pattern:
    - Abstract base class ExporterStrategy
    - One concrete subclass per exporter type
    - Replace if/elif with polymorphic dispatch
    ```

---

## Task 06 - Optimize a Nested Loop

**Scenario:** An O(n²) nested loop is too slow on large inputs.

**Hint:** Show the loop and ask for O(n) optimization.

??? success "Solution"

    ```
    #selection

    This nested loop is O(n²) and slow on large inputs.
    Optimize it using a dictionary or set to reduce to O(n) if possible.
    Explain the time and space complexity of your solution.
    ```
