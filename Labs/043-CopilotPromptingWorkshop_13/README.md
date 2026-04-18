# Lab 13 - Custom Prompts & Prompt Engineering

## 01 - Preface

* While GitHub Copilot is powerful out of the box, the quality of its output is directly related to the quality of your input.
* This skill is often called **Prompt Engineering**.
* In this lab, we will explore how to craft effective prompts, moving from basic requests to advanced, context-aware instructions.

---

## 02 - The Basics of Prompting

* A good prompt provides Copilot with the **Intent** (what you want) and the **Context** (what you have).
* Follow the **4 S's** of prompting:

<div class="grid cards" markdown>

-   <span style="color: #5865f2">:material-target:</span> <span style="color: #d14836">**Single**</span>

    ---

    Focus on a single task or question at a time.

-   <span style="color: #5865f2">:material-magnify:</span> <span style="color: #d14836">**Specific**</span>

    ---

    Be explicit about what you want. Avoid ambiguity.

-   <span style="color: #5865f2">:material-ruler:</span> <span style="color: #d14836">**Short**</span>

    ---

    Keep it concise but descriptive.

-   <span style="color: #5865f2">:material-code-brackets:</span> <span style="color: #d14836">**Surround**</span>

    ---

    Open relevant files to provide context.

</div>

#### Examples: Bad vs. Good

| Bad Prompt        | Good Prompt                                                                                       |
|:------------------|:--------------------------------------------------------------------------------------------------|
| "Fix this."       | "Fix the `IndexError` in the `calculate_total` function when the list is empty."                  |
| "Write tests."    | "Write unit tests for `calculator.py` using `pytest`, covering edge cases like division by zero." |
| "Make it better." | "Refactor this function to improve readability and reduce nesting."                               |

---

## Advanced Strategies

* To get the most out of Copilot, use these advanced techniques:

----

## 03. Role Prompting (Persona)

* Tell Copilot who it should be.

    !!! tip "Example Personas"
        * **Example**: "Act as a Senior Python Developer. Review this code for best practices
        * **Example**: "You are a Technical Writer. Generate documentation for the following code."
        * **Example**: "You are a QA Engineer. Write test cases for the following functionality."

---

#### Zero-Shot / One-Shot / Few-Shot Prompting

## 04. Zero-Shot Prompting
* Ask Copilot to perform a task without any examples.

    !!! tip "Example Zero-Shot Prompt"
        * "Generate a function that calculates the factorial of a number."
        * "Write unit tests for the `add` method in the `Calculator` class."
        * "Refactor this code to improve performance."
        * "Create a CLI application that interacts with the user to perform basic arithmetic operations using the `Calculator` class from `calculator/calculator.py`. 
        * The application should:
            1. Prompt the user to enter an operation (add, subtract, power, modulus).
            2. Based on the operation, ask for the required number(s).
            3. Display the result of the calculation.
            4. Allow the user to perform multiple calculations until they choose to exit."
            5. Handle invalid inputs gracefully.
            6. Log detailed information about each operation performed.

---

## 05. One-Shot Prompting
* Provide a single example to guide Copilot.

    !!! tip "Example One-Shot Prompt"
        * **Example**: "Here is a function that adds two numbers:
            ```python
            def add(a: int, b: int) -> int:
                return a + b
            ```
            Now, write a function that subtracts two numbers.
        ---
        * **Example**: "Here is a unit test for the `add` function:
            ```python
            def test_add():
                assert add(2, 3) == 5
                assert add(-1, 1) == 0
            ```
            Now, write a unit test for the `add` function.

---

## 06. Few-Shot Prompting

* Provide examples of what you want.

    !!! tip "Example Few-Shot Prompt"
        * Convert these file names to snake_case:
            * Input: UserLogin.py -> Output: user_login.py
            * Input: DataManager.js -> Output: data_manager.js
            * Input: PageLayout.css -> Output:


---

## 07. Explicit Reasoning

* Ask Copilot to think through the problem step-by-step.
* Ask Copilot to explain its reasoning step-by-step. 
* This often leads to more accurate results.

    !!! tip "Example Reasoning Prompt"
            
        "Explain how this regex works step-by-step, then optimize it."

---

## 08. Iterative Refinement

* Don't stop at the first answer. 
* Refine **your** prompt based on the output.
    
    !!! tip "Example Iterative Refinement"
        
        * **Example**: "That's good, but now make it async." -> "Now add error handling."
        * **Example**: "This function works, but can you optimize it for performance?"
        * **Example**: "The tests are good, but add edge cases for negative inputs."

---

## 09. Mastering Context

* Copilot needs context to understand your codebase. 
* You can explicitly provide this using **Context Variables**.

| Variable     | Description                                                                   |
|:-------------|:------------------------------------------------------------------------------|
| `@workspace` | Searches the entire workspace for context. Use this for high-level questions. |
| `@vscode`    | Asks about VS Code commands and settings.                                     |
| `@terminal`  | Context from the integrated terminal (last command, output).                  |
| `#file`      | References a specific file. (e.g., `#calculator.py`)                          |
| `#selection` | References the currently selected code.                                       |
| `#editor`    | References the visible code in the active editor.                             |

---

## 10. Hands-On: Prompt Engineering

In this section, you will practice the prompt engineering techniques discussed above by creating a Python script to display dates in different countries.

### Exercise 1: The 4 S's (Single, Specific, Short, Surround)

1.  Create a new file named `date_formatter.py`.
2.  Try a **Bad Prompt** in the Chat view:
    *   "Dates."
    *   Observe the response. It is likely too generic.
3.  Now, try a **Good Prompt** applying the 4 S's:
    *   **Surround**: Ensure `date_formatter.py` is open.
    *   **Specific**: "Write a Python function `format_date_germany` that takes a `datetime` object and returns it as a string formatted for Germany (DD.MM.YYYY)."
    *   **Short**: Keep it direct.
    *   **Single**: Ask for just this one function.
4.  Verify that Copilot generates the correct function.

### Exercise 2: Few-Shot Prompting

1.  We want to create a helper function that returns the date format string for a given country code.
2.  Provide examples in your prompt:
    *   "Create a function `get_date_format` that returns the format string for a country code.
    *   Examples:
    *   Input: 'US' -> Output: '%m/%d/%Y'
    *   Input: 'UK' -> Output: '%d/%m/%Y'
    *   Input: 'ISO' -> Output: '%Y-%m-%d'"
3.  See if Copilot can infer the format for 'DE' (Germany) or 'JP' (Japan) if you ask for it next.

### Exercise 3: Iterative Refinement

1.  Start with a basic request:
    *   "Write code to print the current date."
2.  Refine it to be more specific:
    *   "Modify the code to print the date in Spanish."
3.  Refine it further for robustness:
    *   "Use the `locale` module to handle the formatting automatically."
4.  Finally, ask for an explanation:
    *   "Explain how the `locale` module affects date formatting."

### Exercise 4: Mastering Context

1.  Select the code you generated in Exercise 2 
2.  Use **#selection** to ask a specific question:
    *   "Explain how daylight saving time is handled in this #selection."
3.  Use **@workspace** to check for conflicts (even if none exist, it's good practice):
    *   "@workspace Are there any other files in this project that use the `datetime` module?"

