#!/usr/bin/env bash
# Labs/011-ClaudeMd/verify.sh - lab-specific post-flight, called by scripts/verify.sh.
# Asserts: quips/CLAUDE.md exists, is non-empty, and contains >= 3 rule lines
# (lines starting with -, *, or a digit followed by a dot).
# Must be idempotent and run in <10s.
set -euo pipefail

[[ -f "quips/CLAUDE.md" ]] || {
  echo "missing artifact: quips/CLAUDE.md — complete Lab 011 step 4 first" >&2
  exit 1
}

[[ -s "quips/CLAUDE.md" ]] || {
  echo "quips/CLAUDE.md is empty — add at least 3 rule lines" >&2
  exit 1
}

count=$(grep -cE '^[-*]|^[0-9]+\.' quips/CLAUDE.md || true)
[[ "$count" -ge 3 ]] || {
  echo "quips/CLAUDE.md has only ${count} rule line(s) — need >= 3 lines starting with -, *, or a number" >&2
  exit 1
}

exit 0
