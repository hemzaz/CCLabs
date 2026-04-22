#!/usr/bin/env bash
# Labs/007-ToolUse/doctor.sh - lab-specific pre-flight, called by scripts/doctor.sh.
# Checks: claude on PATH, quips/ directory present.
# Exit non-zero with a one-line diagnosis on stderr if any check fails.
set -euo pipefail

# Lab 007 requires Lab 001 artifact: claude must be installed.
command -v claude >/dev/null 2>&1 || {
  echo "claude not found — complete Lab 001 first (npm install -g @anthropic-ai/claude-code)" >&2
  exit 1
}

# quips submodule must be present (needed for the test-file counting exercise).
[[ -d "quips" ]] || {
  echo "missing: quips/ directory — run: git submodule update --init quips" >&2
  exit 1
}

exit 0
