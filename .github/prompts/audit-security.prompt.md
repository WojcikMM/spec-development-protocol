---
name: audit-security
agent: Security Agent
description: Audit selected code and infrastructure scope for security posture and release readiness.
argument-hint: "Provide target scope, threat context, and any compliance/security constraints."
---
# Audit Security

Use [Security Agent](../agents/security.agent.md), [TECH.md](../TECH.md), and [SDLC Process](../instructions/sdlc-process.instructions.md).

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Objective

Audit the selected code and infrastructure scope for security posture.

User-provided inputs:
- Target scope: ${input:targetScope:What files, modules, or services should be audited?}
- Threat context: ${input:threatContext:What threats or abuse cases are most relevant?}
- Compliance requirements: ${input:complianceRequirements:Any required controls or standards}
- Additional context: ${input:additionalContext:Optional extra context}

At minimum evaluate:
- OWASP Top 10 risks (especially Injection, XSS, CSRF)
- Input validation and output encoding
- Anti-forgery controls
- Secrets handling and Key Vault usage
- Identity and RBAC least-privilege posture

Return:
- Prioritized findings with severity
- Mitigation checklist with validation steps
- Explicit security sign-off decision for current scope
