# Active Feature

This file tells all SDP agents which feature is currently in flight.
It is created and updated automatically by the `sdp.prd` agent when a new PRD is started.

---

slug: <feature-slug>
title: <Human Readable Feature Title>

---

## How to switch features

Update the `slug` and `title` lines above to match a different folder under `spec/`.
All agents read this file on startup to load the correct feature context.

## Feature history

All spec artifacts for this feature live in `spec/<feature-slug>/`:

| File | Gate | Contents |
|---|---|---|
| `PRD.md` | Gate 1 | Product requirements |
| `BACKLOG.md` | Gate 2 | Epic index |
| `EPIC-<N>-<slug>.md` | Gate 2 | Stories and acceptance criteria |
| `DESIGN.md` | Gate 3 | Technical design |
| `PLAN.md` | Gate 4 | Current implementation plan |
| `HISTORY.md` | Gate 5 | Running log of completed tasks |
