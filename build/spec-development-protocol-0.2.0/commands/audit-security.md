---
agent: sdp.security
description: Trigger Security Agent to audit implemented changes for vulnerabilities and security risks.
argument-hint: "Provide target scope, threat context, and any compliance/security constraints."
---

## Before You Start

Make sure the following exist:
- [ ] Code review passed or in progress (`run-review` done)
- [ ] Implementation complete (Gate 5 done)
- [ ] Architecture/design documents available in `docs/architecture/`

## What Happens

The `sdp.security` agent will:
1. Threat-model the changed components against the OWASP Top 10 and web security baselines.
2. Check secrets handling, authentication, and authorization flows.
3. Verify secure headers, transport protections, and input/output encoding.
4. Produce findings with severity levels and actionable mitigations.

## Outcomes

- **Sign-off** → run `qa-validate` to complete hardening.
- **Critical/High findings** → `sdp.security` hands off to `sdp.developer` with a fix list.
- **Architecture-level issues** → escalate to `sdp.architect` with redesign request.

