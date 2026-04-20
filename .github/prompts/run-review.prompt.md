---
name: run-review
description: Perform a structured code/design review against approved design and plan.
argument-hint: "Provide change scope, design/plan references, and review priorities."
agent: Reviewer Agent
---
# Run Review

Use [Reviewer Agent](../agents/reviewer.agent.md), [TECH.md](../TECH.md), and [SDLC Process](../instructions/sdlc-process.instructions.md).

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Objective

Review implementation quality for the selected scope.

User-provided inputs:
- Change scope: ${input:changeScope:What code/design scope should be reviewed?}
- Technical design reference: ${input:designReference:Where is the approved technical design?}
- Implementation plan reference: ${input:planReference:Where is the approved implementation plan?}
- Acceptance criteria: ${input:acceptanceCriteria:What AC must be satisfied?}
- Additional review focus: ${input:reviewFocus:Optional extra concerns to prioritize}

Return:
- Findings categorized as Critical, Major, Minor, Suggestion
- Evidence, impact, and remediation per finding
- Final verdict: Approve, Approve with conditions, or Request changes
