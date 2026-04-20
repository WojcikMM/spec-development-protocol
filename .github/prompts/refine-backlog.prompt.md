---
name: refine-backlog
description: Convert a PRD into prioritized epics, features, and testable user stories.
argument-hint: "Provide PRD scope, priorities, and any sequencing constraints."
agent: Analyst Agent
---
# Refine Backlog

Use [Analyst Agent](../agents/analyst.agent.md), [TECH.md](../TECH.md), and [SDLC Process](../instructions/sdlc-process.instructions.md).

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Objective

Refine the approved PRD into delivery-ready backlog artifacts.

User-provided inputs:
- PRD or scope summary: ${input:prdSummary:Paste or summarize the approved PRD scope}
- Priority drivers: ${input:priorityDrivers:Revenue, compliance, risk reduction, timeline, etc.}
- Dependency constraints: ${input:dependencies:List key dependencies or sequencing constraints}
- Additional context: ${input:additionalContext:Optional extra context}

Required output:
- Prioritized epics
- Features under each epic
- User stories with unambiguous acceptance criteria
- Traceability mapping from PRD outcomes to stories

Quality rules:
- Stories must be testable and scoped for incremental delivery.
- Sequence by value, dependency order, and risk.
- Flag assumptions and unresolved decisions.
