---
status: draft
approved_by: pending
approved_at: pending
---

# Backlog: <Feature Title>

Derived from `spec/<slug>/PRD.md`.

## Epics

| ID | Title | Priority | Security Policy | Status |
| --- | --- | --- | --- | --- |
| EPIC-1 | <title> | <P0/P1/P2> | risk-based | draft |

Security policies:

- `risk-based` (default): specialist audit runs only when a security boundary is
  affected.
- `per-story`: audit every included story.
- `epic-level`: audit aggregate changes before final epic acceptance.
- `waived`: skip specialist audit with an explicit reason.

## Stories

| Story ID | Epic | Outcome | Priority | Dependencies |
| --- | --- | --- | --- | --- |
| STORY-1 | EPIC-1 | <observable outcome> | <P0/P1/P2> | <none or IDs> |

Split independently valuable, hazardous, separately reversible, or separately
accepted outcomes. Related stories may form one coherent delivery package.

## Open Decisions

- <only a decision that blocks refinement or design>

---

Approval is required before Gate 3 unless the user explicitly approved a
lightweight path against an existing product contract.
