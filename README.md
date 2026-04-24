# Spec Development Protocol (SDP)

An AI-agentic framework for spec-driven engineering — structured, traceable, and ready for both greenfield and legacy web projects.

SDP turns GitHub Copilot Agent Mode into a disciplined delivery team: a PRD author, analyst, architect, developer, reviewer, security auditor, and QA validator — all following a 6-gate SDLC process so nothing gets built without being properly specified first.

---

## Quick Install

Run this in the root of your project repository:

```bash
curl -fsSL https://raw.githubusercontent.com/WojcikMM/spec-development-protocol/main/install.sh | bash
```

This copies the `.github/` framework files into your repository **without overwriting** any existing files. Your custom agents, instructions, and scripts stay untouched.

In this template repository, framework sources are stored under `src/`. During install, they are copied into your project's `.github/` folder. A `.github/sdp-version` file is written so you always know which version is installed.

**Options (via environment variables):**

| Variable        | Default           | Description                                                                   |
| --------------- | ----------------- | ----------------------------------------------------------------------------- |
| `SDP_BRANCH`    | `main`            | Install from a specific branch or release tag                                 |
| `SDP_FORCE`     | `false`           | Set to `true` to overwrite existing SDP files during upgrade                  |
| `SDP_TECH_MODE` | `init`            | Control `.github/TECH.md`: `init` (create if missing), `overwrite`, or `skip` |
| `SDP_TARGET`    | current directory | Target repository root                                                        |

```bash
# Install a specific version
SDP_BRANCH=v1.0.0 curl -fsSL https://raw.githubusercontent.com/WojcikMM/spec-development-protocol/main/install.sh | bash

# Upgrade existing installation (overwrite SDP files)
SDP_FORCE=true curl -fsSL https://raw.githubusercontent.com/WojcikMM/spec-development-protocol/main/install.sh | bash

# Upgrade SDP files but keep existing .github/TECH.md
SDP_FORCE=true SDP_TECH_MODE=skip curl -fsSL https://raw.githubusercontent.com/WojcikMM/spec-development-protocol/main/install.sh | bash

# Re-initialize .github/TECH.md from template
SDP_TECH_MODE=overwrite curl -fsSL https://raw.githubusercontent.com/WojcikMM/spec-development-protocol/main/install.sh | bash
```

### Manual Installation

1. Clone or download this repository.
2. Create `.github/` in your project root if missing.
3. Copy the **contents of `src/`** into your project's `.github/` folder.
4. Existing files in your `.github/` folder should not be overwritten unless you explicitly choose to.

---

## Setup

### 1. Fill in `TECH.md`

After installation, open `.github/TECH.md` — this is the single source of truth SDP agents read before doing anything. Fill it in with your project's:

- Frontend and backend stack
- CI/CD system and deployment environment
- Coding standards and conventions
- Security and identity baseline

> **Working on an existing project?** Use `discover-tech` to trigger the `sdp.discover` agent, which reads your codebase and drafts `TECH.md` for review.

### 2. Enable Agent Mode in VS Code

SDP agents run in **GitHub Copilot Agent Mode**. Make sure you have the [GitHub Copilot](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot) extension installed and agent mode enabled in your editor settings.

---

## Quick Start: End-to-End Example

> New to SDP? Here is the full flow for adding a feature to a web app, step by step.

**Goal:** Add a "User Registration" feature to an existing web application.

| Step | What you do | Prompt to run | Output |
|---|---|---|---|
| 1 | Describe the feature idea in plain language | `create-prd` | `spec/user-registration/PRD.md` + `spec/ACTIVE.md` |
| 2 | Review and approve `PRD.md`, then break it into stories | `refine-backlog` | `spec/user-registration/BACKLOG.md` + `spec/user-registration/EPIC-1-core-flow.md` |
| 3 | Design the technical solution | `design-system` | `spec/user-registration/DESIGN.md` |
| 4 | Pick story `US-1`, create an implementation plan (no code yet) | `plan-task` with "US-1" | `spec/user-registration/PLAN.md` |
| 5 | Review and approve the plan, then implement | `implement` with "US-1" | Code + tests + `spec/user-registration/HISTORY.md` updated |
| 6a | Review the code | `run-review` | Review findings |
| 6b | Security audit | `audit-security` | Security sign-off |
| 6c | QA validation | `qa-validate` with "US-1" | Pass / Fail verdict |
| 7 | Repeat from step 4 for the next story | `plan-task` with "US-2" | — |

