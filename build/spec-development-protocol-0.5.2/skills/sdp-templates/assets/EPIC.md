---
status: draft
approved_by: pending
approved_at: pending
---

# EPIC-<N>: <Epic Title>

Traceability: `spec/<slug>/PRD.md` -> `spec/<slug>/BACKLOG.md` -> this epic.

## Security Review Policy

- **Policy**: `per-story | epic-level | waived`
- **Reason** (required if `epic-level` or `waived`): `<explicit justification, e.g. "internal tooling, no external input, no auth/data boundary changed">`

> If this policy is left unset and any story below touches auth, secrets, external input, or data boundaries, downstream agents (`sdp.reviewer`) must stop and require it to be set before hardening. If the policy is `epic-level`, the epic carries a `pending_audit` obligation (tracked in `spec/ACTIVE.md`) that is not cleared until the aggregate audit runs and final QA confirms it — see `sdlc-process.instructions.md`.

## Stories

### STORY-<N>: <Story Title>

**As a** `<user/persona>`
**I want** `<capability>`
**So that** `<benefit>`

**Acceptance Criteria**

1. Given `<context>`, when `<action>`, then `<expected result>`.
2. `<negative/edge case criterion>`

**Sizing**: Size `<S/M/L>` (XL must be split), Risk `<Low/Moderate/High>`, Uncertainty `<Resolved/Bounded/Open>` — see Capability Sizing in `sdlc-process.instructions.md`. Rate independently: a small change can still be high-risk.

**Dependencies**: `<other stories/epics, or "none">`

---

_Approval required before proceeding to Gate 3 (`/design-system`). Set `status: approved` above once confirmed._
