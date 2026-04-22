---
hide:
  - toc
---

# ClaudeCodeLabs

ClaudeCodeLabs is a series of 30 hands-on labs that teach Claude Code from first install to shipping real features — every lab produces a concrete artifact you can point to. The labs are built around **Quips**, a small Fastify API that grows with you across the curriculum.

This site is for anyone new to Claude Code who wants a structured, practical path. No prior AI tooling experience is required — just Node 20, Git, and a GitHub account.

## The curriculum

- **Part I — Orientation** (Labs 001–005): install, first session, slash commands, reading a codebase, writing first code
- **Part II — Working Loop** (006–010): prompting, tool use, plan mode, permission modes, multi-file edits
- **Part III — Context & Memory** (011–015): CLAUDE.md, @ mentions, settings layering, compaction, custom instructions
- **Part IV — Quality Gates** (016–020): TDD, rescue and recover, code review, verify scripts, refactor safely
- **Part V — Autonomy & Orchestration** (021–025): subagents, subagent delegation, hooks, skills, MCP
- **Part VI — Shipping** (026–030): skills practice, MCP practice, Claude in CI, PR review loop, ship feature PR
- **Capstone**: summative reviewed-PR delivery scored against the 4×4 rubric

## How to start

Open [Lab 001 — Install and Auth](001-InstallAuth/README.md) and follow the steps. Once Claude Code is running, use `./scripts/labs.sh next` to advance through the series.

## Labs

| # | Lab | Artifact |
|---|---|---|
| [001](001-InstallAuth/README.md) | Install and Auth | `claude --version` works |
| [002](002-FirstSession/README.md) | First Session | saved REPL transcript |
| [003](003-SlashCommands/README.md) | Slash Commands | notes on `/help` `/clear` `/memory` |
| [004](004-ReadingCodebase/README.md) | Reading a Codebase | 3-bullet Quips summary |
| [005](005-WritingFirstCode/README.md) | Writing First Code | `GET /random` endpoint added to Quips |
| [006](006-Prompting/README.md) | Prompting | prompts journal |
| [007](007-ToolUse/README.md) | Tool Use | tool-call trace |
| [008](008-PlanMode/README.md) | Plan Mode | saved plan + executed diff |
| [009](009-PermissionModes/README.md) | Permission Modes | `quips/.claude/settings.local.json` |
| [010](010-MultiFileEdits/README.md) | Multi-File Edits | `author` field end-to-end |
| [011](011-ClaudeMd/README.md) | CLAUDE.md | `quips/CLAUDE.md` steers Claude |
| [012](012-AtMentions/README.md) | At Mentions | file-targeted prompt log |
| [013](013-SettingsLayering/README.md) | Settings Layering | layered settings trace |
| [014](014-Compaction/README.md) | Compaction | compacted-session evidence |
| [015](015-CustomInstructions/README.md) | Custom Instructions | nested `quips/src/CLAUDE.md` |
| [016](016-TDD/README.md) | TDD | failing-then-green test |
| [017](017-RescueRecover/README.md) | Rescue and Recover | `quips/.claude/rescue-log.md` |
| [018](018-CodeReview/README.md) | Code Review | `quips/REVIEW-NOTES.md` |
| [019](019-VerifyScripts/README.md) | Verify Scripts | `quips/verify-feature.sh` |
| [020](020-RefactorSafely/README.md) | Refactor Safely | split `db.js` under green tests |
| [021](021-Subagents/README.md) | Subagents | `quips/.claude/agents/reviewer.md` |
| [022](022-SubagentDelegation/README.md) | Subagent Delegation | second subagent + delegation log |
| [023](023-Hooks/README.md) | Hooks | PreToolUse hook blocks `rm -rf` |
| [024](024-Skills/README.md) | Skills | `seed-db` skill |
| [025](025-MCP/README.md) | MCP | filesystem MCP server scoped to `src/` |
| [026](026-SkillsPractice/README.md) | Skills Practice | `dump-db` skill that composes with seed |
| [027](027-McpPractice/README.md) | MCP Practice | second (git) MCP server |
| [028](028-ClaudeInCi/README.md) | Claude in CI | `.github/workflows/claude-review.yml` |
| [029](029-PrReviewLoop/README.md) | PR Review Loop | headless review-revise loop evidence |
| [030](030-ShipFeaturePr/README.md) | Ship Feature PR | shipped PR URL in `quips/SHIPPED.md` |

Six checkpoints close each Part (A after 005, B after 010, C after 015, D after 020, E after 025, F after 030). The [Capstone](_CAPSTONE/README.md) closes the curriculum. See the [design document](../docs/DESIGN.md) for the full curriculum map and outcome coverage.
