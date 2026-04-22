#!/usr/bin/env bash
# Labs/027-McpPractice/verify.sh - lab-specific post-flight, called by scripts/verify.sh.
# Asserts: settings.json parses as JSON and has both fs-scoped and git-read;
#          mcp-git-log.md exists, is non-empty, and matches /commit|author/.
# Must be idempotent and run in <10s.
set -euo pipefail

python3 -c "
import json, sys, re

# Check settings.json validity and both keys present.
try:
    s = json.load(open('quips/.claude/settings.json'))
except (FileNotFoundError, json.JSONDecodeError) as e:
    print('quips/.claude/settings.json missing or invalid JSON: ' + str(e), file=sys.stderr)
    sys.exit(1)

servers = s.get('mcpServers', {})
for key in ('fs-scoped', 'git-read'):
    if key not in servers:
        print('missing: mcpServers.' + key + ' not found in quips/.claude/settings.json', file=sys.stderr)
        sys.exit(1)
" || exit 1

[[ -s "quips/.claude/mcp-git-log.md" ]] || {
  echo "missing or empty: quips/.claude/mcp-git-log.md — complete Lab 027 step 5 first" >&2
  exit 1
}

grep -qiE 'commit|author' quips/.claude/mcp-git-log.md || {
  echo "quips/.claude/mcp-git-log.md exists but contains no commit or author reference" >&2
  exit 1
}

exit 0
