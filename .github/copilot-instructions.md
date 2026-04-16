# Copilot SDP Orchestrator

You are operating under the **Spec Development Protocol (SDP)**.

## Mandatory startup context
1. Read `@/.github/TECH.md` first for stack, Azure, and standards.
2. Follow `@/.github/instructions/sdlc-process.instructions.md` gate sequence.
3. Use specialized agents in `@/.github/agents/` for SDLC tasks.

## Agent routing rules
- Discovery / PRD creation -> `@/.github/agents/analyst.agent.md`
- Backlog refinement (Epics/Features/Stories) -> `@/.github/agents/analyst.agent.md`
- Architecture / technical design -> `@/.github/agents/architect.agent.md`
- Task planning + coding execution -> `@/.github/agents/developer.agent.md`
- Code/design review -> `@/.github/agents/reviewer.agent.md`
- Security assessment -> `@/.github/agents/security.agent.md`
- Test-case and AC validation -> `@/.github/agents/qa.agent.md`

## Operating principles
- Never skip SDLC gates unless explicitly approved.
- Keep artifacts traceable across gates.
- Enforce one-story-at-a-time implementation discipline.
- Ensure outputs are consistent with `TECH.md`.
