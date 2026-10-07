---
status: draft
approved_by: pending
approved_at: pending
---

# Plan: <Delivery Package Title> (<delivery-id>)

## Outcome and Demonstration

- **Outcome**: <what will work when this delivery is accepted>
- **Demonstration**: <short reproducible way to observe it>
- **Included stories / acceptance criteria**: <IDs and concise behaviors>
- **Non-goals**: <explicit exclusions>

## Relevant Context and Decisions

- Read: <scoped AGENTS.md, design sections, owning code, neighboring tests>
- Settled decisions: <contracts and constraints carried from approved artifacts>
- Implementation choices left open: <safe decisions owned by the developer>

## Delivery Shape

| Field | Value |
| --- | --- |
| Size | <S / M / L> |
| Risk | <Low / Moderate / High> |
| Uncertainty | <Resolved / Bounded> |
| Assurance profile | <Lean / Balanced / Compliance> |
| Security policy | <risk-based / per-story / epic-level / waived: reason> |

If size is XL or uncertainty is Open, stop and return to refinement/design.

## Change Boundary

- **Allowed paths**: <paths or modules>
- **Expected changes**: <likely files and purpose>
- **Explicit exclusions**: <areas that must not change>
- **Dependencies, data, or migration constraints**: <only applicable constraints>

## Work

1. <implementation step> - Verify: <command or observable check>
2. <implementation step> - Verify: <command or observable check>

## Verification

| Acceptance behavior | Evidence/check | Expected result |
| --- | --- | --- |
| <behavior> | <test, command, or demonstration> | <result> |

## Applicable Risk and Recovery

- Security-sensitive boundaries: <none or details>
- Compatibility/migration: <none or details>
- Rollback/recovery: <not needed or concise approach>

## Autonomy and Escalation

- Developer owns: naming, idiomatic local design, helper reuse/extraction, and
  adjacent tests inside the boundary.
- A simpler in-boundary approach may proceed when outcome, risk, and
  verification remain unchanged.
- Replan for: changed public behavior, new dependency/service, expanded
  security/data boundary, destructive operation, weakened acceptance criterion,
  or work outside allowed paths.

---

Review this plan, then run bare `/deliver` to approve and execute it. Manual
`/implement` requires approval metadata above to be filled in first.
