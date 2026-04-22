#!/usr/bin/env bash
# Labs/008-PlanMode/verify.sh - lab-specific post-flight, called by scripts/verify.sh.
# Asserts: plan-transcript.md exists, is non-empty, contains the word "plan",
# has a numbered or bulleted list of at least 3 steps, and contains APPROVE or REVISE.
# Must be idempotent and run in <10s.
set -euo pipefail

ARTIFACT="Labs/008-PlanMode/plan-transcript.md"

# 1. File must exist and be non-empty.
[[ -f "$ARTIFACT" ]] || {
  echo "missing: $ARTIFACT — complete Lab 008 step 5 first" >&2
  exit 1
}
[[ -s "$ARTIFACT" ]] || {
  echo "$ARTIFACT is empty — paste the plan transcript into it" >&2
  exit 1
}

# 2. Must contain the word "plan" (case-insensitive).
grep -qi "plan" "$ARTIFACT" || {
  echo "$ARTIFACT does not contain the word 'plan'" >&2
  exit 1
}

# 3. Must contain a numbered or bulleted list with at least 3 list items.
list_count=$(grep -cE '^\s*(-|\*|[0-9]+[.)]) ' "$ARTIFACT" || true)
if [[ "$list_count" -lt 3 ]]; then
  echo "$ARTIFACT must contain a numbered or bulleted list of at least 3 steps (found $list_count)" >&2
  exit 1
fi

# 4. Must contain an APPROVE or REVISE note.
grep -qiE 'approve|revise' "$ARTIFACT" || {
  echo "$ARTIFACT must contain an APPROVE: or REVISE: line with your note" >&2
  exit 1
}

exit 0
