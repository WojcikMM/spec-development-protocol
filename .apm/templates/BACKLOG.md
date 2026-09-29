---
status: draft
approved_by: pending
approved_at: pending
---

# Backlog: <Feature Title>

Traceability: derived from `spec/<slug>/PRD.md`.

## Epics

| ID     | Title          | Priority     | Security Review Policy              | Status  |
| ------ | -------------- | ------------ | ----------------------------------- | ------- |
| EPIC-1 | `<epic title>` | `<P0/P1/P2>` | `per-story \| epic-level \| waived` | `draft` |

> **Security Review Policy** (declared per epic, see `EPIC-*.md` for details/reason):
>
> - `per-story` (default) — security audit runs on every story.
> - `epic-level` — security audit deferred until all stories in the epic are implemented, then runs once.
> - `waived` — security audit intentionally skipped; reason is mandatory and recorded in the epic file.

## Story Sizing Rule

Stories must satisfy INVEST (Independent, Negotiable, Valuable, Estimable, Small, Testable). Related stories that share one coherent, demonstrable outcome may later be bundled into a single delivery package at Gate 4 — see Capability Sizing in `sdlc-process.instructions.md` (size S/M/L/XL, plus independent risk and uncertainty ratings). Split a story here, before Gate 3, if it is independently hazardous, needs independent rollback, or cannot be verified together with the rest of its epic.

## Stories (summary — full AC in EPIC-<N>-<slug>.md)

| Story ID | Epic   | Title           | Priority     |
| -------- | ------ | --------------- | ------------ |
| STORY-1  | EPIC-1 | `<story title>` | `<P0/P1/P2>` |

## Open Questions / Assumptions

- `<question or assumption>`

---

_Approval required before proceeding to Gate 3 (`/design-system`). Set `status: approved` above once confirmed._
