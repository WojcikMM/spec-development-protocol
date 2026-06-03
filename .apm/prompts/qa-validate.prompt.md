---
description: Trigger QA Agent to validate acceptance criteria against delivered changes.
argument-hint: "Provide the story/task ID, acceptance criteria, and scope of delivered changes."
agent: sdp.qa
---

## Before You Start

Make sure the following exist:
- [ ] An approved user story with acceptance criteria (from `docs/backlog/EPIC-*.md`)
- [ ] An approved implementation plan (Gate 4 complete)
- [ ] Implemented code changes (Gate 5 complete)
- [ ] Code review passed or in progress (Gate 6 — Reviewer)

## What Happens

The `sdp.qa` agent will:
1. Derive test cases directly from the story's acceptance criteria.
2. Validate positive, negative, and edge-case scenarios.
3. Check regression risk in impacted modules.
4. Produce a test matrix and pass/fail verdict.

## Next Gate

- **Pass / Conditional Pass** → story is complete; move to the next story.
- **Fail** → `sdp.qa` will hand off to `sdp.developer` with a defect list to fix.
