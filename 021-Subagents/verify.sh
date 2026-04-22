#!/usr/bin/env bash
# Labs/021-Subagents/verify.sh - lab-specific post-flight, called by scripts/verify.sh.
# Asserts: quips/.claude/agents/reviewer.md exists, is non-empty, has valid frontmatter.
# Must be idempotent and run in <10s.
set -euo pipefail

AGENT_FILE="quips/.claude/agents/reviewer.md"

# File must exist and be non-empty.
[[ -f "$AGENT_FILE" ]] || {
  echo "missing: $AGENT_FILE — complete Lab 021 step 4 first" >&2
  exit 1
}

[[ -s "$AGENT_FILE" ]] || {
  echo "empty: $AGENT_FILE — add frontmatter and a system prompt body" >&2
  exit 1
}

# Must contain exactly two ^---$ lines (opening and closing frontmatter delimiters).
delimiter_count=$(grep -c '^---$' "$AGENT_FILE" 2>/dev/null || true)
[[ "$delimiter_count" -eq 2 ]] || {
  echo "frontmatter error: expected 2 '---' delimiter lines, found $delimiter_count in $AGENT_FILE" >&2
  exit 1
}

# Frontmatter must include all four required keys.
key_count=$(grep -E '^(name|description|tools|model):' "$AGENT_FILE" | wc -l | tr -d ' ')
[[ "$key_count" -eq 4 ]] || {
  echo "frontmatter error: expected 4 keys (name, description, tools, model), found $key_count in $AGENT_FILE" >&2
  exit 1
}

# Body after the closing --- must be non-empty (system prompt must exist).
body=$(awk '/^---$/{n++; next} n==2{print}' "$AGENT_FILE")
[[ -n "$(echo "$body" | tr -d '[:space:]')" ]] || {
  echo "missing system prompt body after frontmatter in $AGENT_FILE" >&2
  exit 1
}

exit 0
