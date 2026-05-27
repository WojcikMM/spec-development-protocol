# AGENTS.md — Scoped Context Map

Use this file to define the local working contract for AI agents in this folder subtree.

## Scope
- Applies to: `<folder subtree this file governs>`
- Parent context: inherits higher-level `AGENTS.md` unless overridden below.

## Purpose
- Describe what this module owns.
- Point agents to key files and directories.
- Reduce unnecessary repository-wide scanning.

## Preferred Entry Points
- Code: `<primary source folders>`
- Tests: `<primary test folders>`
- Docs/specs: `<relevant docs paths>`

## File Discovery Rules
- Start in this subtree first.
- Do not scan unrelated folders unless required by a dependency or explicit user request.
- If cross-module work is needed, read the target module's `AGENTS.md` before continuing.

## Tech/Module Notes
- Runtime/framework: `<define>`
- Key dependencies/contracts: `<define>`
- Build/test command(s): `<define>`

## Placement Guidance
- Repository root: one global `AGENTS.md`.
- `.NET`: add one `AGENTS.md` per meaningful library/service folder (usually next to each `.csproj`).
- Frontend: add one `AGENTS.md` per app/package root (for example `apps/web`, `src/frontend`, `packages/ui`).
