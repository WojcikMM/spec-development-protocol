---
description: Trigger Reviewer Agent to review implemented changes for correctness, maintainability, and architecture alignment.
argument-hint: "Provide change scope, design/plan references, and review priorities."
agent: sdp.reviewer
---

## Before You Start

Make sure the following exist:
- [ ] Implementation complete (Gate 5 done — run `implement` first)
- [ ] Approved implementation plan available for reference
- [ ] Technical design from `docs/architecture/` available

## What Happens

The `sdp.reviewer` agent will:
1. Review logical correctness, edge-case handling, and readability.
2. Verify adherence to architecture and module boundaries defined in the design.
3. Check test quality and coverage for the changed behavior.
4. Flag scope creep and regressions.
5. Produce findings categorized as Critical / Major / Minor / Suggestion.

## Outcomes

- **Approve** → run `audit-security` next.
- **Approve with conditions** → minor fixes can be done before or alongside security audit.
- **Request changes** → `sdp.reviewer` hands off back to `sdp.developer` with a fix list.
