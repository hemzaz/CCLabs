# Lab 019 - Debugging with Copilot

!!! hint "Overview"

    - GitHub Copilot is a powerful debugging partner that can diagnose errors, trace bugs, and explain complex stack traces.
    - In this lab, you will submit failing code, error messages, and logs to Copilot and receive targeted fix suggestions.
    - You will learn how to use `/fix` in Chat, Inline Chat on error lines, and context-rich prompts to accelerate debugging.
    - By the end of this lab, you will be faster at resolving runtime errors and more systematic in your debugging approach.

## Prerequisites

- Completed [Lab 018 - Code Review](../018-CodeReview/README.md)

## What You Will Learn

- How to explain and fix runtime errors with Copilot
- How to interpret stack traces using `#terminalLastCommand`
- How to use Copilot to add strategic logging
- How to debug asynchronous and concurrent code issues
- How to use Copilot in the VS Code Debugger

---

## Lab Steps

## Step 1 - Explain a Stack Trace

Run your application and let it crash. Then in Copilot Chat:

```
#terminalLastCommand

Explain this error. What caused it, what line is the root cause,
and how do I fix it?
```

Example stack trace Copilot can diagnose:

```
TypeError: Cannot read properties of undefined (reading 'email')
    at UserService.sendWelcomeEmail (/app/services/UserService.ts:47:32)
    at async AuthController.register (/app/controllers/AuthController.ts:23:5)
```

## Step 2 - Fix Errors with `/fix`

Select the problematic code and use the `/fix` slash command:

1. Select the error-throwing code
2. Use Copilot Chat: `/fix`
3. Copilot explains the issue and provides a corrected version

## Step 3 - Debug Logical Errors

For bugs where the code runs but produces wrong output:

```python
# This function should return the average, but it's returning wrong values
def calculate_average(numbers):
    total = 0
    for n in numbers:
        total += n
    return total / len(numbers) + 1  # bug here
```

Ask:

```
This calculate_average function is returning incorrect results.
For input [2, 4, 6], it returns 5.0 instead of 4.0.
Identify the bug and fix it.
```

## Step 4 - Add Strategic Debug Logging

```
@workspace Add debug logging to the order processing pipeline
(OrderService.processOrder and PaymentService.charge) to help trace
why some orders are being silently dropped.
Use a structured logging format with order ID, timestamp, and step name.
```

## Step 5 - Debug Async/Promise Issues

Problematic async code:

```javascript
async function fetchUserOrders(userId) {
  const user = await getUser(userId);
  const orders = getOrders(userId); // forgot await!
  return { user, orders };
}
```

Ask:

```
This function returns a Promise object instead of the actual orders array.
Identify all missing awaits and other async issues in this function.
```

## Step 6 - Memory Leak Detection

```
@workspace Analyze the event listener registrations in src/components/.
Are there any components that register listeners but don't remove them
on unmount? This could cause memory leaks.
```

## Step 7 - Use Copilot with VS Code Debugger

1. Set a breakpoint in your code
2. Start the VS Code Debugger (`F5`)
3. When the program pauses, open Copilot Chat:

```
#editor

The program is paused at line 47. The variable `user` is null even though
we checked for it two lines above. What could have caused this?
```

## Step 8 - Race Condition Analysis

```
We have an intermittent bug where users occasionally see stale data
after updating their profile. The issue happens about 1 in 20 times.

#file:src/services/UserService.ts
#file:src/controllers/UserController.ts

Analyze the code for race conditions in the update flow.
Could there be a caching issue or concurrent request problem?
```

---

## Debugging Patterns with Copilot

| Problem Type     | Approach                                               |
| :--------------- | :----------------------------------------------------- |
| Stack trace      | Paste into Chat with `#terminalLastCommand`            |
| Logic bug        | Describe expected vs actual behavior                   |
| Async issue      | Show the async chain, ask to identify missing `await`  |
| Memory leak      | Ask to find listeners/resources not cleaned up         |
| Race condition   | Show concurrent code paths, ask for analysis           |
| Intermittent bug | Describe conditions when it occurs, show relevant code |

---

## Summary

Copilot excels at understanding error patterns, explaining complex stack traces in plain English, and suggesting targeted fixes - cutting debugging time significantly.

## Next Steps

Continue with [Lab 020 - Database Queries](../020-DatabaseQueries/README.md)

---

## Tasks

## Task 01 - Explain a Stack Trace

**Scenario:** Your app crashed with a cryptic stack trace. Ask Copilot to explain it.

**Hint:** Use `#terminalLastCommand` after the crash, or paste the trace.

??? success "Solution"

    ````
    #terminalLastCommand

    Explain this error. What caused it, which line is the root cause,
    and how do I fix it?
    ```

---

## Task 02 - Fix with `/fix`

**Scenario:** Select error-throwing code and use `/fix` to get a corrected version.

**Hint:** Select the problematic code, Chat → `/fix`

??? success "Solution"

    1. Select the code causing the error
    2. Open Copilot Chat
    3. Type `/fix`
    4. Copilot explains the issue and shows a corrected version with a diff

---

## Task 03 - Debug a Logic Error

**Scenario:** A function returns wrong output even though it doesn't crash.

**Hint:** Describe expected vs actual output.

??? success "Solution"

    ````

    #selection

    This function should return the average of a list of numbers.
    For input [2, 4, 6] it returns 5.0 instead of 4.0.
    Find the bug and fix it.
    ```

---

## Task 04 - Add Debug Logging

**Scenario:** Silent failures make it hard to trace an issue. Add structured logging.

**Hint:** Describe which functions need logging and what info to include.

??? success "Solution"

    `     @workspace Add debug logging to the order processing pipeline
    (OrderService.processOrder and PaymentService.charge).
    Use structured logging with: order_id, timestamp, step_name, and result.
    `

---

## Task 05 - Find a Missing `await`

**Scenario:** A function returns a Promise object instead of the resolved value.

**Hint:** Paste the async function and describe the symptom.

??? success "Solution"

    ````
    This function returns a Promise object as the value of 'orders' instead of the array.

    #selection

    Find all missing awaits and other async issues. Explain each one.
    ```

---

## Task 06 - Analyze a Race Condition

**Scenario:** A bug occurs 1 in 20 times - likely a race condition.

**Hint:** Show the concurrent code paths and describe the intermittent behavior.

??? success "Solution"

    ````

    #file:src/services/UserService.ts
    #file:src/controllers/UserController.ts

    Users occasionally see stale profile data after updating it (about 1 in 20 times).
    Analyze for race conditions, caching issues, or concurrent request problems.
    ```
