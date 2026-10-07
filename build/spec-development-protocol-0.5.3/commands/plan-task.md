---
description: Create an implementation-grade plan for the active delivery package.
argument-hint: "[optional story or coherent package selection]"
agent: sdp.planner
---

The planner resolves `spec/ACTIVE.md` and asks for a package choice only when
selection is ambiguous. It writes a concise `PLAN.md` containing outcome,
non-goals, decisions, change boundary, ordered work, verification, risk,
assurance profile, and implementation autonomy.

XL scope or Open uncertainty returns to refinement/design.

Review the resulting plan, then run bare `/deliver` to approve and execute it.
