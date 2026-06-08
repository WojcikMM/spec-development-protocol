---
description: Trigger PRD Agent to draft a Product Requirements Document from business intent.
argument-hint: "Describe the initiative, business goal, target users, and constraints."
agent: sdp.prd
---

## Before You Start

Make sure the following exist or are understood:
- [ ] A clear business problem, feature idea, or change request you want to specify
- [ ] Basic knowledge of who the target users are
- [ ] Any known constraints (timeline, tech, regulatory)

If you have none of the above, start by describing the problem in free text — the PRD agent will help structure it.

## What Happens

The `sdp.prd` agent will:
1. Evaluate your input against a Critical Information Checklist (business goals, users, scope, architecture-relevant decisions).
2. **Ask Q&A questions** for any critical gaps before drafting — it will not silently assume.
3. Once the critical unknowns are resolved, draft a structured `PRD.md`.
4. Flag any remaining minor unknowns as `[ASSUMPTION]` in the `Open Questions` section for your confirmation.
5. Hand off to `sdp.analyst` once you approve the PRD and confirm all `[ASSUMPTION]` items.

## Next Gate

After PRD approval → run `refine-backlog` to break the PRD into epics and user stories.
