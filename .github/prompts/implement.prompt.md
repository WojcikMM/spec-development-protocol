---
name: implement
description: Execute one approved implementation plan with minimal, testable code changes.
argument-hint: "Provide approved plan details, story/task ID, and any execution constraints."
agent: Developer Agent
---
# Implement

Use [Developer Agent](../agents/developer.agent.md), [TECH.md](../TECH.md), and [SDLC Process](../instructions/sdlc-process.instructions.md).

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Objective

Implement code changes for one approved implementation plan only.

User-provided inputs:
- Approved plan reference: ${input:approvedPlan:What approved implementation plan should be executed?}
- Story/task identifier: ${input:storyTaskId:Provide the story/task ID}
- Acceptance criteria: ${input:acceptanceCriteria:List AC to validate during implementation}
- Additional execution constraints: ${input:constraints:Optional constraints or boundaries}

Rules:
- Refuse execution if no approved plan exists.
- Modify only files in the approved plan.
- If additional files are required, pause and request plan amendment.
- Add or update tests required by acceptance criteria.

Required output:
- Change summary mapped to plan steps
- File-by-file modifications
- Test and validation evidence
- Known limitations and handover notes
