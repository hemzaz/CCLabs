## Lab 06 - Plan Mode Hands-On

## Exercises

### 1. Planning a Class-Based Calculator

??? question "Task: Planning a Class-Based Calculator"

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
        * You should see Copilot analyzing your request.

    1.  **Review the Results**: Copilot will analyze the request and suggest a way to implement it.
    2.  **Select an Approach**: If multiple approaches are suggested, choose the one that best fits your needs.
    3.  **Review the Plan**: Copilot will outline the steps it will take, such as:
            * Creating the `Calculator` class in `calculator/calculator.py`.
            * Updating `calculator/main.py` to use the new class.
            * Updating tests to reflect the API changes.

    4.  **Execute**: Click **Start Implementation** and follow the instructions.
    5.  **Use background Agent**: If prompted, allow Copilot to use the background agent to make changes across multiple files.
    6.  The changes are being made automatically by Copilot based on the plan. in a new worktree created for this purpose.
    7.  **Follow Changes**: Monitor the changes being made to ensure they align with your expectations.

### 2. Verifying the Code

??? question "Task: Verifying the Code"

    * Once the implementation is complete, you should see something like this:

    1.  Open `calculator/calculator.py` copy the code from the planning and confirm that the functions are now methods within a `Calculator` class.
    2.  Check `calculator/main.py` to see how the `Calculator` class is instantiated and used.
    3.  Run the application or tests to ensure the refactor didn't break existing functionality.
    4.  Make sure that the code is working with decimal numbers as well.

        ```bash
        python3 calculator/main.py
        ```

### 3. Planning Documentation Strategy

??? question "Task: Planning Documentation Strategy"

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
