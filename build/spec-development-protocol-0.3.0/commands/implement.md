---
description: Execute an approved implementation plan for a single story.
argument-hint: "Provide the approved plan reference and story ID."
agent: sdp.developer
---

The `sdp.developer` agent will:
1. Execute the steps in the approved `spec/<slug>/PLAN.md`.
2. Modify only the files listed in the plan.
3. Add or update tests as required.

This command requires an approved plan from `plan-task`. It will not run without one.

