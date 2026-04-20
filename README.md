# Spec Development Protocol (SDP)

An AI-agentic framework for spec-driven engineering — structured, traceable, and ready for both greenfield and legacy projects.

SDP turns GitHub Copilot Agent Mode into a disciplined delivery team: a PRD author, analyst, architect, developer, reviewer, security auditor, and QA validator — all following a 6-gate SDLC process so nothing gets built without being properly specified first.

---

## Quick Install

Run this in the root of your project repository:

```bash
curl -fsSL https://raw.githubusercontent.com/WojcikMM/spec-development-protocol/main/install.sh | bash
```

This copies the `.github/` framework files into your repository **without overwriting** any existing files. Your custom agents, instructions, and scripts stay untouched.

**Options (via environment variables):**

| Variable | Default | Description |
|---|---|---|
| `SDP_BRANCH` | `main` | Install from a specific branch or release tag |
| `SDP_FORCE` | `false` | Set to `true` to overwrite existing SDP files during upgrade |
| `SDP_TARGET` | current directory | Target repository root |

```bash
# Install a specific version
SDP_BRANCH=v1.0.0 curl -fsSL https://raw.githubusercontent.com/WojcikMM/spec-development-protocol/main/install.sh | bash

# Upgrade existing installation (overwrite SDP files)
SDP_FORCE=true curl -fsSL https://raw.githubusercontent.com/WojcikMM/spec-development-protocol/main/install.sh | bash
```

### Manual Installation

1. Clone or download this repository.
2. Copy the `.github/` folder into your project root.
3. Existing files in your `.github/` folder will not be overwritten.

---

## Setup

### 1. Fill in `TECH.md`

After installation, open `.github/TECH.md` — this is the single source of truth SDP agents read before doing anything. Fill it in with your project's:

- Frontend and backend stack
- Infrastructure and cloud environment
- Coding standards and conventions
- Security and identity baseline

> **Working on an existing project?** A `sdp.discover` agent (coming soon) can read your codebase and generate a `TECH.md` draft for you to review.

### 2. Enable Agent Mode in VS Code

SDP agents run in **GitHub Copilot Agent Mode**. Make sure you have the [GitHub Copilot](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot) extension installed and agent mode enabled in your editor settings.

---

## How It Works

SDP enforces a **6-gate SDLC process**. Work progresses gate by gate — no coding until the design is approved, no design without a backlog, no backlog without a PRD.

```
Gate 1: Discovery      → PRD.md
Gate 2: Refinement     → BACKLOG.md + EPIC-*.md
Gate 3: Architecture   → Technical design docs
Gate 4: Planning       → Implementation plan (one story at a time)
Gate 5: Implementation → Code + tests
Gate 6: Hardening      → Review + Security audit + QA validation
```

### Starting a New Feature (Greenfield or Greenfield Feature)

Use the prompts in `.github/prompts/` to trigger the right agent at each gate:

| Step | Prompt file | What happens |
|---|---|---|
| 1 | `create-prd` | Describe your idea — the PRD agent drafts `PRD.md` |
| 2 | `refine-backlog` | Analyst breaks PRD into epics and user stories |
| 3 | `design-system` | Architect produces a technical design |
| 4 | `plan-task` | Developer plans one story (no code yet) |
| 5 | `implement` | Developer implements the approved plan |
| 6 | `run-review` + `audit-security` | Reviewer and Security agent validate the changes |

### Working on a Legacy Project

SDP works equally well on existing codebases:

1. Fill `TECH.md` with your current stack (or generate a draft with the discovery agent).
2. Use `create-prd` to describe a specific change, bug fix, or improvement area.
3. Follow the gate sequence from there — the agents will respect your existing architecture and constraints.

---

## Agents

| Agent | File | Purpose |
|---|---|---|
| `sdp.prd` | `agents/sdp.prd.agent.md` | Writes `PRD.md` from business intent |
| `sdp.analyst` | `agents/sdp.analyst.agent.md` | Refines PRD into epics, features, and user stories |
| `sdp.architect` | `agents/sdp.architect.agent.md` | Produces right-sized technical designs |
| `sdp.developer` | `agents/sdp.developer.agent.md` | Plans and implements one story at a time |
| `sdp.reviewer` | `agents/sdp.reviewer.agent.md` | Code and design review |
| `sdp.security` | `agents/sdp.security.agent.md` | Security audit (OWASP + cloud baselines) |
| `sdp.qa` | `agents/sdp.qa.agent.md` | Validates acceptance criteria |

Agents hand off to each other automatically — after implementation the developer agent offers to trigger reviewer, security, and QA in one click.

---

## Prompts

Prompts are the entry points that activate agents with the correct mode:

| Prompt | Triggers | Gate |
|---|---|---|
| `create-prd` | `sdp.prd` | Gate 1 |
| `refine-backlog` | `sdp.analyst` | Gate 2 |
| `design-system` | `sdp.architect` | Gate 3 |
| `plan-task` | `sdp.developer` (plan mode) | Gate 4 |
| `implement` | `sdp.developer` (implement mode) | Gate 5 |
| `run-review` | `sdp.reviewer` | Gate 6 |
| `audit-security` | `sdp.security` | Gate 6 |

---

## Customization

SDP is designed to coexist with your own tooling:

- **Custom agents:** add your own `.agent.md` files alongside the SDP ones — they won't be touched by updates.
- **Custom instructions:** extend `.github/copilot-instructions.md` with project-specific rules.
- **Custom prompts:** add prompts to `.github/prompts/` for team-specific workflows.
- **TECH.md is yours:** it's the one file you're expected to own and keep current.

---

## Templates

The `.github/templates/` folder contains:

- `TECH.md` — blank TECH.md template to copy when starting a new project.
- `template.agent.md` — starter template for writing your own agents.
- `template.prompt.md` — starter template for writing your own prompts.

---

## Project Structure

```
.github/
├── TECH.md                          ← Fill this in for your project
├── copilot-instructions.md          ← Global AI coding standards (auto-loaded)
├── agents/
│   ├── sdp.prd.agent.md
│   ├── sdp.analyst.agent.md
│   ├── sdp.architect.agent.md
│   ├── sdp.developer.agent.md
│   ├── sdp.reviewer.agent.md
│   ├── sdp.security.agent.md
│   └── sdp.qa.agent.md
├── instructions/
│   └── sdlc-process.instructions.md
├── prompts/
│   ├── create-prd.prompt.md
│   ├── refine-backlog.prompt.md
│   ├── design-system.prompt.md
│   ├── plan-task.prompt.md
│   ├── implement.prompt.md
│   ├── run-review.prompt.md
│   └── audit-security.prompt.md
└── templates/
    ├── TECH.md
    ├── template.agent.md
    └── template.prompt.md
```

---

## License

[MIT](LICENSE)
