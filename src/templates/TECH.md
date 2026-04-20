# Global Technology Context (TECH)

This document is the source of truth for technology choices, standards, and Azure environment constraints used by the Spec Development Protocol (SDP).

## 1) Frontend Stack
- **Primary framework:** `<define>`
- **Language:** `<TypeScript/JavaScript>`
- **UI system/design:** `<define>`
- **State management:** `<define>`
- **Testing:** `<unit/e2e tools>`
- **Build toolchain:** `<define>`

## 2) Backend Stack
- **Primary runtime/framework:** `<define>`
- **Language:** `<define>`
- **API style:** `<REST/GraphQL/gRPC>`
- **Data access pattern:** `<ORM/query builder/raw SQL>`
- **Messaging/events:** `<define if applicable>`
- **Testing:** `<unit/integration/contract tools>`

## 3) Azure DevOps Project Details
- **Organization:** `<define>`
- **Project:** `<define>`
- **Repositories:** `<define>`
- **Boards setup:** `<Epics/Features/User Stories/Bugs>`
- **Pipelines:** `<build/release strategy>`
- **Environments:** `<dev/test/stage/prod>`
- **Branching policy:** `<trunk/GitFlow + protections>`

## 4) Infrastructure (Bicep/Terraform)
- **IaC tool:** `<Bicep/Terraform>`
- **Subscription(s):** `<define>`
- **Resource groups:** `<define naming convention>`
- **Networking:** `<VNet/Subnet/Private Endpoint policy>`
- **Compute/data resources:** `<App Service/Container Apps/AKS/SQL/Cosmos/etc.>`
- **Secrets/configuration:** `Azure Key Vault + managed identity`
- **Observability:** `<App Insights/Log Analytics/Azure Monitor>`
- **Policy/compliance controls:** `<Azure Policy/Defender/Tagging>`

## 5) Security & Identity Baseline
- Prefer **managed identities** over secrets wherever possible.
- Store secrets only in **Azure Key Vault**.
- Enforce least privilege with Azure RBAC and scoped service connections.
- Require HTTPS/TLS, secure transport, and environment segregation.

## 6) Coding Standards
- Follow **Clean Code** principles:
  - Small focused functions/modules
  - Clear naming and intent-revealing code
  - Avoid unnecessary complexity
- Follow **DRY**:
  - Reuse validated abstractions
  - Centralize shared logic and policies
- Use consistent formatting/linting from repo toolchain.
- Keep changes small, testable, and traceable to backlog items.

## 7) Definition of Done Anchors
- Spec artifacts updated and traceable (PRD -> backlog -> design -> tasks).
- Implementation aligns with approved technical design.
- Tests and quality gates pass per project standards.
- Security and QA sign-off criteria satisfied for the change scope.

## 8) Project-Specific Decisions Log
Use this section to append architecture decision records (ADRs) or key technical decisions.

- `YYYY-MM-DD`: `<decision summary>`
