# Changelog

All notable changes to the Spec Development Protocol (SDP) are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [Unreleased]

## [v0.5.3]

### Added

- **`scripts/sync-templates.sh`** — regenerates the APM `sdp-templates` skill-asset mirror from the canonical `.apm/templates/` directory (`apm run sync-templates`) and checks for drift without modifying files (`apm run check-templates`), replacing the manual byte-for-byte copy obligation.
- **Proportional assurance profiles** — added Lean, Balanced (default), and Compliance delivery profiles. Review remains independent, while specialist security and QA stages run when policy, risk, or independently observable behavior requires them. Compliance retains strict hashes, manifests, environment identity, and evidence retention when a project needs them.
- **Natural-language correction flow** — after the acceptance brief, users can accept, reject, or describe what is wrong without supplying delivery/candidate identifiers. Bounded corrections are repaired and rechecked; changed contracts return to planning.
- **Durable comment policy** — production comments must not contain story/task/epic/AC identifiers, implementation narration, change history, completed planning notes, or obvious code restatements. Developer and reviewer agents now enforce this policy.
- **Implementation autonomy** — plans explicitly preserve developer ownership of naming, idiomatic local design, helper reuse/extraction, and adjacent tests inside the approved outcome and change boundary.

### Changed

- **Simplified `/deliver` workflow** — bare `/deliver` now resolves `spec/ACTIVE.md`, approves the current visible `PLAN.md`, executes it, runs proportionate assurance, and stops at human acceptance. Delivery IDs, plan revisions, digests, and candidate hashes are no longer required when active state is unambiguous. Advanced Compliance, resume, inspect, and reject actions remain available.
- **Risk-based security is now the default** — epic policy is `risk-based | per-story | epic-level | waived`. Specialist security review is triggered by authentication, authorization, secrets, untrusted input, sensitive data, cryptography, trust boundaries, dependency/infrastructure security, regulated controls, or explicit policy.
- **Reviewer and QA responsibilities are separated** — reviewer owns technical correctness, maintainability, scope, and test quality. QA runs when independently exercising observable behavior adds evidence beyond review and focused tests.
- **`PLAN.md` is implementation-focused** — removed normal-mode orchestration bookkeeping such as upstream hashes, model references, resource counters, file manifests, and immutable revision metadata. Plans retain outcome, non-goals, decisions, boundary, ordered work, verification, applicable recovery, and autonomy limits.
- **Delivery evidence is compact by default** — `DELIVERY-RUN.json` schema version 2 is a small resume checkpoint, and `HISTORY.md` stores one final delivery summary plus unresolved blocks/escalations instead of duplicating successful stage narratives and command logs.
- **State model consolidated** — `ACTIVE.md` now uses `current_delivery`, `feature_status`, and `delivery_status`, replacing overlapping `current_story`, `status`, and `final_status` fields.
- **Earlier gates can be right-sized** — small resolved changes may explicitly reference existing product/design contracts instead of generating redundant artifacts, while still requiring an outcome, plan, verification, independent review, and human acceptance.
- **Global standards made proportional** — softened universal requirements around assertions, health endpoints, metrics, branching, ADRs, test placement, and migration rollback so project-specific policy can live in `TECH.md`.
- **All agents and prompts aligned** — role files now contain role-specific behavior rather than repeating the entire run-state and compliance contract. Bare `/deliver`, profile routing, conversational correction, and compact evidence are consistent across agents, prompts, instructions, templates, and README.
- **Skills refined** — API/UI/error-handling skills reinforce durable comments, migration guidance supports safe forward recovery for approved irreversible operations, and test guidance permits multiple assertions that verify one behavioral outcome.
- **Documentation and installer guidance updated** — README now documents the simplified workflow, delivery profiles, security/QA triggers, state migration, and Compliance fallback. Installer behavior is unchanged; output now points users to the SDP Delivery Policy in `TECH.md`.
- **Generated context refreshed** — root `AGENTS.md` and the APM template-asset mirror were regenerated from canonical `.apm/` sources.

### Breaking Changes

- Existing clients must migrate `current_story` to `current_delivery`, `status` to `feature_status`, and `final_status` to the closest `delivery_status`.
- Existing active plans should be regenerated with the simplified `PLAN.md` template.
- New delivery checkpoints use `DELIVERY-RUN.json` schema version 2; unresolved `pending_audit` obligations must be preserved during migration.
- Old agents, prompts, instructions, and templates must not be mixed with the redesigned workflow. Upgrade SDP-managed files together and preserve project `TECH.md` with `SDP_TECH_MODE=skip` when appropriate.

### Removed

