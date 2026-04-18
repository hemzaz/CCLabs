# Lab 09 - Custom Instructions

## 01 - Preface

* `GitHub Copilot` allows you to provide **Custom Instructions** to tailor its responses to your specific needs, coding style, and project requirements. 
* **Custom Instructions** act as a persistent context that Copilot considers for **every chat interaction** and code generation.

#### There are two main types of custom instructions:

<div class="grid cards" markdown>

-   <span style="color: #5865f2">:material-account-cog:</span> <span style="color: #d14836">**User-Specific Instructions**</span>

    ---

    Configured in your IDE settings. 
    These apply to *all* projects you work on in that IDE.

-   <span style="color: #5865f2">:material-file-document-edit:</span> <span style="color: #d14836">**Repository-Specific Instructions**</span>

    ---

    Stored in a `.github/copilot-instructions.md` file in your repository. These apply to *anyone* working on that specific project.

</div>

* In this lab, we will explore how to set up both, with a focus on creating a robust repository-level instruction file.

---

## 02 - User Custom Instructions (GUI)

You can configure custom instructions directly through your IDE's settings. This is useful for setting your personal preferences (e.g., "Always use Python type hints", "Prefer concise answers").

=== ":fontawesome-solid-code: VS Code"

    1.  Open **Settings** (`Cmd+,` on macOS, `Ctrl+,` on Windows/Linux).
    2.  Search for **"Copilot Custom Instructions"**.
    3.  Look for **GitHub > Copilot > Chat: Code Generation Instructions**.
    4.  You can typically provide a file path or edit the settings directly depending on the version.
    5.  Alternatively, open the **Copilot Chat** pane, click the `...` menu, and look for **"Edit Custom Instructions"** (if available in your version).

=== ":fontawesome-brands-windows: Visual Studio"

    1.  Go to **Tools** > **Options**.
    2.  Navigate to **GitHub** > **Copilot**.
    3.  Look for the **Custom instructions** text box.
    4.  Enter your instructions here.

=== ":fontawesome-solid-laptop-code: JetBrains"

    1.  Open **Settings** (macOS: `Cmd+,`, Windows/Linux: `Ctrl+Alt+S`).
    2.  Navigate to **Languages & Frameworks** > **GitHub Copilot**.
    3.  Find the **Custom Instructions** section.
    4.  Enter your instructions.

---

## 03 - Repository Instructions

* For shared projects, it is best practice to use a `.github/copilot-instructions.md` file. 
* This ensures that all team members (and Copilot) adhere to the same project standards.

#### Where to save it

*   **File Path**: `.github/copilot-instructions.md`
*   **Location**: Root of your repository.

#### What to write

* Effective custom instructions should cover:

<div class="grid cards" markdown>

-   <span style="color: #5865f2">:material-account-tie:</span> <span style="color: #d14836">**Role**</span>

    ---

    Who is Copilot acting as? (e.g., "Expert Python Developer").

-   <span style="color: #5865f2">:material-format-paint:</span> <span style="color: #d14836">**Style**</span>

    ---

    Naming conventions, formatting, type hinting.

-   <span style="color: #5865f2">:material-test-tube:</span> <span style="color: #d14836">**Testing**</span>

    ---

    Preferred frameworks (pytest, unittest), coverage requirements.

-   <span style="color: #5865f2">:material-layers:</span> <span style="color: #d14836">**Tech Stack**</span>

    ---

    Specific libraries or versions to use (e.g., "Use Pydantic v2").

-   <span style="color: #5865f2">:material-chat-processing:</span> <span style="color: #d14836">**Behavior**</span>

    ---

    How should Copilot respond? (e.g., "Be concise", "Always explain the 'why'").

-   <span style="color: #5865f2">:material-file-document:</span> <span style="color: #d14836">**Documentation**</span>

    ---

    Docstring standards (Google/NumPy), comment style, and README updates.

