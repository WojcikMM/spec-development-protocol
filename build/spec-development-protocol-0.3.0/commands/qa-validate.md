---
description: Validate that delivered changes meet acceptance criteria.
argument-hint: "Provide the story/task ID and scope of delivered changes."
agent: sdp.qa
---

The `sdp.qa` agent will:
1. Derive test cases from the story's acceptance criteria.
2. Validate positive, negative, and edge-case scenarios.
3. Produce a test matrix and a final pass/fail verdict.

A `pass` verdict completes the story. A `fail` verdict will be handed back to the developer with a defect list.
