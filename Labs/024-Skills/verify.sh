#!/usr/bin/env bash
# Labs/024-Skills/verify.sh - lab-specific post-flight, called by scripts/verify.sh.
# Asserts: SKILL.md exists with valid frontmatter, seed.sql exists with >=10 INSERT statements.
# Must be idempotent and run in <10s.
set -euo pipefail

# --- SKILL.md checks ---

[[ -f "quips/.claude/skills/seed-db/SKILL.md" ]] || {
  echo "missing: quips/.claude/skills/seed-db/SKILL.md — complete Lab 024 step 4 first" >&2
  exit 1
}

[[ -s "quips/.claude/skills/seed-db/SKILL.md" ]] || {
  echo "empty: quips/.claude/skills/seed-db/SKILL.md has no content" >&2
  exit 1
}

# Valid frontmatter requires exactly two lines that are bare '---'.
delimiter_count=$(grep -c '^---$' "quips/.claude/skills/seed-db/SKILL.md")
[[ "$delimiter_count" -eq 2 ]] || {
  echo "invalid frontmatter: quips/.claude/skills/seed-db/SKILL.md — expected 2 '---' lines, found ${delimiter_count}" >&2
  exit 1
}

# Both required frontmatter keys must appear.
for key in name description; do
  grep -q "^${key}:" "quips/.claude/skills/seed-db/SKILL.md" || {
    echo "missing frontmatter key '${key}' in quips/.claude/skills/seed-db/SKILL.md" >&2
    exit 1
  }
done

# --- seed.sql checks ---

[[ -f "quips/.claude/skills/seed-db/seed.sql" ]] || {
  echo "missing: quips/.claude/skills/seed-db/seed.sql — complete Lab 024 step 4 first" >&2
  exit 1
}

[[ -s "quips/.claude/skills/seed-db/seed.sql" ]] || {
  echo "empty: quips/.claude/skills/seed-db/seed.sql has no content" >&2
  exit 1
}

insert_count=$(grep -c -i 'insert' "quips/.claude/skills/seed-db/seed.sql")
[[ "$insert_count" -ge 10 ]] || {
  echo "seed.sql has only ${insert_count} INSERT statement(s) — need at least 10" >&2
  exit 1
}

exit 0
