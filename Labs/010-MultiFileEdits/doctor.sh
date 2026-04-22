#!/usr/bin/env bash
# Labs/010-MultiFileEdits/doctor.sh - lab-specific pre-flight, called by scripts/doctor.sh.
# Checks: claude on PATH, quips directory and all three source files exist.
# Exit non-zero with a one-line diagnosis on stderr if any check fails.
set -euo pipefail

# Lab 010 requires claude to be installed (Lab 001 artifact).
command -v claude >/dev/null 2>&1 || {
  echo "claude not found — complete Lab 001 first (npm install -g @anthropic-ai/claude-code)" >&2
  exit 1
}

# quips project must exist (proves the repo was cloned with its submodule).
[[ -d "quips" ]] || {
  echo "missing: quips/ — run: git submodule update --init quips" >&2
  exit 1
}

# All three files that the learner will edit must be present (Lab 009 artifact).
[[ -f "quips/src/db.js" ]] || {
  echo "missing prior artifact: quips/src/db.js — complete Lab 009 first" >&2
  exit 1
}

[[ -f "quips/src/server.js" ]] || {
  echo "missing prior artifact: quips/src/server.js — complete Lab 009 first" >&2
  exit 1
}

[[ -f "quips/test/server.test.js" ]] || {
  echo "missing prior artifact: quips/test/server.test.js — complete Lab 009 first" >&2
  exit 1
}

exit 0
