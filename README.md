# Spec Development Protocol (SDP)

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![GitHub release](https://img.shields.io/github/v/release/WojcikMM/spec-development-protocol)](https://github.com/WojcikMM/spec-development-protocol/releases)
[![GitHub stars](https://img.shields.io/github/stars/WojcikMM/spec-development-protocol)](https://github.com/WojcikMM/spec-development-protocol/stargazers)

SDP is an open-source, spec-driven delivery framework for GitHub Copilot Agent
Mode. It keeps product intent, implementation, independent assurance, and human
acceptance connected without forcing compliance-grade ceremony onto every
change.

The normal delivery experience is:

```text
/plan-task
review PLAN.md
/deliver
accept, reject, or describe a correction
```

SDP installs into the `.github/` folder of greenfield or existing repositories.

## Contents

- [Why SDP](#why-sdp)
- [Installation](#installation)
- [Setup](#setup)
- [Quick Start](#quick-start)
- [How the Process Works](#how-the-process-works)
- [Delivery Profiles](#delivery-profiles)
- [Security and QA Routing](#security-and-qa-routing)
- [Manual and Supervised Delivery](#manual-and-supervised-delivery)
- [Artifacts and State](#artifacts-and-state)
- [Reference](#reference)
- [Customization](#customization)
- [Repository and Package Structure](#repository-and-package-structure)
- [Upgrading from the Strict Identity Workflow](#upgrading-from-the-strict-identity-workflow)
- [Contributing](#contributing)

## Why SDP

AI coding assistants can implement quickly before intent, constraints, and
verification are clear. SDP provides:

- specification before implementation;
- right-sized product, design, and delivery artifacts;
- explicit change boundaries and non-goals;
- developer autonomy inside approved outcomes;
- independent review proportional to risk;
- security and QA only when they add evidence;
- concise traceability in specs and delivery history, not production comments;
- a final human acceptance decision.

SDP uses six gates, but the cost of each gate is proportional to the work. A
small resolved change can use existing product/design contracts. A high-risk or
regulated change can opt into retained integrity evidence.

## Prerequisites

| Requirement | Version | Notes |
| --- | --- | --- |
| Visual Studio Code | Latest | Runs Copilot agents |
| GitHub Copilot extension | Latest | Agent Mode must be enabled |
| GitHub Copilot subscription | Current | Individual, Team, or Enterprise |
| Bash or PowerShell | bash 3.2+ / PS 5.1+ | Direct installer |
| `curl` | Recent | Bash installer |

## Installation

Run an installer from the target repository root.

### macOS / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/WojcikMM/spec-development-protocol/main/install.sh | bash
```

### Windows

```powershell
iwr -useb https://raw.githubusercontent.com/WojcikMM/spec-development-protocol/main/install.ps1 | iex
```

If PowerShell blocks script execution:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

The installers recursively copy canonical `.apm/` content into `.github/`
without overwriting existing files by default. `.github/sdp-version` records the
source version. Existing `TECH.md` is preserved unless explicitly overwritten.

### Installer Options

| Variable | Default | Description |
| --- | --- | --- |
| `SDP_BRANCH` | `main` | Branch or release tag |
| `SDP_FORCE` | `false` | Overwrite existing SDP-managed files |
| `SDP_TECH_MODE` | `init` | `init`, `overwrite`, or `skip` TECH handling |
| `SDP_TARGET` | current directory | Target repository root |

Bash examples:

```bash
# Install a release
curl -fsSL https://raw.githubusercontent.com/WojcikMM/spec-development-protocol/main/install.sh \
  | SDP_BRANCH=v0.5.2 bash

# Upgrade managed files while preserving project TECH.md
curl -fsSL https://raw.githubusercontent.com/WojcikMM/spec-development-protocol/main/install.sh \
  | SDP_FORCE=true SDP_TECH_MODE=skip bash
```

PowerShell examples:

```powershell
$env:SDP_BRANCH='v0.5.2'
iwr -useb https://raw.githubusercontent.com/WojcikMM/spec-development-protocol/main/install.ps1 | iex

$env:SDP_FORCE='true'
$env:SDP_TECH_MODE='skip'
iwr -useb https://raw.githubusercontent.com/WojcikMM/spec-development-protocol/main/install.ps1 | iex
```

### APM Installation

```bash
apm marketplace add WojcikMM/spec-development-protocol
apm install spec-development-protocol@spec-development-protocol
```

Or install directly:

```bash
apm install WojcikMM/spec-development-protocol
```

APM cannot package `.apm/templates/` directly, so generated copies are shipped
as assets of the `sdp-templates` skill. Maintainers author only
`.apm/templates/` and regenerate the mirror.

### Manual Installation

1. Clone or download this repository.
2. Create `.github/` in the target repository.
3. Copy the contents of `.apm/` into `.github/`.
4. Do not overwrite project customizations unless intentionally upgrading.

## Setup

### 1. Complete `.github/TECH.md`

Define:

- stack, module structure, and external boundaries;
- build, test, lint, and formatting commands;
- architecture and compatibility conventions;
- default SDP delivery profile;
- project-specific security and independent-QA triggers;
- Compliance integrity/retention requirements, if any;
- optional model routing.

`Balanced` is the recommended default. Missing model telemetry does not block
Lean or Balanced delivery. Compliance may require verified model/tool
configuration when project policy explicitly says so.

### 2. Add scoped `AGENTS.md` files

Place context maps where they reduce unnecessary scanning:

- repository root for global boundaries;
- service/library roots;
- frontend application or package roots.

Use `.github/templates/AGENTS.md` as a starter.

### 3. Enable Agent Mode

Open Copilot Chat in VS Code and confirm Agent Mode and custom agents/prompts are
available.

## Quick Start

Example: add user registration.

| Step | Action | Prompt | Output |
| --- | --- | --- | --- |
| 1 | Define outcome and scope | `/create-prd` | `PRD.md`, `ACTIVE.md` |
| 2 | Approve PRD and refine behavior | `/refine-backlog` | `BACKLOG.md`, `EPIC-*.md` |
| 3 | Approve backlog and design contracts | `/design-system` | `DESIGN.md` |
| 4 | Approve design and plan active package | `/plan-task` | concise `PLAN.md` |
| 5 | Read the plan and deliver it | `/deliver` | code, tests, proportional assurance |
| 6 | Review acceptance brief | normal language | accept, reject, or describe correction |

Bare `/deliver` resolves `spec/ACTIVE.md`, approves the current visible plan,
implements it, runs the required assurance profile, and stops for human
acceptance. It does not require delivery IDs, revisions, digests, or candidate
hashes when active state is unambiguous.

Example correction:

```text
The empty state is wrong. Keep the action visible but disabled, and explain why.
```

The orchestrator classifies this as a bounded correction or a contract change.
Bounded work is repaired and rechecked; changed requirements return to planning.

## How the Process Works

```text
Gate 1: Discovery     -> PRD.md
Gate 2: Refinement    -> BACKLOG.md + EPIC-*.md
Gate 3: Architecture  -> DESIGN.md
Gate 4: Planning      -> PLAN.md
Gate 5: Implementation
Gate 6: Assurance -> human acceptance
```

Gate artifacts start as draft and carry:

```yaml
status: draft | approved | rejected
approved_by: pending | <identity>
approved_at: pending | <ISO timestamp>
```

Manual downstream gates require approval metadata. Bare `/deliver` is the
convenience action that records approval of the current plan before execution.

### Right-sized earlier gates

Use the full chain for new capabilities and material behavior. For a small fix
with an established product contract and design, the user may explicitly
approve a lightweight path that references existing artifacts.

The lightweight path still requires:

- a clear outcome and non-goals;
- a plan and change boundary;
- executable verification;
- proportionate independent review;
- human acceptance.

### Capability sizing

Every delivery declares:

- size: `S`, `M`, `L`, or `XL`;
- risk: `Low`, `Moderate`, or `High`;
- uncertainty: `Resolved`, `Bounded`, or `Open`.

XL work is split. Open uncertainty about behavior, data, security, or
architecture returns to refinement/design.

### Implementation autonomy

The plan locks outcome, contracts, safety constraints, non-goals, and
verification. The developer owns naming, idiomatic local design, helper
reuse/extraction, and adjacent tests inside the boundary.

A simpler in-boundary solution may proceed when outcome, risk, and verification
remain unchanged. Public-contract, dependency, security/data-boundary, or
destructive changes require replanning.

### Durable comments

Production comments must not contain story, task, epic, delivery, ticket, or AC
identifiers; implementation-step narration; change history; obvious
restatements; or completed planning notes.

Keep comments only for durable non-obvious invariants, compatibility
constraints, security rationale, protocol quirks, or deliberate trade-offs.
Traceability belongs in specs, meaningful tests, PR/commit descriptions, and
delivery history.

## Delivery Profiles

| Profile | Use | Assurance | Evidence |
| --- | --- | --- | --- |
| Lean | Small, low-risk, resolved work | Developer validation + reviewer; specialists only on trigger | Final summary |
| Balanced | Normal product work | Reviewer always; security/QA when they add evidence | Compact run checkpoint + final summary |
| Compliance | Regulated/high-risk or explicitly requested | Full policy-required sequence | Configured hashes, manifests, environment, retained evidence |

Balanced is the default. A plan may raise but not silently lower a mandatory
project profile.

Compliance preserves the former strict identity controls where they are useful.
It does not claim to provide a tamper-proof audit system.

## Security and QA Routing

Each epic selects:

- `risk-based` (default);
- `per-story`;
- `epic-level`;
- `waived` with a reason.

Risk-based security dispatches the specialist when changes affect:

- authentication or authorization;
- secrets;
- untrusted input;
- sensitive data;
- cryptography;
- network trust;
- dependency/infrastructure security;
- regulated controls.

Secure coding remains active in every profile.

QA runs when independently exercising behavior adds confidence, such as user
journeys, integrations, accessibility, compatibility, migrations, performance,
or critical workflows. If QA can only repeat the same review and focused tests,
Lean/Balanced may record it as not applicable.

Reviewer answers: "Is the code technically correct and maintainable?"

QA answers: "Does independently observable behavior satisfy acceptance?"

## Manual and Supervised Delivery

### Supervised

```text
/deliver
/deliver --profile compliance
/deliver resume
/deliver inspect
/deliver reject
```

IDs are requested only when several active/resumable runs are ambiguous.

The orchestrator dispatches one worker at a time and never writes product code.
One autonomous repair is allowed after the first rejected candidate; a second
autonomous rejection escalates. Explicit human-guided correction does not
consume that ceiling merely because feedback was given.

### Manual

Use:

```text
/implement
/run-review
/audit-security
/qa-validate
```

Manual mode remains useful for expert control, troubleshooting, or runtimes
without specialist dispatch.

Both modes stop at an acceptance brief. Acceptance never automatically commits,
merges, deploys, or selects the next package.

## Artifacts and State

```text
spec/
  ACTIVE.md
  <feature-slug>/
    PRD.md
    BACKLOG.md
    EPIC-*.md
    DESIGN.md
    PLAN.md
    HISTORY.md
    deliveries/
      <delivery-id>.json
```

`ACTIVE.md` separates feature progress from delivery state:

```yaml
slug: user-registration
title: User Registration
current_gate: 5
current_delivery: user-registration-DP-1
feature_status: in-progress
delivery_status: delivering
pending_audit: []
```

Delivery states:

```text
not-planned -> planned -> delivering -> awaiting-acceptance -> accepted
                              |                 |
                              -> blocked        -> changes-requested -> delivering
                                                -> rejected
```

`DELIVERY-RUN.json` is a compact resume checkpoint containing profile, current
stage, completed stages, changed paths, compact verdicts, material findings,
audit obligations, and acceptance decision.

`HISTORY.md` stores one concise final entry per delivery plus unresolved
blocking/escalation entries. Detailed command logs remain in test/CI output and
are referenced rather than copied.

## Reference

### Agents

| Agent | Responsibility |
| --- | --- |
| `sdp.discover` | Discover legacy technology context |
| `sdp.prd` | Define product outcome and scope |
| `sdp.analyst` | Create coherent stories and acceptance criteria |
| `sdp.architect` | Record right-sized technical decisions |
| `sdp.planner` | Create an implementation-grade plan |
| `sdp.developer` | Implement product code and tests |
| `sdp.reviewer` | Review technical correctness and maintainability |
| `sdp.security` | Audit security-sensitive changes |
| `sdp.qa` | Validate independently observable acceptance |
| `sdp.orchestrator` | Coordinate delivery and human acceptance |

### Prompts

| Prompt | Purpose |
| --- | --- |
| `/discover-tech` | Draft TECH from repository evidence |
| `/create-prd` | Draft product requirements |
| `/refine-backlog` | Draft stories and ACs |
| `/design-system` | Draft technical design |
| `/plan-task` | Plan the active delivery |
| `/deliver` | Approve and deliver the active plan |
| `/implement` | Manual implementation |
| `/run-review` | Manual review |
| `/audit-security` | Manual security audit |
| `/qa-validate` | Manual acceptance validation |

### Skills

| Skill | Purpose |
| --- | --- |
| `create-api-endpoint` | Secure REST endpoint guidance |
| `create-ui-component` | Accessible UI component guidance |
| `database-migration` | Safe migration and recovery guidance |
| `error-handling` | Consistent observable failure handling |
| `write-tests` | Meaningful behavior-focused tests |
| `sdp-templates` | Generated APM template assets |

### Templates

| Template | Purpose |
| --- | --- |
| `TECH.md` | Stack, commands, conventions, delivery policy |
| `AGENTS.md` | Scoped context map |
| `ACTIVE.md` | Active feature and package state |
| `PRD.md` | Product outcome |
| `BACKLOG.md`, `EPIC.md` | Stories, ACs, security policy |
| `DESIGN.md` | Contracts, boundaries, decisions |
| `PLAN.md` | Outcome, work, boundary, verification, autonomy |
| `DELIVERY-RUN.json` | Compact resume state |
| `HISTORY.md` | Final outcomes and unresolved blocks |

## Customization

| Need | Location |
| --- | --- |
| Project coding standards | `.github/instructions/coding-standards.instructions.md` |
| Delivery/security/QA policy | `.github/TECH.md` |
| Custom agents | `.github/agents/*.agent.md` |
| Custom prompts | `.github/prompts/*.prompt.md` |
| Custom skills | `.github/skills/<name>/SKILL.md` |
| Module context | repository/module `AGENTS.md` files |

The installer is non-destructive by default. `SDP_FORCE=true` is explicit
overwrite behavior.

## Repository and Package Structure

Canonical distributable source:

```text
.apm/
  agents/
  instructions/
  prompts/
  skills/
    sdp-templates/
      assets/        # generated APM mirror
  templates/         # canonical authoring source
```

Direct installers copy `.apm/*` to client `.github/*`. APM packages templates
through the generated `sdp-templates` skill assets because the package format
does not include arbitrary template directories.

After changing `.apm/templates/`:

```bash
apm run sync-templates
apm run check-templates
```

Package metadata is in `apm.yml`. Marketplace build:

```bash
apm marketplace check
apm pack --marketplace=claude,codex
```

## Upgrading from the Strict Identity Workflow

This redesign intentionally changes delivery state and the default evidence
model.

When upgrading an existing client:

1. Back up project customizations.
2. Upgrade SDP-managed files together:

   ```bash
   curl -fsSL https://raw.githubusercontent.com/WojcikMM/spec-development-protocol/main/install.sh \
     | SDP_FORCE=true SDP_TECH_MODE=skip bash
   ```

3. Update `TECH.md` with the new SDP Delivery Policy.
4. Migrate active state:
   - `current_story` -> `current_delivery`;
   - `status` -> `feature_status`;
   - `final_status` -> the closest `delivery_status`.
5. Regenerate the active `PLAN.md` using the simplified template.
6. Start new run checkpoints with `DELIVERY-RUN.json` schema version 2.
7. Preserve unresolved security obligations in `pending_audit`.

Do not mix old plan/run semantics with new agents. Default non-overwriting
installation may leave mixed versions, so deliberate upgrades should use
`SDP_FORCE=true` after review.

Projects that still need strict digests, manifests, and retained stage evidence
should set Compliance as their mandatory profile.

## Contributing

1. Edit distributable content in `.apm/`, never repository `.github/`.
2. Treat `.apm/templates/` as canonical.
3. Run `scripts/sync-templates.sh` after template changes.
4. Keep process instructions, agents, prompts, templates, installer output, and
   this README aligned.
5. Run:

   ```bash
   bash -n install.sh
   bash scripts/sync-templates.sh --check
   git diff --check
   ```

## License

[MIT](LICENSE)
