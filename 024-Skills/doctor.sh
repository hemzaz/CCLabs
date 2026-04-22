#!/usr/bin/env bash
# Labs/024-Skills/doctor.sh - lab-specific pre-flight, called by scripts/doctor.sh.
# Checks: claude on PATH, quips dir exists, quips.db exists or can be created, sqlite3 on PATH.
# Exit non-zero with a one-line diagnosis on stderr if any check fails.
set -euo pipefail

# Lab 024 requires claude to be installed (Lab 001 artifact).
command -v claude >/dev/null 2>&1 || {
  echo "claude not found — complete Lab 001 first (npm install -g @anthropic-ai/claude-code)" >&2
  exit 1
}

# quips project must exist (proves the repo was cloned with its submodule).
[[ -d "quips" ]] || {
  echo "missing: quips/ — run: git submodule update --init quips" >&2
  exit 1
}

# sqlite3 is required to inspect and seed the database.
command -v sqlite3 >/dev/null 2>&1 || {
  echo "sqlite3 not found — install sqlite3 (e.g. brew install sqlite3)" >&2
  exit 1
}

# quips.db must exist or be creatable (start the server once if needed).
if [[ ! -f "quips/quips.db" ]]; then
  # Attempt to create an empty database so the learner can proceed.
  sqlite3 quips/quips.db "" 2>/dev/null || {
    echo "cannot create quips/quips.db — check write permissions in quips/" >&2
    exit 1
  }
fi

exit 0
