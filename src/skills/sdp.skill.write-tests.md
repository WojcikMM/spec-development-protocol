---
description: Guidance for writing unit and integration tests following the Arrange-Act-Assert pattern, aligned with the project's testing stack in TECH.md.
---
# Skill: Write Tests

## Purpose

Produce meaningful, maintainable tests that validate behavior — not implementation — and give the team confidence to ship and refactor.

## When to Use

- Before writing implementation code (TDD) for complex logic.
- Alongside implementation for straightforward changes.
- When adding tests to untested legacy code at a touch point.
- When acceptance criteria include explicit test scenarios (Given/When/Then).

## Prerequisites

- [ ] Acceptance criteria for the story/task are defined and unambiguous.
- [ ] The testing stack is specified in `.github/TECH.md` (section 2 or 3).
- [ ] The module or function under test has a clear, single responsibility.

## Checklist

### Unit Tests
1. **Identify the unit** — one function, method, or component.
2. **Enumerate test cases** from the acceptance criteria: happy path, error paths, edge cases.
3. **Structure each test** using Arrange-Act-Assert (AAA):
   - *Arrange* — set up inputs, mocks, and preconditions.
   - *Act* — invoke the unit under test.
   - *Assert* — verify the outcome against the expected result.
4. **Name tests descriptively**: `should <do something> when <condition>` or `given <state>, when <action>, then <outcome>`.
5. **One assertion focus per test** — if a test needs many unrelated assertions, split it.
6. **Avoid testing implementation details** — test what the code does, not how it does it internally.

### Integration Tests
1. **Identify the boundary** — HTTP endpoint, database query, external service call.
2. **Use real or in-memory implementations** for the integrated layer; mock only external services.
3. **Test the contract** — request → response shape, status codes, error responses.
4. **Cover authentication and authorization** paths explicitly.
5. **Reset state** between tests to prevent test-order dependencies.

### General Rules
- Do not skip or comment out failing tests — fix them or delete them with a documented reason.
- Keep test files co-located with source files or in a consistent `__tests__/` structure per TECH.md conventions.
- Tests must pass in CI before merging.

## Quality Bar

- Every acceptance criterion maps to at least one test case.
- All happy-path, error-path, and edge-case scenarios are covered.
- No test depends on external network calls or global mutable state.
- Tests run in isolation and are deterministic.

## Common Pitfalls

- **Testing implementation, not behavior** — if refactoring breaks the test without changing behavior, the test was wrong.
- **Over-mocking** — mocking the unit under test defeats the purpose; mock only dependencies.
- **Missing error paths** — always test what happens when input is invalid, a dependency fails, or a timeout occurs.
- **Flaky tests** — avoid timers, network calls, and shared mutable state in tests.
