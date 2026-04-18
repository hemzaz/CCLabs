## Lab 10 - Advanced Instructions Hands-On

#### Step-by-Step Instructions

## 01. Set Up the Folder Structure

??? question "Task: Set Up the Folder Structure"

    - Create a folder named `.github/instructions/` in the root of your project.
    - This folder will contain our custom instruction files.

## 02. Create the Instruction File

??? question "Task: Create the Instruction File"

    - Inside the `.github/instructions/` folder, create a new file named `script.instructions.md`.
    - This file will contain the specific instructions for files in the `script` directory.

## 03. Add Scoped Instructions

??? question "Task: Add Scoped Instructions"

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

## 04. Instructions in Action

??? question "Task: Instructions in Action"

    - Now, when you will create bash scripts in the `script` directory, GitHub Copilot will follow the custom instructions defined in `script.instructions.md`.
    - Test this by creating a new bash script in the `script` directory and observing how Copilot generates code based on the specified instructions.
    - Use the following prompt in Copilot Chat to generate a new bash script:

        !!! example "Prompt to use in Copilot Chat"
            * Create a bash script that print the current date and time
            * The bash script should be in the `script` directory.
