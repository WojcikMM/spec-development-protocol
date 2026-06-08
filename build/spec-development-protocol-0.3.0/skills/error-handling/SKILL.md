---
name: error-handling
description: Guidance for implementing consistent, observable error handling.
---
# Skill: Error Handling

## Purpose
Implement error handling that is observable, safe for users, and actionable for developers.

## Prerequisites
- Error categories are understood (user error, system error, etc.).
- Logging stack is defined in `TECH.md`.

## Checklist
1.  **Classify Errors**: Distinguish between user errors (4xx), system errors (5xx), programmer errors, and transient errors.
2.  **Backend/API**: Validate input at the entry point. Use a consistent error response shape. Never expose stack traces. Return correct HTTP status codes. Log system errors with a trace ID.
3.  **Service/Domain**: Return explicit error types (e.g., Result objects) instead of throwing generic exceptions. Don't swallow errors; re-throw or convert them.
4.  **Frontend/UI**: Handle loading, success, and error states for every async call. Show user-friendly messages. Use Error Boundaries (React) to prevent page crashes. Log UI errors to a tracking service.
5.  **Retries & Timeouts**: Set explicit timeouts on all external calls. Retry only idempotent operations, using exponential backoff with jitter. Use a circuit breaker for unreliable dependencies.

## Quality Bar
- Every async call has an explicit error handler.
- No internal error details leak to API responses or UI.
- All errors are logged with sufficient context for debugging.
- Error paths are covered by tests.