Each story goes through Gates 4–6 independently. You stay in control at every approval checkpoint.

---

## How It Works

SDP enforces a **6-gate SDLC process**. Work progresses gate by gate — no coding until the design is approved, no design without a backlog, no backlog without a PRD.

```
Gate 1: Discovery      → spec/<slug>/PRD.md  +  spec/ACTIVE.md
Gate 2: Refinement     → spec/<slug>/BACKLOG.md + EPIC-*.md
Gate 3: Architecture   → spec/<slug>/DESIGN.md
Gate 4: Planning       → spec/<slug>/PLAN.md (one story at a time)
Gate 5: Implementation → Code + tests  →  spec/<slug>/HISTORY.md updated
Gate 6: Hardening      → Review → Security audit → QA validation
```

**Feedback loops** — when a gate fails, work returns to the appropriate earlier gate, not the beginning:

- Review failure → back to Gate 5 (fix + re-run Gate 6 from the start)
- Security finding (Critical/High) → back to Gate 5
- QA failure → back to Gate 5
- Architecture-level security issue → back to Gate 3

### Starting a New Feature

Use the prompts in `.github/prompts/` to trigger the right agent at each gate:

| Step | Prompt file | What happens |
|---|---|---|
| 1 | `create-prd` | Describe your idea — the PRD agent drafts `PRD.md` |
| 2 | `refine-backlog` | Analyst breaks PRD into epics and user stories |
| 3 | `design-system` | Architect produces a technical design |
| 4 | `plan-task` | Developer plans one story (no code yet) |
| 5 | `implement` | Developer implements the approved plan |
| 6 | `run-review` → `audit-security` → `qa-validate` | Reviewer, Security, and QA validate in sequence |

### Feature Folder Structure

All spec artifacts for a feature live together in `spec/<feature-slug>/` at the project root. You do not need to remember where files go — agents create and update them automatically.

```
spec/
  ACTIVE.md                        ← which feature is currently active
  user-registration/
    PRD.md                         ← Gate 1: product requirements
    BACKLOG.md                     ← Gate 2: epic index
    EPIC-1-core-registration.md    ← Gate 2: stories + acceptance criteria
    DESIGN.md                      ← Gate 3: technical design
    PLAN.md                        ← Gate 4: current implementation plan
    HISTORY.md                     ← Gate 5: running log of completed tasks
  checkout-flow/
    PRD.md
    ...
```

**`spec/ACTIVE.md`** is the key file — it tells all agents which feature is currently in flight:

```
slug: user-registration
title: User Registration
```

When you start a new PRD, the `sdp.prd` agent derives the slug from the feature title, creates the folder, and updates `ACTIVE.md` for you. All subsequent agents read it automatically — you don't need to mention which feature you're working on in every chat.

To switch to a different feature, update `slug` and `title` in `spec/ACTIVE.md`, or run `create-prd` for the new feature.

### Working on a Legacy Project

SDP works equally well on existing codebases:

1. Fill `TECH.md` with your current stack (or generate a draft with the discovery agent).
2. Use `create-prd` to describe a specific change, bug fix, or improvement area.
3. Follow the gate sequence from there — the agents will respect your existing architecture and constraints.

---

## Agents

| Agent           | File                            | Purpose                                             |
| --------------- | ------------------------------- | --------------------------------------------------- |
| `sdp.prd`       | `agents/sdp.prd.agent.md`       | Writes `PRD.md` from business intent                |
| `sdp.discover`  | `agents/sdp.discover.agent.md`  | Discovers legacy stack signals and drafts `TECH.md` |
| `sdp.analyst`   | `agents/sdp.analyst.agent.md`   | Refines PRD into epics, features, and user stories  |
| `sdp.architect` | `agents/sdp.architect.agent.md` | Produces right-sized technical designs              |
| `sdp.developer` | `agents/sdp.developer.agent.md` | Plans and implements one story at a time            |
| `sdp.reviewer`  | `agents/sdp.reviewer.agent.md`  | Code and design review                              |
| `sdp.security`  | `agents/sdp.security.agent.md`  | Security audit (OWASP web baselines)                |
| `sdp.qa`        | `agents/sdp.qa.agent.md`        | Validates acceptance criteria                       |

