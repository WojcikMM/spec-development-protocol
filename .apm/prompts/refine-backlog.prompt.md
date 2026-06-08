---
description: Convert an approved PRD into a prioritized backlog of epics and stories.
argument-hint: "Provide the PRD scope and any priority constraints."
agent: sdp.analyst
---

The `sdp.analyst` agent will:
1. Read the approved `PRD.md`.
2. Break it down into prioritized epics and user stories with acceptance criteria.
3. Create `BACKLOG.md` and `EPIC-*.md` files in the `spec/<slug>/` directory.

An approved backlog is the input for the `design-system` command.
