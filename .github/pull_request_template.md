<!--
  Loaded automatically on every PR. See CONTRIBUTING.md for the full author contract.
-->

## Summary
<!-- 1-3 lines: what lab/area this PR changes, and why. -->

## Lab PR? Complete the checklist below

Skip this block for infra/docs-only PRs; otherwise every box is required before review.

- [ ] Exactly one new concept (Bloom-tagged)
- [ ] Every verify step is a command (no "you should see X" alone)
- [ ] Flesch-Kincaid grade <= 9 (vale report attached)
- [ ] No prohibited patterns (docs/DESIGN.md §7.3)
- [ ] >= 1 prior-lab concept exercised in the Recall section
- [ ] Spacing band <= 3 from any new-term re-exposure
- [ ] `glossary.md` updated for any new term
- [ ] `sources.yml` updated with >= 1 primary Anthropic source
- [ ] `./scripts/doctor.sh NNN` and `./scripts/verify.sh NNN` green locally

## CI gates (auto)
- [ ] MkDocs build
- [ ] verify-labs matrix
- [ ] link-check (lychee)
- [ ] lint-prose (vale)

## Screenshots / session transcripts
<!-- Optional. If a lab step produces a visible artifact worth showing, paste terminal output here. -->
