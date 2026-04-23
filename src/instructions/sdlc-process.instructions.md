---
description: This file outlines the 6-stage gate process for software development lifecycle (SDLC) to ensure structured and quality delivery.
applyTo: **/*
---
# SDLC Process Instructions (6-Stage Gates)

All work must progress through these gates in order unless an explicit exception is recorded.

## Gate 1: Discovery (PRD)
**Objective:** Define the problem, users, business value, and success metrics.
- Output: `./PRD.md`
- Owner: PRD
- Exit criteria: goals, scope, constraints, risks, and measurable outcomes are clear.

## Gate 2: Refinement (Epics/Stories)
**Objective:** Convert PRD into delivery-ready backlog.
- Output: `./BACKLOG.md`, `./docs/backlog/EPIC-<N>-<slug>.md`, optional `./docs/qa/ACL.md`.
- Owner: Analyst
- Exit criteria: stories are testable, scoped, and sequenced.

## Gate 3: Architecture (Tech Spec)
**Objective:** Produce architecture/design that fits complexity and `TECH.md`.
- Output: `./docs/architecture/ADL.md` plus `./docs/architecture/ADR-<N>-<slug>.md` for major decisions.
- Owner: Architect
- Exit criteria: design is reviewable, implementable, and traceable to backlog.

## Gate 4: Planning (Task Breakdown)
**Objective:** Create implementation plan for one selected story/task.
- Output: `./docs/plans/IMPLEMENTATION-PLAN-<TASK-ID>.md`.
- Owner: Developer
- Exit criteria: plan is explicit, approved, and bounded to one task.

## Gate 5: Implementation (Coding)
**Objective:** Implement only the approved task plan.
- Output: code + tests + docs updates within planned scope, and `./CHANGELOG.md` when behavior changes.
- Owner: Developer
- Exit criteria: implementation complete, tests passing, no out-of-scope edits.

## Gate 6: Hardening (Review/Security/QA)
**Objective:** Validate quality, security, and acceptance criteria.
- Output: `./docs/review/REVIEW-<TASK-ID>.md`, `./docs/security/SECURITY-AUDIT-<TASK-ID>.md`, and `./docs/qa/QA-REPORT-<TASK-ID>.md`.
- Owners: Reviewer, Security, QA
- Exit criteria: critical issues resolved, AC passed, release readiness confirmed.

## Cross-Gate Rules
- Always reference `@/.github/TECH.md` for stack and standards.
- Maintain bidirectional traceability: PRD -> backlog -> design -> plan -> code -> validation.
- Block progression if current gate artifacts are incomplete or ambiguous.
- Canonical artifact directories:
	- Root: `PRD.md`, `BACKLOG.md`, `CHANGELOG.md`
	- Backlog: `docs/backlog/`
	- Architecture: `docs/architecture/`
	- Planning: `docs/plans/`
	- Review: `docs/review/`
	- Security: `docs/security/`
	- QA: `docs/qa/`
