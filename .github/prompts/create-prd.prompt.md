---
name: create-prd
description: Create a delivery-ready PRD from an initiative description.
argument-hint: "Describe the initiative, business goal, users, and constraints."
agent: Analyst Agent
---
# Create PRD

Use the operating guidance in [Analyst Agent](../agents/analyst.agent.md), [TECH.md](../TECH.md), and [SDLC Process](../instructions/sdlc-process.instructions.md).


## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Objective

Create or update `PRD.md` for this initiative.

User-provided inputs:
- Initiative summary: ${input:initiative:What initiative should this PRD cover?}
- Business objective: ${input:businessObjective:What business outcome is expected?}
- Target users: ${input:targetUsers:Who are the primary users/stakeholders?}
- Constraints and assumptions: ${input:constraints:List constraints, assumptions, and dependencies}
- Additional context: ${input:additionalContext:Optional extra context}

Required PRD sections:
- Problem statement
- Goals and measurable success metrics
- In scope / out of scope
- Risks and mitigations
- Open questions

Output requirements:
- Clear business-first language.
- Explicitly call out assumptions and unknowns.
- Keep outcomes testable and traceable for backlog refinement.
