---
name: write-tests
description: Guidance for writing meaningful unit and integration tests.
---

# Skill: Write Tests

## Purpose

Produce maintainable tests that validate behavior, not implementation, to give the team confidence to ship and refactor.

## Prerequisites

- Acceptance criteria are clear.
- Testing stack is specified in `TECH.md`.

## Checklist

1.  **Test Cases**: Enumerate test cases from acceptance criteria: happy path, error paths, and edge cases.
2.  **Structure (AAA)**: Structure each test using Arrange-Act-Assert.
    - _Arrange_: Set up inputs and mocks.
    - _Act_: Invoke the code under test.
    - _Assert_: Verify the outcome.
3.  **Naming**: Name tests descriptively, like `should <do something> when <condition>`.
4.  **Focus**: Keep one behavioral focus per test. Multiple assertions are fine
    when they jointly verify that outcome.
5.  **Behavior, not Implementation**: Test what the code _does_, not _how_ it does it.
6.  **Integration Tests**: Test contracts at boundaries (HTTP, DB). Use real or in-memory implementations where practical. Cover auth paths. Reset state between tests.
7.  **General**: Don't skip failing tests to make a run pass. If a test must be
    deleted or weakened, record the root cause in the delivery evidence and
    confirm that required behavior remains verified elsewhere. Never delete or
    weaken a test solely to get past review, security, or QA. Follow the
    project's test-location convention.

## Quality Bar

- Every acceptance criterion is tested.
- All scenarios (happy, error, edge) are covered.
- Tests are isolated and deterministic (no network calls or global state).
