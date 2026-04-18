# 031 - Copilot Prompting Workshop

## Overview

Welcome to the **Copilot Prompting Workshop**, a comprehensive 13-section learning module designed to take you from GitHub Copilot basics to advanced customization and prompt engineering. This workshop is structured as a progressive learning path that builds upon itself, starting with setup and foundational concepts, and advancing through powerful features like Agent Mode, custom instructions, and prompt engineering.

## What You'll Learn

Throughout this workshop, you'll master:

- **Core Copilot Features**: Inline suggestions, inline chat, and full chat interface
- **Advanced Capabilities**: Plan Mode, Agent Mode, and automated workflows
- **Customization**: Custom instructions, reusable prompts, and custom agents
- **Best Practices**: Effective prompt engineering and code generation strategies

## Prerequisites

- VS Code or compatible IDE with GitHub Copilot installed
- Basic Python knowledge
- A terminal or command-line interface
- Enthusiasm for learning cutting-edge AI-assisted development!

---

## Table of Contents

1. [Section 1 - Setup](#section-1--setup)
2. [Section 2 - Inline Suggestions](#section-2--inline-suggestions)
3. [Section 3 - Inline Chat](#section-3--inline-chat)
4. [Section 4 - Chat](#section-4--chat)
5. [Section 5 - Built-in Prompts](#section-5--built-in-prompts)
6. [Section 6 - Plan Mode](#section-6--plan-mode)
7. [Section 7 - Agent Mode (Part 1)](#section-7--agent-mode-part-1)
8. [Section 8 - Building a CLI with Agent](#section-8--building-a-cli-with-agent)
9. [Section 9 - Custom Instructions](#section-9--custom-instructions)
10. [Section 10 - Advanced Instructions](#section-10--advanced-instructions)
11. [Section 11 - Reusable Prompts](#section-11--reusable-prompts)
12. [Section 12 - Custom Agents & Chat Extensions](#section-12--custom-agents--chat-extensions)
13. [Section 13 - Custom Prompts & Prompt Engineering](#section-13--custom-prompts--prompt-engineering)

---

## Section 1 - Setup

In this section, we will guide you through the initial setup required to get started with the Copilot Prompting Workshop.

## 01 - Create Workshop Directory

- Open your VS Code and create new directory named `Copilot-Prompts-Workshop`.
- Open the created directory in VS Code.

## 02 - Create Virtual Environment

- The virtual environment will help us manage dependencies for the workshop.
- Run the following command in your terminal to create a virtual environment named `venv`

  ```bash
  python -m venv .venv
  ```

## 03 - Activate the venv

=== "Windows (cmd)"
`cmd
    .venv\Scripts\activate
    `

=== "Windows (PowerShell)"
`powershell
    .venv\Scripts\Activate.ps1
    `

=== "macOS / Linux (bash/zsh)"
`bash
    source .venv/bin/activate
    `

=== "Git Bash (Windows)"
`bash
    source .venv/Scripts/activate
    `

In this section, you will set up the basic code skeleton for the Copilot Prompting Workshop. This includes creating the necessary files as we progress along the labs.

!!! question "Instructions"

    The workshop is based upon creating a simple Calculator in Python with the help of `GitHub Copilot prompts`.

---

## 04 - Create Project Structure

- Create a new directory named `calculator` in your workshop folder.

- Inside the `calculator` directory, create the following file:
  - `calculator.py` - This will be the main module for our calculator functions.
    - Inside `calculator.py` and add the following starter code:
      ```python
      # calculator.py
      def add(x, y):
          """Add two numbers."""
          return x + y
      ```

- Your project structure should look like this:
  ```
  Copilot-Prompts-Workshop/
  ├── calculator/
  │   └── calculator.py
  ```

---

## 05 - Install Required Extensions

- Install the following Python Packages:

  ```bash
  # Create the .venv as explained above if you haven't already.
  source .venv/bin/activate   # or the appropriate command for your OS
  pip install uv

  # Will be used in later labs
  uv pip install pytest
  ```

---

## 06 - Optional .github folders

- (Optional) Create a `.github` folder in the root of your project directory.
- The `.github` folder is a special directory used to store configuration files and templates that are specific to GitHub's platform features.
- List of common subfolders used by Github Copilot and their purposes:

  | Folder           | Description & Usage                                                       |
  | :--------------- | :------------------------------------------------------------------------ |
  | `copilot-agents` | Contains definitions for custom Copilot agents, define specialized agents |
  | `examples`       | Contains example configurations or code for implementation                |
  | `instructions`   | Contains custom instruction files for Copilot                             |
  | `prompts`        | Directory for storing prompts.                                            |

#### Other Folders:

- List of other common subfolders and files under `.github` folder and their purposes:

  | Folder                   | Description                                                                                                                                                                           |
  | :----------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
  | `workflows/`             | The most common folder. It contains YAML files for **GitHub Actions**, which automate tasks like building, testing, and deploying your code.                                          |
  | `ISSUE_TEMPLATE/`        | Used to create structured forms or templates for new issues. This ensures that users provide specific information (like bug reports or feature requests) when they open a new ticket. |
  | `PULL_REQUEST_TEMPLATE/` | While often just a single file (`PULL_REQUEST_TEMPLATE.md`), this can also be a directory if you want to offer multiple types of pull request templates.                              |
  | `actions/`               | Often used to store **Local Actions**-custom scripts or Docker containers created specifically for that repository rather than being hosted in a separate public repo.                |
  | `linters/`               | Sometimes used to store configuration files for linting tools (like Super-Linter) to keep the root directory clean.                                                                   |
  | `scripts/`               | A place for internal automation scripts that are called by GitHub Actions but aren't part of the main project source code.                                                            |
  | `CODEOWNERS`             | A file that defines individuals or teams responsible for code in a repository. It helps in automatically requesting reviews when changes are made to the code they own.               |
  | `FUNDING.yml`            | Allowing users to support the project financially                                                                                                                                     |
  | `SECURITY.md`            | Outlining the security policies and procedures for reporting vulnerabilities in the project.                                                                                          |

  !!! danger "Important Note"
  Those `.github` files & folders and their contents are optional for this workshop, but they can enhance your experience with GitHub Copilot features.

---

## Section 2 - Inline Suggestions

## 01 - Single Inline Suggestion

- In this step, we will use `GitHub Copilot` to help us add a new function to our calculator.

* Open `calculator/calculator.py` in VS Code.
* Use `GitHub Copilot` to help you add a new function `subtract(x, y)` that subtracts two numbers.

  !!! tip "Using GitHub Copilot to add subtract function" - Place your cursor below the `add` function. - Type a comment describing the function you want to create:
  `python
        # Add function to subtract two numbers
        ` - Wait for `GitHub Copilot` to suggest the implementation of the `subtract` function. - Accept the suggestion by pressing `Tab` or `Enter`.

* After adding the function, your `calculator.py` should look like this:

  ```python
  # calculator.py
  def add(x, y):
      """Add two numbers."""
      return x + y

  def subtract(x, y):
      """Subtract two numbers."""
      return x - y
  ```

---

## 02 - Multiple Inline Suggestion

- Now, based upon what we used above, add 2 more methods for multiply and divide.

- Use `GitHub Copilot` to help you add a new function `multiply(x, y)` that multiplies two numbers.
- Use `GitHub Copilot` to help you add a new function `divide(x, y)` that divides two numbers.
- **This time we will add both functions together.**

  !!! tip "Using GitHub Copilot to add multiply and divide functions"
  _ Place your cursor below the `subtract` function.
  _ Type a comment describing the function you want to create:
  `python
        # Add function to multiply two numbers
        # Add function to divide two numbers
        `
  _ Wait for `GitHub Copilot` to suggest the implementation of the `multiply` and `divide` functions.
  _ Accept the suggestion by pressing `Tab` or `Enter`.

- After adding the functions, your `calculator.py` should look like this:

  ```python
  # calculator.py

  def add(a, b):
      return a + b

  # Add subtract function
  def subtract(a, b):
      return a - b

  # Add function to multiply two numbers
  # Add function to divide two numbers
  def multiply(a, b):
      return a * b

  def divide(a, b):
      if b == 0:
          raise ValueError("Cannot divide by zero.")
      return a / b
  ```

- If the code does not match, for example the divide by zero check is missing, we will handle it in the next section.
- Congratulations!
  - You have successfully used GitHub Copilot to add multiple functions to your calculator using inline suggestions.

---

## 03 - Contextual Suggestions

- GitHub Copilot understands the context of your code. Since we are building a calculator with arithmetic operations, it can anticipate other common mathematical functions.

- Let's add a power function.
- Place your cursor at the end of the file.
- Start typing `def power` and pause.

  !!! tip "Adding power function"
  Type:
  `python
        def power
        `
  _ Copilot will likely suggest:
  `python
        def power(a, b):
            return a ** b
        `
  _ Accept the suggestion.

- Now, let's try to add a square root function.
- Start typing `def sq`.

  !!! tip "Adding square root function"
  _ Type:
  `python
        def sq
        `
  _ Copilot should suggest a square root implementation.
  _ Note that it might suggest importing `math` or using `** 0.5`.
  _ If it suggests `math.sqrt`, make sure to add `import math` at the top of the file if it's not there, or let Copilot handle it.

---

## Section 3 - Inline Chat

In this section, we will explore the **Inline Chat** feature of GitHub Copilot.

## Overview

- Inline Chat allows you to ask Copilot to generate code, refactor existing code, or explain code directly within the editor, without switching to a separate chat window.
- This feature enhances productivity by providing context-aware assistance right where you need it.
- You will learn how to effectively use Inline Chat to improve your coding workflow.

---

<img src="../assets/images/tldr.png" alt="Inline Chat Overview" style="width:100px; border-radius:25px;"/>

1.  **Open Inline Chat**.
2.  **Generate Code**.
3.  **Refactor Code**.

---

## Steps to Use Inline Chat

#### 01. Open Inline Chat:

- This can be done in several ways.
  - Press `Cmd+I` (macOS) or `Ctrl+I` (Windows/Linux).
  - Use the Icon from the `Github Copilot` top icon.
  - Right-click in the editor and select `GitHub Copilot: Open Inline Chat`.
- Once the Inline Chat panel is open, you can type your request in the input box at the bottom.

---

#### 02. Use Inline Chat

- Mark the multiply function in the code editor.
- Open Inline Chat using one of the methods described above.
- In the Inline Chat input box, here are few example prompts you can use:

  ```
  Refactor this function to use arrow function syntax.
  ```

  ```
  Explain what this function does.
  ```

  ```
  Add documentation comments to this function.
  ```

---

#### 03. Task: Improve Code Quality

- Let's use Inline Chat to make our code more robust and readable.

##### 03.01. Add Type Hints:

- Select all the code in `calculator/calculator.py` (`Cmd+A` / `Ctrl+A`).
- Open Inline Chat (`Cmd+I` / `Ctrl+I`).
- Type: `Add type hints to all functions`.
- Review the changes (Copilot will show a diff view).
- Accept the changes.
    <details>
    <summary>Expected Code After Type Hints</summary>
        ```python
        # calculator.py

        def add(a: float, b: float) -> float:
            return a + b

        # Add subtract function
        def subtract(a: float, b: float) -> float:
            return a - b

        # Add function to multiply two numbers
        # Add function to divide two numbers
        def multiply(a: float, b: float) -> float:
            return a * b

        def divide(a: float, b: float) -> float:
            if b == 0:
                raise ValueError("Cannot divide by zero.")
            return a / b
        ```

    </details>

##### 03.02. Add Docstrings

- Select all the code again.
- Open Inline Chat.
- Type: `Add Google-style docstrings to all functions`.
- Accept the changes.
    <details>
    <summary>Expected Code After Docstrings</summary>
        ```python
        # calculator.py
        def add(a: float, b: float) -> float:
            """Add two numbers.

            Args:
                a: First number.
                b: Second number.

            Returns:
                The sum of a and b.
            """
            return a + b

        ... (similar docstrings for other functions) ...
        ```
      </details>

##### 03.03. Task: Error Handling

- Ensure our calculator handles edge cases gracefully.
- **Validate Division**: `("Cannot divide by zero.")`
- Select the `divide` function.
- Open Inline Chat.
- Type: `Update this function to raise a ValueError if dividing by zero, if not already present`.
- Copilot should either confirm it's there or add the check.
- Accept the changes if any.
    <details>
    <summary>Expected Code After Error Handling</summary>
      ```python
      def divide(a: float, b: float) -> float:
          """Divide two numbers.

          Args:
              a: Numerator.
              b: Denominator.

          Raises:
              ValueError: If b is zero.

          Returns:
              The result of a divided by b.
          """
          if b == 0:
              raise ValueError("Cannot divide by zero.")
          return a / b
      ```
      </details>

---

## Section 4 - Chat

In this section we will write prompts in the chat asking it to create main python code which will test our calculator.

## Overview

- The chat feature allows you to have a more interactive experience with GitHub Copilot
- `GitHub Copilot Chat`, enabling you to `ask` questions, `request` code snippets, and much more.
- The chat mode is the core of GitHub Copilot's advanced capabilities, allowing for a more conversational and context-aware coding experience.

---

<img src="../assets/images/tldr.png" alt="Chat Overview" style="width:100px; border-radius:25px;"/>

1.  **Open Chat**.
2.  **Request Code Generation**.
3.  **Ask Questions**.

---

## Steps to Use Chat

#### 01. Open Chat:

- You can open the Chat panel in several ways:
  - Press `Cmd+Shift+C` (macOS) or `Ctrl+Shift+C` (Windows/Linux).
  - Use the Icon from the `Github Copilot` top icon.
  - Right-click in the editor and select `GitHub Copilot: Open Chat`.
- Once the Chat panel is open, you can type your requests in the input box at the bottom.

---

#### 02. Use Chat

- In this task, we will use Chat to generate a `main.py` file that tests all functions in our `calculator.py` file.
- In the Chat input box, write the following prompt:

  ```
  1. Generate a main.py file that tests all functions in calculator.py
  2. Explain how to use the add function in calculator.py
  3. Print out instructions on how to run the tests
  ```

    <details>
    <summary>Possible solution</summary>

  ```python
  import calculator

  def test_add():
      """Test the add function."""
      assert calculator.add(1, 2) == 3
      assert calculator.add(-1, 1) == 0
      assert calculator.add(0, 0) == 0
      print("test_add passed")

  def test_subtract():
      """Test the subtract function."""
      assert calculator.subtract(5, 3) == 2
      assert calculator.subtract(1, 5) == -4
      assert calculator.subtract(0, 0) == 0
      print("test_subtract passed")

  def test_multiply():
      """Test the multiply function."""
      assert calculator.multiply(2, 3) == 6
      assert calculator.multiply(-2, 3) == -6
      assert calculator.multiply(0, 5) == 0
      print("test_multiply passed")

  def test_divide():
      """Test the divide function."""
      assert calculator.divide(6, 2) == 3
      assert calculator.divide(5, 2) == 2.5

      # Test division by zero
      try:
          calculator.divide(1, 0)
          print("Error: ZeroDivisionError not raised")
      except ValueError as e:
          assert str(e) == "Cannot divide by zero."
      print("test_divide passed")

  if __name__ == "__main__":
      print("Running tests...")
      test_add()
      test_subtract()
      test_multiply()
      test_divide()
      print("All tests passed!")
  ```

    </details>

---

#### 03. Adding tests

- In the chat window, choose the `Agent Mode`
- Open the `calculator/calculator.py` file or add it as context to the chat.
- Type the following prompt:

  ```
  1. Add square and root functions to the calculator.py file
  2. Add tests for power and square root functions in main.py
  3. Ensure the square root function handles negative inputs by raising a ValueError
  4. Print out instructions on how to run the tests

  ```

    <details>
    <summary>Possible solution</summary>

  ```python
  # calculator.py
  def square(n: float) -> float:
      """Return the square of a number.

      Args:
          n: The number to square.

      Returns:
          The square of n.
      """
      return n * n

  def sqrt(n: float) -> float:
      """Return the square root of a number.

      Args:
          n: The number to find the square root of.

      Returns:
          The square root of n.

      Raises:
          ValueError: If n is negative.
      """
      if n < 0:
          raise ValueError("Cannot calculate square root of a negative number.")
      return math.sqrt(n)

  # --------------------------------

  # main.py
  def test_power():
      """Test the power function."""
      assert calculator.power(2, 3) == 8
      assert calculator.power(5, 0) == 1
      assert calculator.power(2, -2) == 0.25
      print("test_power passed")

  def test_square_root():
      """Test the square root function."""
      assert calculator.square_root(9) == 3
      assert calculator.square_root(0) == 0
      try:
          calculator.square_root(-1)
          print("Error: ValueError not raised for negative input")
      except ValueError as e:
          assert str(e) == "Cannot compute square root of negative number."
      print("test_square_root passed")

  if __name__ == "__main__":
      print("Running tests...")
      test_add()
      test_subtract()
      test_multiply()
      test_divide()
      test_power()
      test_square_root()
      print("All tests passed!")
  ```

    </details>

---

## Section 5 - Built-in Prompts

In this section, we will explore how to use `GitHub Copilot's` built-in prompts to upgrade and maintain our calculator code. Those built-in prompts help you quickly generate explanations, documentation, and tests for your code. Those commands are available in both Chat and Inline Chat modes and known as `Slash commands`.

---

## Overview

- GitHub Copilot provides several slash commands that act as shortcuts for common tasks:

  | Command     | Description                                          |
  | :---------- | :--------------------------------------------------- |
  | `/clear`    | Clear the session context.                           |
  | `/doc`      | Generate documentation for the selected code.        |
  | `/explain`  | Explain how the selected code works.                 |
  | `/ext`      | Commands for VS Code extension development.          |
  | `/fix`      | Propose a fix for the problems in the selected code. |
  | `/help`     | Get help about using GitHub Copilot.                 |
  | `/notebook` | Commands for working with Jupyter Notebooks.         |
  | `/tests`    | Generate unit tests for the selected code.           |
  | `/vscode`   | Commands for VS Code specific questions.             |

---

## Exercises

#### 1. Explain Code

1.  Open `calculator/calculator.py`.
2.  Select the `divide` function.
3.  Open the Chat view and type `/explain`.
4.  Review the explanation provided by Copilot.

#### 2. Generate Documentation

1.  Select the `subtract` function in `calculator/calculator.py`.
2.  Type `/doc` in the Chat or right-click inside the `calculator.py` and select **Copilot > Generate Docs**.
3.  Observe how Copilot adds docstrings to your function.

#### 3. Generate Tests

1.  Select the entire content of `calculator/calculator.py`.
2.  Type `/tests` in the Chat.
3.  Copilot will suggest a new test file or add tests to an existing one.
4.  Review the generated tests and ensure they cover edge cases (like division by zero).

---

## Section 6 - Plan Mode

In this section, we will explore **Plan Mode**, a powerful feature that allows GitHub Copilot to **analyze complex requests** and **propose** structured plans before implementation. This is particularly useful for architectural changes, refactoring, or implementing large features.

`Github Copilot` Plan Mode is a **premium feature** and may not be available in all accounts. `Github Copilot` Plan Mode requires enabling in settings.

!!! danger "Plan Mode" \* `Github Copilot` Plan Mode **DOES NOT** work with Agent mode, you need to update the code manually based on the plan provided.

## Overview

- **Plan Mode** enables Copilot to:
  - Analyze your entire workspace context.
  - Break down complex problems into manageable steps.
  - Propose multiple implementation strategies.
  - Execute the chosen plan across multiple files.
  - Facilitate large-scale refactoring or feature additions.
  - Improve collaboration by providing clear implementation plans.
  - Enhance code quality by ensuring thoughtful design before coding.
  - Save time by automating multi-step coding tasks.

- Example:
  - Once the plan is generated, you can review it and choose to proceed with the implementation.
    <img src="../assets/images/plan-mode.png" style="max-width: 600px;">

---

## Exercises

#### 1. Planning a Class-Based Calculator

- We will use Plan Mode to refactor our existing functional calculator into a more robust Object-Oriented design.
  - Delete the existing code in `calculator/calculator.py` and leave it empty for now.
  - Open the **Copilot Chat** or **Copilot Edits** view.
  - Switch to **Plan Mode** (if available in the dropdown) or ensure you are using **Copilot Edits** which supports multi-file planning.
  - Type the following prompt into the chat:
    ```text
    Plan a better calculator which will be based upon python
    class and will replace the current calculator code.
    The calculator should only support add and subtract,
    but will have the ability to pass arguments as a list as well.
    The plan should include the necessary changes to the existing files
    and any new files that need to be created.
    ```
  - You should see Copilot analyzing your request. (This may take a few moments and you should see something like this):
    <img src="../assets/images/plan-mode-results-1.png" style="max-width: 800px;">

---

1.  **Review the Results**: Copilot will analyze the request and suggest a way to implement it.
2.  **Select an Approach**: If multiple approaches are suggested, choose the one that best fits your needs.
3.  **Review the Plan**: Copilot will outline the steps it will take, such as:
    _ Creating the `Calculator` class in `calculator/calculator.py`.
    _ Updating `calculator/main.py` to use the new class. \* Updating tests to reflect the API changes.

4.  **Execute**: Click **Start Implementation** and follow the instructions.
5.  **Use background Agent**: If prompted, allow Copilot to use the background agent to make changes across multiple files.
6.  The changes are being made automatically by Copilot based on the plan. in a new worktree created for this purpose.
7.  **Follow Changes**: Monitor the changes being made to ensure they align with your expectations. The progress will be shown in the Copilot Sessions list view

      <img src="../assets/images/plan-mode-agent.png" style="max-width: 600px;">

---

#### 2. Verifying the Code

- Once the implementation is complete, you should see something like this:
  <img src="../assets/images/plan-mode-agent-1.png" style="max-width: 800px;">

1.  Open `calculator/calculator.py` copy the code from the planning and confirm that the functions are now methods within a `Calculator` class.
2.  Check `calculator/main.py` to see how the `Calculator` class is instantiated and used.
3.  Run the application or tests to ensure the refactor didn't break existing functionality.
4.  Make sure that the code is working with decimal numbers as well.

    ```bash
    python3 calculator/main.py
    ```

    <details>
    <summary>Expected Output</summary>
    ```python

    ### This line will not work, as the code is now class based.

    ### You need to install pytest to run the tests.

    ### Use Github copilot to "fix" it for you so the code will

    ### works with the new class based calculator.

    ### ERROR:

    ###

    ### Traceback (most recent call last):

    ### File ".../main.py", line 1, in <module>

    ### import pytest

    ### ModuleNotFoundError: No module named 'pytest'

    import pytest

    from calculator import Calculator

    class TestCalculator:
    def test_add_list(self):
    calc = Calculator()
    assert calc.add([1.0, 2.0, 3.0]) == 6.0
    assert calc.add([]) == 0.0
    assert calc.add([-1.0, 1.0]) == 0.0

        def test_subtract_list(self):
            calc = Calculator()
            # 10 - 2 - 3 = 5
            assert calc.subtract([10.0, 2.0, 3.0]) == 5.0
            # 10 - (-2) = 12
            assert calc.subtract([10.0, -2.0]) == 12.0
            assert calc.subtract([5.0]) == 5.0
            assert calc.subtract([]) == 0.0

    ```
    </details>
    ```

---

#### 3. Planning Documentation Strategy

- Use Plan Mode to help plan the documentation strategy for the calculator project.
- In the Copilot Chat choose `Plan` and enter the following prompt:

  ```text
  "Plan a documentation strategy for my calculator project.
  What should be documented
  and how? Consider docstrings, README, and usage examples."
  ```

- Review the proposed documentation plan and implement the suggestions.
- Update the `calculator/calculator.py` file with appropriate docstrings for the class and its methods.
- Create or update the `README.md` file in the project root with usage examples and explanations based on the plan provided by Copilot.

---

## Section 7 - Agent Mode (Part 1)

In this section, we will explore **Agent Mode**. `Agent Mode` can **run terminal commands**, **create and edit files**, and **iterate** on (user and automate) requests until the task is complete. `Agent Mode` is ideal for tasks like "fix all linting errors", "implement this feature and add tests", or "refactor this module".

## Overview

- **Agent Mode** enables Copilot to:
  - Execute terminal commands (run tests, list files, etc.).
  - Create, read, and edit multiple files.
  - Analyze error output and self-correct.
  - Handle multi-step instructions without constant user intervention.
  - Iterate until the task is complete.
  - work and update multiple files in a single session.

---

## Exercises

#### 1. TDD with Agent

- We will use `Agent Mode` to implement new features in our `Calculator` class using a Test-Driven Development (TDD) approach.
  - **Create New Tests**:
    - Create a new file named `tests/test_advanced_calc.py`.
    - Add the following code to define tests for `power` (exponentiation) and `modulus` (remainder) operations, **which don't exist yet**.

      ```python
      import pytest
      from calculator.calculator import Calculator

      def test_power():
          calc = Calculator()
          assert calc.power(2, 3) == 8
          assert calc.power(5, 0) == 1
          assert calc.power(2, -1) == 0.5

      def test_modulus():
          calc = Calculator()
          assert calc.modulus(10, 3) == 1
          assert calc.modulus(10, 5) == 0
      ```

---

#### 2. Using Agent Mode:

- Open **Copilot Chat**
- Open New Chat
- Switch to **Agent Mode**
- Ensure the working directory is set to the root of the `Copilot-Prompts-Workshop` project
- Make sure you already have `pytest` installed in your environment.
- Type the following prompt:
  ```text
  I have created a new test file `tests/test_advanced_calc.py` with new tests.
  Please run these tests to confirm they fail, then implement the missing
  methods in `calculator/calculator.py` to make all tests pass.
  ```
- **Observe the Agent**:
  <img src="../assets/images/calc-errors.png" alt="Agent Working" style="max-width=800px"/>
  - The Agent will likely:
    - Run `pytest tests/test_advanced_calc.py` and see the failures (AttributeError).
    - Read `calculator/calculator.py`.
    - Edit `calculator/calculator.py` to add `power` and `modulus` methods.
    - Re-run the tests to verify they pass.

     <img src="../assets/images/calc-pass.png" alt="Agent Working" style="max-width=800px"/>

---

#### 3. Handling Edge Cases and Iteration

- Now let's ask the Agent to handle a more complex scenario involving error handling.
  1.  **Update Requirements**:
      - We want to ensure `modulus` raises a `ValueError` when dividing by zero.

  2.  **Prompt**:

      ```text
      Update the calculator with `modulus` method to raise a ValueError if the second argument is 0.
      Also, add a test case to `tests/test_advanced_calc.py` that verifies this exception is raised.
      ```

      <details>
      <summary>Example Test Case for Exception</summary>
      ```python
      import pytest
      from calculator.calculator import Calculator

      def test_power():
      calc = Calculator()
      assert calc.power(2, 3) == 8
      assert calc.power(5, 0) == 1
      assert calc.power(2, -1) == 0.5

      def test_modulus():
      calc = Calculator()
      assert calc.modulus(10, 3) == 1
      assert calc.modulus(10, 5) == 0

      def test_modulus_by_zero():
      calc = Calculator()
      with pytest.raises(ValueError, match="Cannot calculate modulus with zero divisor."):
      calc.modulus(10, 0)

      ```
      </details>

      ```

  3.  **Review Changes**:
      - The Agent should:
        - Modify `calculator/calculator.py` to add the check.
        - Modify `tests/test_advanced_calc.py` to add the exception test.
        - Run the tests to confirm everything is green.

---

## Summary

- You have successfully used **Agent Mode** to:
  - Detect failing tests.
  - Implement code to satisfy requirements.
  - Iterate on code to add error handling and additional test coverage.
  - Verify the solution by running tests **automatically**.

---

## Section 8 - Building a CLI with Agent

In this section, we will leverage the power of GitHub Copilot Agent to expand our calculator project. We will create a command-line interface (CLI) that interacts with our existing `Calculator` class. This demonstrates how Agent mode can understand project structure (importing existing classes) and implement new functionality (user input handling) based on high-level instructions.

## Objectives

1.  **Use Copilot Agent** to generate a new Python script `cli_calculator.py`.
2.  **Implement an interactive CLI** that prompts users for operations and inputs.
3.  **Integrate** with the existing `calculator/calculator.py` module.
4.  **Ensure robust error handling** and detailed output logging.

---

## Step-by-Step Instructions

#### 1. Create the Prompt

- **Copy and paste the following prompt into Copilot Chat:**

  !!! example "Prompt to use in Copilot Chat"
  Create a new file `cli_calculator.py` in the calculator directory.
  This script should import the `Calculator` class from `calculator/calculator.py`.
  It should run an interactive loop asking the user to choose an operation (add, subtract, power, modulus) and enter numbers.
  It should print detailed information about the operation being performed and the result.
  Handle invalid inputs gracefully.

---

#### 2. Review the Generated Code

- Copilot should generate a plan to create `cli_calculator.py`.

    <details>
    <summary>Cli Calculator - Review Generated Code</summary>
    ```python
        import sys
        import os

        # Add the current directory to sys.path to ensure we can import the local module
        sys.path.append(os.path.dirname(os.path.abspath(__file__)))

        from calculator import Calculator

        def get_numbers_list(prompt: str) -> list[float]:
            """Get a list of numbers from user input."""
            while True:
                try:
                    user_input = input(prompt)
                    # Split by comma or space
                    parts = user_input.replace(',', ' ').split()
                    numbers = [float(x) for x in parts]
                    return numbers
                except ValueError:
                    print("Invalid input. Please enter numeric values separated by spaces or commas.")

        def get_number(prompt: str) -> float:
            """Get a single number from user input."""
            while True:
                try:
                    return float(input(prompt))
                except ValueError:
                    print("Invalid input. Please enter a numeric value.")

        def main():
            calc = Calculator()
            print("Welcome to the CLI Calculator!")
            print("Available operations: add, subtract, power, modulus")

            while True:
                print("\n----------------------------------------")
                operation = input("Enter operation (or 'quit' to exit): ").lower().strip()

                if operation in ['quit', 'exit']:
                    print("Goodbye!")
                    break

                if operation not in ['add', 'subtract', 'power', 'modulus']:
                    print("Unknown operation. Please choose from: add, subtract, power, modulus")
                    continue

                try:
                    if operation == 'add':
                        nums = get_numbers_list("Enter numbers separated by spaces: ")
                        print(f"Performing addition on {nums}...")
                        result = calc.add(nums)
                        print(f"Result: {result}")

                    elif operation == 'subtract':
                        nums = get_numbers_list("Enter numbers separated by spaces: ")
                        print(f"Performing subtraction on {nums}...")
                        result = calc.subtract(nums)
                        print(f"Result: {result}")

                    elif operation == 'power':
                        base = get_number("Enter base: ")
                        exponent = get_number("Enter exponent: ")
                        print(f"Calculating {base} raised to the power of {exponent}...")
                        result = calc.power(base, exponent)
                        print(f"Result: {result}")

                    elif operation == 'modulus':
                        dividend = get_number("Enter dividend: ")
                        divisor = get_number("Enter divisor: ")
                        print(f"Calculating modulus of {dividend} and {divisor}...")
                        result = calc.modulus(dividend, divisor)
                        print(f"Result: {result}")

                except Exception as e:
                    print(f"An error occurred: {e}")

        if __name__ == "__main__":
            main()

  ```
  </details>

  ```

- **Look for the following features in the generated code:**

<div class="grid cards" markdown>

- **Imports**
  - Does it correctly import `sys` (for path manipulation if needed) or just `from calculator.calculator import Calculator`?

- **Input Handling**
  - Does it ask for the operation first?

- **Argument Handling**
  - For `add` and `subtract`, it should accept a list of numbers (e.g., comma-separated).
  - For `power` and `modulus`, it should ask for two specific numbers.

- **Loop**
  - Does it allow the user to perform multiple calculations without restarting?

</div>

#### 3. Run the Calculator CLI

- Once the file is created, run it in the terminal to test it out.

```bash
python3 cli_calculator.py
```

#### 4. Example Interaction

```text
Welcome to the CLI Calculator!
Available operations: add, subtract, power, modulus

Enter operation (or 'quit' to exit): add
Enter numbers separated by spaces: 10 20 30
Performing addition on [10.0, 20.0, 30.0]...
Result: 60.0

Enter operation (or 'quit' to exit): power
Enter base: 2
Enter exponent: 3
Calculating 2.0 raised to the power of 3.0...
Result: 8.0
```

---

#### What is happening behind the scenes?

| Feature               | Description                                                                                                                                                                                                                                                                    |
| :-------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Context Awareness** | By using `@workspace`, Copilot scans your project structure. <br/>It reads `calculator/calculator.py` to understand the `Calculator` class methods (`add`, `subtract`, `power`, `modulus`) and their specific signatures (e.g., `add` takes a list, `power` takes two floats). |
| **Code Generation**   | Copilot generates the boilerplate code for the command-line interface, including the `while` loop for continuous operation and `input()` calls for user interaction.                                                                                                           |
| **Logic Mapping**     | It maps the user's string input (e.g., "add") to the specific method call `calc.add(...)`.                                                                                                                                                                                     |
| **Error Handling**    | A good agent response will include `try-except` blocks to handle cases where the user enters text instead of numbers, preventing the program from crashing.                                                                                                                    |

---

## Section 9 - Custom Instructions

## 01 - Preface

- `GitHub Copilot` allows you to provide **Custom Instructions** to tailor its responses to your specific needs, coding style, and project requirements.
- **Custom Instructions** act as a persistent context that Copilot considers for **every chat interaction** and code generation.

#### There are two main types of custom instructions:

<div class="grid cards" markdown>

- <span style="color: #5865f2">:material-account-cog:</span> <span style="color: #d14836">**User-Specific Instructions**</span>

  ***

  Configured in your IDE settings.
  These apply to _all_ projects you work on in that IDE.

- <span style="color: #5865f2">:material-file-document-edit:</span> <span style="color: #d14836">**Repository-Specific Instructions**</span>

  ***

  Stored in a `.github/copilot-instructions.md` file in your repository. These apply to _anyone_ working on that specific project.

</div>

- In this section, we will explore how to set up both, with a focus on creating a robust repository-level instruction file.

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

- For shared projects, it is best practice to use a `.github/copilot-instructions.md` file.
- This ensures that all team members (and Copilot) adhere to the same project standards.

#### Where to save it

- **File Path**: `.github/copilot-instructions.md`
- **Location**: Root of your repository.

#### What to write

- Effective custom instructions should cover:

<div class="grid cards" markdown>

- <span style="color: #5865f2">:material-account-tie:</span> <span style="color: #d14836">**Role**</span>

  ***

  Who is Copilot acting as? (e.g., "Expert Python Developer").

- <span style="color: #5865f2">:material-format-paint:</span> <span style="color: #d14836">**Style**</span>

  ***

  Naming conventions, formatting, type hinting.

- <span style="color: #5865f2">:material-test-tube:</span> <span style="color: #d14836">**Testing**</span>

  ***

  Preferred frameworks (pytest, unittest), coverage requirements.

- <span style="color: #5865f2">:material-layers:</span> <span style="color: #d14836">**Tech Stack**</span>

  ***

  Specific libraries or versions to use (e.g., "Use Pydantic v2").

- <span style="color: #5865f2">:material-chat-processing:</span> <span style="color: #d14836">**Behavior**</span>

  ***

  How should Copilot respond? (e.g., "Be concise", "Always explain the 'why'").

- <span style="color: #5865f2">:material-file-document:</span> <span style="color: #d14836">**Documentation**</span>

  ***

  Docstring standards (Google/NumPy), comment style, and README updates.

- <span style="color: #5865f2">:material-alert-circle:</span> <span style="color: #d14836">**Error Handling**</span>

  ***

  Preferred exception types, logging practices, and error message formats.

- <span style="color: #5865f2">:material-shield-lock:</span> <span style="color: #d14836">**Security**</span>

  ***

  Input validation rules, avoiding hardcoded secrets, and secure coding practices.

- <span style="color: #5865f2">:material-speedometer:</span> <span style="color: #d14836">**Performance**</span>

  ***

  Efficiency considerations, complexity limits, and resource management.

- <span style="color: #5865f2">:material-git:</span> <span style="color: #d14836">**Git Conventions**</span>

  ***

  Commit message styles (Conventional Commits), branching strategies.

</div>

---

## 04 - Hands-On

#### Generating Custom Instructions

- Instead of writing the instructions from scratch, let's use `GitHub Copilot` to generate a draft for us based on our project context.

#### 01: Create from prompt

- Use the following prompt to generate a comprehensive instruction file.

  !!! tip "Prompting Copilot"

  ````text
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

  ````

- Copy the generated content into `.github/copilot-instructions.md`.
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
  - **Comments**: Explain _why_ for complex logic, not just _what_.

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

  ***

  **All code and documentation generated for this project must adhere to these instructions.**

  ```
  </details>
  ```

---

#### 02: Create from scratch

1. Create a new folder named `.github` in the root of your workspace if it doesn't exist.
2. Create a file named `copilot-instructions.md` inside it.
3. Copy the content generated by Copilot into this file.
4. Review and refine the instructions.

---

#### 03 - Checklist

- Ensure your `copilot-instructions.md` covers the major parts. Use this checklist to verify:
- Validating Your Instructions
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

- Now that you've created the file, let's test if Copilot is respecting it.
  1.  Open `calculator/calculator.py`.
  2.  Write in the custom instructions: (1st line of the file)
      ```text
      Reply in spanish
      ```
  3.  Ask Copilot to do anything
  4.  Verify that the response is in Spanish.

    <img src="../assets/images/custom-instructions.png" alt="Custom Instructions in Action" style="max-width:800px;"/>

---

<center>
  <img src="https://raw.githubusercontent.com/nirgeier/labs-assets/main/assets/images/well_done.jpg" alt="Well Done" style="max-width:400px; border-radius:50% ;"/>
</center>

---

## Section 10 - Advanced Instructions

## 01. Preface

- This section is all about Advanced Instructions for GitHub Copilot.
- We will explore how to create custom instructions for specific coding styles, best practices, and project conventions.

---

## 02. Objectives

- Understand the concept of Advanced Instructions in GitHub Copilot.
- Learn how to create and implement custom instructions for your projects.
- Explore best practices for writing effective instructions.
- Apply advanced instructions to a sample project.

---

## 03. Advanced File-Specific Scoping

- In this section, we will learn how to create file-specific instructions for GitHub Copilot.
- This allows us to tailor Copilot's behavior based on the specific files or directories in our project.
- We will create a set of instructions that apply only to backend files in the `script` directory.
- At the start of the file, create a `frontmatter` block containing the applyTo keyword.
- Use glob syntax to specify what files or directories the instructions apply to.
- Glob examples:

  | Glob Pattern        | Description                                                            |
  | ------------------- | ---------------------------------------------------------------------- |
  | `*`                 | Match all files in the current directory.                              |
  | `**` or `**/*`      | Match all files in all directories.                                    |
  | `*.sh`              | Match all `.sh` files in the current directory.                        |
  | `**/*.sh`           | Recursively match all `.sh` files in all directories.                  |
  | `src/*.sh`          | Match all `.sh` files in the src directory.sh).                        |
  | `src/**/*.sh`       | Recursively match all `.sh` files in the src directory.sh).            |
  | `**/subdir/**/*.sh` | Recursively match all `.sh` files in any subdir directory at any depth |

- After the `frontmatter`, add your custom instructions for the specified files or directories.

---

#### Step-by-Step Instructions

## 04. Set Up the Folder Structure

- Create a folder named `.github/instructions/` in the root of your project.
- This folder will contain our custom instruction files.

## 05. Create the Instruction File

- Inside the `.github/instructions/` folder, create a new file named `script.instructions.md`.
- This file will contain the specific instructions for files in the `script` directory.

## 06. Add Scoped Instructions

- Open the `.github/instructions/script.instructions.md` file and add the following frontmatter at the top:

  ```markdown
  ---
  applyTo: "script/**/*.sh"
  ---

  # Custom Instructions for Bash Scripts

  - All scripts must start with `#!/bin/bash` as the shebang.
  - Before any logic, check if a `.env` file exists in the same directory as the script
  - if `.env` exists, load it with `source ".env"`.
  - Define color variables for output (e.g., green for info, red for errors, yellow for warnings, blue for debug).
  - Implement and use the following logging functions for all output:
    - `log_info` for informational messages (green)
    - `log_error` for error messages (red, output to stderr)
    - `log_debug` for debug messages (blue, only print if a DEBUG variable is set)
    - `log_warn` for warnings (yellow)
  - Always quote variables in bash to prevent word splitting and globbing.
  - Use `set -euo pipefail` at the top of the script for safer error handling.
  - Use functions for logical grouping of code; avoid long, unstructured scripts.
  - Add comments to explain non-obvious logic.
  - Use `$(...)` for command substitution, not backticks.
  - Prefer `[[ ... ]]` for conditionals over `[ ... ]`.
  - Scripts should exit with a non-zero status on error.
  - Avoid hardcoding paths; use variables and check for file existence.
  - Use `trap` to handle cleanup on exit if the script creates temporary files or resources.
  - All scripts must be POSIX-compliant unless Bash-specific features are required.
  - Add a usage/help function if the script takes arguments.
  ```

- Save the file.

---

## 07. Instructions in Action

- Now, when you will create bash scripts in the `script` directory, GitHub Copilot will follow the custom instructions defined in `script.instructions.md`.
- Test this by creating a new bash script in the `script` directory and observing how Copilot generates code based on the specified instructions.
- Use the following prompt in Copilot Chat to generate a new bash script:

  !!! example "Prompt to use in Copilot Chat"
  _ Create a bash script that print the current date and time
  _ The bash script should be in the `script` directory.

    <details>
    <summary>Expected Generated Code</summary>
    ```bash
    #!/bin/bash
    set -euo pipefail

  # Load .env if present in the same directory

  if [[-f "$(dirname "$0")/.env"]]; then
  source "$(dirname "$0")/.env"
  fi

  # Color definitions

  GREEN="\033[0;32m"
  RED="\033[0;31m"
  YELLOW="\033[1;33m"
  BLUE="\033[0;34m"
  NC="\033[0m" # No Color

  # Logging functions

  log_info() {
  echo -e "${GREEN}[INFO] $*${NC}"
  }
  log_error() {
  echo -e "${RED}[ERROR] $*${NC}" >&2
  }
  log_debug() {
  if [["${DEBUG:-}" == "1"]]; then
  echo -e "${BLUE}[DEBUG] $*${NC}"
  fi
  }
  log_warn() {
  echo -e "${YELLOW}[WARN] $*${NC}"
  }

  # Print current date and time

  print_datetime() {
  log_info "Current date and time: $(date)"
  }

  print_datetime

  ```
  </details>
  ```

---

## Section 11 - Reusable Prompts (.github/prompts)

## 01 - Introduction

- **Reusable Prompts** (also known as Prompt Files) allow you to define and share complex prompts across your team.
- They are stored as Markdown files in a `.github/prompts` directory.
- You can reference them in Copilot Chat to quickly apply a specific set of instructions or context.

---

## 02 - Setup

- To use this feature, you need to create a specific directory structure in your repository.

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

- A prompt file is a standard Markdown file with the `.prompt.md` extension.
- It can contain:
  - **Text**: The instructions for Copilot.
  - **Context References**: You can use `#file` references to include other files relative to the prompt file.
  - **Variables**: (Advanced) You can define template variables.

#### Example: `explain-code.prompt.md`

!!! tip \* Create a file named `explain-code.prompt.md` in the `.github/prompts` directory with the following content:

        * You are an expert educator.
        * Explain the selected code to a junior developer.
        * Use analogies and simple language.
        * Focus on the "Why" rather than the "What".

---

## 04 - Using Prompt Files

- Once you have created a prompt file, you can use it in Copilot Chat.
- In the Chat input, type `#` followed by the name of your prompt file (e.g., `#explain-code`).
- Copilot will resolve the file and use its content as the prompt context.

---

## 05 - Hands-On: Creating a Reusable Prompt

#### Exercise 1: Create the Directory Structure

1.  Open your terminal.
2.  Create the directory `.github/prompts`.

#### Exercise 2: Create a "Code Review" Prompt

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

#### Exercise 3: Use the Prompt

1.  Open `calculator/calculator.py`.
2.  Select the `divide` function.
3.  Open Copilot Chat.
4.  Type `#review` (or the name of your file) and press Enter.
    - _Note: If `#review` doesn't auto-complete, you can manually attach the file using the paperclip icon or by typing `#file:.github/prompts/review.prompt.md`._
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

---

## Section 12 - Custom Agents & Chat Extensions

## 01 - Introduction

- GitHub Copilot Chat can be extended using **Chat Extensions** (also known as Agents or Participants).
- These allow you to bring your own domain knowledge, tools, and workflows directly into the Copilot Chat interface.
- You interact with them using the `@` symbol (e.g., `@workspace`, `@azure`, `@my-agent`).

---

## 02 - Custom Agents Types

There are two main approaches to creating custom agents:

<div class="grid cards" markdown>

- :material-file-document-outline:{ .lg .middle } **YAML-Based Agents (Declarative)**

  ***

  **Characteristics:**
  - Simple configuration files
  - Stored in `.github/agents/`
  - Define behavior through YAML
  - No coding required
  - Great for domain-specific experts
  - **Focus of this lab**

  **Best For:**
  - Domain knowledge experts
  - Template-based responses
  - Consistent formatting
  - Quick prototyping

- :material-cog-outline:{ .lg .middle } **VS Code Extension Agents (Programmatic)**

  ***

  **Characteristics:**
  - Full VS Code extensions
  - Contributes `chatParticipants`
  - TypeScript/JavaScript required
  - More powerful and flexible
  - Execute commands & APIs
  - Real-time interactions

  **Best For:**
  - Complex workflows
  - API integrations
  - File system access
  - Dynamic behavior

</div>

---

## 03 - YAML-Based Agent

- YAML-based agents are defined in the `.github/agents/` folder of your repository.
- Each agent is a single YAML file that describes its behavior, expertise, and instructions.

#### Key Components of a YAML Agent:

| Component          | Description                                                |
| :----------------- | :--------------------------------------------------------- |
| **`name`**         | Display name of the agent                                  |
| **`description`**  | Brief explanation of what the agent does                   |
| **`agent`**        | AI model to use (e.g., `gpt-4o`, `gpt-4`, `gpt-3.5-turbo`) |
| **`instructions`** | Detailed system prompt that defines the agent's behavior   |
| **`tools`**        | List of capabilities the agent has access to               |
| **`expertise`**    | Areas of knowledge and specialization                      |
| **`examples`**     | Sample interactions to guide the agent's responses         |

---

## 04 - Example: @agent-time

- **Example**: **The most advanced World Time Agent** located in `.github/agents/agent-time.yml`.
- Unique development made in **Elbit's** Secret Labs.
- Before continuing, check that you have the right classification for this section: "YAML-Based Agents".

#### Step 1: Define Purpose

The `@agent-time` agent is designed to:

- Display current time across different time zones
- Explain time zone differences between cities
- Handle daylight saving time (DST) considerations
- Provide time conversions between different zones
- Format time displays in various formats (24h, 12h, ISO)

#### Step 2: Agent Structure

- #### Metadata

  The top section defines basic metadata:

  ```yaml
  name: World Time Specialist
  description: Expert in displaying current time across different time zones and major cities
  agent: gpt-4o
  ```

  | Field             | Description                                                    |
  | :---------------- | :------------------------------------------------------------- |
  | **`name`**        | The friendly name shown when you invoke the agent              |
  | **`description`** | Helps users understand what the agent can do                   |
  | **`agent`**       | The AI model to use (e.g., `gpt-4o`, `gpt-4`, `gpt-3.5-turbo`) |

- #### Instructions Section

  The most important part is the `instructions` field, which contains the system prompt:

  ```yaml
  instructions: |
    You are a time zone expert that helps users understand and display current times
    across different cities and time zones around the world.

    ## Your Responsibilities

    - Display current time in multiple cities simultaneously
    - Explain time zone differences between cities
    - Handle daylight saving time (DST) considerations
    - Provide time conversions between different zones
    - Format time displays in various formats (24h, 12h, ISO)
  ```

  !!! tip "Instruction Details"
  _ Use the `|` character to allow multi-line instructions
  _ Clear role definition: "You are a time zone expert"
  _ Specific responsibilities listed
  _ Defines the scope and boundaries of the agent

- #### Default Behavior

  The agent's default behavior is specified in detail:

  ```markdown
  ## Default Cities to Display

  When asked to show the time in major cities, use these 4 by default:

  1. **New York** (America/New_York) - EST/EDT
  2. **London** (Europe/London) - GMT/BST
  3. **Tokyo** (Asia/Tokyo) - JST
  4. **Sydney** (Australia/Sydney) - AEDT/AEST
  ```

  !!! tip "Default Behavior"
  _ Defines default cities for time display
  _ Specifies time zones and abbreviations
  _ Provides consistent, predictable behavior
  _ Covers major time zones globally \* Reduces ambiguity in user requests

- #### Output

  Define the desired output format:

  ```markdown
  ## Time Display Format

  When displaying times, use this format:

  # 🌍 Current Time in Major Cities

  🗽 New York: HH:MM AM/PM (Time Zone Abbreviation)
  🇬🇧 London: HH:MM (Time Zone Abbreviation)
  🗼 Tokyo: HH:MM (Time Zone Abbreviation)
  🦘 Sydney: HH:MM (Time Zone Abbreviation)

  📅 Date: YYYY-MM-DD
  ⏰ UTC Time: HH:MM:SS
  ```

  !!! tip "Time Display Format"
  _ Defines exact output format
  _ Uses emojis for visual clarity \* Ensures consistency across all responses

- #### Implementation Guidelines

  Instruct the agent on how to implement time functionality:

  ````markdown
  ## Implementation Approach

  When asked to implement time display functionality:

  1. **Use Python's datetime and zoneinfo modules:**

     ```python
     from datetime import datetime
     from zoneinfo import ZoneInfo

     def get_city_time(timezone_name):
         return datetime.now(ZoneInfo(timezone_name))
     ```
  ````

  !!! tip "Implementation Guidelines"
  _ Provides code templates and best practices
  _ Specifies which libraries to use \* Shows implementation patterns

- #### Tools & Expertise

  Describe the agent's capabilities and knowledge:

  ```yaml
  tools:
    - datetime_manipulation
    - timezone_conversion
    - time_display
    - scheduling_assistant

  expertise:
    - Python datetime module
    - zoneinfo module
    - Time zone databases (IANA)
    - DST rules and transitions
    - ISO 8601 formatting
  ```

  | Field           | Description                               |
  | :-------------- | :---------------------------------------- |
  | **`tools`**     | Capabilities the agent claims to have     |
  | **`expertise`** | Knowledge domains the agent is trained in |

---

#### Examples Section

````yaml
examples:
  - prompt: "Show me the current hour in 4 major cities"
    response: |
      I'll display the current hour in New York, London, Tokyo, and Sydney:

      ```python
      from datetime import datetime
      from zoneinfo import ZoneInfo

      cities = {
          '🗽 New York': 'America/New_York',
          '🇬🇧 London': 'Europe/London',
          '🗼 Tokyo': 'Asia/Tokyo',
          '🦘 Sydney': 'Australia/Sydney'
      }

      print("Current Hour in Major Cities:")
      print("=" * 40)

      for city, tz in cities.items():
          now = datetime.now(ZoneInfo(tz))
          hour_24 = now.hour
          hour_12 = now.strftime('%I %p')
          print(f"{city}: {hour_24:02d}:00 ({hour_12})")
      ```
````

- Provides concrete examples of agent interactions
- Demonstrates the expected input/output format
- Helps guide the LLM's responses

---

#### 05 - Hands-On

##### 01: Examine the Agent File

1. Navigate to [.github/agents/agent-time.yml](.github/agents/agent-time.yml)
2. Read through the entire YAML file
3. Identify each section:
   - Name and description
   - Instructions
   - Tools
   - Expertise
   - Examples

**Discussion Questions:**

- What makes the instructions clear and effective?
- How do the examples help guide the agent's behavior?
- What tools and expertise are declared?

---

##### 02: Using the @agent-time Agent

1. Open the GitHub Copilot Chat panel
2. Type `@agent-time` to invoke the World Time Specialist
3. Try these prompts:

   **Prompt 1: Basic Time Query**

   ```
   @agent-time Show me the current hour in 4 major cities
   ```

   **Prompt 2: Implementation Request**

   ```
   @agent-time Create a Python script to display world times
   ```

   **Prompt 3: Specific Cities**

   ```
   @agent-time What time is it in Paris, Berlin, and Moscow?
   ```

   **Prompt 4: Time Conversion**

   ```
   @agent-time If it's 3 PM in New York, what time is it in Tokyo?
   ```

   !!! success "Observe the Responses"
   _ Does the agent follow the specified format?
   _ Does it use the default cities when appropriate?
   _ Does it provide code snippets using `datetime` and `zoneinfo`?
   _ How well does it handle DST explanations?

---

##### 03: Testing Agent Behavior

Let's test how well the agent follows its instructions:

1. **Test Default Cities:**

   ```
   @agent-time show time
   ```

   - Does it show New York, London, Tokyo, and Sydney by default?

2. **Test Output Format:**

   ```
   @agent-time display world clock
   ```

   - Does it use the emoji format specified?
   - Does it include UTC time?

3. **Test Implementation Guidance:**

   ```
   @agent-time write a function to get city time
   ```

   - Does it use `datetime` and `zoneinfo`?
   - Does it follow the code patterns in the YAML?

4. **Test DST Knowledge:**

   ```
   @agent-time Explain daylight saving time for New York
   ```

   - Does it demonstrate expertise in DST?

---

#### 06 - Building Agent

Now let's create a custom agent from scratch!

##### Step-by-Step Guide

##### Step 1: DefineAgent's Purpose

Think about a domain or task where you want specialized assistance:

- **Code reviewer** for a specific language or framework
- **Documentation writer** for your project's style
- **Test generator** following your testing patterns
- **Database expert** for SQL optimization
- **API designer** following REST best practices

For this exercise, let's create a **Python Test Generator** agent.

##### Step 2: Create the Agent File

1. Create `.github/agents/` folder if it doesn't exist
2. Create a new file: `.github/agents/test-generator.yml`

##### Step 3: Define Basic Metadata

```yaml
name: Python Test Generator
description: Expert in creating comprehensive pytest tests following best practices
agent: gpt-4o
```

##### Step 4: Write the Instructions

````yaml
instructions: |
  You are a Python testing expert specializing in pytest framework.

  ## Your Responsibilities

  - Generate comprehensive test cases for Python functions and classes
  - Follow pytest best practices and conventions
  - Include edge cases and error handling tests
  - Use appropriate fixtures and parametrization
  - Write clear test names that describe what is being tested

  ## Testing Principles

  1. **Arrange-Act-Assert Pattern**: Structure all tests clearly
  2. **One Assertion Per Test**: Keep tests focused and simple
  3. **Descriptive Names**: Use `test_<function>_<scenario>_<expected_result>`
  4. **Fixtures**: Use pytest fixtures for setup and teardown
  5. **Parametrize**: Use `@pytest.mark.parametrize` for multiple test cases

  ## Default Test Structure

  ```python
  import pytest
  from module import function_to_test

  def test_function_with_valid_input():
      # Arrange
      input_data = "valid_value"
      expected = "expected_result"

      # Act
      result = function_to_test(input_data)

      # Assert
      assert result == expected

  def test_function_with_invalid_input():
      # Arrange
      invalid_input = None

      # Act & Assert
      with pytest.raises(ValueError):
          function_to_test(invalid_input)
````

## Code Quality Guidelines

- Import only what's needed
- Use type hints in test functions
- Add docstrings for complex test scenarios
- Group related tests in classes
- Use meaningful fixture names

## Coverage Goals

For each function, generate tests for:

- Happy path (normal operation)
- Edge cases (boundary conditions)
- Error cases (exceptions)
- Type validation
- Null/None handling

````

##### Step 5: Add Tools and Expertise

```yaml
tools:
  - test_generation
  - code_analysis
  - pytest_framework
  - fixture_creation

expertise:
  - pytest framework
  - unittest and mock
  - Test-Driven Development (TDD)
  - Code coverage analysis
  - Python testing best practices
````

##### Step 6: Provide Examples

````yaml
examples:
  - prompt: "Generate tests for a calculator add function"
    response: |
      I'll create comprehensive pytest tests for an add function:

      ```python
      import pytest
      from calculator import add

      def test_add_positive_numbers():
          """Test addition of two positive numbers."""
          assert add(2, 3) == 5

      def test_add_negative_numbers():
          """Test addition of two negative numbers."""
          assert add(-2, -3) == -5

      def test_add_mixed_signs():
          """Test addition of positive and negative numbers."""
          assert add(5, -3) == 2

      @pytest.mark.parametrize("a,b,expected", [
          (0, 0, 0),
          (1, 0, 1),
          (0, 1, 1),
          (100, 200, 300),
      ])
      def test_add_with_parametrize(a, b, expected):
          """Test add function with multiple inputs."""
          assert add(a, b) == expected
      ```
````

---

## Section 13 - Custom Prompts & Prompt Engineering

## 01 - Preface

- While GitHub Copilot is powerful out of the box, the quality of its output is directly related to the quality of your input.
- This skill is often called **Prompt Engineering**.
- In this section, we will explore how to craft effective prompts, moving from basic requests to advanced, context-aware instructions.

---

## 02 - The Basics of Prompting

- A good prompt provides Copilot with the **Intent** (what you want) and the **Context** (what you have).
- Follow the **4 S's** of prompting:

<div class="grid cards" markdown>

- <span style="color: #5865f2">:material-target:</span> <span style="color: #d14836">**Single**</span>

  ***

  Focus on a single task or question at a time.

- <span style="color: #5865f2">:material-magnify:</span> <span style="color: #d14836">**Specific**</span>

  ***

  Be explicit about what you want. Avoid ambiguity.

- <span style="color: #5865f2">:material-ruler:</span> <span style="color: #d14836">**Short**</span>

  ***

  Keep it concise but descriptive.

- <span style="color: #5865f2">:material-code-brackets:</span> <span style="color: #d14836">**Surround**</span>

  ***

  Open relevant files to provide context.

</div>

#### Examples: Bad vs. Good

| Bad Prompt        | Good Prompt                                                                                       |
| :---------------- | :------------------------------------------------------------------------------------------------ |
| "Fix this."       | "Fix the `IndexError` in the `calculate_total` function when the list is empty."                  |
| "Write tests."    | "Write unit tests for `calculator.py` using `pytest`, covering edge cases like division by zero." |
| "Make it better." | "Refactor this function to improve readability and reduce nesting."                               |

---

## Advanced Strategies

- To get the most out of Copilot, use these advanced techniques:

---

## 03. Role Prompting (Persona)

- Tell Copilot who it should be.

  !!! tip "Example Personas"
  _ **Example**: "Act as a Senior Python Developer. Review this code for best practices
  _ **Example**: "You are a Technical Writer. Generate documentation for the following code." \* **Example**: "You are a QA Engineer. Write test cases for the following functionality."

---

#### Zero-Shot / One-Shot / Few-Shot Prompting

## 04. Zero-Shot Prompting

- Ask Copilot to perform a task without any examples.

  !!! tip "Example Zero-Shot Prompt"
  _ "Generate a function that calculates the factorial of a number."
  _ "Write unit tests for the `add` method in the `Calculator` class."
  _ "Refactor this code to improve performance."
  _ "Create a CLI application that interacts with the user to perform basic arithmetic operations using the `Calculator` class from `calculator/calculator.py`. \* The application should: 1. Prompt the user to enter an operation (add, subtract, power, modulus). 2. Based on the operation, ask for the required number(s). 3. Display the result of the calculation. 4. Allow the user to perform multiple calculations until they choose to exit." 5. Handle invalid inputs gracefully. 6. Log detailed information about each operation performed.

---

## 05. One-Shot Prompting

- Provide a single example to guide Copilot.

  !!! tip "Example One-Shot Prompt"
  \_ **Example**: "Here is a function that adds two numbers:
  `python
        def add(a: int, b: int) -> int:
            return a + b
        `
  Now, write a function that subtracts two numbers.

  ***

  \_ **Example**: "Here is a unit test for the `add` function:
  `python
        def test_add():
            assert add(2, 3) == 5
            assert add(-1, 1) == 0
        `
  Now, write a unit test for the `add` function.

---

## 06. Few-Shot Prompting

- Provide examples of what you want.

  !!! tip "Example Few-Shot Prompt"
  _ Convert these file names to snake_case:
  _ Input: UserLogin.py -> Output: user*login.py
  * Input: DataManager.js -> Output: data*manager.js
  * Input: PageLayout.css -> Output:

---

## 07. Explicit Reasoning

- Ask Copilot to think through the problem step-by-step.
- Ask Copilot to explain its reasoning step-by-step.
- This often leads to more accurate results.

  !!! tip "Example Reasoning Prompt"

        "Explain how this regex works step-by-step, then optimize it."

---

## 08. Iterative Refinement

- Don't stop at the first answer.
- Refine **your** prompt based on the output.

  !!! tip "Example Iterative Refinement"

        * **Example**: "That's good, but now make it async." -> "Now add error handling."
        * **Example**: "This function works, but can you optimize it for performance?"
        * **Example**: "The tests are good, but add edge cases for negative inputs."

---

## 09. Mastering Context

- Copilot needs context to understand your codebase.
- You can explicitly provide this using **Context Variables**.

| Variable     | Description                                                                   |
| :----------- | :---------------------------------------------------------------------------- |
| `@workspace` | Searches the entire workspace for context. Use this for high-level questions. |
| `@vscode`    | Asks about VS Code commands and settings.                                     |
| `@terminal`  | Context from the integrated terminal (last command, output).                  |
| `#file`      | References a specific file. (e.g., `#calculator.py`)                          |
| `#selection` | References the currently selected code.                                       |
| `#editor`    | References the visible code in the active editor.                             |

---

## 10. Hands-On: Prompt Engineering

In this section, you will practice the prompt engineering techniques discussed above by creating a Python script to display dates in different countries.

#### Exercise 1: The 4 S's (Single, Specific, Short, Surround)

1.  Create a new file named `date_formatter.py`.
2.  Try a **Bad Prompt** in the Chat view:
    - "Dates."
    - Observe the response. It is likely too generic.
3.  Now, try a **Good Prompt** applying the 4 S's:
    - **Surround**: Ensure `date_formatter.py` is open.
    - **Specific**: "Write a Python function `format_date_germany` that takes a `datetime` object and returns it as a string formatted for Germany (DD.MM.YYYY)."
    - **Short**: Keep it direct.
    - **Single**: Ask for just this one function.
4.  Verify that Copilot generates the correct function.

#### Exercise 2: Few-Shot Prompting

1.  We want to create a helper function that returns the date format string for a given country code.
2.  Provide examples in your prompt:
    - "Create a function `get_date_format` that returns the format string for a country code.
    - Examples:
    - Input: 'US' -> Output: '%m/%d/%Y'
    - Input: 'UK' -> Output: '%d/%m/%Y'
    - Input: 'ISO' -> Output: '%Y-%m-%d'"
3.  See if Copilot can infer the format for 'DE' (Germany) or 'JP' (Japan) if you ask for it next.

#### Exercise 3: Iterative Refinement

1.  Start with a basic request:
    - "Write code to print the current date."
2.  Refine it to be more specific:
    - "Modify the code to print the date in Spanish."
3.  Refine it further for robustness:
    - "Use the `locale` module to handle the formatting automatically."
4.  Finally, ask for an explanation:
    - "Explain how the `locale` module affects date formatting."

#### Exercise 4: Mastering Context

1.  Select the code you generated in Exercise 2
2.  Use **#selection** to ask a specific question:
    - "Explain how daylight saving time is handled in this #selection."
3.  Use **@workspace** to check for conflicts (even if none exist, it's good practice):
    - "@workspace Are there any other files in this project that use the `datetime` module?"

---

## Conclusion

Congratulations! You have completed the **Copilot Prompting Workshop**, a comprehensive 13-section learning module covering everything from basic setup to advanced prompt engineering and custom agents.

## Key Takeaways

1. **GitHub Copilot Features**: From inline suggestions to full Chat integration, you've learned to leverage all of Copilot's capabilities.
2. **Advanced Workflows**: You've mastered Plan Mode, Agent Mode, and complex multi-file refactoring scenarios.
3. **Customization & Personalization**: You understand how to tailor Copilot to your specific project needs through custom instructions, prompts, and agents.
4. **Prompt Engineering**: You've learned the art and science of crafting effective prompts that yield high-quality code generation.
5. **Team Collaboration**: You know how to share Copilot customizations across teams through repository-level instructions and reusable prompts.

## Next Steps

- **Experiment**: Continue exploring Copilot with your own projects
- **Customize**: Create custom instructions and agents for your specific domain
- **Share**: Share your best practices and custom agents with your team
- **Iterate**: Continuously refine your prompts and instructions based on results
- **Learn**: Stay updated with new Copilot features and capabilities

## Resources

- [GitHub Copilot Documentation](https://docs.github.com/en/copilot)
- [GitHub Copilot Chat](https://github.com/features/copilot)
- [Prompt Engineering Best Practices](https://platform.openai.com/docs/guides/prompt-engineering)

---

**Happy coding with GitHub Copilot! 🚀**
