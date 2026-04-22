#!/usr/bin/env bash
# Labs/030-ShipFeaturePr/verify.sh - lab-specific post-flight, called by scripts/verify.sh.
# Asserts: quips/SHIPPED.md exists, has >=4 lines, contains a PR URL line,
#          and some commit in quips touches the by-tag feature.
# Must be idempotent and run in <10s.
set -euo pipefail

# quips/SHIPPED.md must exist and be non-empty.
[[ -f "quips/SHIPPED.md" ]] || {
  echo "missing: quips/SHIPPED.md — complete Lab 030 step 3 first" >&2
  exit 1
}

[[ -s "quips/SHIPPED.md" ]] || {
  echo "empty: quips/SHIPPED.md — add the three spec bullets and the PR URL" >&2
  exit 1
}

# Must have at least 4 lines: 3 spec bullets + 1 PR line.
line_count=$(wc -l < quips/SHIPPED.md)
[[ "$line_count" -ge 4 ]] || {
  echo "quips/SHIPPED.md has only ${line_count} line(s) — need at least 4 (3 spec bullets + PR line)" >&2
  exit 1
}

# Must contain a line matching PR: https?://
grep -q '^PR: https\?://' quips/SHIPPED.md || {
  echo "missing: no 'PR: https://...' line in quips/SHIPPED.md — append the PR URL from Lab 030 step 5" >&2
  exit 1
}

# Must have at least one commit in quips referencing the by-tag feature.
(cd quips && git log --oneline --all | grep -qi 'by-tag') || {
  echo "missing: no commit mentioning 'by-tag' in quips git log — complete Lab 030 step 5 first" >&2
  exit 1
}

exit 0
