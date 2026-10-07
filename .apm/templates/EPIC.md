---
status: draft
approved_by: pending
approved_at: pending
---

# EPIC-<N>: <Epic Title>

## Outcome

<The coherent product capability and user value.>

## Security Policy

- **Policy**: `risk-based | per-story | epic-level | waived`
- **Reason**: <required for per-story, epic-level, or waived>

`risk-based` is the default. Security still runs when changes affect
authentication, authorization, secrets, untrusted input, sensitive data,
cryptography, trust boundaries, dependency/infrastructure security, or a
regulated control.

## Stories

### STORY-<N>: <Story Title>

- **As a** <user/persona>
- **I want** <capability>
- **So that** <benefit>

**Acceptance Criteria**

1. Given <context>, when <action>, then <observable result>.
2. <material negative or edge behavior>.

**Dependencies**: <none or IDs>

## Open Decisions

- <only unresolved product decisions>

---

Approval is required before design unless the user explicitly approved a
lightweight path against an existing contract.
