#!/usr/bin/env bash
# Labs/017-RescueRecover/verify.sh - lab-specific post-flight, called by scripts/verify.sh.
# Asserts: quips/.claude/rescue-log.md exists, is non-empty, and contains >= 3 lines.
# Must be idempotent and run in <10s.
set -euo pipefail

[[ -f "quips/.claude/rescue-log.md" ]] || {
  echo "missing: quips/.claude/rescue-log.md — complete Lab 017 step 5 first" >&2
  exit 1
}

[[ -s "quips/.claude/rescue-log.md" ]] || {
  echo "empty: quips/.claude/rescue-log.md has no content — add at least 3 lines" >&2
  exit 1
}

line_count=$(wc -l < "quips/.claude/rescue-log.md")
[[ "$line_count" -ge 3 ]] || {
  echo "too short: quips/.claude/rescue-log.md has ${line_count} line(s) — need at least 3" >&2
  exit 1
}

exit 0
