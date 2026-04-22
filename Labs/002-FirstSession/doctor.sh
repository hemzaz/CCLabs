#!/usr/bin/env bash
# Labs/002-FirstSession/doctor.sh - lab-specific pre-flight, called by scripts/doctor.sh.
# Checks that Lab 001's artifact is present: claude must be on PATH.
# Exit non-zero with a one-line diagnosis on stderr if anything is missing.
set -euo pipefail

if ! command -v claude >/dev/null 2>&1; then
  echo "missing: claude (not on PATH) — complete Lab 001 first: npm i -g @anthropic-ai/claude-code" >&2
  exit 1
fi

exit 0
