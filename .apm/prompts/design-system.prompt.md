---
description: Create a technical design for approved backlog stories.
argument-hint: "Provide the story/feature scope and any architecture constraints."
agent: sdp.architect
---

The `sdp.architect` agent will:
1. Read the approved backlog stories and `TECH.md`.
2. Produce a right-sized technical design.
3. Define module boundaries, contracts (API/data schemas), and NFRs.
4. Save the design to `spec/<slug>/DESIGN.md`.

An approved design is the input for the `plan-task` command.
