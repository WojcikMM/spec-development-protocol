---
description: Deliver the active plan through implementation, proportionate assurance, and human acceptance.
argument-hint: "[--profile compliance | resume [delivery-id] | inspect | reject | natural-language correction]"
agent: sdp.orchestrator
---

Bare `/deliver` is the normal action:

1. Resolve the active package: an explicit ID, the `sdp/<delivery-id>` branch,
   `spec/ACTIVE.md`, or the only open package.
2. Treat this command as approval of the current visible plan and record it.
3. Select the required Lean, Balanced, or Compliance assurance profile.
4. Implement, review, and run only security/QA stages that policy and risk
   require.
5. Stop with a concise acceptance brief.

No delivery ID, revision, digest, or candidate hash is required when active
state is unambiguous. In a package worktree, the branch name selects the
package, so bare `/deliver` works in each worktree independently.

After the brief, accept it or describe what is wrong in normal language. A
bounded correction is repaired and rechecked; a changed contract returns to
planning.

Advanced actions are available for compliance, resume, inspection, and explicit
rejection.
