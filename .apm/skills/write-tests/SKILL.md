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
    - *Arrange*: Set up inputs and mocks.
    - *Act*: Invoke the code under test.
    - *Assert*: Verify the outcome.
3.  **Naming**: Name tests descriptively, like `should <do something> when <condition>`.
4.  **Focus**: Focus on a single assertion per test where possible.
5.  **Behavior, not Implementation**: Test what the code *does*, not *how* it does it.
6.  **Integration Tests**: Test contracts at boundaries (HTTP, DB). Use real or in-memory implementations where practical. Cover auth paths. Reset state between tests.
7.  **General**: Don't skip failing tests—fix or delete them. Co-locate tests with source files.

## Quality Bar
- Every acceptance criterion is tested.
- All scenarios (happy, error, edge) are covered.
- Tests are isolated and deterministic (no network calls or global state).
