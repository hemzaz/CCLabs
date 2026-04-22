#!/usr/bin/env bash
# Labs/023-Hooks/verify.sh - lab-specific post-flight, called by scripts/verify.sh.
# Asserts: hook script exists and is executable, settings.json is valid JSON,
#          settings.json references no-rm.sh in a PreToolUse entry,
#          and the hook script exits 2 when given a rm -rf command on stdin.
# Must be idempotent and run in <10s.
set -euo pipefail

# 1. Hook script must exist and be executable.
[[ -f "quips/.claude/hooks/no-rm.sh" ]] || {
  echo "missing: quips/.claude/hooks/no-rm.sh — complete Lab 023 step 4 first" >&2
  exit 1
}

[[ -x "quips/.claude/hooks/no-rm.sh" ]] || {
  echo "not executable: quips/.claude/hooks/no-rm.sh — run: chmod +x quips/.claude/hooks/no-rm.sh" >&2
  exit 1
}

# 2. settings.json must exist and parse as valid JSON.
[[ -f "quips/.claude/settings.json" ]] || {
  echo "missing: quips/.claude/settings.json — complete Lab 023 step 4 first" >&2
  exit 1
}

python3 -c "import json; json.load(open('quips/.claude/settings.json'))" 2>/dev/null || {
  echo "invalid JSON: quips/.claude/settings.json — run: python3 -m json.tool quips/.claude/settings.json" >&2
  exit 1
}

# 3. settings.json must contain a PreToolUse hook entry referencing no-rm.sh.
python3 -c "
import json, sys
s = json.load(open('quips/.claude/settings.json'))
hooks = s.get('hooks', {}).get('PreToolUse', [])
if not any('no-rm' in str(h) for h in hooks):
    sys.exit(1)
" 2>/dev/null || {
  echo "missing PreToolUse hook: settings.json has no entry referencing no-rm.sh — complete Lab 023 step 4" >&2
  exit 1
}

# 4. Running the hook with a rm -rf command must exit with code 2.
actual_exit=0
echo '{"tool_input":{"command":"rm -rf /tmp/test"}}' | quips/.claude/hooks/no-rm.sh >/dev/null 2>&1 || actual_exit=$?

[[ "$actual_exit" -eq 2 ]] || {
  echo "hook did not block: expected exit 2, got $actual_exit — check exit code in no-rm.sh" >&2
  exit 1
}

exit 0
