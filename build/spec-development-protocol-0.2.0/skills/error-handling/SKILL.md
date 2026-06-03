---
name: Error Handling
description: Guidance for implementing consistent, user-friendly, and observable error handling across API boundaries, service layers, and UI components.
---
# Skill: Error Handling

## Purpose

Produce error handling that is visible to operators (good logs), safe for users (no leaks), and actionable for developers (clear failure signals) — without letting errors become invisible or swallowed.

## When to Use

- Implementing any function that calls an external service, database, or third-party API.
- Handling HTTP request/response errors in frontend or backend code.
- Adding error boundaries to UI components.
- Designing a service layer where partial failures must be handled gracefully.

## Prerequisites

- [ ] The error categories for this module are understood: user error (bad input), system error (infrastructure), not-found, unauthorized.
- [ ] The logging and observability stack is defined in `.github/TECH.md` section 5.
- [ ] The API error response format is consistent across the project.

## Checklist

### Classify the Error First
1. **User error (4xx)** — invalid input, missing resource, unauthorized. Do not retry; return a clear message.
2. **System error (5xx)** — infrastructure failure, timeout, unexpected exception. Log it; return a generic safe message.
3. **Programmer error** — assertion failure, null reference, type mismatch. Crash loudly in development; alert in production.
4. **Transient error** — temporary unavailability (network blip, DB overload). Retry with backoff; log if retries exhaust.

### Backend / API Layer
5. **Validate at the entry point** — catch user errors early, before they propagate into business logic.
6. **Use a consistent error response shape**: `{ error: string, code?: string, details?: object }`.
7. **Never expose stack traces, SQL errors, or internal paths** in API responses.
8. **Return the right HTTP status** for each category (400, 401, 403, 404, 409, 422, 500, 503).
9. **Log system errors with context**: timestamp, correlation/trace ID, user ID (if available), affected resource, full stack trace.
10. **Use structured logging** (JSON) so errors are queryable in the observability platform.

### Service / Domain Layer
11. **Return explicit error types** instead of throwing generic exceptions where possible (Result type, discriminated union, or named error classes).
12. **Do not swallow errors silently** — if a catch block cannot handle an error, re-throw it or convert it to a typed error.
13. **Distinguish retryable from non-retryable failures** and document this in the code.

### Frontend / UI Layer
14. **Handle loading, success, and error states** for every async operation — never leave the UI in an indeterminate state.
15. **Show user-friendly error messages** — "Something went wrong, please try again" is better than a raw API error string.
16. **Use Error Boundaries** (React) or equivalent to catch render-time errors and prevent the whole page from crashing.
17. **Log frontend errors to an error tracking service** (e.g., Sentry) with context (user session, route, component name).
18. **Do not display technical error details to end users** — log them and show a safe fallback message.

### Retries and Timeouts
19. **Set explicit timeouts** on all external calls — never rely on the platform's default infinite timeout.
20. **Retry only idempotent operations** (GET, PUT with the same payload) — never automatically retry POST operations that create resources.
21. **Use exponential backoff with jitter** for retries to avoid thundering herd.
22. **Define a circuit breaker** for dependencies that are frequently unavailable.

## Quality Bar

- Every async call in the codebase has an explicit error handler.
- No internal error details (stack traces, DB errors, file paths) reach API responses or UI.
- All errors are logged with enough context to reproduce and diagnose the issue.
- Error paths have at least one test covering the failure scenario.

## Common Pitfalls

- **Empty catch blocks** — `catch (e) {}` silently swallows errors and makes debugging impossible.
- **Leaking internals** — returning `e.message` directly from a caught exception may expose SQL queries or internal paths.
- **Missing timeout** — an external call without a timeout can hang indefinitely and block threads or event loop.
- **Retrying non-idempotent operations** — retrying a POST that creates a record can create duplicates.
- **No user feedback on error** — the UI continues to look like it's loading after a failed request.
