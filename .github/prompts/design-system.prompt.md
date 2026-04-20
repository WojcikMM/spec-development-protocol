---
name: design-system
description: Produce or update a right-sized technical design for selected backlog scope.
argument-hint: "Describe the story/feature scope and any architecture constraints."
agent: Architect Agent
---
# Design System

Use [Architect Agent](../agents/architect.agent.md), [TECH.md](../TECH.md), and [SDLC Process](../instructions/sdlc-process.instructions.md).

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Objective

Create or update the technical design for this scope.

User-provided inputs:
- Story or feature scope: ${input:scope:What backlog scope should be designed?}
- Existing architecture context: ${input:existingArchitecture:What current modules/services are involved?}
- Non-functional priorities: ${input:nfrPriorities:Security, performance, reliability, operability priorities}
- Constraints: ${input:constraints:Timeline, compliance, technology, or staffing constraints}
- Additional context: ${input:additionalContext:Optional extra context}

Required output:
- Architecture overview with rationale
- Module boundaries and ownership
- Contracts (API/events/data schemas)
- Failure modes and handling
- NFR coverage
- Implementation implications for planning and QA

Ensure the design is right-sized to complexity and implementable via small incremental tasks.
