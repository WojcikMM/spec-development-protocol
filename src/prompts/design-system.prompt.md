---
description: Trigger Architect Agent to produce a technical design for approved backlog stories.
argument-hint: "Describe the story/feature scope and any architecture constraints."
agent: sdp.architect
---

## Before You Start

Make sure the following exist:
- [ ] An approved `BACKLOG.md` and at least one `docs/backlog/EPIC-*.md` (Gate 2 complete)
- [ ] A filled-in `.github/TECH.md` with your stack and standards
- [ ] The stories you want designed are clearly scoped and prioritized

## What Happens

The `sdp.architect` agent will:
1. Read the approved backlog stories and TECH.md.
2. Produce a right-sized technical design (no overengineering for simple scope).
3. Define module boundaries, contracts (API/data schemas), and NFR coverage.
4. Save the design to `docs/architecture/DESIGN-<slug>.md`.

## Next Gate

After design approval → run `plan-task` with one story at a time to create an implementation plan.
