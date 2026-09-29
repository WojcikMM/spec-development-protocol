---
description: Defines the 6-stage SDLC gate process, agent routing, and orchestration rules for structured delivery.
applyTo: "**/*"
---

# SDLC Process Instructions

You are operating under the **Spec Development Protocol (SDP)** — a spec-first, gate-driven engineering framework for both greenfield and legacy projects. This file is the **single source of truth** for process, gate ordering, agent routing, and orchestration. Coding standards live separately in `coding-standards.instructions.md`.

All work must follow these gates sequentially unless an explicit exception below applies.

## Mandatory Startup Context

1. Read `@/.github/TECH.md` first — it defines the stack, cloud environment, project-specific standards, and the **Model Policy** (which implementation/assurance model profile applies). All agents and decisions must be consistent with it. If it does not exist, invoke `sdp.discover` before Gate 1 to draft it from repository evidence.
2. Follow the 6-gate SDLC below — never skip or reorder gates without explicit user approval.
3. Route specialized work through the agents in `@/.github/agents/` using the routing table below.
4. Check `@/spec/ACTIVE.md` — if it exists, it names the currently active feature and its progress (slug, title, current gate, current story/delivery, status, `final_status`, and any `pending_audit` obligation). Use it as the default working context for all gate operations when no explicit feature is specified in the user's input, and as the resume point after an interrupted session.
5. Resolve the `AGENTS.md` context chain before broad repo exploration: read root-level `AGENTS.md` plus the nearest `AGENTS.md` files in the target module path and follow their scope constraints.
6. Two execution modes exist for Gates 5-6, and both remain fully supported:
   - **Manual mode** — the user runs `/implement`, `/run-review`, `/audit-security`, `/qa-validate` one at a time, reviewing each result before continuing.
   - **Supervised mode** — the user runs `/deliver` once to approve and execute an approved plan through implementation and hardening in one session, ending at a human acceptance checkpoint (never further). See "Supervised Delivery" below.

## AGENTS.md Context Strategy (Required)

- Use `AGENTS.md` files as scoped context maps to avoid loading unrelated repository areas.
- Resolution order:
  1. Repository root `AGENTS.md` (global rules and boundaries)
  2. Nearest domain-level `AGENTS.md` (for example solution/app folder)
  3. Nearest module-level `AGENTS.md` in the exact implementation path
- If instructions conflict, the most specific (closest) `AGENTS.md` wins for that module.
- Before searching for files, identify the target module and read only its relevant `AGENTS.md` chain.
- Suggested placement in client repositories:
  - One `AGENTS.md` in each meaningful `.NET` library/service folder (typically next to each `.csproj` or library root).
  - One `AGENTS.md` in each frontend app/package root (for example `apps/web`, `src/frontend`, `packages/ui`).

## Agent Routing

| Task                                                    | Agent              | Entry-point prompt |
| -------------------------------------------------------- | ------------------ | ------------------- |
| Legacy stack discovery                                  | `sdp.discover`     | `/discover-tech`   |
| Discovery / PRD creation                                | `sdp.prd`          | `/create-prd`      |
| Backlog refinement (epics, stories, AC)                 | `sdp.analyst`      | `/refine-backlog`  |
| Architecture / technical design                        | `sdp.architect`    | `/design-system`   |
| Delivery-package planning (no code)                     | `sdp.planner`      | `/plan-task`       |
| Implementation (manual, single-shot)                    | `sdp.developer`    | `/implement`       |
| Code and design review (manual, single-shot)            | `sdp.reviewer`     | `/run-review`      |
| Security assessment (manual, single-shot)               | `sdp.security`     | `/audit-security`  |
| Acceptance criteria validation (manual, single-shot)    | `sdp.qa`           | `/qa-validate`     |
| Supervised implementation + hardening, one approval     | `sdp.orchestrator` | `/deliver`         |

**Prefer prompt commands for manual entry.** `/deliver` coordinates Gates 5-6 using the `agent` tool to invoke named specialists, not by executing slash prompts. `/implement`, `/run-review`, `/audit-security`, and `/qa-validate` remain standalone manual entry points. Handoff buttons require user selection even with `send: true`; they are not an autonomous dispatcher.

## SDLC Discipline

