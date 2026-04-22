#!/usr/bin/env bash
# Labs/006-Prompting/doctor.sh - lab-specific pre-flight, called by scripts/doctor.sh.
# Check ONLY what this lab needs above the baseline; exit non-zero with a one-line
# diagnosis on stderr if anything is missing.
set -euo pipefail

command -v claude >/dev/null 2>&1 || { echo "claude CLI not found in PATH" >&2; exit 1; }
[[ -d quips ]] || { echo "missing prior artifact: quips/ (complete Lab 005 first)" >&2; exit 1; }

exit 0
