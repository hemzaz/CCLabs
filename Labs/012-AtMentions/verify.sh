#!/usr/bin/env bash
# Labs/012-AtMentions/verify.sh - lab-specific post-flight, called by scripts/verify.sh.
# Asserts: session.md exists, is non-empty, and contains at least 3 @ followed by a file path.
# Must be idempotent and run in <10s.
set -euo pipefail

[[ -f "Labs/012-AtMentions/session.md" ]] || {
  echo "missing artifact: Labs/012-AtMentions/session.md — complete Lab 012 step 5 first" >&2
  exit 1
}

[[ -s "Labs/012-AtMentions/session.md" ]] || {
  echo "empty artifact: Labs/012-AtMentions/session.md — save your transcript excerpt first" >&2
  exit 1
}

count=$(grep -cE '@[/a-zA-Z0-9._-]+' Labs/012-AtMentions/session.md || true)
[[ "$count" -ge 3 ]] || {
  echo "insufficient @ mentions: found ${count}, need at least 3 occurrences of @<path> in session.md" >&2
  exit 1
}

exit 0