- Never write code before an approved implementation plan exists.
- Implement exactly one **delivery package** at a time — a package may bundle tightly related stories that share one coherent, demonstrable outcome (see Capability Sizing), but never bundle unrelated packages.
- Keep every artifact traceable: PRD → backlog → design → plan → code → validation → human acceptance.
- Block on incomplete or ambiguous artifacts.
- Flag and block progression if gate exit criteria are not met.
- A passing QA verdict is **not** completion. It produces `final_status: awaiting-acceptance` in `spec/ACTIVE.md`. Only an explicit human acceptance decision closes the delivery package. Acceptance never itself authorizes committing, merging, deploying, or starting the next package.

---

## Feature Folder Convention

All artifacts for a feature are stored in `spec/<feature-slug>/`.

```
spec/
  ACTIVE.md              # Active feature slug, title, and progress state
  <feature-slug>/
    PRD.md               # Gate 1: Product Requirements
    BACKLOG.md           # Gate 2: Epics and stories
    EPIC-<N>-<slug>.md   # Gate 2: Epic details
    DESIGN.md            # Gate 3: Technical design
    PLAN.md              # Gate 4: Implementation plan
    HISTORY.md           # Log of completed tasks and hardening outcomes
```

Every gate artifact (`PRD.md`, `BACKLOG.md`, `EPIC-*.md`, `DESIGN.md`, `PLAN.md`) MUST follow its template in `.github/templates/` and MUST start with a status header:

```
status: draft | approved | rejected
approved_by: <name or "pending">
approved_at: <ISO date or "pending">
```

Agents MUST treat an artifact as usable input for the next gate **only** when `status: approved` AND `approved_by`/`approved_at` are filled in (not `pending`). Do not infer approval from conversational tone alone — check all three fields. An agent that produces an artifact sets `status: draft` and stops; only the user (or an explicit user instruction such as "approved") flips it to `approved` and fills in `approved_by`/`approved_at`. This check is symmetric across every gate agent that consumes an upstream artifact (`sdp.analyst` checks `PRD.md`, `sdp.architect` checks `BACKLOG.md`/`EPIC-*.md`, `sdp.planner` checks `DESIGN.md`, `sdp.developer`/`sdp.orchestrator` check `PLAN.md`) — none of them may proceed on a `draft` or `rejected` upstream artifact.

`PLAN.md` additionally carries `plan_digest` in its YAML approval header. Compute SHA-256 over the UTF-8 body AFTER the closing frontmatter delimiter and its newline, with CRLF/CR normalized to LF; retain all other whitespace, including the final newline. Exclude the entire header, including the digest itself, to avoid self-reference. Delivery ID, plan revision, upstream content hashes, and all contract terms belong in the hashed body. Missing hash tooling blocks execution; timestamps and word counts are not substitutes. A body or upstream-content mismatch invalidates approval and requires reapproval, never silent digest refresh. Archive the approved plan as `spec/<slug>/plans/<delivery-id>-<revision>.md` before replacing it; references must resolve to exact content, not a moving branch name.

`ACTIVE.md` format:

```
slug: <feature-slug>
title: <Human Readable Feature Title>
current_gate: <1-6>
current_story: <story/delivery id or "n/a">
status: <in-progress | blocked | done>
final_status: <not-started | in-delivery | awaiting-acceptance | accepted | rejected>
pending_audit: [] # list of epic IDs; detailed obligations live in the delivery run record
```

Agents read and update `spec/ACTIVE.md` at the start and end of every gate so work can resume correctly after an interrupted session. `final_status` and `pending_audit` are updated by `sdp.qa`/`sdp.orchestrator` per the Final Human Acceptance and Security Review Policy rules below.

---

## The 6 Gates

1.  **Discovery (PRD)**: Define the "what" and "why".
    - **Owner**: `sdp.prd`
    - **Output**: `spec/<feature-slug>/PRD.md`

2.  **Refinement (Backlog)**: Break PRD into INVEST stories (Independent, Negotiable, Valuable, Estimable, Small, Testable), sized by capability, risk, and uncertainty rather than day/file/line caps.
    - **Owner**: `sdp.analyst`
    - **Output**: `spec/<feature-slug>/BACKLOG.md`, `EPIC-*.md`
    - Each epic declares a `security_review` policy (see Security Review Policy below).

3.  **Architecture (Design)**: Create the technical design, including a rough complexity/effort rating per story so oversized stories are caught before planning.
    - **Owner**: `sdp.architect`
    - **Output**: `spec/<feature-slug>/DESIGN.md`

