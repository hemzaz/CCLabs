#!/usr/bin/env bash
# Labs/020-RefactorSafely/verify.sh - lab-specific post-flight, called by scripts/verify.sh.
# Asserts: db/connection.js and db/quips.js both exist (or db.js re-exports from a new location)
# AND npm test passes in quips/.
# Must be idempotent and run in <30s.
set -euo pipefail

# Check that the split produced both new modules.
if [[ -f "quips/src/db/connection.js" && -f "quips/src/db/quips.js" ]]; then
  : # split complete — both files present
elif grep -q "module.exports" quips/src/db.js 2>/dev/null && \
     grep -qE "require.*db/" quips/src/db.js 2>/dev/null; then
  : # db.js exists as a re-exporter pointing to new sub-modules
else
  echo "missing: quips/src/db/connection.js and quips/src/db/quips.js not found — complete Lab 020 step 4 first" >&2
  exit 1
fi

# Tests must stay green — behavior must be preserved after the split.
(cd quips && npm test --silent) || {
  echo "quips tests failed — run 'cd quips && npm test' to see errors" >&2
  exit 1
}

exit 0
