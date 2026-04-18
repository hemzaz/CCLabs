## Lab 01 - Setup Hands-On

## 01 - Create Workshop Directory

??? question "Task: Create Workshop Directory"

    - Open your VsCode and create new directory named `Copilot-Prompts-Workshop`.
    - Open the created directory in VsCode.

## 02 - Create Virtual Environment

??? question "Task: Create Virtual Environment"

    * The virtual environment will help us manage dependencies for the workshop.
    * Run the following command in your terminal to create a virtual environment named `venv`

        ```bash
        python -m venv .venv
        ```

## 03 - Activate the venv

??? question "Task: Activate the venv"

    === "Windows (cmd)"
        ```cmd
        .venv\Scripts\activate
        ```

    === "Windows (PowerShell)"
        ```powershell
        .venv\Scripts\Activate.ps1
        ```

    === "macOS / Linux (bash/zsh)"
        ```bash
        source .venv/bin/activate
        ```

    === "Git Bash (Windows)"
        ```bash
        source .venv/Scripts/activate
        ```

## 04 - Create Project Structure

??? question "Task: Create Project Structure"

    - Create a new directory named `calculator` in your workshop folder.

    - Inside the `calculator` directory, create the following file:
        * `calculator.py` - This will be the main module for our calculator functions.

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

## 05 - Install Required Extensions

??? question "Task: Install Required Extensions"

    * install the following Python Packages:

        ```bash
        # Create the .venv as explaind above if you haven't already.
        source .venv/bin/activate   # or the appropriate command for your OS
        pip install uv

        # Will be used in later labs
        uv pip install pytest    
        ```

## 06 - Optional .github folders

??? question "Task: Optional .github folders"

    * (Optional) Create a `.github` folder in the root of your project directory.
    * The `.github` folder is a special directory used to store configuration files and templates that are specific to GitHub's platform features. 
