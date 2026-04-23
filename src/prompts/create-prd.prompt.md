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
1. Extract the core problem and business value from your input.
2. Draft a structured `PRD.md` with goals, scope, constraints, and open questions.
3. Hand off to `sdp.analyst` once you approve the PRD.

## Next Gate

After PRD approval → run `refine-backlog` to break the PRD into epics and user stories.
