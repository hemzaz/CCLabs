# ClaudeCodeLabs — Curriculum Design Document

**Version** 0.1 · **Status** approved (Week 0 kickoff) · **Owner** TBD · **Review cadence** bi-weekly during authoring, quarterly post-launch.

---

## 1. Purpose & scope

### 1.1 Purpose
Design a self-paced, instructor-optional, open-source curriculum that takes a fresher from zero AI-tool literacy to shipping a reviewed feature autonomously with Claude Code, in **30 contact hours**.

### 1.2 In scope
Claude Code CLI (pinned stable); `CLAUDE.md`/`AGENTS.md`; subagents; skills; hooks; plugins; MCP; Claude Code in CI (`claude-code-action`, headless mode); IDE integration as an optional chapter.

### 1.3 Out of scope (v1)
Anthropic API, Agent SDK, fine-tuning, evals, multimodal, language deep-dives. API/SDK ships as **Part VII electives**.

### 1.4 Non-goals
Not a certification program. Not a reference manual (Anthropic docs are). Not a Copilot-vs-Claude comparison — we teach Claude, full stop.

---

## 2. Learner profile

### 2.1 Primary persona — "Maya"
CS junior, 2 prior internships, basic CRUD in one language, used Git, never used an AI coding assistant, 5 h/day × 6 days available, English B2+, easily discouraged by silent failures.

### 2.2 Secondary persona — "Dan"
Bootcamp grad, 0 internships, weaker debugging intuition. Requires more "If stuck" coverage and more scaffolding in Parts I–II.

### 2.3 Assumed baseline (enforced by `doctor.sh 000`)
Git; Node ≥ 20 *or* Python ≥ 3.11 *or* Go ≥ 1.22; terminal fluency (`cd`, `ls`, `cat`); GitHub account + SSH key.

### 2.4 Explicit non-assumptions
No prior AI-tool use. No VS Code. No prior MCP / LSP / agent-concept exposure.

---

## 3. Learning outcomes (Bloom-tagged, measurable)

Backwards design (Wiggins & McTighe, 2005): outcomes → assessments → activities.

| # | Outcome | Bloom | Evidence of attainment |
|---|---|---|---|
| O1 | Install, authenticate, and update Claude Code | Remember | `claude --version` + session log |
| O2 | Hold a productive multi-turn session on a real codebase | Apply | transcript with ≥1 accepted edit |
| O3 | Select a permission mode appropriate to a task | Analyze | written rationale + verified behavior |
| O4 | Write a `CLAUDE.md` that reliably steers Claude | Create | rule enforced by a hook + green tests |
| O5 | Author a subagent with correct frontmatter and model routing | Create | `Task` invocation + visible output |
| O6 | Integrate one MCP server and call its tools | Apply | recorded tool use against live data |
| O7 | Write a hook that blocks an unsafe action | Create | PreToolUse hook proven to block |
| O8 | Author a skill and invoke it via slash | Create | `/skill-name` runs end-to-end |
| O9 | Ship a feature via reviewed PR using Claude Code in CI | Create | merged PR with CI-green review |
| O10 | Diagnose a failed Claude run and recover | Evaluate | annotated rescue transcript |

Bloom verbs are load-bearing — they gate assessment design in §9.

---

## 4. Pedagogical foundations

The curriculum composes nine peer-reviewed methods. Each is cited where applied; no method appears without a concrete mechanism elsewhere in this document.

| Method | Source | Concrete application |
|---|---|---|
| Backwards design | Wiggins & McTighe, 2005 | Outcomes → checkpoints → labs (§3, §6) |
| Mastery learning | Bloom, 1968 | `verify.sh` gates each lab — no advancement without green |
| Cognitive Load Theory | Sweller, 1988 | ≤1 new concept / lab; extraneous chrome stripped (§7.3) |
| Worked examples + fading | Sweller & Cooper, 1985; Renkl & Atkinson, 2003 | Fading schedule, §5.4 |
| PRIMM for coding | Sentance et al., 2019 | Every **Do** section: Predict → Run → Investigate → Modify → Make |
| Spaced retrieval | Roediger & Karpicke, 2006; Karpicke & Bauernschmidt, 2011 | Spacing bands, §11.1 |
| Productive failure | Kapur, 2008 | Stretch tasks harder than taught |
| ZPD + scaffolding | Vygotsky, 1978 | Each lab +1 concept; `doctor.sh` pre-flight |
| Constructive alignment | Biggs, 1996 | Outcome × lab matrix, §6 |
| Andragogy | Knowles, 1980 | Single spine project keeps work problem-centered and self-relevant |

