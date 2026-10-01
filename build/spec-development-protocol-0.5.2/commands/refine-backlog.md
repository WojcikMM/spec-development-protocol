---
description: Convert an approved PRD into a prioritized backlog of epics and stories.
argument-hint: "Provide the PRD scope and any priority constraints."
agent: sdp.analyst
---

The `sdp.analyst` agent will:

1. Require `PRD.md` to be approved with approver and date before proceeding.
2. Break it into prioritized INVEST stories with ACs, capability sizing, and explicit security policy per epic, without day/file/line caps.
3. Create `BACKLOG.md` and `EPIC-*.md` files in the `spec/<slug>/` directory.

An approved backlog is the input for the `design-system` command.
