## Lab 13 - Custom Prompts Hands-On

## 10. Hands-On: Prompt Engineering

In this section, you will practice the prompt engineering techniques discussed above by creating a Python script to display dates in different countries.

### Exercise 1: The 4 S's (Single, Specific, Short, Surround)

??? question "Task: The 4 S's (Single, Specific, Short, Surround)"

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

??? question "Task: Few-Shot Prompting"

    1.  We want to create a helper function that returns the date format string for a given country code.
    2.  Provide examples in your prompt:
        *   "Create a function `get_date_format` that returns the format string for a country code.
        *   Examples:
        *   Input: 'US' -> Output: '%m/%d/%Y'
        *   Input: 'UK' -> Output: '%d/%m/%Y'
        *   Input: 'ISO' -> Output: '%Y-%m-%d'"
    3.  See if Copilot can infer the format for 'DE' (Germany) or 'JP' (Japan) if you ask for it next.

### Exercise 3: Iterative Refinement

??? question "Task: Iterative Refinement"

    1.  Start with a basic request:
        *   "Write code to print the current date."
    2.  Refine it to be more specific:
        *   "Modify the code to print the date in Spanish."
    3.  Refine it further for robustness:
        *   "Use the `locale` module to handle the formatting automatically."
    4.  Finally, ask for an explanation:
        *   "Explain how the `locale` module affects date formatting."

### Exercise 4: Mastering Context

??? question "Task: Mastering Context"

    1.  Select the code you generated in Exercise 2 
    2.  Use **#selection** to ask a specific question:
        *   "Explain how daylight saving time is handled in this #selection."
    3.  Use **@workspace** to check for conflicts (even if none exist, it's good practice):
        *   "@workspace Are there any other files in this project that use the `datetime` module?"