---

## 5. Instructional architecture

### 5.1 Macro shape
**6 Parts × 5 labs + 6 Checkpoints + 1 Capstone = 30 labs, 7 assessments, 30 hours.**

### 5.2 Arc
Orientation → Working Loop → Context & Memory → Quality Gates → Autonomy & Orchestration → Shipping. Each Part closes a loop; the next opens by exercising the previous Part's artifact on the spine project.

### 5.3 Cognitive-load budget (enforced)
- **Lab**: ≤1 new concept · ≤30 min · ≤3 new commands · ≤12 new lines of configuration
- **Checkpoint**: 0 new concepts; 100% retrieval practice on the prior 5 labs
- **Capstone**: 0 new concepts; full-arc integration on a performance task

### 5.4 Fading schedule

| Part | Scaffolding | Form |
|---|---|---|
| I Orientation | Maximum | every keystroke shown, outputs shown |
| II Working Loop | High | commands shown, expected outputs shown |
| III Context | Medium-high | commands shown, outputs described |
| IV Quality | Medium | verify described, command inferred |
| V Orchestration | Medium-low | task stated, learner scripts it |
| VI Shipping | Low | capstone-style prompts |

### 5.5 Interleaving (six threads run lengthwise)

| Thread | Appears in |
|---|---|
| Prompting discipline | 006, 011, 016, 021, 024 |
| Permissioning | 009, 013, 023, 028 |
| Verification | 005, 016, 019, 028 |
| Delegation | 021, 022, 025, 030 |
| Context hygiene | 011, 012, 014, 021 |
| Shipping rituals | 005, 026, 027, 028 |

Rationale: interleaving beats blocked practice for transfer (Rohrer & Taylor, 2007).

---

## 6. Curriculum map (outcomes × labs, spaced-retrieval verified)

| Outcome | Introduced | Practiced | Assessed |
|---|---|---|---|
| O1 | 001 | 003, 015 | Checkpoint A |
| O2 | 002 | 004, 005, 006 | Checkpoint A |
| O3 | 009 | 010, 015, 023 | Checkpoint D |
| O4 | 011 | 013, 015, 021 | Checkpoint C |
| O5 | 021 | 022, 023, 024 | Checkpoint E |
| O6 | 025 | 027 | Checkpoint E artifact |
| O7 | 023 | 025 | Checkpoint E |
| O8 | 024 | 026 | Checkpoint E |
| O9 | 028 | 030 | Capstone |
| O10 | 017 | 019, 024 | Checkpoint D + Capstone |

Every outcome: introduced → re-exposed within ≤3 labs → re-tested at a distant checkpoint. Matches Karpicke & Bauernschmidt's (2011) optimal spacing band.

---

## 7. Lab template specification (bit-level)

### 7.1 Header block — fixed order, 1 line each
1. `# Lab NNN — Title`
2. `⏱ NN min` (single integer)
3. `📦 You'll add: <artifact>`
4. `🔗 Builds on: Lab NNN−1`
5. `🎯 Success: <verifiable sentence, ≤15 words>`

### 7.2 Sections — nine, same order, every lab

1. **Why** — 2 sentences, learner-relevant framing (Knowles)
2. **Check** — `./scripts/doctor.sh NNN` output must be green
3. **Do** — PRIMM-ordered numbered steps; each step ends with a verify **command**
4. **Observe** — meta-cognition prompt: what did Claude do, and why?
5. **If stuck** — 3 triples (symptom → cause → fix), each cited
6. **Stretch** — one productive-failure task, 10 min
7. **Recall** — one retrieval-practice question about a distant prior lab
8. **References** — auto-rendered from `sources.yml`
9. **Next** — 1-sentence handoff to Lab N+1