4.  **Planning (Delivery Plan)**: Create an implementation plan for exactly one **delivery package** — one coherent, demonstrable capability, which may bundle tightly related stories that share the same outcome. **Does not write code.**
    - **Owner**: `sdp.planner`
    - **Output**: `spec/<feature-slug>/PLAN.md`, including a mandatory Capability Sizing declaration and Delivery Contract (see below).

5.  **Implementation (Code)**: Execute the approved plan exactly.
    - **Owner**: `sdp.developer`
    - **Output**: Code, tests, and docs. Appends to `HISTORY.md`.
    - **Terminal step**: once implementation is complete, the only valid next action is handing off to `sdp.reviewer` (manual mode) or returning a structured result to `sdp.orchestrator` (supervised mode). `sdp.developer` never re-invokes itself and never regenerates `PLAN.md` on its own initiative.

6.  **Hardening (Validate)**: Review, secure, and test — ending at a human acceptance checkpoint, never at automatic completion.
    - **Sequence**: `sdp.reviewer` → `sdp.security` (unless waived/deferred, see policy below) → `sdp.qa` → human acceptance decision.
    - **Output**: Review, audit, and QA reports appended to `HISTORY.md`; `spec/ACTIVE.md`: `final_status: awaiting-acceptance` on QA pass.

---

## Capability Sizing (Gate 4, mandatory)

Every `PLAN.md` MUST declare a size, a risk level, and an uncertainty level before it can be approved. These replace fixed file/line/day caps, which optimized for document size rather than delivery coherence.

| Size | Delivery shape | Execution approach |
| ---- | --------------- | -------------------- |
| S    | One bounded behavior change with known contracts | One package, short work graph, focused assurance |
| M    | One end-to-end capability crossing established layers | One package with internal integration checkpoints |
| L    | A cohesive subsystem capability with several interacting flows | One package when contracts are resolved; staged implementation steps and aggregate regression evidence |
| XL   | Multiple independently useful capabilities, unresolved architecture, or independently hazardous rollout units | Split — return to Gate 2 (`sdp.analyst`) along outcome, ownership, or rollback boundaries |

- **Risk**: `Low | Moderate | High`, based on blast radius, privilege, sensitive data, reversibility, and external exposure. Rate independently of size — a two-file authorization fix can be `S`/`High`.
- **Uncertainty**: `Resolved | Bounded | Open`. `Bounded` permits named implementation choices within the contract. `Open` uncertainty about public behavior, data loss, or architecture blocks approval until Gate 3 resolves it — do not hide it inside a larger size label.

**Split rule**: split when outcomes must be accepted separately, rollbacks must be independent, ownership boundaries require different approvals, verification cannot cover the combined candidate, or the human cannot meaningfully review the decision brief in one sitting. Do not split solely because a diff is estimated to cross a fixed file or line count — file/line/test counts remain useful **review information** in `PLAN.md`, not a hard permission boundary.

**Rule**: If a delivery package is rated `XL`, or if its uncertainty is `Open`, `sdp.planner` MUST stop and recommend splitting or returning to Gate 2/3 for re-slicing or further design, instead of producing an under-specified plan. Do not silently plan past unresolved uncertainty.

## Delivery Contract & Identity (Gates 4-6)

Every `PLAN.md` carries a **Delivery Contract** in addition to its narrative plan:

- **Delivery ID** — stable identifier for this package (e.g. the story/epic slug plus a sequence number).
- **Plan digest** — see the plan-digest rule above; recorded at approval time, invalidated by any later edit to the plan body.
- **Upstream references** — which `PRD.md` / `BACKLOG.md` / `EPIC-*.md` / `DESIGN.md` revisions this plan was built from.
- **Change boundary** — allowed modules/paths, expected files, explicitly excluded areas, and any dependency/migration constraints. The developer may make reasonable adjacent changes within this boundary (e.g. an obviously-related test file) without stopping, but must stop and flag if the boundary itself needs to expand.
- **Model policy reference** — which model profile from `TECH.md` applies to implementation vs. assurance for this package (see Model Policy in `TECH.md`).

**Candidate identity** is the exact set of relevant tracked and untracked working-tree content under review at a given moment — not just the last commit. Any product-code change after a review/security/QA result invalidates that result; the changed candidate must re-enter assurance starting from code review. Appending report metadata (e.g. a HISTORY.md entry) does not itself invalidate a candidate. If a trustworthy candidate identity cannot be established with the tools available (e.g. no way to diff the working tree), the agent must say so and treat the result as unverified rather than silently assume the candidate is unchanged.

