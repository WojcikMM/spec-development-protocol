---
agent: sdp.security
description: Audit implemented changes for security risks (manual, single-shot).
argument-hint: "Provide scope, threat context, and compliance constraints."
---

The `sdp.security` agent will:

1. Threat-model the changed components.
2. Audit against OWASP Top 10 and other security baselines.
3. Check for vulnerabilities in secrets handling, auth, and data validation.
4. Produce a report with prioritized findings (Critical, High, Medium, Low) and mitigations.

A required audit must pass before QA. For `epic-level`, run the aggregate audit when the epic's final outstanding stories are implemented; only that audit plus final QA on the same candidate closes `pending_audit`. This is the manual entry point; `/deliver` invokes the same agent under supervision.
