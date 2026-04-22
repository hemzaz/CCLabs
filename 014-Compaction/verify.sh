#!/usr/bin/env bash
# Labs/014-Compaction/verify.sh - lab-specific post-flight, called by scripts/verify.sh.
# Asserts: compact-notes.md exists, is non-empty, contains 'compact', 'before', and 'after'.
# Must be idempotent and run in <10s.
set -euo pipefail

[[ -f "Labs/014-Compaction/compact-notes.md" ]] || {
  echo "missing artifact: Labs/014-Compaction/compact-notes.md — complete Lab 014 step 5 first" >&2
  exit 1
}

[[ -s "Labs/014-Compaction/compact-notes.md" ]] || {
  echo "Labs/014-Compaction/compact-notes.md is empty — add Before/After/Dropped sections" >&2
  exit 1
}

grep -qi "compact" "Labs/014-Compaction/compact-notes.md" || {
  echo "compact-notes.md must contain the word 'compact' (case-insensitive)" >&2
  exit 1
}

grep -qi "before" "Labs/014-Compaction/compact-notes.md" || {
  echo "compact-notes.md must contain a 'before' marker (case-insensitive)" >&2
  exit 1
}

grep -qi "after" "Labs/014-Compaction/compact-notes.md" || {
  echo "compact-notes.md must contain an 'after' marker (case-insensitive)" >&2
  exit 1
}

exit 0
