# Good Prompts vs Bad Prompts - Examples

This guide shows effective and ineffective prompting strategies for GitHub Copilot.

## General Principles

### ✅ Good Prompts Are:
- **Specific**: Clear about what you want
- **Contextual**: Provide relevant information
- **Actionable**: Request concrete implementations
- **Iterative**: Willing to refine based on output

### ❌ Bad Prompts Are:
- **Vague**: "Make it better"
- **Ambiguous**: Multiple interpretations possible
- **Too Broad**: Asking for too much at once
- **Context-free**: No information about existing code

---

## Exercise 1: Inline Suggestions

### ✅ Good Inline Prompts

```python
# Function to multiply two numbers and return the result
def multiply(x: float, y: float) -> float:
    # Copilot will suggest: return x * y

# Function to divide two numbers, handling division by zero
def divide(x: float, y: float) -> float:
    # Copilot suggests proper error handling
```

### ❌ Bad Inline Prompts

```python
# do math
def calc():
    # Too vague - what math? what inputs?

# div
def d(a, b):
    # No context, unclear abbreviations
```

**Why it matters**: Specific comments with type hints guide Copilot to generate exactly what you need.

---

## Exercise 2-3: Chat Ask

### ✅ Good Chat Ask Prompts

```
"Add a modulo function that takes two numbers and returns the remainder. 
Handle the case where the divisor is zero by raising a ValueError."

"How do I improve the error messages in my divide function to be more 
helpful to users? Show me an example."

"Add input validation to ensure that the numbers passed to my calculator 
functions are actually numeric (int or float)."
```

### ❌ Bad Chat Ask Prompts

```
"Add modulo"
// What should it do when divisor is 0? What should it return?

"Make errors better"
// Which errors? Better how? What's the goal?

"Fix inputs"
// Fix what about them? Validation? Type conversion? Error handling?
```

**Why it matters**: Chat Ask works best with clear, specific requests that explain the desired behavior.

---

## Exercise 4: Chat Plan

### ✅ Good Chat Plan Prompts

```
"Plan how to add scientific functions (sqrt, log, sin, cos, tan) to my 
calculator. Consider:
- Should they be in a separate module or integrated into Calculator class?
- How to handle domain errors (negative sqrt, log of zero)?
- Should we use math library or implement from scratch?
Provide pros and cons for each approach."

"Design a testing strategy for my calculator project. What types of tests 
should I have? How should they be organized? What's a realistic coverage goal?"
```

### ❌ Bad Chat Plan Prompts

```
"Plan scientific calculator"
// No context about current structure, no specific questions

"How to test?"
// Too broad - test what? What's the current state? What's unclear?
```

**Why it matters**: Plan mode shines when you ask architectural questions with specific considerations.

---

## Exercise 7-9: Chat Agent

### ✅ Good Chat Agent Prompts

```
"Refactor my calculator into object-oriented structure:
- Create a Calculator class with all operations as methods
- Maintain all existing functionality (4 basic + 2 advanced operations)
- Add calculation history that stores each operation as: 
  {operation, operands, result, timestamp}
- Provide methods to: get_history(), clear_history()
- Keep all error handling from the current implementation
- Update main() to use the new class structure"

"Add comprehensive history management system:
1. Store calculations in a list with metadata (time, operation, result)
2. Add show_last(n) method to show most recent N calculations
3. Add clear_history() method
4. Add export_history(filename) to save history to text file
5. Add ability to recall last result using get_last_result()
All methods should have proper error handling and docstrings."
```

### ❌ Bad Chat Agent Prompts

```
"Make it OOP"
// No details on what structure, what to preserve, what to add

"Add history stuff"
// What history operations? How should it be stored? What format?

"Refactor everything and make it better and add features"
// Too many vague requests at once - Agent will make arbitrary choices
```

**Why it matters**: Agent mode is autonomous, so you must be explicit about requirements, constraints, and success criteria.

---

## Exercise 10-11: Custom Instructions

### ✅ Good Instructions Creation Prompts

```
"Create a .github/copilot-instructions.md file for my calculator project.
Include specific requirements:

Code Style:
- Python 3.12 type hints (use | for Union, list[int] syntax)
- Google-style docstrings with Args, Returns, Example sections
- Max line length 100 characters

Architecture:
- Class-based design with Calculator as main class
- Separate concerns: logic, I/O, history
- Plugin system for extensibility

Testing:
- Pytest framework
- 90% coverage goal
- Parametrized tests for similar scenarios

Provide specific examples for each guideline."
```

### ❌ Bad Instructions Creation Prompts

```
"Make instructions file"
// What should be in it? What standards matter?

"Create copilot instructions for good code"
// "Good" is subjective - need specific, measurable criteria
```