- Mandatory plan digests, upstream artifact hashes, full working-tree manifests, environment fingerprints, exact candidate IDs, and immutable plan archives from Lean/Balanced delivery. These remain available through project-configured Compliance policy.
- Required `approve-and-run <delivery-id> <revision>` and `accept <delivery-id> <candidate-id>` syntax from the normal user workflow.

## [v0.5.2]

Customization-layer refactor addressing `SDP-REVIEW.md`, with synchronized documentation and installer notices. No version bump in `apm.yml`/`plugin.json`.

### Added

- **APM-compatible template assets** — canonical `.apm/templates/` files are mirrored into the `sdp-templates` skill because APM 0.29 rejects unknown primitive directories during `apm pack`; process instructions now resolve either direct-installer or APM asset paths.
- **`sdp.orchestrator` agent and `/deliver` prompt** — a supervised-delivery entry point that dispatches `sdp.developer`, `sdp.reviewer`, `sdp.security`, and `sdp.qa` in sequence within one session, ends at a human acceptance checkpoint, and never writes product code itself. Manual mode (`/implement`, `/run-review`, `/audit-security`, `/qa-validate`) remains fully valid and is the required fallback.
- **Final Human Acceptance checkpoint** — a `sdp.qa` Pass now sets `final_status: awaiting-acceptance` and produces an acceptance brief instead of marking the story/feature `done` automatically. Only an explicit human accept/reject/request-changes decision closes a delivery package; acceptance never itself authorizes commit/merge/deploy/next-package.
- **`spec/ACTIVE.md` fields** — added `final_status` (`not-started | in-delivery | awaiting-acceptance | accepted | rejected`) and `pending_audit` (list of outstanding epic audit IDs).
- **Plan digest** — `PLAN.md` approval now records a content fingerprint of the plan body; any later edit to the body invalidates the approval regardless of the `status` field, binding approval to a specific revision instead of a filename.
- **Symmetric upstream-approval enforcement** — every gate agent (`sdp.analyst`, `sdp.architect`, `sdp.planner`, `sdp.developer`/`sdp.orchestrator`) now explicitly refuses to proceed unless its upstream artifact is `status: approved` with `approved_by`/`approved_at` filled in, not just the developer/PLAN.md pair.
- **Capability Sizing** — replaced the fixed Gate 4 Scope Budget (8 files / 300 lines / S-M-L) with an independent Size (S/M/L/XL) x Risk (Low/Moderate/High) x Uncertainty (Resolved/Bounded/Open) rating and outcome-based split criteria, carried from `DESIGN.md` through `EPIC.md`/`BACKLOG.md`/`PLAN.md`.
- **Delivery Contract** — `PLAN.md` restructured into a Human Decision Brief plus an Execution Contract (Delivery Identity, Change Boundary, Work Graph, Verification Matrix, Autonomy Policy, Operational Limits, Recovery).
- **Delivery Run Record**: new `DELIVERY-RUN.json` template for baseline/candidate manifests, steps, results, obligations, resource use and acceptance. HISTORY defines the worker envelope and validation contract. Both manual and supervised runs use the same data format; no runtime engine or dependency is added.
- **Model Policy** — `TECH.md` gained a section mapping each gate role to a model profile label, with an explicit instruction not to invent unavailable model IDs.
- **Deferred-audit closure tracking**: the final package dispatches an aggregate audit against the original epic baseline, then final QA before closure. Intermediate acceptance retains obligations; multi-story/multi-epic packages preserve all policies.

### Changed

- **Central rejected-candidate counter** replaces "same story fails the same hardening step twice" — escalation to the user now triggers after the delivery package's **2nd** rejected candidate, counting rejections from review, security, or QA in any combination, not per-stage.
- **Delivery package** replaces "one story at a time" as the Gate 4-6 unit of work — a package may bundle tightly related stories sharing one coherent, demonstrable outcome; unrelated work is never bundled.
- `sdp.developer`, `sdp.reviewer`, `sdp.security`, `sdp.qa` now describe dual-mode operation: standalone manual handoffs are unchanged, and each also returns a structured result to `sdp.orchestrator` instead of self-chaining when invoked under `/deliver`.
- `write-tests` skill's test-deletion guidance ("fix or delete failing tests") replaced with a requirement for a root-cause explanation and confirmation that equivalent required coverage remains.
- `README.md` — added a "Manual vs. Supervised Delivery" section, updated the Quick Start walkthrough, 6-gate diagram, feedback loop table, feature folder structure, and agents/prompts/templates reference tables.
- Added documented tool allowlists and worker subagent restrictions. The read-only reviewer returns records for the next role/coordinator to persist; terminal permissions are not represented as a sandbox.
- Added explicit approve-and-run/run/resume/accept/reject/request-changes routing with fresh candidate checks and no automatic next-package selection.
- Both installers now report mixed-version upgrade risks and Model Policy setup; copy/force/TECH handling is unchanged. Normalized the touched Bash installer to LF so the raw syntax gate passes. Corrected Bash README examples to apply environment variables to `bash`, not `curl`.
- Regenerated root `AGENTS.md` using the installed APM CLI; no manual edits or archived build changes.