Agents suggest handoffs to the next step — after review, the reviewer agent offers to trigger the security agent; after security sign-off, the security agent offers to trigger QA. Each handoff requires your confirmation.

---

## Prompts

Prompts are the entry points that activate agents with the correct mode. Each prompt file includes a checklist of prerequisites and describes what will happen before you commit to running it.

| Prompt           | Triggers                         | Gate              |
| ---------------- | -------------------------------- | ----------------- |
| `discover-tech`  | `sdp.discover`                   | Legacy onboarding |
| `create-prd`     | `sdp.prd`                        | Gate 1            |
| `refine-backlog` | `sdp.analyst`                    | Gate 2            |
| `design-system`  | `sdp.architect`                  | Gate 3            |
| `plan-task`      | `sdp.developer` (plan mode)      | Gate 4            |
| `implement`      | `sdp.developer` (implement mode) | Gate 5            |
| `run-review`     | `sdp.reviewer`                   | Gate 6            |
| `audit-security` | `sdp.security`                   | Gate 6            |
| `qa-validate`    | `sdp.qa`                         | Gate 6            |

---

## Skills

Skills are focused, reusable technical guidance files that agents and developers can reference for specific programming tasks. They live in `.github/skills/` and encode the "how to do it right" knowledge for common web development patterns.

| Skill | File | Purpose |
|---|---|---|
| Write Tests | `skills/sdp.skill.write-tests.md` | Unit and integration tests with AAA pattern, TDD guidance |
| Create REST API Endpoint | `skills/sdp.skill.create-api-endpoint.md` | Route design, input validation, auth, error responses, documentation |
| Create UI Component | `skills/sdp.skill.create-ui-component.md` | Component structure, accessibility, state, testing |
| Database Migration | `skills/sdp.skill.database-migration.md` | Safe schema changes, rollback, zero-downtime patterns |
| Error Handling | `skills/sdp.skill.error-handling.md` | Error classification, logging, safe responses, retries |

Skills can be referenced directly in Copilot chat or invoked by agents when a specific technical pattern is needed. To create your own skill, use `.github/templates/template.skill.md` as a starting point.

---

## Customization

SDP is designed to coexist with your own tooling:

- **Custom agents:** add your own `.agent.md` files alongside the SDP ones — they won't be touched by updates.
- **Custom instructions:** extend `.github/copilot-instructions.md` with project-specific rules.
- **Custom prompts:** add prompts to `.github/prompts/` for team-specific workflows.
- **Custom skills:** add your own `.skill.md` files to `.github/skills/` using the template.
- **TECH.md is yours:** it's the one file you're expected to own and keep current.

---

## Templates

After installation, the `.github/templates/` folder in your project contains:

- `TECH.md` — blank TECH.md template to copy when starting a new project.
- `template.agent.md` — starter template for writing your own agents.
- `template.prompt.md` — starter template for writing your own prompts.
- `template.skill.md` — starter template for writing your own skills.

---

## Project Structure

```
Repository source layout:
src/
├── copilot-instructions.md
├── agents/
├── instructions/
├── prompts/
├── skills/
└── templates/

Installed layout in client repository:
.github/
├── TECH.md                          <- Fill this in for your project
├── sdp-version                      <- Installed SDP version marker
├── copilot-instructions.md          <- Global AI coding standards (auto-loaded)
├── agents/
├── instructions/
├── prompts/
├── skills/
└── templates/

Runtime artifacts created by agents in client repository:
.
├── PRD.md
├── BACKLOG.md
├── CHANGELOG.md
└── docs/
	├── backlog/
	├── architecture/
	├── plans/
	├── review/
	├── security/
	└── qa/
```

---

## License

[MIT](LICENSE)
