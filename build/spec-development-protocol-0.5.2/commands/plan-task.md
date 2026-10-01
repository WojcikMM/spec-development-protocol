---
description: Create an implementation plan for one approved delivery package. Does not write code.
argument-hint: "Provide one or more tightly related approved story IDs forming one delivery package."
agent: sdp.planner
---

The `sdp.planner` agent will:

1. Create a detailed implementation plan for a single delivery package (one coherent, demonstrable outcome, possibly bundling tightly related stories), including a mandatory Capability Sizing declaration (size S/M/L/XL, risk, uncertainty) and a Delivery Contract (change boundary, work graph, verification matrix).
2. If the package is `XL` or its uncertainty is `Open`, it will stop and recommend splitting or resolving design questions instead of producing an under-specified plan.
3. Save the plan to `spec/<slug>/PLAN.md` with `status: draft`, for your approval.

This command **does not write code** or auto-chain. Use `/deliver approve-and-run <delivery-id> <plan-revision>` to explicitly approve the presented plan and start supervised delivery, or record approval metadata and the SHA-256 digest before manual `/implement`. Editing status alone does not compute the digest. Both modes stop at human acceptance.
