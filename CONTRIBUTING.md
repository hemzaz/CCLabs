# Contributing to ClaudeCodeLabs

Thank you for adding to the curriculum. This file is the **author contract**.
CI enforces it; reviewers check it. See `docs/DESIGN.md` for the full rationale.

---

## Author contract

Every lab PR MUST:

- Conform to `Labs/_TEMPLATE/README.md` exactly (linted)
- Include `doctor.sh` and `verify.sh` inside the lab directory, both executable
- Include exactly 3 "If stuck" entries, each with a source URL
- Add any new term to `glossary.md` before first use in the lab
- Update `sources.yml` with at least one primary Anthropic source for the lab
- Introduce exactly one new concept (split labs rather than cramming)
- Exercise at least one prior-lab concept in the Recall section
- Pass all CI gates: mkdocs build, verify-labs, link-check, lint-prose

## Prose style

- Imperative second person ("Run `claude -p`"), no exclamation marks
- Sentences <= 25 words
- Flesch-Kincaid grade <= 9 (enforced by vale)
- Every verify step is a command; never "you should see X" on its own
- No jargon before its glossary entry
- No "we" when describing Claude's behavior

## PR workflow

1. Branch from `main`: `git checkout -b lab-NNN-title`
2. Run `make lab NNN` to scaffold a template-conformant directory (coming in Week 1)
3. Author the lab; run `./scripts/doctor.sh NNN && ./scripts/verify.sh NNN` locally until both green
4. Open the PR; the PR template auto-loads the review checklist
5. CI must be green before review; reviewers will not start otherwise

## Review checklist (reviewer-facing)

- [ ] Exactly one new concept
- [ ] Every verify step is a command
- [ ] F-K grade <= 9 (vale report attached)
- [ ] Bloom tag on each exercise
- [ ] No prohibited patterns (see `docs/DESIGN.md` §7.3)
- [ ] At least one prior-lab concept exercised in Recall
- [ ] Spacing band <= 3 labs from any new-term re-exposure

## Governance

- RFC required for Part reshuffles, new labs, or `sources.yml` canonical-list expansion
- Maintainers rotate the pinned Claude Code CLI version via an explicit PR with a migration note
- Public changelog at `CHANGELOG.md`
