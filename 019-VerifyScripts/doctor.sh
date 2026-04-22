#!/usr/bin/env bash
# Labs/019-VerifyScripts/doctor.sh - lab-specific pre-flight, called by scripts/doctor.sh.
# Checks: claude on PATH, quips dir exists, quips/src/server.js and quips/package.json exist, curl available.
# Exit non-zero with a one-line diagnosis on stderr if any check fails.
set -euo pipefail

# Lab 019 requires claude to be installed (Lab 001 artifact).
command -v claude >/dev/null 2>&1 || {
  echo "claude not found — complete Lab 001 first (npm install -g @anthropic-ai/claude-code)" >&2
  exit 1
}

# quips project must exist (proves the repo was cloned with its submodule).
[[ -d "quips" ]] || {
  echo "missing: quips/ — run: git submodule update --init quips" >&2
  exit 1
}

# server.js must be present (Lab 005 artifact — the learner will write a verifier for it).
[[ -f "quips/src/server.js" ]] || {
  echo "missing prior artifact: quips/src/server.js — complete Lab 005 first" >&2
  exit 1
}

# package.json must be present so npm start works.
[[ -f "quips/package.json" ]] || {
  echo "missing: quips/package.json — run: git submodule update --init quips" >&2
  exit 1
}

# curl is required to exercise the HTTP endpoints.
command -v curl >/dev/null 2>&1 || {
  echo "curl not found — install curl (e.g. brew install curl)" >&2
  exit 1
}

exit 0
