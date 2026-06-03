---
description: Trigger Developer Agent in implement mode to execute an approved implementation plan.
argument-hint: "Provide the approved plan reference, story/task ID, and any execution constraints."
agent: sdp.developer
---

## Before You Start

Make sure the following exist:
- [ ] An approved implementation plan (Gate 4 complete — run `plan-task` first)
- [ ] The plan has been explicitly approved (not just created)
- [ ] You are implementing exactly one story/task — no bundling

## What Happens

The `sdp.developer` agent will:
1. Execute only the steps listed in the approved plan.
2. Modify only the files explicitly listed in the plan.
3. Add or update tests as required by acceptance criteria.
4. Pause and request approval if additional files are needed beyond the plan.

## Next Gate

After implementation → run `run-review` to validate correctness and architecture alignment.

