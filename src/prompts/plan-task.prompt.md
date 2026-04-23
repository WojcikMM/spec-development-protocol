---
description: Trigger Developer Agent in plan-task mode to create an implementation plan for one approved story — no code yet.
argument-hint: "Provide one approved story/task ID and any constraints for implementation planning."
agent: sdp.developer
---

## Before You Start

Make sure the following exist:
- [ ] An approved technical design in `docs/architecture/` (Gate 3 complete)
- [ ] The specific story/task ID you want to implement (from `BACKLOG.md`)
- [ ] Story acceptance criteria are clear and unambiguous

## What Happens

The `sdp.developer` agent will:
1. Create an explicit implementation plan: files to change, steps, tests needed, and rollback notes.
2. **Not write any code** — planning only.
3. Present the plan for your approval before moving to implementation.

## Next Gate

After plan approval → run `implement` with the same story ID to execute the plan.
