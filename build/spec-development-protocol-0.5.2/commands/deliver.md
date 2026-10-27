---
description: Approve-and-run supervised implementation and hardening for one approved delivery package, stopping at human acceptance.
argument-hint: "approve-and-run <id> <revision> | run <id> <revision> | resume <id> | accept/reject <id> <candidate> | request-changes <id> <candidate> <correction>"
agent: sdp.orchestrator
---

The `sdp.orchestrator` agent will:

1. Route the explicit action. `approve-and-run` records your approval of the named plan revision and computes its digest before preflight; `run` requires existing matching approval. `resume` revalidates prior progress; decision actions never implicitly restart execution.
2. Dispatch `sdp.developer`, then `sdp.reviewer`, then `sdp.security` (per the epic's `security_review` policy), then `sdp.qa`, one at a time, reporting each stage result.
3. Allow at most one automatic repair round after the first rejected candidate; a second rejection escalates to you instead of retrying again.
4. On a QA pass, stop at `final_status: awaiting-acceptance` with an acceptance brief. It will not mark anything `done`, advance to the next delivery package, or commit/merge/deploy on your behalf.

The plan comes from `/plan-task`. Bare `/deliver` only reports missing arguments. `accept` requires the exact candidate ID from a complete acceptance brief and rechecks all required evidence before recording your decision; it cannot authorize a next package or release. See the agent's Action Router for each action's prerequisites.

For manual, single-step control instead of supervised delivery, use `/implement`, `/run-review`, `/audit-security`, and `/qa-validate` individually.
