# Global Technology Context (TECH)

This document defines the technology choices and standards for the project.

## 1) Platform

- **Application type**: `<Web App / API / Full-Stack / etc.>`
- **Target environments**: `<Browser / Node.js / etc.>`

## 2) Frontend

- **Framework**: `<React / Vue / etc.>`
- **Language**: `<TypeScript / JavaScript>`
- **UI system**: `<Tailwind CSS / MUI / etc.>`
- **State management**: `<Redux / Zustand / etc.>`
- **Testing**: `<Vitest / Jest / etc.>`

## 3) Backend

- **Framework**: `<Node.js + Express / NestJS / etc.>`
- **Language**: `<TypeScript / Python / etc.>`
- **API style**: `<REST / GraphQL / etc.>`
- **Data access**: `<ORM / Query Builder / Raw SQL>`

## 4) CI/CD & DevOps

- **VCS**: `<GitHub / GitLab / etc.>`
- **CI/CD system**: `<GitHub Actions / GitLab CI / etc.>`
- **Environments**: `<dev / staging / prod>`
- **Branching**: `<trunk-based / GitFlow>`

## 5) Infrastructure

- **Hosting**: `<Vercel / AWS / Azure / etc.>`
- **IaC**: `<Terraform / Pulumi / Bicep / etc.>`
- **Database**: `<PostgreSQL / MySQL / MongoDB / etc.>`
- **Secrets**: `<Environment variables / Secrets manager>`
- **Observability**: `<Datadog / Sentry / OpenTelemetry / etc.>`

## 6) Security

- **Authentication**: `<JWT / OAuth2 / etc.>`
- **Authorization**: `<RBAC / ABAC / etc.>`

## 7) Standards

- Follow Clean Code and DRY principles.
- Use consistent formatting from the repo toolchain.
- Keep changes small and traceable to the backlog.

## 8) Model Policy (for `/deliver` and manual gate agents)

Define which model profile applies to each role. These are **project policy labels**, not runtime model IDs — map each to an actual model available in your environment/agent runtime; do not invent or hard-code a model name here that your tooling doesn't support.

- **Planning / plan-readiness** (`sdp.planner`): `<profile, e.g. "strong-reasoning">`
- **Coordinator** (`sdp.orchestrator`): `<profile; must be able to invoke the assurance profile below per your runtime's model/cost-tier rules>`
- **Implementation** (`sdp.developer`): `<profile, e.g. "economical-coding">`
- **Code review** (`sdp.reviewer`): `<profile, e.g. "strong-reasoning">`
- **Security** (`sdp.security`): `<profile, e.g. "strong-security-reasoning", required when security_review is not waived>`
- **QA** (`sdp.qa`): `<profile, e.g. "strong-reasoning-plus-execution">`

If a required profile is unavailable in a given session, `sdp.orchestrator` must block supervised delivery for the affected stage rather than silently substitute a weaker model; fall back to manual mode (`/run-review`, `/audit-security`, `/qa-validate`) with an explicitly chosen model instead.

| Profile | Available model/configuration | Approved equivalent fallback | Verification |
| ------- | ----------------------------- | ---------------------------- | ------------ |
| `<policy label>` | `<actual available model and where selected>` | `<equivalent or none>` | `<runtime/version, tool access, coordinator cost-tier eligibility>` |

These mappings do not select models automatically. Configure supported agent frontmatter or the runtime picker after checking availability. An unverifiable mandatory mapping blocks supervised delivery. Record actual model, latency, dispatch count, and cost only when exposed; do not fabricate telemetry. Existing projects may keep manual mode while configuring this section.

## 9) Project Decisions

- `YYYY-MM-DD`: `<Decision summary>`
