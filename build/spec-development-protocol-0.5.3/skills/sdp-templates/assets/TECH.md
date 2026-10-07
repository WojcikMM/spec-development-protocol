# Global Technology Context (TECH)

Define project-specific facts. Use `not applicable` instead of inventing
requirements.

## 1. Platform and Structure

- Application type: <web/API/library/CLI/etc.>
- Runtimes/frameworks: <versions>
- Primary modules: <paths and ownership>
- Target environments: <environments>

## 2. Data and External Boundaries

- Data stores/access: <technology and conventions>
- APIs/events/integrations: <styles and contracts>
- Authentication/authorization: <approach>
- Secrets and sensitive data: <handling>

## 3. Build, Test, and Quality

- Restore/install: <command>
- Build/type-check: <command>
- Unit/integration/end-to-end tests: <commands and applicability>
- Lint/format: <commands>
- CI/CD: <system and required checks>

## 4. Architecture and Coding Conventions

- Established patterns: <patterns to reuse>
- Error handling: <project convention>
- Observability: <project convention or not applicable>
- Compatibility constraints: <constraints>

## 5. SDP Delivery Policy

- Default assurance profile: `Balanced`
- Lean permitted when: <low-risk criteria>
- Compliance required when: <regulatory/high-risk criteria>
- Security specialist triggers: <project additions to SDP defaults>
- Independent QA triggers: <project additions to SDP defaults>
- Run-state retention: <transient | retain summaries | compliance retention>
- Compliance integrity requirements: <none or plan/manifests/environment rules>

Profiles:

- Lean: developer validation plus independent review; extra specialists only
  when triggered.
- Balanced: review always; security and QA when they add independent evidence.
- Compliance: full configured assurance and retained integrity evidence.

## 6. Model Routing (Optional)

Model labels guide selection; they do not automatically configure runtime
models. Do not block Lean/Balanced delivery merely because telemetry is
unavailable.

| Role | Preferred profile/model | Allowed fallback |
| --- | --- | --- |
| Planning | <selection> | <fallback> |
| Implementation | <selection> | <fallback> |
| Review | <selection> | <fallback> |
| Security | <selection> | <fallback> |
| QA | <selection> | <fallback> |
| Coordination | <selection> | <fallback> |

Compliance may require verified model/tool availability when project policy
explicitly says so.

## 7. Project Decisions

- YYYY-MM-DD: <durable project decision>
