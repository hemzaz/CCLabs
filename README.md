# ClaudeCodeLabs

30 hands-on labs taking a fresher from zero to shipping with Claude Code.

## Why Claude Code

Claude Code is an agentic CLI that runs directly in your terminal and executes multi-step
tasks autonomously. It is codebase-aware by default, reading your files, git history, and
project structure before acting. It is built and documented by Anthropic, so every lab in
this series tracks the authoritative source.

## Prerequisites

- Node 20+
- Git
- GitHub account
- Claude Code CLI: `npm i -g @anthropic-ai/claude-code`
- Claude Pro/Max plan OR `ANTHROPIC_API_KEY`
- macOS, Linux, or WSL2

## The Curriculum

The series is organized into six parts:

- **Part I — Orientation**: install, authenticate, and get your bearings
- **Part II — Working Loop**: edit, run, commit with Claude in the loop
- **Part III — Context & Memory**: CLAUDE.md, memory files, project knowledge
- **Part IV — Quality Gates**: tests, linting, CI triggered from the CLI
- **Part V — Autonomy & Orchestration**: agents, sub-agents, parallel tasks
- **Part VI — Shipping**: pull requests, releases, deployment pipelines

Five labs are available today:

| # | Lab | Artifact |
|---|-----|----------|
| 001 | Install & Auth | `claude --version` works |
| 002 | First Session | saved REPL transcript |
| 003 | Slash Commands | notes on `/help` `/clear` `/memory` |
| 004 | Reading a Codebase | 3-bullet Quips summary |
| 005 | Writing First Code | `GET /random` endpoint added to Quips |

## Quips — the Spine Project

Quips is a small Express API that lives in `quips/` and grows with you across every lab.
Each lab adds one capability to Quips so you always have a real artifact to show for your work.

## Run Locally

```bash
git clone https://github.com/claudecodelabs/claudecodelabs.git
cd quips && npm ci && npm test
./scripts/labs.sh next
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## Forked From

Originally forked from [nirgeier/GithubCopilotLabs](https://github.com/nirgeier/GithubCopilotLabs) (Apache 2.0). See NOTICE for full attributions.

## License

Apache 2.0.
