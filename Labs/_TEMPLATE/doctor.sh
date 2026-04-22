#!/usr/bin/env bash
# Labs/_TEMPLATE/doctor.sh - lab-specific pre-flight, called by scripts/doctor.sh.
# Check ONLY what this lab needs above the baseline; exit non-zero with a one-line
# diagnosis on stderr if anything is missing.
set -euo pipefail

# Example: require a specific file to already exist (prior lab's artifact).
# [[ -f quips/src/server.js ]] || { echo "missing prior artifact: quips/src/server.js" >&2; exit 1; }

exit 0
