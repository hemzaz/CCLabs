#!/usr/bin/env bash
# Labs/016-TDD/doctor.sh - lab-specific pre-flight, called by scripts/doctor.sh.
# Checks: claude on PATH, quips dir exists, quips/src/server.js and quips/test/server.test.js present.
# Exit non-zero with a one-line diagnosis on stderr if any check fails.
set -euo pipefail

# Lab 016 requires claude to be installed (Lab 001 artifact).
command -v claude >/dev/null 2>&1 || {
  echo "claude not found — complete Lab 001 first (npm install -g @anthropic-ai/claude-code)" >&2
  exit 1
}

# quips project must exist (proves the repo was cloned with its submodule).
[[ -d "quips" ]] || {
  echo "missing: quips/ — run: git submodule update --init quips" >&2
  exit 1
}

# quips/src/server.js must exist (built during Labs 005–015).
[[ -f "quips/src/server.js" ]] || {
  echo "missing prior artifact: quips/src/server.js — complete Labs through Checkpoint C first" >&2
  exit 1
}

# quips/test/server.test.js must exist (built during earlier labs).
[[ -f "quips/test/server.test.js" ]] || {
  echo "missing prior artifact: quips/test/server.test.js — complete Labs through Checkpoint C first" >&2
  exit 1
}

exit 0
