#!/usr/bin/env bash
# Labs/031-PromptingWorkshop/doctor.sh - lab-specific pre-flight, called by scripts/doctor.sh.
# Check ONLY what this lab needs above the baseline; exit non-zero with a one-line
# diagnosis on stderr if anything is missing.
set -euo pipefail

# Require claude on PATH.
command -v claude >/dev/null 2>&1 || { echo "claude not found on PATH — install via: npm i -g @anthropic-ai/claude-code" >&2; exit 1; }

# Soft precondition: Capstone PR URL evidence.
# This lab is optional extra practice after the Capstone; warn but do not fail.
if [[ ! -f Labs/_CAPSTONE/evidence/pr_url.txt ]]; then
  echo "WARN: Labs/_CAPSTONE/evidence/pr_url.txt not found — Capstone may not be complete." \
       "Lab 031 is optional and works without it, but the Capstone is recommended first." >&2
fi

exit 0
