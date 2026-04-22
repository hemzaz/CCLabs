#!/usr/bin/env bash
# Labs/004-ReadingCodebase/verify.sh - lab-specific post-flight, called by scripts/verify.sh.
# Asserts summary.md exists, is non-empty, mentions SQLite and Fastify, and
# contains at least two of the known Quips endpoints (case-insensitive).
# Must be idempotent and run in <10s.
set -euo pipefail

SUMMARY="Labs/004-ReadingCodebase/summary.md"

if [[ ! -f "$SUMMARY" ]]; then
  echo "missing artifact: $SUMMARY — complete step 5 of the lab" >&2
  exit 1
fi

if [[ ! -s "$SUMMARY" ]]; then
  echo "artifact is empty: $SUMMARY" >&2
  exit 1
fi

if ! grep -qi "sqlite" "$SUMMARY"; then
  echo "summary.md does not mention SQLite" >&2
  exit 1
fi

if ! grep -qi "fastify" "$SUMMARY"; then
  echo "summary.md does not mention Fastify" >&2
  exit 1
fi

# Count how many of the known endpoints appear (case-insensitive).
endpoint_count=0
grep -qi "POST /quips"     "$SUMMARY" && (( endpoint_count++ )) || true
grep -qi "GET /quips"      "$SUMMARY" && (( endpoint_count++ )) || true
grep -qi "DELETE /quips"   "$SUMMARY" && (( endpoint_count++ )) || true
grep -qi "/quips/:id"      "$SUMMARY" && (( endpoint_count++ )) || true

if [[ "$endpoint_count" -lt 2 ]]; then
  echo "summary.md must mention at least 2 Quips endpoints (POST /quips, GET /quips, DELETE /quips, /quips/:id); found $endpoint_count" >&2
  exit 1
fi

exit 0
