#!/usr/bin/env bash
# Labs/005-WritingFirstCode/doctor.sh - lab-specific pre-flight, called by scripts/doctor.sh.
# Checks: claude on PATH, quips/package.json exists, /random NOT yet in quips/src/server.js.
# Exit non-zero with a one-line diagnosis on stderr if any check fails.
set -euo pipefail

# Lab 005 requires Lab 001 artifact: claude must be installed.
command -v claude >/dev/null 2>&1 || {
  echo "claude not found — complete Lab 001 first (npm install -g @anthropic-ai/claude-code)" >&2
  exit 1
}

# quips project must exist (proves the repo was cloned with its submodule).
[[ -f "quips/package.json" ]] || {
  echo "missing: quips/package.json — run: git submodule update --init quips" >&2
  exit 1
}

# The /random route must NOT yet exist — this lab is what adds it.
if grep -qi "/random" quips/src/server.js 2>/dev/null; then
  echo "quips/src/server.js already contains '/random' — Lab 005 artifact already present; nothing to do" >&2
  exit 1
fi

exit 0
