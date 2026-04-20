---
name: plan-task
description: Build an implementation plan for one approved story/task without coding.
argument-hint: "Provide one approved story/task and constraints for implementation planning."
agent: Developer Agent
---
# Plan Task

Use [Developer Agent](../agents/developer.agent.md), [TECH.md](../TECH.md), and [SDLC Process](../instructions/sdlc-process.instructions.md).

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Objective

Create a detailed implementation plan for exactly one approved story/task.

User-provided inputs:
- Story/task identifier and summary: ${input:storyTask:What single approved story/task should be planned?}
- Acceptance criteria: ${input:acceptanceCriteria:List AC for this story/task}
- Constraints: ${input:constraints:Time, compatibility, tooling, or policy constraints}
- Additional context: ${input:additionalContext:Optional extra context}

Required output:
- Exact files to modify
- Step-by-step implementation plan
- Tests to add/update
- Risks and rollback notes

Hard rule: do not write code in this prompt. End with an explicit approval checkpoint before implementation.
