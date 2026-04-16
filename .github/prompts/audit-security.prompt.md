# /audit-security

Use `@/.github/agents/security.agent.md`.

Audit selected code/infrastructure scope for security posture. At minimum evaluate:
- OWASP Top 10 risks (Injection, XSS, CSRF emphasis)
- anti-forgery controls
- secure encoding/sanitization
- secret management and Azure Key Vault usage
- Azure identity/RBAC best practices

Return prioritized findings and mitigation checklist.
