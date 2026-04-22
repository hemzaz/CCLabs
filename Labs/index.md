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
- **Part IV — Quality Gates** (016–020): TDD prompts, debugging, code review, security, refactoring
- **Part V — Autonomy & Orchestration** (021–025): subagents, parallel agents, hooks, skills, MCP
- **Part VI — Shipping** (026–030): commits and PRs, headless mode, GitHub Actions, plugins, capstone

## How to start

Open [Lab 001 — Install and Auth](001-InstallAuth/README.md) and follow the steps. Once Claude Code is running, use `./scripts/labs.sh next` to advance through the series.

## Available today

| # | Lab | Artifact |
|---|---|---|
| [001](001-InstallAuth/README.md) | Install and Auth | `claude --version` works |
| [002](002-FirstSession/README.md) | First Session | saved REPL transcript |
| [003](003-SlashCommands/README.md) | Slash Commands | notes on `/help` `/clear` `/memory` |
| [004](004-ReadingCodebase/README.md) | Reading a Codebase | 3-bullet Quips summary |
| [005](005-WritingFirstCode/README.md) | Writing First Code | `GET /random` endpoint added to Quips |

More labs land as each Part is authored. See the [design document](../docs/DESIGN.md) for the full curriculum map.
