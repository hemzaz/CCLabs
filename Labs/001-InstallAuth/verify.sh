#!/usr/bin/env bash
# Labs/001-InstallAuth/verify.sh - lab-specific post-flight, called by scripts/verify.sh.
# Asserts: claude is on PATH AND claude --version exits 0.
# Must be idempotent and run in <10s.
set -euo pipefail

if ! claude_path="$(command -v claude 2>/dev/null)" || [[ -z "$claude_path" ]]; then
  echo "claude not found on PATH — run: npm i -g @anthropic-ai/claude-code" >&2
  exit 1
fi

if ! claude --version >/dev/null 2>&1; then
  echo "claude --version failed — installation may be corrupt; try: npm i -g @anthropic-ai/claude-code" >&2
  exit 1
fi

exit 0
