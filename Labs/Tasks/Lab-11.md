## Lab 11 - Reusable Prompts Hands-On

## 01 - Setup

??? question "Task: Create the Directory Structure"

    1. Open your terminal.
    2. Create the directory `.github/prompts/` in the root of your project:

        ```bash
        mkdir -p .github/prompts
        ```

---

## 02 - Anatomy of a Prompt File

??? question "Task: Understand Prompt File Structure"

    A prompt file (`.prompt.md`) has two parts:

    1. **YAML Frontmatter** (optional) - metadata like `description`, `mode`, `tools`.
    2. **Markdown Body** - the actual prompt instructions.

    Create a file `.github/prompts/explain-code.prompt.md` with:

    ```markdown
    ---
    description: "Explain selected code in plain English"
    mode: "ask"
    ---
    Explain the selected code clearly and concisely.
    Include:
    1. What the code does
    2. Key logic and control flow
    3. Any edge cases handled
    ```

---

## 03 - Create a Code Review Prompt

??? question "Task: Build a Review Prompt"

    1. Create a file named `.github/prompts/review.prompt.md`.
    2. Add the following content:

        ```markdown
        You are a strict code reviewer.
        Review the selected code for:
        1. Security vulnerabilities.
        2. Performance bottlenecks.
        3. Adherence to PEP 8 (Python) standards.

        Provide your feedback in a markdown table with columns:
        - Severity (High/Medium/Low)
        - Issue
        - Suggestion
        ```

---

## 04 - Use the Prompt

??? question "Task: Invoke Your Prompt"

    1. Open `calculator/calculator.py`.
    2. Select the `divide` function.
    3. Open Copilot Chat.
    4. Type `#review` (or the name of your file) and press Enter.
        - If `#review` doesn't auto-complete, manually attach the file using the paperclip icon or by typing `#file:.github/prompts/review.prompt.md`.
    5. Observe the structured table output.
    6. Now try `#explain-code` on a different function and compare the response format.

---

## 05 - Create Your Own Prompt

??? question "Task: Design a Custom Prompt"

    1. Think of a task you repeat often (e.g., writing docstrings, creating fixtures, generating SQL).
    2. Create a new `.prompt.md` file in `.github/prompts/`.
    3. Include:
        - A clear description in the frontmatter
        - Specific instructions in the body
        - Expected output format
    4. Test it by invoking it with `#<filename>` in Chat.
    5. Iterate on the prompt until the output matches your expectations.
