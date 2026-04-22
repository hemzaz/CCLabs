#!/usr/bin/env bash
# Labs/007-ToolUse/verify.sh - lab-specific post-flight, called by scripts/verify.sh.
# Asserts: Labs/007-ToolUse/observations.md exists, is non-empty, and mentions
# at least 3 of the canonical tool names: Read, Edit, Write, Bash, Grep, Glob, Task.
# Must be idempotent and run in <10s.
set -euo pipefail

OBS="Labs/007-ToolUse/observations.md"

[[ -f "$OBS" ]] || {
  echo "missing artifact: $OBS — complete Lab 007 step 5 first" >&2
  exit 1
}

[[ -s "$OBS" ]] || {
  echo "$OBS is empty — add your tool observations first" >&2
  exit 1
}

# Count how many distinct tool names appear (case-sensitive per spec).
tools=(Read Edit Write Bash Grep Glob Task)
found=0
for tool in "${tools[@]}"; do
  grep -q "$tool" "$OBS" && (( found++ )) || true
done

if (( found < 3 )); then
  echo "$OBS mentions $found tool(s); need at least 3 of: Read, Edit, Write, Bash, Grep, Glob, Task" >&2
  exit 1
fi

exit 0
