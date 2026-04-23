# Global Technology Context (TECH)

This document is the source of truth for technology choices, standards, and delivery constraints used by the Spec Development Protocol (SDP). Fill in every `<define>` placeholder before running SDP agents.

## 1) Platform Type

- **Application type:** `<Web Application / API Service / Full-Stack / Frontend-only / Backend-only>`
- **Target environments:** `<Browser / Node.js server / Edge / define>`

## 2) Frontend Stack

> Remove this section if the project is backend-only or API-only.

- **Primary framework:** `<React / Vue / Angular / Svelte / Next.js / Nuxt / define>`
- **Language:** `<TypeScript / JavaScript>`
- **UI system/design:** `<Tailwind CSS / MUI / shadcn/ui / define>`
- **State management:** `<Redux / Zustand / Pinia / Context API / define>`
- **Testing:** `<Vitest / Jest + Testing Library / Playwright / Cypress / define>`
- **Build toolchain:** `<Vite / Webpack / Turbopack / define>`

## 3) Backend Stack

> Remove this section if the project is frontend-only.

- **Primary runtime/framework:** `<Node.js + Express / NestJS / FastAPI / Django / Spring Boot / define>`
- **Language:** `<TypeScript / Python / Java / Go / define>`
- **API style:** `<REST / GraphQL / gRPC / tRPC>`
- **Data access pattern:** `<ORM / query builder / raw SQL>`
- **Messaging/events:** `<define if applicable>`
- **Testing:** `<Jest / Pytest / JUnit / Supertest / define>`

## 4) CI/CD & DevOps

- **Version control platform:** `<GitHub / GitLab / Bitbucket>`
- **CI/CD system:** `<GitHub Actions / GitLab CI / Azure DevOps / Jenkins / define>`
- **Environments:** `<dev / staging / production>`
- **Branching strategy:** `<trunk-based / GitFlow / define>`
- **Pipeline stages:** `<lint / test / build / deploy>`

## 5) Infrastructure & Deployment

- **Hosting/compute:** `<Vercel / AWS / Azure / GCP / Railway / Render / self-hosted / define>`
- **IaC tool:** `<Terraform / Pulumi / Bicep / CDK / none>`
- **Database(s):** `<PostgreSQL / MySQL / MongoDB / SQLite / define>`
- **Cache:** `<Redis / Memcached / define if applicable>`
- **Secrets/configuration:** `<environment variables / secrets manager name / define>`
- **Observability:** `<Datadog / Sentry / OpenTelemetry / Grafana / define>`

## 6) Security & Identity Baseline

- Store secrets only in a dedicated secrets manager or environment variables — **never in source code**.
- Enforce least privilege access controls for all services and users.
- Require HTTPS/TLS for all traffic; enforce secure HTTP headers (CSP, HSTS, X-Frame-Options).
- Apply input validation and output encoding at all API and UI boundaries (OWASP Top 10 baseline).
- **Authentication method:** `<JWT / OAuth2 / session-based / define>`
- **Authorization model:** `<RBAC / ABAC / define>`

## 7) Coding Standards

- Follow **Clean Code** principles:
  - Small focused functions/modules
  - Clear naming and intent-revealing code
  - Avoid unnecessary complexity
- Follow **DRY**:
  - Reuse validated abstractions
  - Centralize shared logic and policies
- Use consistent formatting/linting from repo toolchain.
- Keep changes small, testable, and traceable to backlog items.

## 8) Definition of Done Anchors

- Spec artifacts updated and traceable (PRD → backlog → design → tasks).
- Implementation aligns with approved technical design.
- Tests and quality gates pass per project standards.
- Security and QA sign-off criteria satisfied for the change scope.

## 9) Project-Specific Decisions Log

Use this section to append architecture decision records (ADRs) or key technical decisions.

- `YYYY-MM-DD`: `<decision summary>`