### Not Changed

- Installer copy behavior: both already recursively copy `.apm/` to `.github/`, including the new agent, prompt and run template. Default preservation and explicit force behavior remain intact.
- `apm.yml` / `plugin.json` — no version bump; these point at the `.apm/` directories generically and needed no path changes.
- No durable execution service, authenticated approval system, automatic model selector, or live cross-harness compatibility guarantee is introduced.

## [v0.5.1]

Technical release only — bumps the APM package version and GitHub Copilot plugin release version. No code, agents, prompts, instructions, or skills were changed.

### Changed

- Bumped version to `0.5.1` in `apm.yml` and `plugin.json`.

## [v0.5.0]

### Fixed

- **Plan → Implement infinite loop** — `sdp.developer` previously combined `plan-task` and `implement` modes behind a self-referencing handoff, which in `auto` mode caused agents to repeatedly re-trigger implementation instead of proceeding to review. Split into two agents:
  - `sdp.planner` (Gate 4) — plans only, never writes code, never self-invokes.
  - `sdp.developer` (Gate 5) — implements only, never plans, hands off exactly once to `sdp.reviewer`.
- `coding-standards.instructions.md` and `sdlc-process.instructions.md` both declared `applyTo: "**/*"` and duplicated the same orchestration/routing content, which was concatenated twice into the generated root `AGENTS.md`. `coding-standards.instructions.md` now covers coding standards only; `sdlc-process.instructions.md` is the single source of truth for process/routing.
- `sdp.reviewer`, `sdp.security`, and `sdp.qa` used inconsistent severity scales (Critical/Major/Minor/Suggestion vs. Critical/High/Medium/Low), making hardening findings hard to aggregate. Unified to a single **Critical/High/Medium/Low** scale across all three.

### Added

- **Configurable security review policy** — epics now declare `security_review: per-story | epic-level | waived` (with a mandatory reason for the latter two). Reviewer/security/QA respect this without complaining when explicitly deferred or waived, and still block if the policy is missing on stories touching auth, secrets, external input, or data boundaries.
- **Plan Scope Budget** — `PLAN.md` now requires a mandatory budget (max 8 files, ~300 changed lines, complexity tier S/M/L, stated exploration scope) to keep implementation time and token usage predictable. Oversized stories must be split and returned to Gate 2 instead of being planned/executed as-is.
- **Missing gate artifact templates** — added `.apm/templates/PRD.md`, `BACKLOG.md`, `EPIC.md`, `DESIGN.md`, `PLAN.md`, `HISTORY.md`, each with a `status: draft | approved | rejected` header so gate approval is a checked field rather than inferred from conversation.
- **Hardening loop breaker** — after 2 failed hardening cycles on the same story, the responsible agent stops auto-retrying and escalates to the user (descope, split, or accept documented risk) instead of looping through Gate 5/6 a third time.
- **Resumable session state** — `ACTIVE.md` extended with `current_gate`, `current_story`, and `status` fields so interrupted sessions resume at the correct point.
- **Story sizing / effort feedback** — `sdp.analyst` applies INVEST sizing (~1 day/1 PR per story); `sdp.architect` rates story complexity (S/M/L) in `DESIGN.md` so oversized stories are caught before planning rather than during it.

### Changed

- `README.md` — updated Quick Start walkthrough, 6-gate diagram, feedback loop table, agents/prompts/templates reference tables, and source/installed file-tree diagrams to reflect the `sdp.planner`/`sdp.developer` split, security review policy, and new templates.
- `AGENTS.md` (generated) — regenerated via `apm compile`; no longer contains duplicated routing/orchestration content.
- Bumped version to `0.5.0`; expanded default `targets` in `apm.yml` to include `claude`, `cursor`, `codex`, and `gemini` alongside `copilot`.

### Added

