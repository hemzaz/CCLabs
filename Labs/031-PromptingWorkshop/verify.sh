#!/usr/bin/env bash
# Labs/031-PromptingWorkshop/verify.sh - lab-specific post-flight, called by scripts/verify.sh.
# Assert the expected artifact exists, has >=8 labeled drill sections, and is non-empty.
# Must be idempotent and run in <10s.
set -euo pipefail

PROMPTS_FILE="Labs/031-PromptingWorkshop/prompts.md"

[[ -f "$PROMPTS_FILE" ]] || { echo "missing artifact: ${PROMPTS_FILE}" >&2; exit 1; }
[[ -s "$PROMPTS_FILE" ]] || { echo "artifact is empty: ${PROMPTS_FILE}" >&2; exit 1; }

drill_count=$(grep -cE '^## Drill [0-9]+' "$PROMPTS_FILE" || true)
if [[ "$drill_count" -lt 8 ]]; then
  echo "prompts.md has ${drill_count} '## Drill N' sections; need >=8" >&2
  exit 1
fi

echo "OK lab 031 verified"
