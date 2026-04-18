# Lab 10 - Advanced Instructions

## 01. Preface

* This lab is all about Advanced Instructions for GitHub Copilot.
* We will explore how to create custom instructions for specific coding styles, best practices, and project conventions.

---

## 02. Objectives

* Understand the concept of Advanced Instructions in GitHub Copilot.
* Learn how to create and implement custom instructions for your projects.
* Explore best practices for writing effective instructions.
* Apply advanced instructions to a sample project.

---

## 03. Advanced File-Specific Scoping

* In this lab, we will learn how to create file-specific instructions for GitHub Copilot.
* This allows us to tailor Copilot's behavior based on the specific files or directories in our project.
* We will create a set of instructions that apply only to backend files in the `script` directory.
* At the start of the file, create a `frontmatter` block containing the applyTo keyword. 
* Use glob syntax to specify what files or directories the instructions apply to.
* Glob examples:

    | Glob Pattern        | Description                                                            |
    |---------------------|------------------------------------------------------------------------|
    | `*`                 | Match all files in the current directory.                              |
    | `**` or `**/*`      | Match all files in all directories.                                    |
    | `*.sh`              | Match all `.sh` files in the current directory.                        |
    | `**/*.sh`           | Recursively match all `.sh` files in all directories.                  |
    | `src/*.sh`          | Match all `.sh` files in the src directory.sh).                        |
    | `src/**/*.sh`       | Recursively match all `.sh` files in the src directory.sh).            |
    | `**/subdir/**/*.sh` | Recursively match all `.sh` files in any subdir directory at any depth |

* After the `frontmatter`, add your custom instructions for the specified files or directories.

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
        * Create a bash script that print the current date and time
        * The bash script should be in the `script` directory.

    <details>
    <summary>Expected Generated Code</summary>
    ```bash
    #!/bin/bash
    set -euo pipefail

    # Load .env if present in the same directory
    if [[ -f "$(dirname "$0")/.env" ]]; then
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
        if [[ "${DEBUG:-}" == "1" ]]; then
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