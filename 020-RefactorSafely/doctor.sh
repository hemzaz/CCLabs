#!/usr/bin/env bash
# Labs/020-RefactorSafely/doctor.sh - lab-specific pre-flight, called by scripts/doctor.sh.
# Checks: claude on PATH, quips dir exists, quips/src/db.js exists, quips/test/server.test.js exists.
# Exit non-zero with a one-line diagnosis on stderr if any check fails.
set -euo pipefail

# Lab 020 requires claude to be installed (Lab 001 artifact).
command -v claude >/dev/null 2>&1 || {
  echo "claude not found — complete Lab 001 first (npm install -g @anthropic-ai/claude-code)" >&2
  exit 1
}

# quips project must exist (proves the repo was cloned with its submodule).
[[ -d "quips" ]] || {
  echo "missing: quips/ — run: git submodule update --init quips" >&2
  exit 1
}

# db.js must be present — this is the file the learner will split.
[[ -f "quips/src/db.js" ]] || {
  echo "missing prior artifact: quips/src/db.js — complete Lab 019 first" >&2
  exit 1
}

# Test file must exist — tests must stay green throughout the refactor.
[[ -f "quips/test/server.test.js" ]] || {
  echo "missing prior artifact: quips/test/server.test.js — complete Lab 019 first" >&2
  exit 1
}

exit 0
