# Spec Development Protocol (SDP)

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![GitHub release](https://img.shields.io/github/v/release/WojcikMM/spec-development-protocol)](https://github.com/WojcikMM/spec-development-protocol/releases)
[![GitHub stars](https://img.shields.io/github/stars/WojcikMM/spec-development-protocol)](https://github.com/WojcikMM/spec-development-protocol/stargazers)

**SDP** is an open-source, AI-agentic framework that enforces spec-driven software delivery using GitHub Copilot Agent Mode. It structures your development workflow into a repeatable 6-gate SDLC process — from product requirements through hardening — so no code is written without a specification, and no specification is incomplete.

SDP installs into the `.github/` folder of any project repository and works with both greenfield projects and existing codebases.

---

## Table of Contents

- [Why SDP?](#why-sdp)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
  - [Method 1: Direct Installation (Recommended)](#method-1-direct-installation-recommended)
  - [Method 2: APM (Agent Package Manager)](#method-2-apm-agent-package-manager)
  - [Method 3: Manual Installation](#method-3-manual-installation)
  - [Installer Options](#installer-options)
- [Setup](#setup)
- [Quick Start: End-to-End Example](#quick-start-end-to-end-example)
- [How It Works](#how-it-works)
  - [The 6-Gate SDLC Process](#the-6-gate-sdlc-process)
  - [Feature Folder Structure](#feature-folder-structure)
  - [Working on a Legacy Project](#working-on-a-legacy-project)
- [Reference](#reference)
  - [Agents](#agents)
  - [Prompts](#prompts)
  - [Skills](#skills)
  - [Templates](#templates)
- [Customization](#customization)
- [Project Structure](#project-structure)
- [Package Distribution](#package-distribution)
- [Contributing](#contributing)
- [License](#license)

---

## Why SDP?

AI coding assistants are powerful but undisciplined by default — they generate code immediately, skip design, and ignore traceability. SDP solves this by layering a structured delivery protocol on top of GitHub Copilot:

- **Specification before code** — every feature starts with a PRD and is refined into stories before any implementation begins.
- **Traceable decisions** — architecture choices, plans, and history are recorded in versioned Markdown files alongside your code.
- **Role-separated agents** — dedicated agents for product, analysis, architecture, development, review, security, and QA enforce separation of concerns.
- **Human approval at every gate** — agents propose; you approve. No gate advances automatically.
- **Safe for existing codebases** — install into any repository without modifying source files.

---

## Prerequisites

Before installing SDP, ensure the following are in place:

| Requirement | Version | Notes |
|---|---|---|
| [Visual Studio Code](https://code.visualstudio.com/) | Latest | Required to run agents |
| [GitHub Copilot extension](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot) | Latest | Agent Mode must be enabled |
| GitHub Copilot subscription | — | Individual, Team, or Enterprise |
| `bash` or PowerShell | bash 3.2+ / PS 5.1+ | Required for the installer scripts |
| `curl` | Any recent | Required for direct bash installation |

> **Agent Mode** must be enabled in VS Code. Open the Copilot Chat panel and confirm the agent icon is available in the input toolbar.

---

## Installation

### Method 1: Direct Installation (Recommended)

Run the installer from the root directory of the target project repository.

#### macOS / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/WojcikMM/spec-development-protocol/main/install.sh | bash
```

#### Windows (PowerShell 5.1+ or PowerShell 7+)

```powershell
iwr -useb https://raw.githubusercontent.com/WojcikMM/spec-development-protocol/main/install.ps1 | iex
```

> **Execution policy note:** If you encounter a script execution policy error on Windows, run `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` and retry.

Both installers copy the `.github/` framework files into the target repository **without overwriting any existing files**. A `.github/sdp-version` marker file records the installed version.

---

### Method 2: APM (Agent Package Manager)

If your environment supports APM:

```bash
# Install from the GitHub repository
apm install WojcikMM/spec-development-protocol
```

For npm ecosystem compatibility:

```bash
npm install -g @wojcikmm/spec-development-protocol
```

The `apm.yml` manifest defines all agents, skills, prompts, and templates included in SDP.

---

### Method 3: Manual Installation

1. Clone or download this repository.
2. Create `.github/` in the target project root if it does not already exist.
3. Copy the entire contents of `src/` into `.github/`.
4. Do not overwrite existing files in `.github/` unless you intend to upgrade.

---

### Installer Options

The direct installers accept configuration via environment variables:

| Variable        | Default           | Description                                                                    |
| --------------- | ----------------- | ------------------------------------------------------------------------------ |
| `SDP_BRANCH`    | `main`            | Install from a specific branch or release tag                                  |
| `SDP_FORCE`     | `false`           | Set to `true` to overwrite existing SDP files during an upgrade                |
| `SDP_TECH_MODE` | `init`            | Controls `.github/TECH.md`: `init` (create if missing), `overwrite`, or `skip` |
| `SDP_TARGET`    | current directory | Target repository root path                                                    |

**bash examples:**

```bash
# Install a specific release version
SDP_BRANCH=v1.0.0 curl -fsSL https://raw.githubusercontent.com/WojcikMM/spec-development-protocol/main/install.sh | bash

# Upgrade an existing installation (overwrite SDP-managed files)
SDP_FORCE=true curl -fsSL https://raw.githubusercontent.com/WojcikMM/spec-development-protocol/main/install.sh | bash

# Upgrade SDP files but preserve the existing TECH.md
SDP_FORCE=true SDP_TECH_MODE=skip curl -fsSL https://raw.githubusercontent.com/WojcikMM/spec-development-protocol/main/install.sh | bash

# Reset TECH.md from the template (useful when re-initializing a project)
SDP_TECH_MODE=overwrite curl -fsSL https://raw.githubusercontent.com/WojcikMM/spec-development-protocol/main/install.sh | bash
```

**PowerShell examples:**

```powershell
# Install a specific release version
$env:SDP_BRANCH='v1.0.0'; iwr -useb https://raw.githubusercontent.com/WojcikMM/spec-development-protocol/main/install.ps1 | iex

# Upgrade an existing installation (overwrite SDP-managed files)
$env:SDP_FORCE='true'; iwr -useb https://raw.githubusercontent.com/WojcikMM/spec-development-protocol/main/install.ps1 | iex

# Upgrade SDP files but preserve the existing TECH.md
$env:SDP_FORCE='true'; $env:SDP_TECH_MODE='skip'; iwr -useb https://raw.githubusercontent.com/WojcikMM/spec-development-protocol/main/install.ps1 | iex

# Reset TECH.md from the template (useful when re-initializing a project)
$env:SDP_TECH_MODE='overwrite'; iwr -useb https://raw.githubusercontent.com/WojcikMM/spec-development-protocol/main/install.ps1 | iex
```

---

## Setup

### 1. Fill in `TECH.md`

After installation, open `.github/TECH.md`. This file is the single source of truth that all SDP agents read before taking any action. Populate it with your project's:

- Frontend and backend technology stack
- CI/CD pipeline and deployment environment
- Coding standards and conventions
- Security baseline and identity model

`TECH.md` is your file — SDP updates will never overwrite it unless you explicitly set `SDP_TECH_MODE=overwrite`.

> **Existing project?** Run the `discover-tech` prompt to invoke the `sdp.discover` agent, which scans your codebase and generates a draft `TECH.md` for your review.

### 2. Add `AGENTS.md` Context Maps

`AGENTS.md` files scope agent context to relevant portions of the repository, reducing noise and improving response quality. Place them as follows:

- **Repository root** — one global `AGENTS.md` for project-wide rules and boundaries.
- **Backend modules** — one `AGENTS.md` per library or service folder (e.g., next to each `.csproj` file).
- **Frontend packages** — one `AGENTS.md` per app or package root (e.g., `apps/web`, `packages/ui`).

All SDP agents are pre-configured to read the root `AGENTS.md` and the nearest module-level `AGENTS.md` before performing deeper file discovery.

A starter template is available at `.github/templates/AGENTS.md` after installation.

### 3. Enable Agent Mode in VS Code

SDP agents require **GitHub Copilot Agent Mode** in VS Code. Verify that the [GitHub Copilot](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot) extension is installed and that agent mode is available in the Copilot Chat panel.

---

## Quick Start: End-to-End Example

The following example walks through adding a "User Registration" feature to an existing web application using the full SDP gate sequence.

| Step | Action | Prompt | Output |
|---|---|---|---|
| 1 | Describe the feature in plain language | `create-prd` | `spec/user-registration/PRD.md`, `spec/ACTIVE.md` |
| 2 | Review and approve `PRD.md`, then break it into stories | `refine-backlog` | `spec/user-registration/BACKLOG.md`, `EPIC-1-core-flow.md` |
| 3 | Design the technical solution | `design-system` | `spec/user-registration/DESIGN.md` |
| 4 | Select story `US-1` and create an implementation plan (no code yet) | `plan-task` + "US-1" | `spec/user-registration/PLAN.md` |
| 5 | Review and approve the plan, then implement | `implement` + "US-1" | Source code, tests, `HISTORY.md` updated |
| 6a | Review the implementation | `run-review` | Review findings report |
| 6b | Perform a security audit | `audit-security` | Security sign-off or findings |
| 6c | Validate acceptance criteria | `qa-validate` + "US-1" | Pass / Fail verdict |
| 7 | Repeat Steps 4–6 for the next story | `plan-task` + "US-2" | — |

Each user story passes through Gates 4–6 independently. You retain full control at every approval checkpoint — no agent advances the process without your confirmation.

---

## How It Works

### The 6-Gate SDLC Process

SDP enforces a sequential gate model. Work cannot advance to the next gate until the current gate is approved. This prevents scope creep, undocumented decisions, and code written without a specification.

```
Gate 1: Discovery      → spec/<slug>/PRD.md  +  spec/ACTIVE.md
Gate 2: Refinement     → spec/<slug>/BACKLOG.md + EPIC-*.md
Gate 3: Architecture   → spec/<slug>/DESIGN.md
Gate 4: Planning       → spec/<slug>/PLAN.md  (one story at a time)
Gate 5: Implementation → Source code + tests  →  spec/<slug>/HISTORY.md updated
Gate 6: Hardening      → Code review → Security audit → QA validation
```

**Feedback loops** — gate failures route work back to the correct earlier gate, not the beginning:

| Failure | Returns to |
|---|---|
| Code review failure | Gate 5 — fix and re-run Gate 6 from the start |
| Security finding (Critical or High severity) | Gate 5 |
| QA validation failure | Gate 5 |
| Security finding requiring architectural change | Gate 3 |

### Feature Folder Structure

All specification artifacts for a feature are co-located in `spec/<feature-slug>/` at the project root. Agents create and update these files automatically — you do not need to manage file placement manually.

```
spec/
  ACTIVE.md                          <- identifies the currently active feature
  user-registration/
    PRD.md                           <- Gate 1: product requirements document
    BACKLOG.md                       <- Gate 2: epic index
    EPIC-1-core-registration.md      <- Gate 2: stories and acceptance criteria
    DESIGN.md                        <- Gate 3: technical design document
    PLAN.md                          <- Gate 4: current story implementation plan
    HISTORY.md                       <- Gate 5: running log of completed work
  checkout-flow/
    PRD.md
    ...
```

**`spec/ACTIVE.md`** declares which feature is currently in progress:

```yaml
slug: user-registration
title: User Registration
```

When a new PRD is created, `sdp.prd` derives the slug from the feature title, initializes the feature folder, and writes `ACTIVE.md`. All subsequent agents read this file automatically — you do not need to specify the active feature in each chat session.

To switch to a different feature, update `spec/ACTIVE.md` directly, or run `create-prd` for the new feature.

### Working on a Legacy Project

SDP is fully compatible with existing codebases:

1. Populate `TECH.md` with the current stack, or run `discover-tech` to generate a draft automatically.
2. Run `create-prd` to describe the change, bug fix, or improvement area.
3. Follow the gate sequence from there. Agents respect the existing architecture and constraints defined in `TECH.md`.

---

## Reference

### Agents

Each SDP agent has a single, well-defined responsibility. Agents are implemented as `.agent.md` files and invoked via the Copilot Chat panel in Agent Mode.

| Agent | File | Responsibility |
| --------------- | ------------------------------- | --------------------------------------------------- |
| `sdp.prd` | `agents/sdp.prd.agent.md` | Authors `PRD.md` from a business intent description |
| `sdp.discover` | `agents/sdp.discover.agent.md` | Scans an existing codebase and drafts `TECH.md` |
| `sdp.analyst` | `agents/sdp.analyst.agent.md` | Refines a PRD into epics, features, and user stories |
| `sdp.architect` | `agents/sdp.architect.agent.md` | Produces a right-sized technical design document |
| `sdp.developer` | `agents/sdp.developer.agent.md` | Plans and implements one user story at a time |
| `sdp.reviewer` | `agents/sdp.reviewer.agent.md` | Performs code and design review |
| `sdp.security` | `agents/sdp.security.agent.md` | Conducts a security audit against OWASP web baselines |
| `sdp.qa` | `agents/sdp.qa.agent.md` | Validates story acceptance criteria |

Agents propose handoffs to the next role — for example, the reviewer agent offers to invoke the security agent after completing its review. Each handoff requires explicit confirmation before proceeding.

---

### Prompts

Prompts are the entry points that activate agents in the correct mode. Each prompt file documents its prerequisites and describes the expected outcome before the operation begins.

| Prompt | Activates | Gate |
| ---------------- | -------------------------------- | ----------------- |
| `discover-tech` | `sdp.discover` | Legacy onboarding |
| `create-prd` | `sdp.prd` | Gate 1 |
| `refine-backlog` | `sdp.analyst` | Gate 2 |
| `design-system` | `sdp.architect` | Gate 3 |
| `plan-task` | `sdp.developer` (plan mode) | Gate 4 |
| `implement` | `sdp.developer` (implement mode) | Gate 5 |
| `run-review` | `sdp.reviewer` | Gate 6 |
| `audit-security` | `sdp.security` | Gate 6 |
| `qa-validate` | `sdp.qa` | Gate 6 |

Prompts are located in `.github/prompts/` after installation and are accessible from the Copilot Chat prompt picker.

---

### Skills

Skills are focused, reusable technical guidance files that agents reference when performing specific programming tasks. They encode implementation patterns, conventions, and quality criteria for common web development operations.

Skills are located in `.github/skills/` and follow the [Agent Skills open standard](https://agentskills.io) — each skill is a folder containing a `SKILL.md` file with metadata and instructions.

| Skill | Folder | Purpose |
|---|---|---|
| Write Tests | `skills/write-tests/` | Unit and integration tests using the AAA pattern; TDD guidance |
| Create REST API Endpoint | `skills/create-api-endpoint/` | Route design, input validation, authentication, error responses, and documentation |
| Create UI Component | `skills/create-ui-component/` | Component structure, accessibility, state management, and testing |
| Database Migration | `skills/database-migration/` | Safe schema changes, rollback strategies, and zero-downtime patterns |
| Error Handling | `skills/error-handling/` | Error classification, structured logging, safe error responses, and retry logic |

To add a custom skill, create a new folder under `.github/skills/` and add a `SKILL.md` file using `.github/templates/template.skill.md` as the starting point.

---

### Templates

The `.github/templates/` folder contains starter files for extending SDP:

| File | Purpose |
|---|---|
| `TECH.md` | Blank technology context template for new projects |
| `AGENTS.md` | Scoped context-map template for repository root, backend modules, and frontend packages |
| `template.agent.md` | Starter template for authoring a custom agent |
| `template.prompt.md` | Starter template for authoring a custom prompt |
| `template.skill.md` | Starter template for authoring a custom skill |

---

## Customization

SDP is designed to coexist with existing tooling and custom workflows. SDP-managed files are isolated and will not conflict with your own additions.

| What to customize | How |
|---|---|
| Project-specific AI coding standards | Extend `.github/copilot-instructions.md` |
| Custom agents | Add `.agent.md` files to `.github/agents/` — SDP updates will not touch them |
| Custom prompts | Add prompt files to `.github/prompts/` |
| Custom skills | Add `<skill-name>/SKILL.md` folders to `.github/skills/` using the provided template |
| Scoped agent context | Add `AGENTS.md` files at repository root and module boundaries |
| Technology context | Edit `.github/TECH.md` — this file is never overwritten by SDP updates unless explicitly requested |

---

## Project Structure

### Source Layout (this repository)

```
src/
├── copilot-instructions.md          <- Global AI coding standards
├── agents/                          <- Agent definition files
├── instructions/                    <- Shared SDLC process instructions
├── prompts/                         <- Gate trigger prompts
├── skills/
│   ├── create-api-endpoint/
│   │   └── SKILL.md
│   ├── create-ui-component/
│   │   └── SKILL.md
│   ├── database-migration/
│   │   └── SKILL.md
│   ├── error-handling/
│   │   └── SKILL.md
│   └── write-tests/
│       └── SKILL.md
└── templates/
    ├── AGENTS.md
    ├── TECH.md
    ├── template.agent.md
    ├── template.prompt.md
    └── template.skill.md
```

### Installed Layout (client repository)

After running the installer, the following structure is created under `.github/` in the target repository:

```
.github/
├── TECH.md                          <- Project technology context (fill this in)
├── sdp-version                      <- Installed SDP version marker
├── copilot-instructions.md          <- Global AI coding standards (auto-loaded by Copilot)
├── agents/                          <- SDP agent definitions
├── instructions/                    <- SDLC process instructions
├── prompts/                         <- Gate trigger prompts
├── skills/
│   ├── <skill-name>/
│   │   └── SKILL.md
│   └── ...
└── templates/
    ├── AGENTS.md
    ├── TECH.md
    ├── template.agent.md
    ├── template.prompt.md
    └── template.skill.md
```

### Recommended `AGENTS.md` Placement

```
<repository root>/
├── AGENTS.md                        <- Global context boundaries and repository rules
├── src/
│   ├── Billing/
│   │   ├── AGENTS.md                <- Service-local context (e.g., next to .csproj)
│   │   └── Billing.csproj
│   └── Frontend/
│       ├── AGENTS.md                <- App/package-local context
│       └── package.json
```

### Runtime Artifacts (created by agents in the client repository)

```
spec/
├── ACTIVE.md                        <- Currently active feature
└── <feature-slug>/
    ├── PRD.md
    ├── BACKLOG.md
    ├── EPIC-*.md
    ├── DESIGN.md
    ├── PLAN.md
    └── HISTORY.md
```

---

## Package Distribution

SDP is distributed as an [Agent Package Manager (APM)](https://agentpackagemanager.io) compatible package. The `apm.yml` manifest defines all framework components:

- **Package type:** `agent-framework` — a complete SDLC workflow system
- **Components:** 8 agents, 9 prompts, 5 skills, global instructions, and templates
- **Install path:** `.github/` in the target repository
- **Source directory:** `src/` in this repository
- **Installers:** bash (`install.sh`) and PowerShell (`install.ps1`)

A `package.json` is also provided for npm ecosystem compatibility.

---

## Contributing

Contributions are welcome. Please follow these guidelines:

1. **Source changes belong in `src/`** — never edit files under `.github/` as template source. The `.github/` folder in this repository is for maintainer automation only.
2. **Keep templates generic** — all files in `src/` must be reusable across different project types and tech stacks.
3. **Update documentation** — if you change behavior in `install.sh` or `install.ps1`, update the corresponding sections in this `README.md`.
4. **Validate the installer** — run `bash -n install.sh` to check for syntax errors before submitting a pull request.
5. **Preserve gate discipline** — changes to agents or prompts must maintain the 6-gate sequential process and human-approval model.

For significant changes, open an issue first to discuss the proposed direction before submitting a pull request.

---

## License

[MIT](LICENSE)
