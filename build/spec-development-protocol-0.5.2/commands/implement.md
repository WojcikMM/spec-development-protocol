---
description: Execute an approved implementation plan for one delivery package (manual, single-shot).
argument-hint: "Provide the approved plan reference and delivery/story ID."
agent: sdp.developer
---

The `sdp.developer` agent will:

1. Verify `spec/<slug>/PLAN.md` has `status: approved` with a matching plan digest — it refuses to run otherwise.
2. Execute the steps in the approved plan's Work Graph, staying within its declared Change Boundary.
3. Add or update tests as required by the Verification Matrix.
4. Hand off once to `sdp.reviewer` when done — it will not loop back into implementation on its own.

This command requires an approved plan from `/plan-task`. It will not run without one. This is the manual, single-shot entry point; `/deliver` runs the same agent under supervision through the full hardening sequence, stopping at human acceptance.
