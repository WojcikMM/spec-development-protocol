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
  - [Manual vs. Supervised Delivery](#manual-vs-supervised-delivery)
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
- **Human approval of intent and outcome**: approve Gates 1-4, then choose manual hardening or supervised delivery; both end with explicit acceptance.
- **Safe for existing codebases** — install into any repository without modifying source files.

---

## Prerequisites

Before installing SDP, ensure the following are in place:

| Requirement                                                                                    | Version             | Notes                                 |
| ---------------------------------------------------------------------------------------------- | ------------------- | ------------------------------------- |
| [Visual Studio Code](https://code.visualstudio.com/)                                           | Latest              | Required to run agents                |
| [GitHub Copilot extension](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot) | Latest              | Agent Mode must be enabled            |
| GitHub Copilot subscription                                                                    | —                   | Individual, Team, or Enterprise       |
| `bash` or PowerShell                                                                           | bash 3.2+ / PS 5.1+ | Required for the installer scripts    |
| `curl`                                                                                         | Any recent          | Required for direct bash installation |

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

Both installers recursively copy canonical `.apm/` files into the target repository's `.github/` **without overwriting existing framework files** by default. A `.github/sdp-version` marker records the source version, not proof that skipped files were upgraded. Installer output flags mixed-version risk and the Model Policy setup needed for `/deliver`.

---

### Method 2: APM (Agent Package Manager)

If your environment supports APM:

```bash
# Add SDP marketplace (one-time per machine)
apm marketplace add WojcikMM/spec-development-protocol

# Install SDP from that marketplace
apm install spec-development-protocol@spec-development-protocol
```

#### Install from the GitHub repository

apm install WojcikMM/spec-development-protocol

The `apm.yml` manifest defines all agents, skills, prompts, and templates included in SDP.

---

### Method 3: Manual Installation

1. Clone or download this repository.
2. Create `.github/` in the target project root if it does not already exist.
3. Copy the entire contents of `.apm/` into `.github/`.
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
curl -fsSL https://raw.githubusercontent.com/WojcikMM/spec-development-protocol/main/install.sh | SDP_BRANCH=v0.5.1 bash

# Upgrade an existing installation (overwrite SDP-managed files)
curl -fsSL https://raw.githubusercontent.com/WojcikMM/spec-development-protocol/main/install.sh | SDP_FORCE=true bash

# Upgrade SDP files but preserve the existing TECH.md
curl -fsSL https://raw.githubusercontent.com/WojcikMM/spec-development-protocol/main/install.sh | SDP_FORCE=true SDP_TECH_MODE=skip bash

# Reset TECH.md from the template (useful when re-initializing a project)
curl -fsSL https://raw.githubusercontent.com/WojcikMM/spec-development-protocol/main/install.sh | SDP_TECH_MODE=overwrite bash
```

**PowerShell examples:**

```powershell
# Install a specific release version
$env:SDP_BRANCH='v0.5.1'; iwr -useb https://raw.githubusercontent.com/WojcikMM/spec-development-protocol/main/install.ps1 | iex

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
- Model Policy: role profiles, available model mappings, and allowed equivalent fallbacks for supervised delivery

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

| Step | Action                                                                            | Prompt                 | Output                                                     |
| ---- | --------------------------------------------------------------------------------- | ---------------------- | ---------------------------------------------------------- |
| 1    | Describe the feature in plain language                                            | `create-prd`           | `spec/user-registration/PRD.md`, `spec/ACTIVE.md`          |
| 2    | Review and approve `PRD.md` (set `status: approved`), then break it into stories  | `refine-backlog`       | `spec/user-registration/BACKLOG.md`, `EPIC-1-core-flow.md` |
| 3    | Approve backlog/epics with approver and date, then design the solution | `design-system` | `spec/user-registration/DESIGN.md` |
| 4    | Approve DESIGN, then plan one coherent delivery package covering related stories | `plan-task` + "US-1" | `PLAN.md` Decision Brief and Execution Contract |
| 5    | Explicitly approve the exact plan revision and run supervised delivery, or record approval/digest before manual implementation | `/deliver approve-and-run user-registration-DP-1 r1` or `/implement` | Code, tests, run record and history |
| 6a   | Review the implementation                                                         | `run-review`           | Review findings report                                     |
| 6b   | Perform a security audit (unless the epic declares `epic-level`/`waived`)         | `audit-security`       | Security sign-off or findings                              |
| 6c   | Validate all ACs; pass waits for human acceptance | `qa-validate` + "US-1" | `awaiting-acceptance` and evidence brief |
| 7    | Accept the exact verified candidate, or reject/request changes | `/deliver accept user-registration-DP-1 <candidate-id>` | Recorded human decision, no next-package dispatch |
| 8    | Separately select and plan the next delivery package | `/plan-task` | New draft plan |

Steps 6a-6c are manual-mode commands; `/deliver` dispatches those specialists for you after explicit approval, respecting every included epic's audit policy. Gates 4-6 operate on one delivery package, which may contain tightly related stories. Planning never starts execution by itself. Approval requires `status`, `approved_by`, `approved_at`, and a computed plan digest; changing status alone does not populate them.

---

## How It Works

### The 6-Gate SDLC Process

SDP enforces a sequential gate model. Work cannot advance to the next gate until the current gate's artifact has `status: approved`. This prevents scope creep, undocumented decisions, and code written without a specification.

```md
Gate 1: Discovery → spec/<slug>/PRD.md + spec/ACTIVE.md
Gate 2: Refinement → spec/<slug>/BACKLOG.md + EPIC-\*.md (declares security_review policy)
Gate 3: Architecture → spec/<slug>/DESIGN.md (size, risk, uncertainty)
Gate 4: Planning → spec/<slug>/PLAN.md (one capability-sized delivery contract)
Gate 5: Implementation → Source code + tests → spec/<slug>/HISTORY.md updated
Gate 6: Hardening → Review → Required security → QA → Human acceptance
```

Every gate artifact carries `status: draft | approved | rejected`, `approved_by`, and `approved_at`. PLAN also records a SHA-256 `plan_digest` in that header, calculated over its LF-normalized UTF-8 body only. Plan/upstream content changes require reapproval; candidate changes invalidate prior assurance. Missing identity tooling blocks execution instead of using timestamps or word counts as proof.

**Feedback loops** — gate failures route work back to the correct earlier gate, not the beginning:

| Failure                                            | Returns to                                                                                                          |
| -------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| Code review failure (Critical/High)                | Gate 5 — fix and re-run Gate 6 from the start                                                                       |
| Security finding (Critical or High severity)       | Gate 5                                                                                                              |
| QA validation failure                              | Gate 5                                                                                                              |
| Security finding requiring architectural change    | Gate 3                                                                                                              |
| Second rejected candidate for the same package, at any assurance stage | Escalate to the user; one automatic repair is the limit, with full assurance repeated after repair |

All findings across review, security, and QA use one severity scale: **Critical, High, Medium, Low**.

### Controlling Security Audit Scope

Not every story needs its own security audit. Each epic in `BACKLOG.md`/`EPIC-*.md` declares a `security_review` policy:

- **`per-story` (default)** — audited every time, before QA.
- **`epic-level`** — deferred until the whole epic is implemented, then audited once as a batch.
- **`waived`** — explicitly skipped, with a required, documented reason (e.g., internal tooling with no external input or auth changes).

Agents will not complain about a missing security step if the policy is explicitly `epic-level` or `waived` — but they will stop and ask you to set the policy if a story touches auth, secrets, external input, or data boundaries with no policy declared. An `epic-level` deferral records a `pending_audit` obligation in `spec/ACTIVE.md`; the epic cannot reach final acceptance until the aggregate audit runs and that obligation clears.

### Manual vs. Supervised Delivery

Gates 5–6 can run in two modes:

- **Manual mode** — you run `/implement`, `/run-review`, `/audit-security`, and `/qa-validate` one at a time, reviewing each result before continuing. This is the default and the required fallback whenever supervised orchestration or a specific model/tool isn't available.
- **Supervised mode**: `/deliver approve-and-run <id> <revision>` records your explicit approval and dispatches implementation, review, required security, and QA. `/deliver run <id> <revision>` uses existing approval. One automatic repair is permitted, followed by full assurance; the second rejected candidate escalates. The coordinator never writes product code or infers acceptance.

Both modes end the same way: a `sdp.qa` Pass sets `final_status: awaiting-acceptance` and produces an acceptance brief (outcome, AC coverage with evidence, verdicts, deviations, remaining risks). Only your explicit accept / request-changes / reject decision closes the delivery package — no agent infers acceptance from a passing verdict or from silence.

> Supervised mode is a customization-layer workflow that runs inside your active agent session — it does not add a background execution service, a persistent runner, or a tamper-proof audit trail. If a session ends mid-run, `/deliver` can resume the same delivery ID; the orchestrator re-validates the plan and last completed stage rather than assuming prior progress is still valid.

Use `/deliver resume <id>` after interruption; it reconciles baseline, environment, candidate, completed steps and external effects before continuing. `/deliver accept <id> <candidate-id>`, `reject`, and `request-changes` record separate decisions. Acceptance never starts another package, commits, merges, or deploys. Intermediate packages may be accepted with disclosed deferred audits, but final-epic acceptance requires aggregate security plus final QA.

**Sizing:** S is a bounded behavior change, M an end-to-end capability, L a cohesive subsystem with staged checks, and XL must be split. Rate Risk (`Low|Moderate|High`) and Uncertainty (`Resolved|Bounded|Open`) separately; Open blocks planning approval. File/line estimates inform review, not blanket caps. Split by independent acceptance, rollback, ownership, or unverifiable combined scope.

**Models and harness:** configure TECH Model Policy using models actually available in your environment. Profiles do not automatically select models; verify worker configuration, approved equivalent fallbacks and the coordinator's cost-tier eligibility. Missing required tooling/models blocks supervised execution. VS Code Copilot Local is the initial target; no live end-to-end runtime or minimum-version compatibility is proven by this static refactor. Other APM targets remain manual until separately tested. Tool allowlists are not a sandbox, especially for terminal execution.

**Upgrades:** default non-overwriting installs may mix old and new policies. Review/back up customized SDP files, deliberately refresh managed files with `SDP_FORCE=true`, preserve project TECH with `SDP_TECH_MODE=skip`, then add its Model Policy manually. Compare agents, prompts, instructions and templates as a set; preflight blocks inconsistent installations. Legacy PLANs need regeneration/reapproval; existing ACTIVE files gain `final_status` and a `pending_audit` list without losing prior obligations/history.

**Evidence:** both modes use one `deliveries/<delivery-id>.json` initialized from `DELIVERY-RUN.json`, plus append-only HISTORY and immutable approved plans under `plans/`. Workers return structured candidate-bound results; the coordinator owns state during supervision. Manual roles persist their own results; read-only reviewer output is persisted and verified by the next role or `/deliver resume`. JSON parsing and transition checks are protocol requirements, not a bundled runtime engine.

### Feature Folder Structure

All specification artifacts for a feature are co-located in `spec/<feature-slug>/` at the project root. Agents create and update these files automatically using the templates in `.github/templates/` — you do not need to manage file placement or formatting manually.

```md
spec/
ACTIVE.md <- identifies the currently active feature, gate, story, status, final_status, and pending_audit
user-registration/
PRD.md <- Gate 1: product requirements document
BACKLOG.md <- Gate 2: epic index + security_review policy
EPIC-1-core-registration.md <- Gate 2: stories, acceptance criteria, size/risk/uncertainty
DESIGN.md <- Gate 3: technical design + capability sizing per story
PLAN.md <- Gate 4: current delivery package plan + Capability Sizing + Delivery Contract
HISTORY.md <- Gate 5/6: running log of completed work, delivery run records, and acceptance/escalation entries
checkout-flow/
PRD.md
...
```

**`spec/ACTIVE.md`** declares which feature is currently in progress:

```yaml
slug: user-registration
title: User Registration
final_status: not-started
pending_audit: []
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

| Agent           | File                            | Responsibility                                                                                    |
| --------------- | -------------------------------- | ------------------------------------------------------------------------------------------------- |
| `sdp.prd`       | `agents/sdp.prd.agent.md`       | Authors `PRD.md` from a business intent description                                               |
| `sdp.discover`  | `agents/sdp.discover.agent.md`  | Scans an existing codebase and drafts `TECH.md`                                                   |
| `sdp.analyst`   | `agents/sdp.analyst.agent.md`   | Refines a PRD into epics, features, and user stories; declares each epic's security review policy |
| `sdp.architect` | `agents/sdp.architect.agent.md` | Produces a right-sized technical design document and rates story size/risk/uncertainty            |
| `sdp.planner`   | `agents/sdp.planner.agent.md`   | Creates a capability-sized implementation plan for one delivery package — never writes code       |
| `sdp.developer` | `agents/sdp.developer.agent.md` | Implements one approved plan at a time — never plans, never self-loops                            |
| `sdp.reviewer`  | `agents/sdp.reviewer.agent.md`  | Performs code and design review; routes security per epic policy                                  |
| `sdp.security`  | `agents/sdp.security.agent.md`  | Conducts a security audit against OWASP web baselines (per-story, epic-level, or waived)          |
| `sdp.qa`        | `agents/sdp.qa.agent.md`        | Validates acceptance criteria; a pass stops at `awaiting-acceptance`, never at automatic completion |
| `sdp.orchestrator` | `agents/sdp.orchestrator.agent.md` | Supervises Gates 5-6 in one session for `/deliver`; coordinates only, never writes product code |

Agents propose handoffs to the next role — for example, the reviewer agent offers to invoke the security agent after completing its review. Each handoff requires explicit confirmation before proceeding in manual mode. `sdp.planner` never hands off to an executor automatically, so planning cannot loop into repeated re-implementation; `sdp.orchestrator` dispatches specialists internally under `/deliver` but always stops at the human acceptance checkpoint.

---

### Prompts

Prompts are the entry points that activate agents in the correct mode. Each prompt file documents its prerequisites and describes the expected outcome before the operation begins. **Prefer prompts over invoking an agent by name** — each gate has exactly one entry-point prompt.

| Prompt           | Activates          | Gate                                                            |
| ---------------- | ------------------- | ---------------------------------------------------------------- |
| `discover-tech`  | `sdp.discover`      | Legacy onboarding                                                |
| `create-prd`     | `sdp.prd`           | Gate 1                                                           |
| `refine-backlog` | `sdp.analyst`       | Gate 2                                                           |
| `design-system`  | `sdp.architect`     | Gate 3                                                           |
| `plan-task`      | `sdp.planner`       | Gate 4                                                           |
| `implement`      | `sdp.developer`     | Gate 5 (manual, single-shot)                                     |
| `run-review`     | `sdp.reviewer`      | Gate 6 (manual, single-shot)                                     |
| `audit-security` | `sdp.security`      | Gate 6 (manual, single-shot; skipped if policy is `epic-level`/`waived`) |
| `qa-validate`    | `sdp.qa`            | Gate 6 (manual, single-shot)                                     |
| `deliver`        | `sdp.orchestrator`  | Gates 5-6 combined, supervised, one approval, ends at acceptance |

Prompts are located in `.github/prompts/` after installation and are accessible from the Copilot Chat prompt picker.

---

### Skills

Skills are focused, reusable technical guidance files that agents reference when performing specific programming tasks. They encode implementation patterns, conventions, and quality criteria for common web development operations.

Skills are located in `.github/skills/` and follow the [Agent Skills open standard](https://agentskills.io) — each skill is a folder containing a `SKILL.md` file with metadata and instructions.

| Skill                    | Folder                        | Purpose                                                                            |
| ------------------------ | ----------------------------- | ---------------------------------------------------------------------------------- |
| Write Tests              | `skills/write-tests/`         | Unit and integration tests using the AAA pattern; TDD guidance                     |
| Create REST API Endpoint | `skills/create-api-endpoint/` | Route design, input validation, authentication, error responses, and documentation |
| Create UI Component      | `skills/create-ui-component/` | Component structure, accessibility, state management, and testing                  |
| Database Migration       | `skills/database-migration/`  | Safe schema changes, rollback strategies, and zero-downtime patterns               |
| Error Handling           | `skills/error-handling/`      | Error classification, structured logging, safe error responses, and retry logic    |

To add a custom skill, create a new folder under `.github/skills/` and add a `SKILL.md` file using `.github/templates/template.skill.md` as the starting point.

---

### Templates

The `.github/templates/` folder contains starter files for extending SDP, and canonical templates for every gate artifact (each requires a `status: draft | approved | rejected` header):

| File                 | Purpose                                                                                                    |
| -------------------- | ------------------------------------------------------------------------------------------------------------ |
| `TECH.md`            | Blank technology context template for new projects, including the Model Policy section                    |
| `AGENTS.md`          | Scoped context-map template for repository root, backend modules, and frontend packages                    |
| `ACTIVE.md`          | Active feature tracker: slug, title, current gate, current story, status, `final_status`, `pending_audit`  |
| `PRD.md`             | Gate 1 artifact template                                                                                   |
| `BACKLOG.md`         | Gate 2 artifact template, including the `security_review` policy table                                     |
| `EPIC.md`            | Gate 2 per-epic template: stories, acceptance criteria, size/risk/uncertainty, security review policy/reason |
| `DESIGN.md`          | Gate 3 artifact template, including the per-story Capability Sizing table                                  |
| `PLAN.md`            | Gate 4 artifact template: Delivery Identity, Capability Sizing, Change Boundary, Work Graph, Verification Matrix |
| `HISTORY.md`         | Append-only log template for completed work, Delivery Run Records, acceptance entries, and escalations      |
| `DELIVERY-RUN.json`  | Structured run identity, steps, candidate-bound results, audit obligations, counters and acceptance |
| `template.agent.md`  | Starter template for authoring a custom agent                                                              |
| `template.prompt.md` | Starter template for authoring a custom prompt                                                             |
| `template.skill.md`  | Starter template for authoring a custom skill                                                              |

---

## Customization

SDP is designed to coexist with existing tooling and custom workflows. SDP-managed files are isolated and will not conflict with your own additions.

| What to customize                    | How                                                                                                |
| ------------------------------------ | -------------------------------------------------------------------------------------------------- |
| Project-specific AI coding standards | Extend `.github/instructions/coding-standards.instructions.md`                                     |
| Custom agents                        | Add `.agent.md` files to `.github/agents/` — SDP updates will not touch them                       |
| Custom prompts                       | Add prompt files to `.github/prompts/`                                                             |
| Custom skills                        | Add `<skill-name>/SKILL.md` folders to `.github/skills/` using the provided template               |
| Scoped agent context                 | Add `AGENTS.md` files at repository root and module boundaries                                     |
| Technology context                   | Edit `.github/TECH.md` — this file is never overwritten by SDP updates unless explicitly requested |

---

## Project Structure

### Source Layout (this repository)

```md
.apm/
├── agents/ <- Agent definition files
├── instructions/ <- Shared SDLC process instructions (includes coding-standards.instructions.md)
├── prompts/ <- Gate trigger prompts
├── skills/
│ ├── create-api-endpoint/
│ │ └── SKILL.md
│ ├── create-ui-component/
│ │ └── SKILL.md
│ ├── database-migration/
│ │ └── SKILL.md
│ ├── error-handling/
│ │ └── SKILL.md
│ └── write-tests/
│ └── SKILL.md
└── templates/
├── ACTIVE.md
├── AGENTS.md
├── TECH.md
├── PRD.md
├── BACKLOG.md
├── EPIC.md
├── DESIGN.md
├── PLAN.md
├── HISTORY.md
├── DELIVERY-RUN.json
├── template.agent.md
├── template.prompt.md
└── template.skill.md
```

### Installed Layout (client repository)

After running the installer, the following structure is created under `.github/` in the target repository:

```md
.github/
├── TECH.md <- Project technology context (fill this in)
├── sdp-version <- Installed SDP version marker
├── agents/ <- SDP agent definitions
├── instructions/ <- SDLC process instructions (includes coding-standards.instructions.md)
├── prompts/ <- Gate trigger prompts
├── skills/
│ ├── <skill-name>/
│ │ └── SKILL.md
│ └── ...
└── templates/
├── ACTIVE.md
├── AGENTS.md
├── TECH.md
├── PRD.md
├── BACKLOG.md
├── EPIC.md
├── DESIGN.md
├── PLAN.md
├── HISTORY.md
├── DELIVERY-RUN.json
├── template.agent.md
├── template.prompt.md
└── template.skill.md
```

### Recommended `AGENTS.md` Placement

```md
<repository root>/
├── AGENTS.md <- Global context boundaries and repository rules
├── src/
│ ├── Billing/
│ │ ├── AGENTS.md <- Service-local context (e.g., next to .csproj)
│ │ └── Billing.csproj
│ └── Frontend/
│ ├── AGENTS.md <- App/package-local context
│ └── package.json
```

### Runtime Artifacts (created by agents in the client repository)

```md
spec/
├── ACTIVE.md <- Currently active feature
└── <feature-slug>/
├── PRD.md
├── BACKLOG.md
├── EPIC-\*.md
├── DESIGN.md
├── PLAN.md
└── HISTORY.md
```

---

## Package Distribution

SDP is distributed as an [Agent Package Manager (APM)](https://agentpackagemanager.io) compatible package. The `apm.yml` manifest defines all framework components:

- **Components:** 8 agents, 9 prompts, 5 skills, global instructions, and templates
- **Install path:** `.github/` in the target repository
- **Source directory:** `.apm/` in this repository
- **Installers:** bash (`install.sh`) and PowerShell (`install.ps1`)
- **Marketplace outputs:** `.claude-plugin/marketplace.json` and `.agents/plugins/marketplace.json`

APM producer release flow (recommended):

```bash
# 1) Validate marketplace entries resolve
apm marketplace check

# 2) Build marketplace artifacts
apm pack --marketplace=claude,codex

# 3) Commit generated marketplace files and tag a release
git add .claude-plugin/marketplace.json .agents/plugins/marketplace.json apm.yml
git commit -m "release: update marketplace index"
git tag spec-development-protocol-v0.4.0
git push --tags
```

For npm ecosystem compatibility:

```bash
npm install -g @wojcikmm/spec-development-protocol
```

---

## Contributing

Contributions are welcome. Please follow these guidelines:

1. **Source changes belong in `.apm/`** — never edit files under `.github/` as template source. The `.github/` folder in this repository is for maintainer automation only.
2. **Keep templates generic** — all files in `.apm/` must be reusable across different project types and tech stacks.
3. **Update documentation** — if you change behavior in `install.sh` or `install.ps1`, update the corresponding sections in this `README.md`.
4. **Validate the installer** — run `bash -n install.sh` to check for syntax errors before submitting a pull request.
5. **Preserve gate discipline** — changes to agents or prompts must maintain the 6-gate sequential process and human-approval model.

For significant changes, open an issue first to discuss the proposed direction before submitting a pull request.

---

## License

[MIT](LICENSE)
