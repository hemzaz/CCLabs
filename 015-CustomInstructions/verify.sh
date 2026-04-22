#!/usr/bin/env bash
# Labs/015-CustomInstructions/verify.sh - lab-specific post-flight, called by scripts/verify.sh.
# Asserts: quips/src/CLAUDE.md exists, is non-empty, and differs from quips/CLAUDE.md (if both present).
# Must be idempotent and run in <10s.
set -euo pipefail

[[ -f "quips/src/CLAUDE.md" ]] || {
  echo "missing artifact: quips/src/CLAUDE.md — complete Lab 015 step 4 first" >&2
  exit 1
}

[[ -s "quips/src/CLAUDE.md" ]] || {
  echo "quips/src/CLAUDE.md is empty — add at least one src-specific rule" >&2
  exit 1
}

# If quips/CLAUDE.md also exists (Lab 011 done), the two files must not be identical.
if [[ -f "quips/CLAUDE.md" ]]; then
  if diff -q "quips/CLAUDE.md" "quips/src/CLAUDE.md" >/dev/null 2>&1; then
    echo "quips/src/CLAUDE.md is identical to quips/CLAUDE.md — add distinct src-specific rules" >&2
    exit 1
  fi
fi

exit 0
