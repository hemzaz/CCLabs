# Lab 01 - Setup

- In this lab we will guide you through the initial setup required to get started with the Copilot Prompting Workshop.

## 01 - Create Workshop Directory

- Open your VsCode and create new directory named `Copilot-Prompts-Workshop`.
- Open the created directory in VsCode.

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

- In this lab, you will set up the basic code skeleton for the Copilot Prompting Workshop.
- This includes creating the necessary files as we progress along the labs.

!!! question "Instructions"

    The lab is based upon creating a simple Calculator in Python with the help of `GitHub Copilot prompts`.

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

- install the following Python Packages:

  ```bash
  # Create the .venv as explaind above if you haven't already.
  source .venv/bin/activate   # or the appropriate command for your OS
  pip install uv

  # Will be used in later labs
  uv pip install pytest
  ```

---

## 06 - Optional .github folders

- (Optional) Create a `.github` folder in the root of your project directory.
- The `.github` folder is a special directory used to store configuration files and templates that are specific to GitHub's platform features.
- List of common subfolders used bu Github Copilot and their purposes:

  | Folder           | Description & Usage                                                       |
  | :--------------- | :------------------------------------------------------------------------ |
  | `copilot-agents` | Contains definitions for custom Copilot agents, define specialized agents |
  | `examples`       | Contains example configurations or code for implementation                |
  | `instructions`   | Contains custom instruction files for Copilot                             |
  | `promps`         | Directory for storing prompts.                                            |

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
  Those `.github` files & folders and their contents are optional for this workshop,
  but they can enhance your experience with GitHub Copilot features.
