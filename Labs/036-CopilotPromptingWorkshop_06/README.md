# Lab 06 - Plan Mode

* In this lab, we will explore **Plan Mode**, a powerful feature that allows GitHub Copilot to **analyze complex requests** and **propose** structured plans before implementation.
* This is particularly useful for architectural changes, refactoring, or implementing large features.
* `Github Copilot` Plan Mode is a **premium feature** and may not be available in all accounts.
* `Github Copilot` Plan Mode requires enabling in settings.
    
!!! danger "Plan Mode"
    * `Github Copilot` Plan Mode **DOES NOT** work with Agent mode, you need to update the code manually based on the plan provided.

## Overview

* **Plan Mode** enables Copilot to:
    * Analyze your entire workspace context.
    * Break down complex problems into manageable steps.
    * Propose multiple implementation strategies.
    * Execute the chosen plan across multiple files.
    * Facilitate large-scale refactoring or feature additions.
    * Improve collaboration by providing clear implementation plans.
    * Enhance code quality by ensuring thoughtful design before coding.
    * Save time by automating multi-step coding tasks.


* Example:
  * Once the plan is generated, you can review it and choose to proceed with the implementation.
<img src="../assets/images/plan-mode.png" style="max-width: 600px;">

---

## Exercises

### 1. Planning a Class-Based Calculator

* We will use Plan Mode to refactor our existing functional calculator into a more robust Object-Oriented design.

    * Delete the existing code in `calculator/calculator.py` and leave it empty for now.
    * Open the **Copilot Chat** or **Copilot Edits** view.
     * Switch to **Plan Mode** (if available in the dropdown) or ensure you are using **Copilot Edits** which supports multi-file planning.
    * Type the following prompt into the chat:
        ```text
        Plan a better calculator which will be based upon python 
        class and will replace the current calculator code.
        The calculator should only support add and subtract, 
        but will have the ability to pass arguments as a list as well.
        The plan should include the necessary changes to the existing files 
        and any new files that need to be created.
        ```
    * You should see Copilot analyzing your request. (This may take a few moments and you should see something like this):
        <img src="../assets/images/plan-mode-results-1.png" style="max-width: 800px;">

----

1.  **Review the Results**: Copilot will analyze the request and suggest a way to implement it.
2.  **Select an Approach**: If multiple approaches are suggested, choose the one that best fits your needs.
3.  **Review the Plan**: Copilot will outline the steps it will take, such as:
        * Creating the `Calculator` class in `calculator/calculator.py`.
        * Updating `calculator/main.py` to use the new class.
        * Updating tests to reflect the API changes.

4.  **Execute**: Click **Start Implementation** and follow the instructions.
5.  **Use background Agent**: If prompted, allow Copilot to use the background agent to make changes across multiple files.
6.  The changes are being made automatically by Copilot based on the plan. in a new worktree created for this purpose.
7.  **Follow Changes**: Monitor the changes being made to ensure they align with your expectations. The progress will be shown in the Copilot Sessions list view
   
      <img src="../assets/images/plan-mode-agent.png" style="max-width: 600px;">

---

### 2. Verifying the Code

* Once the implementation is complete, you should see something like this:
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
    ###   import pytest
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

---

### 3. Planning Documentation Strategy

* Use Plan Mode to help plan the documentation strategy for the calculator project.
* In the Copilot Chat choose `Plan` and enter the following prompt:
    ```text
    "Plan a documentation strategy for my calculator project. 
    What should be documented 
    and how? Consider docstrings, README, and usage examples."
    ```

* Review the proposed documentation plan and implement the suggestions.
* Update the `calculator/calculator.py` file with appropriate docstrings for the class and its methods.
* Create or update the `README.md` file in the project root with usage examples and explanations based on the plan provided by Copilot.


