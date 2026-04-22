#!/usr/bin/env bash
# Labs/022-SubagentDelegation/verify.sh - lab-specific post-flight, called by scripts/verify.sh.
# Asserts: test-writer.md exists with valid frontmatter (4 keys), delegation-log.md exists and
# references at least one subagent.
# Must be idempotent and run in <10s.
set -euo pipefail

# --- test-writer.md checks ---

[[ -f "quips/.claude/agents/test-writer.md" ]] || {
  echo "missing: quips/.claude/agents/test-writer.md — complete Lab 022 step 4 first" >&2
  exit 1
}

[[ -s "quips/.claude/agents/test-writer.md" ]] || {
  echo "empty: quips/.claude/agents/test-writer.md has no content" >&2
  exit 1
}

# Valid frontmatter requires exactly two lines that are bare '---'.
delimiter_count=$(grep -c '^---$' "quips/.claude/agents/test-writer.md")
[[ "$delimiter_count" -eq 2 ]] || {
  echo "invalid frontmatter: quips/.claude/agents/test-writer.md — expected 2 '---' lines, found ${delimiter_count}" >&2
  exit 1
}

# All four required keys must appear inside the frontmatter block.
for key in name description tools model; do
  grep -q "^${key}:" "quips/.claude/agents/test-writer.md" || {
    echo "missing frontmatter key '${key}' in quips/.claude/agents/test-writer.md" >&2
    exit 1
  }
done

# --- delegation-log.md checks ---

[[ -f "quips/.claude/delegation-log.md" ]] || {
  echo "missing: quips/.claude/delegation-log.md — complete Lab 022 step 5 first" >&2
  exit 1
}

[[ -s "quips/.claude/delegation-log.md" ]] || {
  echo "empty: quips/.claude/delegation-log.md has no content — paste both subagent outputs" >&2
  exit 1
}

grep -qi 'test-writer\|reviewer' "quips/.claude/delegation-log.md" || {
  echo "quips/.claude/delegation-log.md does not mention test-writer or reviewer — add subagent outputs" >&2
  exit 1
}

exit 0
