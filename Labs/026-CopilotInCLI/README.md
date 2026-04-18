# Lab 026 - GitHub Copilot in the CLI

!!! hint "Overview"

    - GitHub Copilot CLI (`gh copilot`) brings AI assistance directly to your terminal without switching to an IDE.
    - In this lab, you will use `gh copilot suggest` to generate shell commands from natural language descriptions.
    - You will also use `gh copilot explain` to understand complex commands before running them, reducing the risk of mistakes.
    - By the end of this lab, you will have a terminal-native Copilot workflow that speeds up your command-line operations.

## Prerequisites

- Completed [Lab 025 - Shell Scripting](../025-ShellScripting/README.md)
- GitHub CLI (`gh`) installed and authenticated

## What You Will Learn

- How to install and configure GitHub Copilot CLI
- How to use `gh copilot suggest` for command suggestions
- How to use `gh copilot explain` to understand commands
- How to alias CLI commands for maximum productivity
- Integration with your existing shell workflow

---

## Lab Steps

## Step 1 - Install GitHub Copilot CLI Extension

```bash
# Install the Copilot CLI extension for gh
gh extension install github/gh-copilot

# Verify installation
gh copilot --version
```

## Step 2 - Authenticate

```bash
# If not already authenticated
gh auth login

# Verify auth
gh auth status
```

## Step 3 - Suggest Commands (`gh copilot suggest`)

Ask for shell commands in plain English:

```bash
# Suggest a git command
gh copilot suggest "undo my last commit but keep the changes staged"

# Suggest a docker command
gh copilot suggest "run a container with my current directory mounted and port 3000 exposed"

# Suggest a kubectl command
gh copilot suggest "get logs from all pods matching label app=api in the production namespace"

# Suggest a find command
gh copilot suggest "find all Python files modified in the last 7 days larger than 100KB"
```

When Copilot suggests a command, you can:

- Press `Enter` to run it immediately
- Press `e` to edit it first
- Press `q` to quit

## Step 4 - Explain Commands (`gh copilot explain`)

Get plain-English explanations of commands:

```bash
# Explain a complex command
gh copilot explain "git rebase -i HEAD~3 --autosquash"

# Explain a cryptic one-liner
gh copilot explain "awk 'NR==FNR{a[$1]=$2;next} $1 in a{print $0,a[$1]}' file1 file2"

# Explain curl options
gh copilot explain "curl -fsSL https://example.com | bash"

# Explain a sed command
gh copilot explain "sed -i 's/\b\(foo\|bar\)\b/baz/g' *.txt"
```

## Step 5 - Set Up Shell Aliases

Add these to your `~/.zshrc` or `~/.bashrc` for faster access:

```bash
# Short aliases for copilot CLI
alias '??'='gh copilot suggest -t shell'
alias 'git?'='gh copilot suggest -t git'
alias 'gh?'='gh copilot suggest -t gh'
alias 'explain'='gh copilot explain'

# Usage examples:
# ?? "compress all PNG files in current dir"
# git? "cherry-pick a range of commits"
# explain "ls -lah | awk '{print $5, $9}'"
```

Reload: `source ~/.zshrc`

## Step 6 - Specify Command Type

The `-t` flag restricts suggestions to a command type:

```bash
# Get only git suggestions
gh copilot suggest -t git "show all commits that changed a specific file"

# Get only GitHub CLI suggestions
gh copilot suggest -t gh "create a draft PR from current branch"

# Get general shell suggestions (default)
gh copilot suggest -t shell "monitor CPU usage of a specific process in real time"
```

## Step 7 - Use in Scripts

```bash
#!/usr/bin/env bash
# Interactive command builder
read -p "What do you want to do? " request
gh copilot suggest "$request"
```

## Step 8 - Practical Scenarios

**Git emergency:**

```bash
gh copilot suggest "I accidentally committed to main, move my commit to a new branch"
```

**Kubernetes troubleshooting:**

```bash
gh copilot suggest "find which pod is consuming the most CPU in the default namespace"
```

**File operations:**

```bash
gh copilot suggest "rename all .jpeg files to .jpg recursively"
```

**Network debugging:**

```bash
gh copilot suggest "check which process is listening on port 5432"
```

---

## Configuration

```bash
# Set default target type
gh config set copilot.suggest.default-target shell

# Disable telemetry
gh config set copilot.usage-telemetry false
```

---

## Summary

GitHub Copilot CLI makes AI assistance available everywhere you work - in the terminal, in scripts, and in remote SSH sessions where you don't have VS Code.

## Next Steps

Continue with [Lab 027 - Knowledge Bases](../027-KnowledgeBases/README.md)

---

## Tasks

## Task 01 - Install the Copilot CLI Extension

**Scenario:** Set up `gh copilot` in your terminal.

**Hint:** Use `gh extension install`.

??? success "Solution"

    ```bash
    gh extension install github/gh-copilot
    gh copilot --version
    ```

---

## Task 02 - Suggest a Git Command

**Scenario:** You want to undo your last commit but keep the changes staged.

**Hint:** `gh copilot suggest -t git "..."`

??? success "Solution"

    ```bash
    gh copilot suggest -t git "undo my last commit but keep all changes staged"
    ```

    Expected suggestion: `git reset --soft HEAD~1`

---

## Task 03 - Explain a Complex Command

**Scenario:** You found a `git rebase` command you don't understand.

**Hint:** `gh copilot explain "..."`

??? success "Solution"

    ```bash
    gh copilot explain "git rebase -i HEAD~3 --autosquash"
    ```

---

## Task 04 - Suggest a Kubernetes Command

**Scenario:** You want to find which pod is consuming the most CPU.

**Hint:** `gh copilot suggest -t shell "..."`

??? success "Solution"

    ```bash
    gh copilot suggest -t shell "find which pod is consuming the most CPU in the default namespace"
    ```

---

## Task 05 - Set Up Shell Aliases

**Scenario:** Create short aliases so you can use `??` instead of `gh copilot suggest`.

**Hint:** Add aliases to `~/.zshrc`.

??? success "Solution"

    Add to `~/.zshrc`:

    ```bash
    alias '??'='gh copilot suggest -t shell'
    alias 'git?'='gh copilot suggest -t git'
    alias 'explain'='gh copilot explain'
    ```

    Then: `source ~/.zshrc && ?? "compress all PNG files in current directory"`

---

## Task 06 - Suggest a Network Debugging Command

**Scenario:** Find which process is listening on port 5432.

**Hint:** Use the shell target type.

??? success "Solution"

    ```bash
    gh copilot suggest -t shell "find which process is listening on port 5432"
    ```

    Expected: `lsof -i :5432` or `ss -tlnp | grep 5432`