**Why it matters**: Instructions are persistent context - they must be specific and actionable, not vague principles.

---

## Exercise 12-13: Custom Agents

### ✅ Good Custom Agent Creation Prompts

```
"Create a custom Copilot agent YAML file for a testing specialist:

Name: Testing Specialist
Role: Pytest expert focused on comprehensive coverage

Responsibilities:
- Generate pytest tests with 95%+ coverage
- Identify edge cases developers miss
- Suggest parametrized tests for similar cases
- Provide fixture recommendations
- Follow pytest best practices

Approach:
1. Identify all public methods
2. List edge cases for each
3. Generate tests: happy path → edges → errors
4. Suggest coverage improvements

Include examples of good test generation patterns.
Save to .github/copilot-agents/test-agent.yml"
```

### ❌ Bad Custom Agent Creation Prompts

```
"Make a test agent"
// What should it specialize in? What's its approach?

"Create agent that helps with testing"
// Too generic - no specific expertise or methodology defined
```

**Why it matters**: Custom agents need clear roles, approaches, and examples to be useful specialists.

---

## Exercise 14: Beast Mode

### ✅ Good Beast Mode Prompts

```
"Add four major features to my calculator in parallel:

1. GUI Interface (tkinter):
   - Window with buttons for each operation
   - Display showing current calculation
   - History sidebar

2. Database Persistence (SQLite):
   - Store all calculations
   - Schema: operation, operands, result, timestamp
   - Methods: save_calculation(), load_history()

3. REST API (Flask):
   - Endpoints: /calculate, /history, /clear
   - JSON request/response
   - Error handling

4. Unit Conversion:
   - Length (m, ft, in)
   - Weight (kg, lb)
   - Temperature (C, F, K)

Plan architecture first to ensure features integrate well, then implement 
with tests for each component."
```

### ❌ Bad Beast Mode Prompts

```
"Add GUI, database, API, and conversions all at once"
// No details on any feature - Agent will make all decisions

"Make it do everything"
// Completely unguided - will result in chaotic implementation
```

**Why it matters**: Beast Mode requires clear requirements for each feature AND integration guidance.

---

## Exercise 15: Language Conversion

### ✅ Good Conversion Prompts

```
"Convert my complete Python calculator application to JavaScript (Node.js):

Requirements:
- Translate all Python classes to ES6 classes
- Convert pytest tests to Jest format
- Maintain identical functionality:
  * All arithmetic operations
  * Scientific functions using Math library
  * History management
  * Error handling
- Create package.json with dependencies
- Follow JavaScript naming conventions (camelCase)
- Use JSDoc comments for documentation
- Ensure all Jest tests pass

Provide complete working implementation with tests."
```

### ❌ Bad Conversion Prompts

```
"Make this JavaScript"
// Which parts? Node.js or browser? What about tests?

"Convert to JS and make it work"
// No guidance on conventions, dependencies, or testing framework
```

**Why it matters**: Language conversion requires explicit guidance on idioms, tooling, and equivalents.

---

## Iteration and Refinement

### ✅ Good Follow-Up Prompts

```
"The test_divide_by_zero test is failing. Looking at the error, it seems 
the function is returning None instead of raising an exception. Can you fix 
the divide function to raise ZeroDivisionError when y is 0?"

"Your suggestion works but the error message is generic. Can you make it 
more specific? Like 'Cannot divide {x} by zero' instead of just 'Division by zero'?"

"This implementation is correct but very verbose. Can you refactor it to be 
more concise while keeping the same functionality and error handling?"
```

### ❌ Bad Follow-Up Prompts

```
"It's broken, fix it"
// What's broken? What's the error? What should it do instead?

"Make it shorter"
// Shorter how? Don't sacrifice what?

"Try again"
// No guidance on what was wrong with the first attempt
```

**Why it matters**: Iterative prompting should provide specific feedback on what to improve and why.

---

## Key Takeaways

### The Specificity Spectrum

```
Vague ← → Specific

❌ "add tests"
⚠️  "add some tests for the calculator"
✅ "generate pytest tests for add, subtract, multiply, divide functions with 
    edge cases for zero, negatives, and large numbers"
```

### The Context Principle

```
No Context ← → Rich Context

❌ "refactor this"
⚠️  "refactor the calculator"
✅ "refactor my functional calculator into a Calculator class with methods 
    for each operation, maintaining all error handling and adding history 
    tracking"
```

### The Actionability Rule

```
Abstract ← → Actionable

❌ "make it better"
⚠️  "improve the code quality"
✅ "add type hints to all functions, write Google-style docstrings, and 
    extract the validation logic into a separate _validate_numeric() helper method"
```

---

**Remember**: The quality of Copilot's output is directly proportional to the quality of your prompts. Be specific, provide context, and iterate!
