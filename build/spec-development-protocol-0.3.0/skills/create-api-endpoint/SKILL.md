---
name: create-api-endpoint
description: Guidance for implementing secure, well-structured REST API endpoints.
---
# Skill: Create REST API Endpoint

## Purpose
Produce a consistent, secure, and documented HTTP endpoint that meets its design contract.

## Prerequisites
- API contract (path, method, schemas) is defined in the design spec.
- Auth requirements are specified.

## Checklist
1.  **Route**: Use plural nouns for resources (`/users`) and correct HTTP methods (GET, POST, etc.).
2.  **Input Validation**: Reject invalid input immediately with a `400 Bad Request`. Use a schema validation library.
3.  **Auth**: Apply auth middleware to non-public routes. Check resource-level permissions. Return `401` (unauthenticated) or `403` (unauthorized).
4.  **Business Logic**: Delegate logic to a service layer. Keep route handlers thin. Handle `404 Not Found` explicitly.
5.  **Error Handling**: Never expose stack traces. Use a consistent error response shape. Log errors with a trace ID.
6.  **Response**: Return correct status codes (`200`, `201`, `204`, etc.). Include `Location` header for `201 Created`. Use DTOs to avoid over-exposing data.
7.  **Documentation**: Update OpenAPI/Swagger spec.

## Quality Bar
- Rejects invalid input with `400`.
- Covered by integration tests (happy path + error path).
- No internal details (secrets, stack traces) leak in responses.
- Auth is enforced and tested.
