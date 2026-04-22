#!/usr/bin/env bash
# Labs/003-SlashCommands/doctor.sh - lab-specific pre-flight, called by scripts/doctor.sh.
# Check ONLY what this lab needs above the baseline; exit non-zero with a one-line
# diagnosis on stderr if anything is missing.
set -euo pipefail

# Lab 003 requires Lab 001 artifact: claude must be installed (proves Lab 001 done).
command -v claude >/dev/null 2>&1 || { echo "claude not found — complete Lab 001 first (npm install -g @anthropic-ai/claude-code)" >&2; exit 1; }

exit 0
