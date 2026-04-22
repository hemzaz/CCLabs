#!/usr/bin/env bash
# Labs/005-WritingFirstCode/verify.sh - lab-specific post-flight, called by scripts/verify.sh.
# Asserts: npm test passes in quips/ AND /random exists in quips/src/server.js.
# Must be idempotent and run in <30s (test suite is fast; SQLite in-memory).
set -euo pipefail

# Check the route exists first — fast fail before running the full suite.
if ! grep -qi "random" quips/src/server.js 2>/dev/null; then
  echo "GET /random not found in quips/src/server.js — complete Lab 005 steps 2-4 first" >&2
  exit 1
fi

# Run the full Vitest suite. npm test --silent suppresses npm noise but still shows test output.
if ! (cd quips && npm test --silent 2>&1); then
  echo "npm test failed in quips/ — fix failing tests before verifying Lab 005" >&2
  exit 1
fi

exit 0
