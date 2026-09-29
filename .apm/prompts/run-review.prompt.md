---
description: Review implemented changes for correctness, maintainability, and design alignment (manual, single-shot).
argument-hint: "Provide the change scope and design/plan references."
agent: sdp.reviewer
---

The `sdp.reviewer` agent will:

1. Review code for correctness, readability, and alignment with the approved design.
2. Check test quality and coverage.
3. Produce a report with categorized findings (Critical, High, Medium, Low).

A successful review is required before the security audit (unless the epic's `security_review` policy is `epic-level` or `waived`, in which case it hands off directly to QA). This is the manual, single-shot entry point; `/deliver` invokes the same agent under supervision.