-   <span style="color: #5865f2">:material-alert-circle:</span> <span style="color: #d14836">**Error Handling**</span>

    ---

    Preferred exception types, logging practices, and error message formats.

-   <span style="color: #5865f2">:material-shield-lock:</span> <span style="color: #d14836">**Security**</span>

    ---

    Input validation rules, avoiding hardcoded secrets, and secure coding practices.

-   <span style="color: #5865f2">:material-speedometer:</span> <span style="color: #d14836">**Performance**</span>

    ---

    Efficiency considerations, complexity limits, and resource management.

-   <span style="color: #5865f2">:material-git:</span> <span style="color: #d14836">**Git Conventions**</span>

    ---

    Commit message styles (Conventional Commits), branching strategies.

</div>

---

## 04 - Hands-On

#### Generating Custom Instructions

* Instead of writing the instructions from scratch, let's use `GitHub Copilot` to generate a draft for us based on our project context.

### 01: Create from prompt

* Use the following prompt to generate a comprehensive instruction file.

    !!! tip "Prompting Copilot"
        ```text
        @workspace I want to create a .github/copilot-instructions.md file for this repository. 
        Please analyze the current codebase (Python, Calculator project) 
        and generate a comprehensive set of custom instructions. 
        
        Include sections for:
          01. Code Style (PEP 8, type hints)
          02. Testing (pytest)
          03. Documentation (Google style docstrings)
          04. Architecture (Class-based, modular)
          05. Behavior (Concise, professional)
          06. Error Handling (ValueError for invalid inputs)
          07. Library Preferences (standard library only)
          08. Performance (efficient algorithms)
          09. Git Conventions (Conventional Commits)
          10. Security (input validation)
          11. Use "double quotes" for strings.
    
        Format the instructions in Markdown and save it in the `.github/copilot-instructions.md` file.
        ```

* Copy the generated content into `.github/copilot-instructions.md`.
    <details>
    <summary>Example Generated Instructions</summary>
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
    </details>

---

### 02: Create from scratch

  1. Create a new folder named `.github` in the root of your workspace if it doesn't exist.
  2. Create a file named `copilot-instructions.md` inside it.
  3. Copy the content generated by Copilot into this file.
  4. Review and refine the instructions.

---

### 03 - Checklist

* Ensure your `copilot-instructions.md` covers the major parts. Use this checklist to verify:
* Validating Your Instructions

    - [ ] **Role Definition**: Does it define Copilot's persona?
    - [ ] **Code Style**: Are naming conventions and formatting rules clear?
    - [ ] **Type Safety**: Are type hints explicitly required?
    - [ ] **Testing Strategy**: Is the testing framework and style specified?
    - [ ] **Documentation**: Are docstring formats (e.g., Google, NumPy) defined?
    - [ ] **Error Handling**: Are there instructions on how to handle exceptions?
    - [ ] **Library Preferences**: Does it mention specific libraries to use or avoid?

---

#### Example of a good instruction block:

```markdown
## Code Style
- **Python Version**: Target Python 3.12+.
- **Type Hints**: MUST be used for all function arguments and return values.
- **Docstrings**: Use Google-style docstrings for all public modules, classes, and functions.
- **Formatting**: Follow PEP 8. Max line length 100 characters.
```

---

## 05 - Testing the Instructions

* Now that you've created the file, let's test if Copilot is respecting it.

  1.  Open `calculator/calculator.py`.
  2.  Write in the custom instructions: (1st line of the file)
      ```text
      Reply in spanish
      ```
  3.  Ask Copilot to anything
  4.  Verify that the response is in Spanish.
  

    <img src="../assets/images/custom-instructions.png" alt="Custom Instructions in Action" style="max-width:800px;"/>

---
<center>
  <img src="https://raw.githubusercontent.com/nirgeier/labs-assets/main/assets/images/well_done.jpg" alt="Well Done" style="max-width:400px; border-radius:50% ;"/>
</center>


