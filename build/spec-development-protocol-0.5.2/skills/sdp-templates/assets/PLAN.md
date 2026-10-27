---
status: draft
approved_by: pending
approved_at: pending
plan_digest: pending
---

# Plan: <Delivery Package Title> (DP-<N>)

Traceability: `spec/<slug>/DESIGN.md` -> `spec/<slug>/EPIC-<N>-<slug>.md` (`STORY-<N>`, `STORY-<M>`, ...). A delivery package may bundle tightly related stories that share one coherent, demonstrable outcome — list every story ID it covers.

## Delivery Identity (mandatory)

| Field | Value |
| ----- | ----- |
| Delivery ID | `<slug>-DP-<N>` |
| Plan revision | `<immutable revision identifier>` |
| Upstream references | `<PRD/BACKLOG/relevant EPIC/DESIGN paths and exact content SHA-256 hashes>` |
| Model policy reference | `<profile name from TECH.md Model Policy, e.g. "standard">` |

## Human Decision Brief

- **Outcome / demo**: `<what will work when this delivery is accepted>`
- **Included stories & AC IDs**: `<STORY-N: AC1, AC2; STORY-M: AC1>`
- **Explicit non-goals**: `<what this package deliberately does not do>`
- **Public/behavioral/security/data/compatibility changes**: `<list, or "none">`
- **Key design decisions & tradeoffs**: `<carried from DESIGN.md, plus any refinement>`

## Capability Sizing (mandatory)

| Field | Value | Guidance |
| ----- | ----- | -------- |
| Size | `<S/M/L>` (XL must be split — see below) | See `sdlc-process.instructions.md` Capability Sizing |
| Risk | `<Low/Moderate/High>` | Independent of size — rate blast radius, privilege, data sensitivity, reversibility |
| Uncertainty | `<Resolved/Bounded/Open>` | `Open` blocks approval — resolve via Gate 3 first |
| Files/lines (informational) | `<estimate>` | Review information only, not a hard cap |

**If this package is `XL`, or its uncertainty is `Open`, STOP.** Do not produce an under-specified plan — recommend splitting or returning to Gate 2/3.

## Execution Contract

### Context Map and Decisions

- Read only `<relevant AGENTS.md chain, DESIGN sections, owning modules and neighboring tests>` before expanding exploration for a stated blocker.
- Settled decisions: `<contracts and ADR references>`; bounded choices: `<implementation choices left to the developer>`.
- Security coverage: `<each story -> epic -> per-story audit / aggregate obligation / waiver reason>`.

### Change Boundary

- **Allowed modules/paths**: `<pattern(s)>`
- **Expected files**: `<path/to/file>` — `<what changes and why>`
- **Explicitly excluded**: `<areas that must not change>`
- **Dependency/migration constraints**: `<none, or specifics>`

## Work Graph

Ordered steps; each traces to an AC ID and has an executable check. Keep steps small enough to verify, without requiring separate approval per step.

1. `<step>` — AC: `<STORY-N:AC1>` — Check: `<command/observable outcome>`
2. `<step>` — AC: `<STORY-N:AC2>` — Check: `<command/observable outcome>`

## Verification Matrix

| AC ID | Test case | Command | Expected result |
| ----- | --------- | ------- | ---------------- |
| `<STORY-N:AC1>` | `<test case>` | `<command>` | `<expected result>` |

## Autonomy Policy

- **Permitted implementation choices**: `<e.g., naming, reuse of existing helpers, adding tests within the change boundary>`
- **Requires reapproval**: new external dependency, new service, changed public contract, weakened AC, expanded data/security boundary.
- **Escalation triggers**: `<conditions that stop implementation and require the user>`

## Operational Limits

- Resource ceiling: `<explicit dispatch/time/tool-call ceilings for this run, and how measured; stop when exhausted>`
- Repair ceiling: 1 automatic repair round after the first rejected candidate; 2nd rejection escalates (see `sdlc-process.instructions.md`).

## Recovery & Rollback

- Local reversal: `<how to revert this package's changes>`
- Compatibility fallback: `<if applicable>`
- Migration recovery: `<if applicable>`
- Resume-after-interruption notes: `<what to re-check before continuing a supervised run>`

---

_Approval required before implementation. Request `/deliver approve-and-run <delivery-id> <plan-revision>` to record explicit approval and compute the header digest before execution, or approve and record the same metadata before `/implement`. Editing `status` alone does not fill other fields or compute a digest. Hash only the body after frontmatter as specified in the process instructions._
