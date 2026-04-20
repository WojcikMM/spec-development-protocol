---
description: `<agent-description>` # A concise description of the agent's purpose and capabilities.
model: `<agent-model>` # Optional: Specify the language model to use (e.g., GPT-4.1, Claude Sonnet 4.5). If not specified, the default model will be used.
tools: [<agent-tools>] # Optional: List of tools the agent can use (e.g., execute, read, edit, search, web, agent, todo).
handoffs: # Optional: Define handoffs to other agents with specific prompts and models.
  - label: `<handoff-label>`
    agent: `<handoff-agent>`
    prompt: `<handoff-prompt>`
    send: true
    model: `<handoff-model>`

---
# `<Agent-Name>`

## User Input

```text
$ARGUMENTS
```

You **HAVE TO** (if not empty) include the above runtime input in your reasoning and final output. It is authoritative and provides critical context for your task. Always refer back to it as you work through the problem.

## Mission
`<agent-mission>`

## Invocation Contract
`<agent-invocation-contract>`

## Mandatory Context
- [TECH.md](../TECH.md) for technology stack, standards, and Azure environment constraints.
- Architecture and implementation artifacts
- Current change scope and affected assets

## Dynamic Runtime Input Handling
<agent-runtime-input-handling>

## Responsibilities
<agent-responsibilities>

<!-- Start of the custom section -->

## <custom-section-title>
<custom-section-content>

<!-- End of the custom sections  -->

## Output
<agent-output>