### 7.3 Prohibited patterns (CI-enforced)
- Screenshots as the sole verification artifact
- "You should see X" without an exact expected string
- More than one new concept per lab (split the lab)
- External video links in the primary flow (allowed only in Stretch)
- Tutorial-tone padding ("Great job!"): violates andragogy
- Jargon before its glossary definition

### 7.4 Prose style rules (linted)
- Sentences ≤ 25 words
- Imperative mood for steps; declarative for Observe
- Flesch-Kincaid grade ≤ 9 (enforced via `vale` in CI)
- No unqualified "always"/"never" outside safety rules
- Second person, no exclamation marks, no "we" when describing Claude

---

## 8. Spine project — Quips

### 8.1 Specification
A minimal HTTP API for quotes: `POST /quips`, `GET /quips/:id`, `GET /quips?tag=…`, `DELETE /quips/:id`. SQLite storage. **Polyglot** — identical API across Node, Python, Go reference implementations. Learner picks one at Lab 001.

### 8.2 Why this project
- 1 table × 3 columns — fits in working memory
- Grows monotonically — every lab adds a file, never rewrites old ones
- Every concept is exercisable: routing, tests, DB, Docker, CI, security, refactoring, subagent review
- Shippable — fresher publishes Quips as a portfolio artifact

### 8.3 State-machine branches
Quips lives as a sibling repo with tagged branches `lab-NNN-start` / `lab-NNN-end`.
- Fresher starts Lab N on `lab-N-start`
- Completes lab; diff matches `lab-N-end` within acceptance criteria
- Falls behind → `git checkout lab-N+1-start` rejoins the cohort
  Rationale: Carroll (1963) — learning is a function of *time × opportunity*, not aptitude. Re-entry points preserve opportunity.

### 8.4 Acceptance
Authoritative `main` branch maintained by authors. `verify.sh NNN` diffs against **file existence, test count, endpoint behavior** — never prose match.

---

## 9. Assessment & verification strategy

### 9.1 Four layers

| Layer | Scope | Tool | Gating |
|---|---|---|---|
| Step | Within a lab | inline command output | informational |
| Lab | End of lab | `verify.sh NNN` | **mastery gate** — must pass |
| Checkpoint | End of Part | `checkpoint.sh N` | **retrieval practice** — integrates Part's 5 labs |
| Capstone | End of bootcamp | rubric-scored performance task | **summative** |

### 9.2 `verify.sh` design contract
- Idempotent
- Exits non-zero with a **one-line diagnosis**
- Runs offline by default (MCP/GitHub labs excepted)
- <10 s per lab
- No flaky assertions — retries not allowed

### 9.3 Checkpoint structure (30 min)
- 5 min — recall quiz: 5 items, ≥1 per lab in the Part (Karpicke, 2012)
- 20 min — integration task touching ≥3 concepts from the Part
- 5 min — self-debrief prompt (Zimmerman, 2002 — self-regulated learning)

### 9.4 Capstone rubric (4 dimensions × 4 levels)

| Dimension | 1 Novice | 2 Developing | 3 Proficient | 4 Expert |
|---|---|---|---|---|
| Plan quality | None | Informal | Plan mode used | Iteratively revised with evidence |
| Safety | `bypass` | default | `acceptEdits` + deny rules | Plan + hooks + permission layering |
| Verification | No tests | Tests | Tests + review subagent | Tests + review + security + CI |
| Communication | No PR body | Basic body | Conventional + `claude -p` body | Body + iterated review reply loop |

Pass bar: **≥3 across all four dimensions.**

---

## 10. Cognitive load management

### 10.1 Working-memory budget
Claude Code surfaces ~12 net-new terms. Miller (1956) 7±2 forces chunking into **6 Parts of ≤ 5 labs**.

### 10.2 Chunking
Each Part = one chunk schema in long-term memory. Checkpoints consolidate the chunk before the next opens (van Merriënboer & Sweller, 2005).

