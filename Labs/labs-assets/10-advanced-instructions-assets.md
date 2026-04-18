# Lab 10 - Advanced Instructions Assets

## Example Instruction File: `script.instructions.md`

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

## Example Generated Script

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
