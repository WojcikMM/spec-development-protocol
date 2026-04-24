---
description: Trigger Analyst Agent to convert an approved PRD into prioritized epics, features, and user stories.
argument-hint: "Provide PRD scope, priorities, and any sequencing constraints."
agent: sdp.analyst
---

## Before You Start

Make sure the following exist:
- [ ] An approved `PRD.md` in the repository root (Gate 1 complete)
- [ ] Open questions in the PRD resolved or documented
- [ ] Stakeholder sign-off on goals and in-scope boundaries

## What Happens

The `sdp.analyst` agent will:
1. Read the approved `PRD.md` in full.
2. Break it into prioritized epics and user stories with acceptance criteria.
3. Create `BACKLOG.md` and `docs/backlog/EPIC-*.md` files.
4. Flag any remaining open questions that could block implementation.

## Next Gate

After backlog approval → run `design-system` to produce the technical architecture.
