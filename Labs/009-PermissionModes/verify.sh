#!/usr/bin/env bash
# Labs/009-PermissionModes/verify.sh - lab-specific post-flight, called by scripts/verify.sh.
# Assert the expected artifact exists / tests pass / endpoint responds as spec'd.
# Must be idempotent and run in <10s.
set -euo pipefail

SETTINGS="quips/.claude/settings.local.json"

[[ -f "$SETTINGS" ]] || { echo "missing artifact: $SETTINGS" >&2; exit 1; }

python3 -c "import json,sys; json.load(open(sys.argv[1]))" "$SETTINGS" \
  || { echo "$SETTINGS is not valid JSON" >&2; exit 1; }

python3 - "$SETTINGS" <<'EOF'
import json, sys
data = json.load(open(sys.argv[1]))
has_permissions = (
    "permissions" in data
    and isinstance(data["permissions"], dict)
    and (
        "allow" in data["permissions"]
        or "deny" in data["permissions"]
    )
)
has_mode = "permissionMode" in data and isinstance(data["permissionMode"], str)
if not has_permissions and not has_mode:
    print("settings.local.json must contain either a 'permissions' object with 'allow' or 'deny', or a 'permissionMode' string", file=sys.stderr)
    sys.exit(1)
EOF

exit 0