- `apm.json` — Agent Package Manager manifest defining package metadata, components (agents, skills, prompts, templates), and installers
- `package.json` — npm ecosystem compatibility manifest with scoped package name `@wojcikmm/spec-development-protocol`
- APM installation method documented in `README.md` (Method 2)
- APM Package Structure section in `README.md` explaining manifest structure and distribution model
- `sdp.developer.agent.md` — new `Approve plan and proceed to implementation` handoff entry in frontmatter, providing a one-click option to approve the plan produced by `/plan-task` and immediately move to implement mode (alternative to manually invoking `/implement`)
- `install.ps1` — PowerShell installer for Windows users (PowerShell 5.1+/7+), feature-parity with `install.sh`: same environment variables (`SDP_BRANCH`, `SDP_FORCE`, `SDP_TECH_MODE`, `SDP_TARGET`), TECH.md modes, commit-SHA versioning for branch installs, and `spec/` directory creation
- `README.md` — Windows Quick Install section with PowerShell one-liner (`iwr … | iex`), execution-policy note, and PowerShell examples for all install scenarios

### Changed

- `install.sh` — versioning now appends the short commit SHA when installing from a branch (e.g., `main@a1b2c3d`), making branch-based installs comparable and traceable; tag-based installs continue to use the tag name unchanged
- `src/skills/` restructured to comply with the [Agent Skills open standard](https://agentskills.io): each skill is now a subfolder (`<skill-name>/`) containing a `SKILL.md` file instead of a flat `sdp.skill.<name>.md` file
  - `sdp.skill.write-tests.md` → `write-tests/SKILL.md`
  - `sdp.skill.create-api-endpoint.md` → `create-api-endpoint/SKILL.md`
  - `sdp.skill.create-ui-component.md` → `create-ui-component/SKILL.md`
  - `sdp.skill.database-migration.md` → `database-migration/SKILL.md`
  - `sdp.skill.error-handling.md` → `error-handling/SKILL.md`
- All skill frontmatter updated to include both `name` and `description` fields (required by the Agent Skills standard)
- `README.md` — Skills section updated: table now lists skill folders instead of flat files; Customization and Project Structure sections updated to reflect the new layout

### Added

- `src/skills/` directory with 5 web-focused skill files:
  - `write-tests/SKILL.md` — unit and integration test guidance (AAA, TDD, behavior-based testing)
  - `create-api-endpoint/SKILL.md` — REST API endpoint design, validation, auth, error handling
  - `create-ui-component/SKILL.md` — frontend component structure, accessibility, state, testing
  - `database-migration/SKILL.md` — safe schema migrations, rollback patterns, zero-downtime techniques
  - `error-handling/SKILL.md` — error classification, structured logging, safe API responses, retries
- `src/templates/template.skill.md` — starter template for writing custom skills
- `src/prompts/qa-validate.prompt.md` — missing prompt for triggering the QA agent (Gate 6)
- `.github/sdp-version` file written by installer to track installed SDP version
- Feedback loops table in `sdlc-process.instructions.md` documenting return paths for each failure type
- Handoff sequence documentation in `sdp.reviewer.agent.md` and `sdp.qa.agent.md`

### Fixed

- `src/prompts/create-prd.prompt.md` was incorrectly set to `agent: sdp.analyst`; corrected to `agent: sdp.prd`
- `sdp.reviewer.agent.md` had duplicate content between `Responsibilities` and `Review Focus` sections; duplicate removed
- `sdp.developer.agent.md` had three concurrent Gate 6 handoffs (reviewer + security + QA simultaneously); now hands off only to `sdp.reviewer` to enforce the sequential Gate 6 flow

### Changed

- `src/templates/TECH.md` — replaced Azure-specific sections (Azure DevOps, Bicep, Azure Key Vault) with platform-agnostic equivalents covering any CI/CD system, hosting provider, and secrets manager; kept web-application focus
- All agent `Mandatory Context` sections updated: removed "Azure environment constraints" wording; now references "project-specific constraints" from `TECH.md`
- `src/agents/sdp.security.agent.md` — replaced Azure security baselines with OWASP Web Top 10 and generic web security checks (CSP, CORS, cookies, secrets manager agnostic)
- `src/agents/sdp.architect.agent.md` — added explicit output path `docs/architecture/DESIGN-<slug>.md`
- All prompts enriched with prerequisite checklists, descriptions of what will happen, and next-gate guidance
- `README.md` — added Skills section, end-to-end Quick Start example table, feedback loops description, `sdp-version` mention; corrected "Agents hand off automatically" to "Agents suggest handoffs"

---

## [v0.1.0] — Initial release

### Added

- 6-gate SDLC process (`sdlc-process.instructions.md`)
- 8 agents: `sdp.prd`, `sdp.discover`, `sdp.analyst`, `sdp.architect`, `sdp.developer`, `sdp.reviewer`, `sdp.security`, `sdp.qa`
- 8 prompts covering all gates
- `copilot-instructions.md` with global coding standards
- `TECH.md` template
- `install.sh` with `SDP_BRANCH`, `SDP_FORCE`, `SDP_TECH_MODE`, `SDP_TARGET` options
- `template.agent.md` and `template.prompt.md`
