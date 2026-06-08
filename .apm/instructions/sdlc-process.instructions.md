---
description: Defines the 6-stage SDLC gate process for structured delivery.
applyTo: "**/*"
---
# SDLC Process Instructions

All work must follow these gates sequentially.

## Feature Folder Convention

All artifacts for a feature are stored in `spec/<feature-slug>/`.

```
spec/
  ACTIVE.md              # Active feature slug and title
  <feature-slug>/
    PRD.md               # Gate 1: Product Requirements
    BACKLOG.md           # Gate 2: Epics and stories
    EPIC-<N>-<slug>.md   # Gate 2: Epic details
    DESIGN.md            # Gate 3: Technical design
    PLAN.md              # Gate 4: Implementation plan
    HISTORY.md           # Log of completed tasks
```

`ACTIVE.md` format:
```
slug: <feature-slug>
title: <Human Readable Feature Title>
```
Agents read `spec/ACTIVE.md` to determine the current feature context.

## AGENTS.md Context Convention

Use `AGENTS.md` to scope context and reduce repository-wide scans.
- Read repository root `AGENTS.md` first.
- Read nearest `AGENTS.md` for the current working subtree.
- The most specific `AGENTS.md` (closest to target files) has precedence.

---

## The 6 Gates

1.  **Discovery (PRD)**: Define the "what" and "why".
    - **Owner**: `sdp.prd`
    - **Output**: `spec/<feature-slug>/PRD.md`

2.  **Refinement (Backlog)**: Break PRD into epics and stories.
    - **Owner**: `sdp.analyst`
    - **Output**: `spec/<feature-slug>/BACKLOG.md`, `EPIC-*.md`

3.  **Architecture (Design)**: Create the technical design.
    - **Owner**: `sdp.architect`
    - **Output**: `spec/<feature-slug>/DESIGN.md`

4.  **Planning (Task Plan)**: Create an implementation plan for one story.
    - **Owner**: `sdp.developer` (plan mode)
    - **Output**: `spec/<feature-slug>/PLAN.md`

5.  **Implementation (Code)**: Execute the approved plan.
    - **Owner**: `sdp.developer` (implement mode)
    - **Output**: Code, tests, and docs. Appends to `HISTORY.md`.

6.  **Hardening (Validate)**: Review, secure, and test.
    - **Sequence**: `sdp.reviewer` → `sdp.security` → `sdp.qa`
    - **Output**: Review, audit, and QA reports.

---

## Feedback Loops

Failures route back to the appropriate gate, not to the start.

| Finding Source | Returns To | Action |
|---|---|---|
| `sdp.reviewer` | Gate 5 | Developer fixes findings. |
| `sdp.security` | Gate 5 or 3 | Developer or Architect fixes issues. |
| `sdp.qa` | Gate 5 | Developer fixes defects. |
| Blocked Story | Gate 2 | Analyst updates backlog. |
| PRD Gaps | Gate 1 | PRD agent updates PRD. |

**Rule**: Never silently fix and continue. Feedback loops must be explicit.

---

## Cross-Gate Rules
- Reference `@/.github/TECH.md` for stack and standards.
- Resolve `AGENTS.md` before broad file searches.
- Maintain traceability: PRD -> Backlog -> Design -> Plan -> Code.
- Block on incomplete or ambiguous artifacts.
- Implement one story at a time through Gates 4-6.
