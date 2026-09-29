---
status: draft
approved_by: pending
approved_at: pending
---

# Design: <Feature Title>

Traceability: `spec/<slug>/BACKLOG.md` / `EPIC-*.md`.

## 1) Architecture Overview

`<summary and rationale, right-sized to the problem>`

## 2) Module Boundaries & Ownership

- `<module/service>` — owns `<responsibility>`

## 3) Contracts

- API: `<endpoint, method, request/response schema>`
- Data schema: `<entities, fields, relations>`

## 4) Patterns Applied

- `<e.g., Ports & Adapters at the DB boundary — only where complexity justifies it>`

## 5) Non-Functional Requirements

- Security: `<authn/authz, data handling>`
- Performance: `<latency/throughput targets>`
- Reliability: `<failure modes, retries>`

## 6) Capability Sizing

| Story ID | Size (S/M/L/XL) | Risk (Low/Moderate/High) | Uncertainty (Resolved/Bounded/Open) | Notes |
| -------- | ---------------- | -------------------------- | -------------------------------------- | ----- |
| STORY-1  | `<S/M/L/XL>`      | `<Low/Moderate/High>`      | `<Resolved/Bounded/Open>`               | `<why; flag related stories that could form one delivery package>` |

> Any story rated **XL**, or with **Open** uncertainty, should be sent back to `sdp.analyst` for splitting or further design before planning. Tightly related stories with resolved/bounded uncertainty may be bundled into a single delivery package at Gate 4 — see `sdlc-process.instructions.md`.

## 7) Trade-offs & Decisions

- `<decision>` — chosen over `<alternative>` because `<rationale>`.

## 8) Open Questions / Assumptions

- `<question or assumption>`

---

_Approval required before proceeding to Gate 4 (`/plan-task`). Set `status: approved` above once confirmed._
