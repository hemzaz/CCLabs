#!/usr/bin/env bash
# Labs/006-Prompting/verify.sh - lab-specific post-flight, called by scripts/verify.sh.
# Assert the expected artifact exists / tests pass / endpoint responds as spec'd.
# Must be idempotent and run in <10s.
set -euo pipefail

[[ -s Labs/006-Prompting/prompts.md ]] || { echo "missing artifact: Labs/006-Prompting/prompts.md" >&2; exit 1; }
grep -cqi 'BAD' Labs/006-Prompting/prompts.md || { echo "prompts.md missing BAD sections" >&2; exit 1; }
grep -cqi 'GOOD' Labs/006-Prompting/prompts.md || { echo "prompts.md missing GOOD sections" >&2; exit 1; }
[[ $(grep -c -i 'BAD' Labs/006-Prompting/prompts.md) -ge 3 ]] || { echo "prompts.md needs at least 3 BAD entries" >&2; exit 1; }
[[ $(grep -c -i 'GOOD' Labs/006-Prompting/prompts.md) -ge 3 ]] || { echo "prompts.md needs at least 3 GOOD entries" >&2; exit 1; }

exit 0
