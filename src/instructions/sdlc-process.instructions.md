---
description: This file outlines the 6-stage gate process for software development lifecycle (SDLC) to ensure structured and quality delivery.
applyTo: **/*
---
# SDLC Process Instructions (6-Stage Gates)

All work must progress through these gates in order unless an explicit exception is recorded.

---

## Feature Folder Convention

All spec artifacts for a feature live together under `spec/<feature-slug>/` in the project root.

```
spec/
  ACTIVE.md                    ← slug + title of the currently active feature
  <feature-slug>/
    PRD.md                     ← Gate 1 output
    BACKLOG.md                 ← Gate 2 output (epic index)
    EPIC-<N>-<slug>.md         ← Gate 2 output (one per epic)
    DESIGN.md                  ← Gate 3 output
    PLAN.md                    ← Gate 4 output (current implementation plan)
    HISTORY.md                 ← running log of implemented tasks and decisions
```

`ACTIVE.md` format:
```
slug: <feature-slug>
title: <Human Readable Feature Title>
```

All agents read `spec/ACTIVE.md` to determine the working feature when no explicit feature is given in the user's input.

---

## Gate 1: Discovery (PRD)
**Objective:** Define the problem, users, business value, and success metrics.
- Output: `spec/<feature-slug>/PRD.md`
- Owner: `sdp.prd`
- Exit criteria: goals, scope, constraints, risks, and measurable outcomes are clear.
- Side effect: creates `spec/<feature-slug>/` folder and sets `spec/ACTIVE.md`.

## Gate 2: Refinement (Epics/Stories)
**Objective:** Convert PRD into delivery-ready backlog.
- Output: `spec/<feature-slug>/BACKLOG.md` + `spec/<feature-slug>/EPIC-<N>-<slug>.md`
- Owner: `sdp.analyst`
- Exit criteria: stories are testable, scoped, and sequenced.

## Gate 3: Architecture (Tech Spec)
**Objective:** Produce architecture/design that fits complexity and `TECH.md`.
- Output: `spec/<feature-slug>/DESIGN.md`
- Owner: `sdp.architect`
- Exit criteria: design is reviewable, implementable, and traceable to backlog.

## Gate 4: Planning (Task Breakdown)
**Objective:** Create implementation plan for one selected story/task.
- Output: `spec/<feature-slug>/PLAN.md` (overwrite with current plan).
- Owner: `sdp.developer` (plan-task mode)
- Exit criteria: plan is explicit, approved, and bounded to one task.

## Gate 5: Implementation (Coding)
**Objective:** Implement only the approved task plan.
- Output: code + tests + docs updates within planned scope.
- Side effect: append a summary entry to `spec/<feature-slug>/HISTORY.md`.
- Owner: `sdp.developer` (implement mode)
- Exit criteria: implementation complete, tests passing, no out-of-scope edits.

## Gate 6: Hardening (Review → Security → QA)
**Objective:** Validate quality, security, and acceptance criteria.
- Sequence: `sdp.reviewer` → `sdp.security` → `sdp.qa`
- Output: review findings, security audit results, QA validation report.
- Exit criteria: critical issues resolved, AC passed, release readiness confirmed.

---

## Feedback Loops

Gates are sequential but failures route back to the appropriate gate — not to the beginning.

| Finding source | Returns to | Action |
|---|---|---|
| `sdp.reviewer` — Request changes | Gate 5 | Developer fixes review findings, then re-runs Gate 6 from the start |
| `sdp.security` — Critical/High findings | Gate 5 | Developer fixes security issues, then review + security re-run |
| `sdp.security` — Architecture-level issue | Gate 3 | Architect updates design; Gate 4 and 5 must also re-run |
| `sdp.qa` — Fail | Gate 5 | Developer fixes defects, then QA re-validates |
| Blocked story (missing context) | Gate 2 | Analyst updates backlog; downstream gates re-run as needed |
| PRD gaps discovered during design | Gate 1 | PRD agent updates PRD; downstream gates re-run as needed |

**Rule:** Never silently fix-and-continue. Every feedback loop must be explicit — the gate that triggers a return must document what changed and why.

---

## Cross-Gate Rules
- Always reference `@/.github/TECH.md` for stack and standards.
- Maintain bidirectional traceability: PRD -> backlog -> design -> plan -> code -> validation.
- Block progression if current gate artifacts are incomplete or ambiguous.
- One story/task at a time through Gates 4–6. Never bundle stories.
- Always read `spec/ACTIVE.md` to determine the active feature when it is not explicitly provided.
