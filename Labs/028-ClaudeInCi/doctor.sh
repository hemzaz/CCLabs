#!/usr/bin/env bash
# Labs/028-ClaudeInCi/doctor.sh - lab-specific pre-flight, called by scripts/doctor.sh.
# Checks: claude on PATH, .github directory exists at repo root, python3 on PATH, git on PATH.
# Exit non-zero with a one-line diagnosis on stderr if any check fails.
set -euo pipefail

# Lab 028 requires claude to be installed (Lab 001 artifact).
command -v claude >/dev/null 2>&1 || {
  echo "claude not found — complete Lab 001 first (npm install -g @anthropic-ai/claude-code)" >&2
  exit 1
}

# git is required to commit the workflow file in step 5.
command -v git >/dev/null 2>&1 || {
  echo "git not found — install git: https://git-scm.com/downloads" >&2
  exit 1
}

# python3 is required to validate YAML in step 4.
command -v python3 >/dev/null 2>&1 || {
  echo "python3 not found — install python3: https://www.python.org/downloads/" >&2
  exit 1
}

# .github directory must exist at the repo root (proves this is the CCLabs repo, not quips/).
[[ -d ".github" ]] || {
  echo "missing: .github/ directory — run this script from the CCLabs repo root, not from quips/" >&2
  exit 1
}

exit 0
