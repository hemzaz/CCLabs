#!/usr/bin/env bash
# Labs/010-MultiFileEdits/verify.sh - lab-specific post-flight, called by scripts/verify.sh.
# Asserts: 'author' appears in all three target files AND npm test passes in quips/.
# Must be idempotent and run in <10s.
set -euo pipefail

grep -q 'author' quips/src/db.js || {
  echo "missing: 'author' not found in quips/src/db.js — complete Lab 010 step 2 first" >&2
  exit 1
}

grep -q 'author' quips/src/server.js || {
  echo "missing: 'author' not found in quips/src/server.js — complete Lab 010 step 2 first" >&2
  exit 1
}

grep -q 'author' quips/test/server.test.js || {
  echo "missing: 'author' not found in quips/test/server.test.js — complete Lab 010 step 2 first" >&2
  exit 1
}

(cd quips && npm test --silent) || {
  echo "quips tests failed — run 'cd quips && npm test' to see errors" >&2
  exit 1
}

exit 0
