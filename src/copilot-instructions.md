# Copilot SDP Orchestrator

You are operating under the **Spec Development Protocol (SDP)** — a spec-first, gate-driven engineering framework for both greenfield and legacy projects.

## Mandatory Startup Context
1. Read `@/.github/TECH.md` first — it defines the stack, cloud environment, and project-specific standards. All agents and decisions must be consistent with it.
2. Follow the 6-gate SDLC in `@/.github/instructions/sdlc-process.instructions.md` — never skip or reorder gates without explicit approval.
3. Route specialized work through the agents in `@/.github/agents/`.

## Agent Routing
| Task | Agent |
|---|---|
| Discovery / PRD creation | `sdp.prd` |
| Backlog refinement (epics, stories, AC) | `sdp.analyst` |
| Architecture / technical design | `sdp.architect` |
| Task planning | `sdp.developer` (plan-task mode) |
| Implementation | `sdp.developer` (implement mode) |
| Code and design review | `sdp.reviewer` |
| Security assessment | `sdp.security` |
| Acceptance criteria validation | `sdp.qa` |

## SDLC Discipline
- Never write code before an approved implementation plan exists.
- Implement exactly one story or task at a time — no bundling.
- Keep every artifact traceable: PRD → backlog → design → plan → code → validation.
- Flag and block progression if gate exit criteria are not met.

---

## Global Coding Standards

These apply to all code produced regardless of language, framework, or project type. Adjust specifics to the stack defined in `TECH.md`.

### Code Quality
- **Clean Code first:** small, focused functions with a single clear responsibility.
- **Naming is communication:** use intent-revealing names for variables, functions, classes, and files. Avoid abbreviations unless they are universally understood in the domain.
- **YAGNI:** do not add functionality until it is needed. Avoid speculative abstractions.
- **DRY with judgment:** eliminate duplication, but do not abstract prematurely. Three occurrences before extracting a shared concept is a reasonable heuristic.
- **Avoid deep nesting:** prefer early returns, guard clauses, and flat logic over nested conditionals.
- **Functions and methods:** prefer pure functions where possible. Side effects should be explicit and isolated at system boundaries.

### Architecture & Design
- **Separation of concerns:** keep infrastructure, application logic, and domain rules in separate layers.
- **Dependency direction:** dependencies should point inward toward domain/core logic, never outward.
- **Ports and adapters (Hexagonal):** use interfaces/contracts at external boundaries (HTTP, DB, messaging, file system). This keeps the core testable and portable.
- **Right-size the design:** a simple CRUD endpoint does not need a domain model. A financial transaction processor does. Match complexity to the problem.
- **Prefer composition over inheritance.**

### Error Handling
- **Fail fast:** validate at system entry points (API boundaries, CLI inputs, event consumers). Do not let invalid data propagate deep into business logic.
- **Errors are data:** represent failures explicitly (result types, structured errors) rather than using exceptions for control flow where avoidable.
- **Surface actionable messages:** error messages should help the operator or developer understand what failed and why. Never expose stack traces or internal details to end users.
- **Distinguish error categories:** transient (retry-able) vs. permanent (fail fast) vs. programmer errors (crash loudly in dev, alert in prod).

### Testing
- **Test pyramid:** unit tests are the foundation, integration tests verify boundaries, end-to-end tests cover critical user paths only.
- **Test behavior, not implementation:** tests should validate what the code does, not how it does it internally. Avoid testing private methods directly.
- **One assertion focus per test:** each test should answer one question. Use descriptive test names that describe the scenario and expected outcome.
- **Arrange-Act-Assert (AAA):** structure tests consistently with clear setup, execution, and verification sections.
- **Tests must pass before merging.** No skipped or commented-out tests without a documented reason.
- **Coverage is a proxy, not a goal:** aim for meaningful coverage of business-critical and error paths, not 100% line coverage of trivial code.

### Security (Always On)
Apply these regardless of whether a formal security review has been done:
- **Input validation at boundaries:** validate and sanitize all external input — HTTP requests, file uploads, event payloads, CLI arguments.
- **Output encoding:** encode output appropriate to context (HTML, SQL, shell) to prevent injection attacks.
- **Least privilege:** components, services, and users should have only the permissions they need to do their job.
- **No secrets in code or version control:** use environment variables, secret managers (e.g. Azure Key Vault, AWS Secrets Manager, HashiCorp Vault), or CI/CD secret stores.
- **Secure defaults:** default to deny-all access, require HTTPS/TLS, set secure cookie flags, apply CORS policies explicitly.
- **Dependency hygiene:** flag and address known vulnerable dependencies. Do not add new dependencies without justification.
- **OWASP Top 10 awareness:** treat injection, broken auth, IDOR, security misconfiguration, and sensitive data exposure as active threats in every feature.

### Observability
- **Structured logging:** emit logs as structured data (JSON preferred) with consistent fields: timestamp, level, correlation/trace ID, service name, message, relevant context.
- **Log levels with intent:** DEBUG for development detail, INFO for significant state transitions, WARN for recoverable anomalies, ERROR for failures requiring attention.
- **Never log sensitive data:** no passwords, tokens, PII, or financial details in logs.
- **Health and readiness:** expose health check endpoints on all services. Distinguish liveness (is the process alive) from readiness (is it ready to serve traffic).
- **Metrics at boundaries:** measure and expose latency, error rates, and throughput at external-facing boundaries and critical internal operations.

### Version Control & Commits
- **Atomic commits:** each commit represents one logical change. A commit should be explainable in a single sentence.
- **Commit messages:** use the imperative mood in the subject line (`Add`, `Fix`, `Remove`, not `Added`, `Fixed`). Reference issue/story IDs where applicable.
- **Branch per story/task:** never commit feature work directly to the main/trunk branch.
- **No commented-out code in commits:** delete unused code. Version control preserves history.

### Documentation
- **Code should read as documentation:** prioritize self-documenting code over comments. Comments explain *why*, not *what*.
- **Update docs with code:** if a change affects an API contract, architectural decision, or user-facing behavior, update the corresponding documentation in the same commit/PR.
- **Architecture Decision Records (ADRs):** for significant technical decisions, record the context, options considered, and rationale in a short ADR file.

### Greenfield vs. Legacy
- **Greenfield:** establish the full structure from `TECH.md` up front. Set linting, testing, and CI standards before writing feature code.
- **Legacy:** prefer the strangler fig pattern — incrementally improve at touch points rather than rewriting working code. Respect existing conventions until a deliberate decision to change them is made and documented.
