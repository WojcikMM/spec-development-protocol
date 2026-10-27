---
description: Validate that delivered changes meet acceptance criteria (manual, single-shot).
argument-hint: "Provide the story/delivery ID and scope of delivered changes."
agent: sdp.qa
---

The `sdp.qa` agent will:

1. Derive test cases from the story's acceptance criteria.
2. Validate positive, negative, and edge-case scenarios.
3. Confirm required per-story audits passed; retain intermediate epic deferrals, and require aggregate audit evidence plus final QA to close a due epic obligation.
4. Produce a test matrix and a final pass/fail verdict.

A `pass` verdict does **not** complete the story — it sets `final_status: awaiting-acceptance` and produces an acceptance brief. Only an explicit separate human acceptance decision closes the delivery package. A `fail` verdict is handed back to the developer with a defect list. This is the manual, single-shot entry point; `/deliver` invokes the same agent under supervision and stops at the same acceptance checkpoint.
