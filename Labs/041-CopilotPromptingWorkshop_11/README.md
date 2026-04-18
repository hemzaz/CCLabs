# Lab 11 - Reusable Prompts (.github/prompts)

## 01 - Introduction

*   **Reusable Prompts** (also known as Prompt Files) allow you to define and share complex prompts across your team.
*   They are stored as Markdown files in a `.github/prompts` directory.
*   You can reference them in Copilot Chat to quickly apply a specific set of instructions or context.

---

## 02 - Setup

*   To use this feature, you need to create a specific directory structure in your repository.

1.  Create a folder named `.github` in the root of your workspace (if it doesn't exist).
2.  Inside `.github`, create a folder named `prompts`.

```
.github/
└── prompts/
    ├── code-review.prompt.md
    ├── test-gen.prompt.md
    └── ...
```

---

## 03 - Anatomy of a Prompt File

*   A prompt file is a standard Markdown file with the `.prompt.md` extension.
*   It can contain:
    *   **Text**: The instructions for Copilot.
    *   **Context References**: You can use `#file` references to include other files relative to the prompt file.
    *   **Variables**: (Advanced) You can define template variables.

#### Example: `explain-code.prompt.md`

!!! tip
    * Create a file named `explain-code.prompt.md` in the `.github/prompts` directory with the following content:
    
        * You are an expert educator.
        * Explain the selected code to a junior developer.
        * Use analogies and simple language.
        * Focus on the "Why" rather than the "What".
  

---

## 04 - Using Prompt Files

*   Once you have created a prompt file, you can use it in Copilot Chat.
*   In the Chat input, type `#` followed by the name of your prompt file (e.g., `#explain-code`).
*   Copilot will resolve the file and use its content as the prompt context.

---

## 05 - Hands-On: Creating a Reusable Prompt

### Exercise 1: Create the Directory Structure

1.  Open your terminal.
2.  Create the directory `.github/prompts`.

### Exercise 2: Create a "Code Review" Prompt

1.  Create a file named `.github/prompts/review.prompt.md`.
2.  Add the following content:

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

### Exercise 3: Use the Prompt

1.  Open `calculator/calculator.py`.
2.  Select the `divide` function.
3.  Open Copilot Chat.
4.  Type `#review` (or the name of your file) and press Enter.
    *   *Note: If `#review` doesn't auto-complete, you can manually attach the file using the paperclip icon or by typing `#file:.github/prompts/review.prompt.md`.*
5.  Observe the structured output.

<details>
<summary>Solution: review.prompt.md</summary>

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
</details>
