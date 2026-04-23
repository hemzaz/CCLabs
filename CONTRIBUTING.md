# Contributing to ClaudeCodeLabs

Thank you for adding to the curriculum. This file is the **author contract**.
CI enforces it; reviewers check it. See `docs/DESIGN.md` for the full rationale.

---

## Author contract

Every lab PR MUST:

- Conform to `Labs/_TEMPLATE/README.md` exactly (enforced by `./scripts/lint-labs.sh`)
- Include `doctor.sh` and `verify.sh` inside the lab directory, both executable
- Include `>=3` "If stuck" entries, each with a source URL
- Add any new term to `glossary.md` before first use in the lab
- Update `sources.yml` with at least one primary Anthropic source for the lab
- Introduce exactly one new concept (split labs rather than cramming)
- Exercise at least one prior-lab concept in the Recall section
- Pass all CI gates: mkdocs build, verify-labs, link-check, lint-prose

### Rich lab shape (14 H2 sections in this exact order)

1. `## Prerequisites`
2. `## What You Will Learn`
3. `## Why`
4. `## Walkthrough` — the teaching section (3-6 paragraphs, plus tables and before/after examples when they help)
5. `## Check` — one `./scripts/doctor.sh NNN` call
6. `## Do` — PRIMM steps (Predict → Run → Investigate → Modify → Make), each ending in a verify command
7. `## Observe` — one-paragraph metacognition prompt, no answer key
8. `## If stuck` — table with `>=3` rows (`Symptom | Cause | Fix | Source`)
9. `## Tasks` — `>=5` scenario drills (see "Tasks & Quiz" below)
10. `## Quiz` — `>=3` MCQ questions inside a `<div class="ccg-quiz" data-lab="NNN">`
11. `## Stretch (optional, ~N min)` — one harder variant beyond the scaffolding
12. `## Recall` — one question about a lab `>=5` back
13. `## References` — auto-rendered from `sources.yml` (do not hand-edit)
14. `## Next` — one-line pointer to the next lab

The file MUST also include:
- An `!!! hint "Overview"` admonition with `>=3` bullets, each on its own line starting with four spaces + `- `
- A `**Concept**: \`<one noun>\` (Bloom: Remember|Understand|Apply|Analyze|Evaluate|Create)` line in the first 40 lines

### Tasks & Quiz (the gamification contract)

The `## Tasks` section holds `>=5` scenario-driven drills. Each task follows this shape:

```markdown
### Task N — <short scenario name>

**Scenario:** <1-2 sentence realistic setup, usually inside the `quips/` project>

**Hint:** <one-line nudge that is not the answer>

??? success "Solution"

    ```bash
    <worked answer: prompt, shell command, or code diff>
    ```
```

The `??? success "Solution"` block is a collapsible admonition — learners expand it only when stuck.

The `## Quiz` block wraps `>=3` questions in a `<div class="ccg-quiz" data-lab="NNN">`. Each question is a `<div class="ccg-q" data-answer="X">` containing four radio-button labels (A/B/C/D) and a one-sentence `<p class="ccg-explain">` that reveals on Check. The client-side tracker persists answers in localStorage and awards points (+5 attempted, +15 correct, +100 lab complete).

## Prose style

- Imperative second person ("Run `claude -p`"), no exclamation marks
- Sentences <= 25 words
- Flesch-Kincaid grade <= 9 (enforced by vale)
- Every verify step is a command; never "you should see X" on its own
- No jargon before its glossary entry
- No "we" when describing Claude's behavior

## PR workflow

1. Branch from `main`: `git checkout -b lab-NNN-title`
2. Run `make lab NNN=NNN TITLE=MyLabTitle` to scaffold a template-conformant directory
3. Author the lab; run `make lint-labs` then `./scripts/doctor.sh NNN && ./scripts/verify.sh NNN` locally until all green
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
