#!/usr/bin/env bash
# Labs/030-ShipFeaturePr/doctor.sh - lab-specific pre-flight, called by scripts/doctor.sh.
# Checks: claude on PATH, quips dir exists and is a git repo, gh CLI on PATH.
# Exit non-zero with a one-line diagnosis on stderr if any check fails.
set -euo pipefail

# Lab 030 requires claude to be installed (Lab 001 artifact).
command -v claude >/dev/null 2>&1 || {
  echo "claude not found — complete Lab 001 first (npm install -g @anthropic-ai/claude-code)" >&2
  exit 1
}

# quips project must exist (proves the repo was cloned with its submodule).
[[ -d "quips" ]] || {
  echo "missing: quips/ — run: git submodule update --init quips" >&2
  exit 1
}

# quips must be a git repository (needed for branching in this lab).
[[ -d "quips/.git" ]] || {
  echo "quips/ is not a git repository — run: git submodule update --init quips" >&2
  exit 1
}

# gh CLI must be installed and authenticated (needed for gh pr create).
command -v gh >/dev/null 2>&1 || {
  echo "gh not found — install the GitHub CLI: https://cli.github.com" >&2
  exit 1
}

exit 0
