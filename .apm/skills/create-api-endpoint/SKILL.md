---
name: Create REST API Endpoint
description: Guidance for designing and implementing a well-structured REST API endpoint with proper validation, error handling, authentication, and documentation.
---
# Skill: Create REST API Endpoint

## Purpose

Produce a consistent, secure, and well-documented HTTP endpoint that satisfies the contract defined in the technical design and passes security review without rework.

## When to Use

- Implementing any new HTTP route (GET, POST, PUT, PATCH, DELETE).
- Adding a new resource or action to an existing API.
- Modifying an existing endpoint's contract (request/response shape, auth, or status codes).

## Prerequisites

- [ ] API contract (path, method, request/response schema) is defined in `docs/architecture/DESIGN-<slug>.md`.
- [ ] Authentication and authorization requirements are specified.
- [ ] Error response format is consistent with existing API conventions in TECH.md.

## Checklist

### Route Definition
1. **Path naming** — use plural nouns for resources (`/users`, `/orders/{id}`), not verbs.
2. **HTTP method** — GET (read), POST (create), PUT (full replace), PATCH (partial update), DELETE (remove).
3. **Route parameters** — validate all path and query parameters before use.

### Input Validation
4. **Validate at the boundary** — reject invalid input immediately with a `400 Bad Request` and a clear error message.
5. **Use a schema validation library** (e.g., Zod, Joi, class-validator) consistent with the project stack.
6. **Sanitize** any user-supplied string that will be rendered or stored.

### Authentication & Authorization
7. **Apply auth middleware** to every non-public route.
8. **Check authorization** — verify the caller has permission to access the specific resource (not just a valid token).
9. **Return `401`** for unauthenticated requests, **`403`** for unauthorized.

### Business Logic
10. **Delegate to a service layer** — keep route handlers thin; move logic to a dedicated service or use-case function.
11. **Handle not-found explicitly** — return `404` when a requested resource does not exist.

### Error Handling
12. **Never expose stack traces** or internal error details to the client.
13. **Use consistent error response shape**: `{ error: string, code?: string }` or per project convention.
14. **Log errors** with a correlation/trace ID at the appropriate level (WARN or ERROR).

### Response
15. **Return the correct HTTP status**: `200` (OK), `201` (Created), `204` (No Content), `400`, `401`, `403`, `404`, `409` (Conflict), `422` (Unprocessable), `500`.
16. **Include a `Location` header** for `201` responses pointing to the created resource.
17. **Keep responses lean** — do not over-expose internal model fields; use a response DTO/mapper.

### Documentation
18. **Update or add OpenAPI/Swagger annotations** (or equivalent) for the new endpoint.
19. **Document the error responses** — what codes can be returned and why.

## Quality Bar

- Endpoint rejects invalid input with a `400` before touching the database.
- All routes are covered by at least one integration test (happy path + one error path).
- No secrets, internal stack traces, or PII leak in responses.
- Auth middleware is applied and tested.

## Common Pitfalls

- **Authorization bypass** — checking authentication but not resource-level authorization (IDOR).
- **Missing input validation** — trusting query params or body fields without schema validation.
- **Leaking internals** — returning raw ORM errors or stack traces to the client.
- **Inconsistent error format** — mixing error shapes across routes makes client handling harder.
- **Fat controllers** — putting business logic directly in the route handler; extract to a service.
