---
description: Create a technical design for approved backlog stories.
argument-hint: "Provide the story/feature scope and any architecture constraints."
agent: sdp.architect
---

The `sdp.architect` agent will:

1. Verify backlog and relevant epics have approved status, approver and date; read `TECH.md`.
2. Produce a right-sized technical design.
3. Define module boundaries, contracts (API/data schemas), and NFRs.
4. Rate size, risk and uncertainty independently, flag possible delivery packages, and save DESIGN with `status: draft`. XL requires splitting; Open uncertainty requires design resolution.

An approved design is the input for the `plan-task` command.