### 10.3 Extraneous load removed
No decorative callouts. No memes. No "pro tip" boxes (promoted to Stretch or cut). No multiple-alternative paths in the happy flow. No cross-ecosystem (VS Code vs Cursor vs …) toggles.

### 10.4 Germane load added
Every **Recall** section = retrieval from a distant prior lab. Every **Checkpoint** forces elaboration ("why this permission mode?"). Capstone forces transfer to an unseen task.

---

## 11. Spaced repetition & interleaving (detail)

### 11.1 Spacing bands (labs between exposures)
- 1st → 2nd: ≤ 3 labs (encoding)
- 2nd → 3rd: 5–8 labs (consolidation)
- 3rd → 4th: 10–15 labs (transfer)

Enforced by the curriculum map (§6).

### 11.2 Interleaving enforced
Prompting is **not** taught in one lab. It appears in 006 (clarity/context), 011 (CLAUDE.md constraints), 016 (TDD constraints), 021 (role via subagents), 024 (reusable via skills). Each exposure recontextualizes the last.

---

## 12. Accessibility & inclusion

- WCAG 2.2 AA: alt text on all imagery; no color-only signaling (pair ✓/✗ with red/green)
- Keyboard-only path for every exercise
- Shell examples: bash + zsh; Windows via WSL2 with a single "Windows note" block per lab (max)
- Plain-English: F-K grade ≤ 9
- Dyslexia-friendly default font (Mulish, retained)
- Time-boxed labs friendly to ADHD / neurodivergent learners
- Screen-reader-tested navigation before launch

---

## 13. Tooling & infrastructure

### 13.1 Repository layout
```
/
├── Labs/NNN-title/README.md      # one per lab, template-conformant
├── quips/                        # spine project (submodule or subdir)
├── scripts/
│   ├── doctor.sh                 # pre-flight per lab
│   ├── verify.sh                 # post-flight per lab
│   ├── checkpoint.sh             # assessment per Part
│   └── labs.sh                   # "what do I do next?" helper
├── sources.yml                   # citation manifest
├── glossary.md                   # term index, linked from labs
├── docs/DESIGN.md                # this document
├── mkdocs.yml (+ split files)    # site configuration
└── .github/workflows/
    ├── deploy-ghpages.yml
    ├── deploy-vercel.yml
    ├── test-mkdocs.yml
    ├── verify-labs.yml           # matrix: every lab on a fresh VM
    ├── link-check.yml            # lychee, weekly + every PR
    └── lint-prose.yml            # vale, every PR
```

### 13.2 CI guarantees — merge-blocking
MkDocs build green; `verify-labs.yml` matrix green; `vale` prose lint green; `lychee` link check green (0 broken links to `docs.claude.com`, `github.com/anthropics/*`); `sources.yml` schema valid; no lab missing a `doctor.sh` / `verify.sh`.

### 13.3 Pinned versions
Claude Code CLI pinned to `X.Y.Z`; bumped explicitly via PR with a migration note. Node/Python/Go minor versions pinned. MkDocs + plugins pinned via `requirements.txt`.

### 13.4 Local dev ergonomics
- `make serve` — MkDocs live reload
- `make verify` — full `verify.sh` sweep
- `make lab NNN` — scaffolds a template-conformant new lab

---

## 14. Content sources & citation policy

- Canonical list fixed in `sources.yml`
- Every lab auto-renders its References block from `sources.yml`
- **No non-Anthropic primary sources.** Third-party permitted only in Stretch, labeled "supplementary"
- Ports from `anthropics/courses` and `anthropic-cookbook` (MIT) attributed in `NOTICE`
- **Dead-link SLA**: CI fails → author patches in ≤48 h or lab is removed from nav

---

## 15. Authoring standards & QA

### 15.1 Author contract
Every lab PR must: conform to template (linted); include `doctor.sh` + `verify.sh`; include 3 cited "If stuck" entries; add new terms to `glossary.md`; update `sources.yml`; pass all CI gates.

### 15.2 PR review checklist
- [ ] Exactly one new concept
- [ ] Every verify step is a command
- [ ] F-K grade ≤ 9 (vale report attached)
- [ ] Bloom tag on each exercise
- [ ] No prohibited patterns (§7.3)
- [ ] ≥1 prior-lab concept exercised in Recall
- [ ] Spacing band ≤ 3 from last mention of any new term introduced here

