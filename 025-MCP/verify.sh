#!/usr/bin/env bash
# Labs/025-MCP/verify.sh - lab-specific post-flight, called by scripts/verify.sh.
# Asserts: quips/.claude/settings.json exists, is valid JSON, contains mcpServers.fs-scoped;
#          quips/.claude/mcp-log.md exists, is non-empty, references a file under src/.
# Must be idempotent and run in <10s.
set -euo pipefail

[[ -f "quips/.claude/settings.json" ]] || {
  echo "missing: quips/.claude/settings.json — complete Lab 025 step 4 first" >&2
  exit 1
}

python3 -c "
import json, sys
try:
    s = json.load(open('quips/.claude/settings.json'))
except json.JSONDecodeError as e:
    print(f'quips/.claude/settings.json is not valid JSON: {e}', file=sys.stderr)
    sys.exit(1)
if 'fs-scoped' not in s.get('mcpServers', {}):
    print('quips/.claude/settings.json is missing mcpServers.fs-scoped — complete Lab 025 step 4', file=sys.stderr)
    sys.exit(1)
" || exit 1

[[ -f "quips/.claude/mcp-log.md" ]] || {
  echo "missing: quips/.claude/mcp-log.md — complete Lab 025 step 5 first" >&2
  exit 1
}

[[ -s "quips/.claude/mcp-log.md" ]] || {
  echo "quips/.claude/mcp-log.md is empty — paste Claude's MCP response into it" >&2
  exit 1
}

grep -qi 'src/' quips/.claude/mcp-log.md || {
  echo "quips/.claude/mcp-log.md does not reference a file under src/ — re-run the MCP prompt in step 5" >&2
  exit 1
}

exit 0
