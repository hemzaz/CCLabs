# Answers — Checkpoint F

1. Together they form a round-trip: seed loads a known state, dump exports current state, diffing both proves changes.
2. Scope args prevent one server from reading outside its intended directory or repo — least privilege.
3. `ANTHROPIC_API_KEY` in the repo's Actions secrets.
4. `-p` (or `--print`) — runs Claude non-interactively and prints the response.
5. `gh pr create` (typically with `--fill` or `--title`/`--body`).