## Gate 4 → Gate 5 Handoff (Loop Prevention)

`sdp.planner` (plan-task) and the Gate 5/6 executors (`sdp.developer` manually, `sdp.orchestrator` under supervised mode) are **separate agents** with **no self-referencing handoff**. This prevents the plan → implement → implement → implement loop seen when a single agent's mode is ambiguous:

- `sdp.planner` only ever produces `PLAN.md` with `status: draft` and stops. It never calls itself and never calls `sdp.developer`/`sdp.orchestrator` automatically.
- Moving from Gate 4 to Gate 5 always requires an explicit user action: approving the plan (`status: approved`, `approved_by`/`approved_at` filled in), then either:
  - running `/implement` for manual, single-shot execution, or
  - running `/deliver` once to approve-and-run the full Gate 5-6 sequence under `sdp.orchestrator`, stopping at the human acceptance checkpoint.
- `sdp.developer` only ever hands off forward to `sdp.reviewer` (manual mode) or returns its result to `sdp.orchestrator` (supervised mode) after implementation. It never re-enters implementation or planning on its own.
- If an approved plan needs to change mid-implementation, the executor MUST stop, explain why, and request the user route back to `/plan-task` for an amended, re-approved plan (which invalidates the prior plan digest) — it must not silently keep "implementing" in a loop.

## Supervised Delivery (`/deliver`, Gates 5-6)

`/deliver approve-and-run <delivery-id> <plan-revision>` explicitly authorizes approval of that exact presented plan and starts execution after preflight. The coordinator records the user's approval fields and computes the digest; merely editing `status` does not calculate a hash. `/deliver run <delivery-id> <plan-revision>` requires an already approved, matching plan. Bare `/deliver` never approves or executes. Resume and decision actions are defined in `sdp.orchestrator`; acceptance always names the exact candidate.

`sdp.orchestrator` is a **coordinator**, not another implementer:

