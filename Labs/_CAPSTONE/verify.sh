#!/usr/bin/env bash
set -euo pipefail

# Capstone verify script.
# Run from repo root: ./Labs/_CAPSTONE/verify.sh

fail() {
  echo "FAIL: $1" >&2
  exit 1
}

# evidence/ directory must exist
[[ -d Labs/_CAPSTONE/evidence ]] \
  || fail "Labs/_CAPSTONE/evidence/ directory is missing"

# pr_url.txt must exist, be non-empty, and start with http(s)://
[[ -s Labs/_CAPSTONE/evidence/pr_url.txt ]] \
  || fail "Labs/_CAPSTONE/evidence/pr_url.txt is missing or empty"
head -1 Labs/_CAPSTONE/evidence/pr_url.txt | grep -qE '^https?://' \
  || fail "Labs/_CAPSTONE/evidence/pr_url.txt first line must be a URL starting with http:// or https://"

# reflection.md must exist, be non-empty, and be at least 500 words
[[ -s Labs/_CAPSTONE/evidence/reflection.md ]] \
  || fail "Labs/_CAPSTONE/evidence/reflection.md is missing or empty"
word_count=$(wc -w < Labs/_CAPSTONE/evidence/reflection.md)
[[ "$word_count" -ge 500 ]] \
  || fail "Labs/_CAPSTONE/evidence/reflection.md is $word_count words — must be at least 500"

echo "OK capstone evidence present"
