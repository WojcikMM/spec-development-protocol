---
description: Create an implementation plan for one approved story. Does not write code.
argument-hint: "Provide one approved story/task ID."
agent: sdp.developer
---

The `sdp.developer` agent will:
1. Create a detailed implementation plan for a single story.
2. The plan will list files to change, steps, tests, and risks.
3. The plan is saved to `spec/<slug>/PLAN.md` for your approval.

This command **does not write code**. After approving the plan, run `implement`.