- It validates the plan's approval, digest, upstream revisions, and Model Policy reference before dispatching anything ("preflight"). A failed preflight blocks with a specific reason — it never guesses and proceeds.
- It dispatches `sdp.developer`, then `sdp.reviewer`, then `sdp.security` (per every included epic's policy), then `sdp.qa`, one at a time. Specialists return structured results and never invoke one another under supervision. A package covering multiple stories must map every AC and every security obligation to evidence; bundling does not waive per-story audits.
- Only `sdp.developer` may write product source code. `sdp.reviewer`, `sdp.security`, and `sdp.qa` may execute read-only inspection and run validation commands, but must not modify product code; if a finding needs a code change, it goes back to `sdp.developer` as a bounded repair, not a self-fix.
- The orchestrator is the single writer of `spec/ACTIVE.md` and the Delivery Run Record during a supervised run, to avoid two agents racing to update the same state.
- On any product-code repair, the changed candidate re-enters assurance starting from `sdp.reviewer` — prior review/security/QA results for the old candidate are stale and must not be reused.
- **Repair ceiling**: one automatic repair round after the first rejected candidate for this delivery package. A second rejected candidate — at any stage (review, security, or QA) — escalates to the user instead of attempting a third round. A tool/model/environment failure that blocks a stage (not a quality rejection) does not count toward this ceiling, but must not be silently retried forever either — report it as `Blocked` and ask the user how to proceed if it recurs.
- **Contract drift**: if the work cannot be completed within the plan's declared change boundary, the orchestrator stops and requests an amended, re-approved plan — it does not silently expand scope.
- On QA pass, the orchestrator sets `spec/ACTIVE.md`: `final_status: awaiting-acceptance` and produces a short acceptance brief (outcome, AC coverage with evidence links, review/security/QA verdicts, deviations, remaining risks). It stops there. It does not mark the story/epic `done`, does not advance to the next delivery package, and does not commit, merge, or deploy anything.
- This is a customization-layer workflow running inside an active agent session — it does not provide durable background execution, authenticated approval, or a tamper-proof audit trail. If the session ends mid-run, resume with `/deliver` referencing the same delivery ID; the orchestrator re-validates the plan, baseline, and last completed stage before continuing, and treats an unverifiable prior stage as not yet done rather than assuming it passed.

Manual mode (`/implement`, `/run-review`, `/audit-security`, `/qa-validate` run one at a time by the user) remains fully valid and is the required fallback when supervised orchestration, a specific tool, or a required model profile is unavailable.

### Run State and Worker Contract

Use `.github/templates/DELIVERY-RUN.json` for one `spec/<slug>/deliveries/<delivery-id>.json` run record, in both modes. It is a data template, not an executable state machine. Before each transition, parse it with a JSON parser and validate the required fields and verdict values documented in `HISTORY.md`. The coordinator owns it in supervised mode; in manual mode the currently invoked role appends its result and updates state. Reviewer has no write tools, so its returned record must be persisted by the next manual role or by `/deliver resume` before progression; missing records block, never imply approval.

Preflight records HEAD, a path-sorted content-hash manifest of baseline tracked and relevant untracked files, and the environment/dependency fingerprint. Candidate identity hashes that manifest after implementation, including tests/configuration and deletions. Explicitly exclude only run/history/ACTIVE reporting metadata and declared generated outputs; do not exclude source, tests, lockfiles, plans, or policy files. Record pre-existing user changes without reverting them. Workers receive this baseline, the exact candidate and plan identities, scoped context, ACs, prior findings, model policy, and remaining resource budget. Independent assurance inspects raw changes and actual results, not only a developer summary.

Every stage returns `pass | fail | blocked | not_applicable`, identities, stable findings, scope changes, and checks with command/environment, exit/result, and evidence reference. Missing evidence, malformed records, interrupted checks, or an unverified identity mean `blocked`, never `pass`. `not_applicable` requires a policy reason. Required unmet ACs fail QA; Critical/High findings fail assurance, while Medium/Low remain documented debt. Recheck identities after each stage and at acceptance. Any relevant change invalidates prior assurance and restarts review; approval drift additionally requires reapproval.

On resume, reconcile completed work steps and external side effects (including migrations) before rerunning commands; never blindly repeat destructive or externally visible operations. Preserve unrelated user work and block on concurrent conflicts. Restore the existing rejection count, obligations, and budget across sessions and amendments; a new run ID does not reset limits. Increment once per distinct rejected candidate, not once per finding or repeated inspection. Stop on the first environment/tool/model block; retry only after the cause is resolved and within the approved budget. Budget exhaustion, destructive operations outside approval, and scope drift stop immediately.

Model profiles in TECH are policy, not automatic routing. Verify available configured worker models, permitted equivalent fallbacks, and coordinator cost-tier eligibility before dispatch. No unverifiable mandatory model or silent downgrade is permitted. Record actual model/cost only when exposed. Tool lists reduce available tools but do not sandbox `execute`/`edit`; restrict these by instructions and the user's runtime permissions. VS Code Copilot Local is the initial target; other harnesses use manual mode until dispatch behavior is tested. No live runtime compatibility is established by static validation.

---

## Hardening Gate Rules (Gate 6)

### Unified Severity Taxonomy

`sdp.reviewer`, `sdp.security`, and `sdp.qa` all use the same four-level severity scale so findings can be aggregated and gated consistently:

| Severity     | Meaning                                          | Gate outcome                           |
| ------------ | ------------------------------------------------ | -------------------------------------- |
| **Critical** | Breaks correctness, security, or data integrity  | Always blocks; must return to Gate 5   |
| **High**     | Significant risk or defect, must fix before ship | Blocks; must return to Gate 5          |
| **Medium**   | Should fix, does not block this story            | Logged in `HISTORY.md` as tracked debt |
| **Low**      | Cosmetic/suggestion                              | Logged only, no action required        |

### Security Review Policy (per-epic, configurable)

Security audits are not always required per-story. `BACKLOG.md`/`EPIC-*.md` declares one of:

- **`per-story` (default)** — `sdp.security` runs on every story before QA.
- **`epic-level`**: the first deferral records the epic ID in `pending_audit` and its original baseline, covered deliveries, and closure evidence in the run record. Intermediate packages may pass QA and be accepted with the obligation prominently disclosed; this does not close or authorize release of the epic. When a package implements the epic's final outstanding stories, dispatch `sdp.security` against the aggregate epic changes BEFORE final QA, even though earlier packages deferred it. Clear only that epic's obligation after a passing aggregate audit AND final QA on the unchanged candidate; escalation is not a pass. Repairs reopen affected obligations. Multiple epics retain separate obligations, including when ACTIVE moves between packages.
- **`waived`** — Security audit is intentionally skipped, with a documented reason recorded in the epic's `security_review` field (e.g., "internal tooling, no external input, no auth/data boundary changed"). `sdp.reviewer` hands off directly to `sdp.qa` and logs the waiver and reason in `HISTORY.md`. Agents must not complain or block when a waiver is explicitly declared — but must complain and stop if `security_review` is unset/ambiguous on a story that touches auth, secrets, external input, or data boundaries.

### Loop Breaker / Escalation

Hardening feedback loops (reviewer/security/qa → developer → hardening again) are capped by a **central rejected-candidate count per delivery package**, not by which stage rejected it:

- **After the 2nd rejected candidate for the same delivery package** — regardless of whether review, security, or QA rejected it, and regardless of whether the 1st and 2nd rejections came from the same or different stages — the responsible agent (or `sdp.orchestrator` in supervised mode) MUST stop auto-retrying and escalate to the user for a decision (e.g., descope, split the package, accept documented risk) instead of routing back to Gate 5 a third time.
- A tool/model/environment failure that blocks a stage from running is `Blocked`, not a rejection, and does not consume this count — but a recurring block still must not be retried silently forever; ask the user how to proceed if it recurs.
- Escalations are logged in `HISTORY.md` with the rejected-candidate count and reason.

## Final Human Acceptance (after Gate 6)

A `sdp.qa` Pass is a technical verdict, not a release decision. On Pass:

- `spec/ACTIVE.md` moves to `final_status: awaiting-acceptance` (not `status: done`).
- If the story's epic has an outstanding `pending_audit`, it is not cleared by this Pass alone — see Security Review Policy above.
- The agent (manual `sdp.qa`, or `sdp.orchestrator` in supervised mode) produces a short acceptance brief: delivered outcome, AC coverage with evidence, review/security/QA verdicts, deviations, and remaining risks.
- Only an explicit human decision — accept, request a bounded correction, or reject — changes `final_status` to `accepted` or `rejected`. No agent may infer acceptance from silence or from starting the next delivery package.
- Acceptance confirms the verified candidate meets its contract. It does **not** itself authorize committing, merging, deploying, or planning/running the next delivery package — those remain separate explicit user actions.
- Before recording acceptance, revalidate the exact plan and candidate and all required evidence. Record user identity, time, and decision. If this completes the feature and no audit is pending, `status: done` may be set; otherwise keep the accepted package selected. Selecting or starting the next package requires a separate explicit user action.

---

## Feedback Loops

Failures route back to the appropriate gate, not to the start.

| Finding Source                              | Returns To          | Action                                          |
| --------------------------------------------- | -------------------- | -------------------------------------------------- |
| `sdp.reviewer` (Critical/High)                | Gate 5              | Developer fixes findings.                       |
| `sdp.security` (Critical/High)                | Gate 5 or 3         | Developer or Architect fixes issues.             |
| `sdp.qa` (fail)                               | Gate 5              | Developer fixes defects.                        |
| Blocked delivery package                      | Gate 2              | Analyst updates backlog.                        |
| PRD Gaps                                     | Gate 1              | PRD agent updates PRD.                          |
| 2nd rejected candidate for the same package  | User (escalation)   | User decides: descope, split, or accept risk.   |
| Final-epic QA missing aggregate audit evidence | Aggregate audit | Run the due audit before final QA and epic acceptance. |

**Rule**: Never silently fix and continue. Feedback loops must be explicit. See Loop Breaker above for the retry cap.

---

## Cross-Gate Rules

- Reference `@/.github/TECH.md` for stack, standards, and Model Policy.
- Resolve `AGENTS.md` before broad file searches.
- Maintain traceability: PRD -> Backlog -> Design -> Plan -> Code -> Validation -> Acceptance.
- Block on incomplete, ambiguous, or unapproved (`status: draft`/`rejected`) artifacts, or on a `PLAN.md` whose digest no longer matches its approved body.
- Implement one delivery package at a time through Gates 4-6; a package may bundle tightly related stories (see Capability Sizing) but never unrelated ones.
- Prefer the prompt commands (`/create-prd`, `/refine-backlog`, `/design-system`, `/plan-task`, `/implement`, `/run-review`, `/audit-security`, `/qa-validate`, `/discover-tech`, `/deliver`) over manually invoking an agent.
