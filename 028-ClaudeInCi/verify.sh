#!/usr/bin/env bash
# Labs/028-ClaudeInCi/verify.sh - lab-specific post-flight, called by scripts/verify.sh.
# Asserts: claude-review.yml exists and is non-empty, parses as valid YAML,
#          references anthropics/claude-code-action, and references ANTHROPIC_API_KEY.
# Must be idempotent and run in <10s.
set -euo pipefail

WORKFLOW=".github/workflows/claude-review.yml"

# 1. File must exist and be non-empty.
[[ -f "$WORKFLOW" ]] || {
  echo "missing: $WORKFLOW — complete Lab 028 step 4 first" >&2
  exit 1
}

[[ -s "$WORKFLOW" ]] || {
  echo "empty: $WORKFLOW — file exists but has no content" >&2
  exit 1
}

# 2. File must parse as valid YAML (prefer python3 yaml module; fall back to grep).
if python3 -c "import yaml" 2>/dev/null; then
  python3 -c "import yaml, sys; yaml.safe_load(open('$WORKFLOW'))" 2>/dev/null || {
    echo "invalid YAML: $WORKFLOW — run: python3 -c \"import yaml; yaml.safe_load(open('$WORKFLOW'))\" to see the error" >&2
    exit 1
  }
else
  # Minimal structural check when yaml module is absent.
  grep -q 'on:' "$WORKFLOW" && grep -q 'jobs:' "$WORKFLOW" || {
    echo "invalid YAML structure: $WORKFLOW missing 'on:' or 'jobs:' — check the file content" >&2
    exit 1
  }
fi

# 3. File must reference the claude-code-action.
grep -q 'anthropics/claude-code-action' "$WORKFLOW" || {
  echo "missing action reference: 'anthropics/claude-code-action' not found in $WORKFLOW — add the uses: step" >&2
  exit 1
}

# 4. File must reference the ANTHROPIC_API_KEY secret.
grep -q 'ANTHROPIC_API_KEY' "$WORKFLOW" || {
  echo "missing secret reference: 'ANTHROPIC_API_KEY' not found in $WORKFLOW — pass the secret via anthropic_api_key: \${{ secrets.ANTHROPIC_API_KEY }}" >&2
  exit 1
}

exit 0
