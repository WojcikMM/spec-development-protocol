---
status: draft
approved_by: pending
approved_at: pending
---

# Design: <Feature Title>

## Architecture and Boundaries

- <affected module> owns <responsibility>
- <external boundary> uses <contract>

## Contracts and Data

- API/event/UI contract: <only changed or relied-upon contracts>
- Data model/state: <only changed or material data decisions>

## Material Non-Functional Decisions

- Security: <trust boundaries and controls, or not materially changed>
- Reliability/compatibility: <applicable constraints>
- Performance/accessibility/operations: <applicable requirements>

## Delivery Shape

| Story | Size | Risk | Uncertainty | Suggested profile | Notes |
| --- | --- | --- | --- | --- | --- |
| STORY-1 | <S/M/L/XL> | <Low/Moderate/High> | <Resolved/Bounded/Open> | <Lean/Balanced/Compliance> | <reason> |

XL or Open work returns to refinement/design. Size does not determine risk.

## Decisions and Trade-offs

- <decision> over <alternative> because <durable rationale>

## Implementation Freedom

- Settled: <contracts and constraints implementation must preserve>
- Developer-owned: <local design choices that do not need approval>

## Open Decisions

- <only unresolved decisions that block planning>

---

Approval is required before `/plan-task` unless the user explicitly approved a
lightweight path using an established design.
