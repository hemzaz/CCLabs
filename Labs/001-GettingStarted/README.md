# Lab 001 - Getting Started with GitHub Copilot

!!! hint "Overview"

    - In this lab, you will set up GitHub Copilot in Visual Studio Code and write your first AI-assisted code snippets.
    - You will install the GitHub Copilot extension, sign in with your GitHub account, and verify your subscription is active.
    - Once configured, you will experience Ghost Text inline suggestions and learn how to accept, reject, and cycle through them.
    - By the end of this lab, you will understand how Copilot reads context from your code to generate relevant completions.

## Prerequisites

- Visual Studio Code installed
- GitHub account with an active Copilot subscription
- Internet connection

## What You Will Learn

- How to install and configure the GitHub Copilot extension
- How Copilot Ghost Text (inline suggestions) works
- How to accept, reject, and cycle through suggestions
- The basics of how Copilot understands context from your code

---

## Enabling GitHub Copilot on Your GitHub Account

Before installing the VS Code extension, you need an active GitHub Copilot subscription (or the free tier) on your GitHub account.

## Option A - Free Plan (GitHub Copilot Free)

**GitHub Copilot Free** is available to any GitHub personal account at no cost. It gives you access to core AI coding features with a monthly usage quota - a great way to get started without a paid subscription.

**What's included in the free plan:**

| Feature                       | Limit                                    |
| ----------------------------- | ---------------------------------------- |
| Code completions (Ghost Text) | 2,000 per month                          |
| Copilot Chat messages         | 50 per month                             |
| Supported editors             | VS Code, JetBrains, Vim/Neovim, and more |
| Multi-line completions        | ✓                                        |
| Copilot Chat in the IDE       | ✓                                        |
| CLI assistance                | ✓                                        |

**How to enable it:**

1. Go to [github.com](https://github.com) and sign in to your personal account
2. Click your **profile avatar** (top-right corner) → **Settings**
3. In the left sidebar, scroll down to the **Code, planning, and automation** section and click **Copilot**
4. On the Copilot settings page, click **Start using GitHub Copilot**
5. Read and accept the usage policy, then click **Save**
6. You will see a confirmation that Copilot is now **active** on your account

!!! tip "Free Plan Limits"

    Once you reach the monthly quota, suggestions will pause until the next billing cycle. You can check your remaining quota under **Settings → Copilot**. To remove limits, upgrade to **Copilot Pro** ($10/month) from the same page.

!!! warning "Personal accounts only"

    The free plan is only available for **personal GitHub accounts**. If you are using a GitHub organization account or a work account managed by an enterprise, see Option B below.

---

## Option B - Copilot Pro / Business / Enterprise

If your organization provides a Copilot subscription, you may already have access. Verify at:

1. Go to **Settings** → **Copilot**
2. Check that the status shows **Active** under _GitHub Copilot is enabled for your account_

!!! note "Organization-Managed Access"

    For Business or Enterprise plans, a GitHub organization owner must enable Copilot for your team. Contact your admin if you don't see an active subscription.

---

## Lab Steps

## Step 1 - Install the GitHub Copilot Extension

1. Open VS Code
2. Go to the **Extensions** view (`Ctrl+Shift+X` / `Cmd+Shift+X`)
3. Search for **GitHub Copilot**
4. Click **Install**

!!! note

    Make sure you install the **GitHub Copilot** extension (not just GitHub Copilot Chat).

## Step 2 - Sign In to GitHub

1. After installation, you will be prompted to sign in to GitHub
2. Click **Sign in to GitHub** and follow the OAuth flow
3. Authorize VS Code to use your GitHub Copilot subscription

## Step 3 - Verify the Installation

1. Open a new file (e.g., `hello.py`)
2. Start typing a function and observe Ghost Text appearing:

```python
# Write a function that greets a user by name
def greet(
```

3. Copilot should suggest a completion - press `Tab` to accept it

## Step 4 - Explore Suggestions

Try the following in your file and observe how Copilot responds:

```python
# Generate a list of 5 random numbers between 1 and 100
```

- Press `Alt+]` (Windows/Linux) or `Option+]` (macOS) to cycle through alternate suggestions
- Press `Escape` to dismiss suggestions

---

## Summary

You have successfully set up GitHub Copilot and explored basic code completion. In the next lab, you will dive deeper into code completion features.

## Next Steps

Continue with [Lab 002 - Code Completion](../002-CodeCompletion/README.md)

---

## Tasks

## Task 01 - Install the Copilot Extension

**Scenario:** You have a fresh VS Code install with no Copilot extension. Set it up from scratch.

**Hint:** Extensions panel (`Cmd+Shift+X`), search "GitHub Copilot", install both `GitHub Copilot` and `GitHub Copilot Chat`.

??? success "Solution"

    1. Open VS Code → Extensions (`Cmd+Shift+X`)
    2. Search for **GitHub Copilot** and install it
    3. Search for **GitHub Copilot Chat** and install it
    4. Sign in when prompted: `Cmd+Shift+P` → **GitHub Copilot: Sign In**
    5. Verify: the Copilot icon appears in the status bar (bottom right)

---

## Task 02 - Verify Ghost Text is Working

**Scenario:** After installation, confirm Copilot inline suggestions are active.

**Hint:** Create a new `.py` file, type `def greet(name:`, then pause.

??? success "Solution"

    1. Create `hello.py`
    2. Type: `def greet(name:`
    3. Wait ~0.5s - a greyed-out suggestion appears
    4. Press `Tab` to accept
    5. If nothing appears: Status Bar → Copilot icon → check it is not showing a red X

---

## Task 03 - Cycle Through Suggestions

**Scenario:** Copilot generates multiple completion options. Practice navigating them.

**Hint:** `Alt+[` / `Alt+]` cycles suggestions; `Ctrl+Enter` opens the completions panel.

??? success "Solution"

    1. Type a function signature: `def calculate_tax(price, rate):`
    2. When Ghost Text appears, press `Alt+]` to see the next suggestion
    3. Press `Alt+[` to go back
    4. Press `Ctrl+Enter` to open the **GitHub Copilot Completions** panel (up to 10 options)
    5. Click any option to insert it

---

## Task 04 - Reject a Suggestion

**Scenario:** Copilot suggests something you don't want. Dismiss it without inserting.

**Hint:** `Escape` dismisses the current Ghost Text.

??? success "Solution"

    1. Start typing code that triggers a suggestion
    2. When Ghost Text appears, press `Escape`
    3. The suggestion disappears - you can type your own code normally
    4. Pressing any character that differs from the suggestion also dismisses it

---

## Task 05 - Use a Comment to Guide Copilot

**Scenario:** Write a comment describing a function before writing any code, let Copilot generate the implementation.

**Hint:** `# Function to validate a UK postcode format`

??? success "Solution"

    1. Create `utils.py`
    2. Type this comment:


    ```python
    # Validate a UK postcode (e.g. SW1A 1AA, M1 1AE).
    # Return True if valid, False otherwise.

    ```
    3. Press Enter - Copilot suggests the function signature and body
    4. Accept with `Tab`; observe how the comment drove the implementation

---

## Task 06 - Disable Copilot for a Specific Language

**Scenario:** You want Copilot active for Python but disabled for Markdown files.

**Hint:** Click the Copilot icon in the status bar to toggle per language.

??? success "Solution"

    1. Open a `.md` file
    2. Click the **Copilot icon** in the bottom status bar
    3. Select **Disable for Markdown**
    4. Open a `.py` file - suggestions still work there
    5. To re-enable: click the Copilot icon → **Enable for Markdown**
