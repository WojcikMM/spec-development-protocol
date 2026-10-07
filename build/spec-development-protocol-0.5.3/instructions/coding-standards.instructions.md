---
description: Global code-quality standards for SDP-managed work.
applyTo: "**/*"
---

# Global Coding Standards

Apply these standards proportionally to the project type and the stack defined
in `TECH.md`. Process and orchestration rules live in
`sdlc-process.instructions.md`.

## Code Quality

- Prefer small, focused functions and intent-revealing names.
- Avoid speculative abstractions and unnecessary indirection.
- Remove meaningful duplication without forcing unrelated code into a shared
  abstraction.
- Prefer guard clauses and clear control flow over deep nesting.
- Keep side effects explicit and isolate external boundaries.
- Match architectural complexity to the problem.

## Architecture

- Separate domain/application concerns from infrastructure where the
  distinction improves testability or changeability.
- Keep dependencies directed toward stable contracts.
- Prefer composition over inheritance.
- Reuse established project patterns before introducing a new one.
- A simple change does not require a new architecture layer or ADR.

## Error Handling

- Validate external input at system boundaries.
- Represent expected failures explicitly rather than using broad exceptions for
  control flow.
- Surface actionable messages without exposing secrets, stack traces, or
  internal details.
- Distinguish transient, permanent, and programmer failures.
- Do not swallow errors or convert failures into success-shaped results.

## Testing

- Test observable behavior rather than private implementation details.
- Cover business-critical happy paths, error paths, and material edge cases.
- Use unit, integration, and end-to-end tests where each provides independent
  confidence; do not require every test layer for every change.
- Keep tests isolated and deterministic where practical.
- Use clear Arrange-Act-Assert structure when it improves readability.
- Prefer one behavioral focus per test; multiple assertions are appropriate
  when they jointly verify one outcome.
- Do not skip, delete, or weaken a failing test merely to pass a gate.

## Durable Comments Only

Code should communicate primarily through naming and structure. Comments explain
durable reasons that cannot be made clear in code.

Do not add comments containing:

- story, epic, task, ticket, delivery, or acceptance-criterion IDs;
- implementation-step narration;
- change history such as "added for STORY-12";
- obvious restatements of the next line;
- completed TODOs or temporary planning notes;
- conversational explanations from the implementation session.

Comments are appropriate for non-obvious business invariants, compatibility
constraints, security rationale, external protocol quirks, and deliberate
trade-offs a future maintainer might otherwise undo.

Traceability belongs in specs, meaningful test names, commit/PR descriptions,
and delivery history - not production-code comments.

## Security

- Treat external input, authorization, secrets, and sensitive data as active
  trust boundaries.
- Encode output for its destination and use parameterized data access.
- Apply least privilege and secure defaults.
- Never commit or log credentials, tokens, personal data, or financial data.
- Add dependencies only with justification and review their security posture.
- Apply OWASP guidance relevant to the changed surface.

## Observability

- Use the project's established structured logging and tracing conventions.
- Never log secrets or sensitive payloads.
- Add health/readiness endpoints and boundary metrics when the component is a
  long-running service and operational ownership requires them.
- Do not add observability infrastructure to libraries, scripts, or prototypes
  without a concrete operational need.

## Documentation

- Update documentation when public behavior, contracts, setup, operations, or
  architecture decisions change.
- Record significant, durable architectural decisions in the project's chosen
  format; do not create an ADR for routine implementation choices.
- Keep generated comments and documentation out of source when they add no
  maintenance value.

## Version Control

- Keep commits logically coherent and use imperative subjects.
- Reference work items where the project convention requires it.
- Follow the repository's branching policy from `TECH.md`; do not impose a
  branch-per-story policy on every project.
- Remove dead and commented-out code before delivery.

## Greenfield and Legacy Work

- Greenfield projects should establish formatting, tests, and CI appropriate to
  their risk before substantial implementation.
- Legacy projects should improve touched boundaries incrementally and preserve
  working conventions unless a deliberate change is approved.