### 15.3 Editorial tone
Imperative second person. No exclamation marks. No "we" when describing Claude's behavior. No unqualified absolutes outside safety rules. No futurism.

---

## 16. Deployment & operations

- GH Pages + Vercel (both serve `mkdocs-site/`)
- Final repo: `<org>/claudecodelabs`
- Quips: lives at `/quips/` subdir in v0; promoted to sibling repo `<org>/quips` in Week 4
- Shared MkDocs theme submodule: decision pending (keep `nirgeier/mkdocs` with credit, or fork)
- Domain cutover on rename: redirect page at old GH Pages URL for 6 months
- License: Apache 2.0 (inherited). `NOTICE` credits Nir Geier and Anthropic (MIT ports)

---

## 17. Roadmap & execution plan

| Week | Deliverable | Exit criterion |
|---|---|---|
| 0 | Design doc approved; Quips v0; template lint; CI skeleton | this doc sign-off |
| 1 | Scaffold rebrand + Parts I–II (labs 001–010) + Checkpoints A–B | 10 labs live, verify-matrix green |
| 2 | Parts III–IV (011–020) + Checkpoints C–D | 20 labs live, 4 checkpoints live |
| 3 | Parts V–VI (021–030) + Checkpoints E–F + Capstone | 30 labs live, all assessments live |
| 4 | Pilot cohort (≤ 5 freshers) + telemetry + revisions | pilot findings applied; v1 cut |
| 5+ | Part VII electives (API/SDK) | published separately |

---

## 18. Risks & mitigations

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| Claude Code CLI breaks labs on update | Med | High | Pin version; weekly CI against `latest`; migration PR required |
| Docs URL churn (Anthropic reorg) | Med | Med | `sources.yml` + `lychee` catches; 48 h patch SLA |
| MCP ecosystem drift | Med | Med | Reference servers only |
| Fresher stalls on env setup | High | High | `doctor.sh 000` extensive; Codespaces fallback image |
| Drift between Quips impls | Med | Med | Shared test suite runs against each in CI |
| Scope creep (API/SDK into bootcamp) | Med | High | Part VII elective; non-goals hard-gated in RFCs |
| Over-reliance on instructor | Low | Med | Self-paced by design |
| Rubric subjectivity at Capstone | Med | Low | 4×4 rubric + calibration session |

---

## 19. Success metrics

| Metric | Target | How measured |
|---|---|---|
| Bootcamp completion rate | ≥ 60% | Opt-in telemetry in `labs.sh` |
| Median lab completion time | within ±25% of budget | Same |
| Capstone pass rate (rubric ≥ 3) | ≥ 70% of completers | Rubric sheet |
| Post-cohort self-efficacy (1–5) | ≥ 4.0 | Post-survey |
| Link-check green rate over 30 days | ≥ 98% | CI history |
| Median lab-bug close time | ≤ 7 days | GitHub analytics |

**Abort condition**: if completion < 40% over two cohorts, reopen design doc.

---

## 20. Governance & maintenance

- Owner TBD; 2–3 maintainers rotating the CLI-pin duty
- RFC process for Part reshuffles, new labs, source-list expansion
- Quarterly review — metrics, CLI bump, pilot re-run
- Public changelog; every Part revision tagged `v1.X`
- Contribution guide in `CONTRIBUTING.md`

---

## Appendices (to be authored before Week 1)

- **A. Glossary** — `glossary.md`, CI-linted for term-on-first-use
- **B. Lab template** — `Labs/_TEMPLATE/README.md` + worked example
- **C. Quips** — schema + OpenAPI contract + polyglot test suite
- **D. `sources.yml`** — schema + populated v0
- **E. Rubric sheets** — checkpoints A–F + Capstone
- **F. Script specs** — `doctor.sh` / `verify.sh` / `checkpoint.sh`
- **G. Contribution guide** — PR template + author contract
- **H. References** — full citations with DOIs for §4 methods
