# Answers — Checkpoint D

1. Red (write a failing test) → Green (write the minimal implementation to pass) → Refactor (clean up under a green suite).
2. Press ESC to interrupt Claude mid-stream, then run `git status` to inspect what changed before deciding how to proceed.
3. To force Claude to argue against its own output — surfacing edge cases, missing error handling, and reviewer-worthy issues it would otherwise skip.
4. Exit 0 when every assertion passes; exit non-zero (typically 1) on the first assertion failure, printing a descriptive FAIL message to stderr.
5. A green baseline proves the existing tests pass before your changes, so any newly broken test is caused by your refactor, not a pre-existing bug.
