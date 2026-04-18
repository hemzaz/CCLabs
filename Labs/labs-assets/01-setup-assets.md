# Lab 01 Assets

## Virtual Environment

```bash
python -m venv .venv
```

## Activation

**Windows (cmd)**
```cmd
.venv\Scripts\activate
```

**Windows (PowerShell)**
```powershell
.venv\Scripts\Activate.ps1
```

**macOS / Linux (bash/zsh)**
```bash
source .venv/bin/activate
```

**Git Bash (Windows)**
```bash
source .venv/Scripts/activate
```

## Calculator Starter Code

`calculator/calculator.py`

```python
# calculator.py
def add(x, y):
    """Add two numbers."""
    return x + y
```

## Install Extensions

```bash
# Create the .venv as explaind above if you haven't already.
source .venv/bin/activate   # or the appropriate command for your OS
pip install uv

# Will be used in later labs
uv pip install pytest    
```
