# SDP Review: From Manual Gates to Supervised Delivery

Date: 2026-09-25  
Scope: Canonical [.apm](.apm) agents, prompts, instructions, templates, and skills.  
Disposition: Architecture and workflow recommendations only; no plugin behavior changed.

## 1. Findings

Severity describes the impact on the proposed autonomous workflow, not a claim that the current manual workflow is unusable. No Critical runtime defect was established. Findings come from static inspection; actual multi-agent execution was not exercised.

### F1. High: Handoffs are navigation, not pipeline orchestration

Evidence: [planner hard constraint](.apm/agents/sdp.planner.agent.md#L19), [developer handoff](.apm/agents/sdp.developer.agent.md#L4), and [reviewer routing](.apm/agents/sdp.reviewer.agent.md#L38).

The planner expressly requires plan approval followed by a separate `/implement` invocation. Subsequent roles expose handoff buttons, with mixed `send: true` and `send: false` settings. These are deliberate manual checkpoints, not an executable state machine.

**Important platform distinction:** VS Code documents that `send: true` auto-submits the prompt *after the user selects the handoff button*. It does not automatically select that button when an agent finishes. Changing every flag to `true` will not deliver the requested pipeline. Conditional security routing and repairs also need an owner beyond static buttons.

**Recommendation:** Introduce one coordinator that invokes existing roles as subagents, validates their results, and owns transitions. Keep handoffs as the manual-mode interface. Change the central process policy explicitly; an orchestrator must not silently bypass today's rules.

### F2. High: QA success currently means completion, not readiness for human acceptance

Evidence: [QA pass transition](.apm/agents/sdp.qa.agent.md#L38) and [active-state template](.apm/templates/ACTIVE.md#L1).

QA either marks the feature `done` or advances to the next story at Gate 4. There is no state for a validated delivery awaiting the developer's final decision. Automating that transition unchanged would remove the very approval boundary requested here.

**Recommendation:** QA pass should produce `awaiting-acceptance`. Only an explicit human decision can mark the delivery accepted. Acceptance is not permission to commit, merge, publish, deploy, or execute the next plan.

### F3. High: Deferred security has no explicit closure trigger on the QA completion path

Evidence: [security execution policy](.apm/agents/sdp.security.agent.md#L34), [reviewer bypass](.apm/agents/sdp.reviewer.agent.md#L40), and [QA responsibilities](.apm/agents/sdp.qa.agent.md#L27).

The central process correctly says an epic cannot finish before its deferred audit. However, the reviewer sends `epic-level` stories directly to QA, and QA accepts documented deferral and can mark the final story complete. The QA completion branch does not explicitly trigger or verify the full-epic audit. This is a policy-to-transition gap, not proof that every run skips security.

**Recommendation:** Persist an outstanding audit obligation with an owner, scope, baseline, and closure condition. When the last delivery in that epic reaches hardening, run its aggregate audit before final QA and epic acceptance. Earlier deliveries can be accepted as partial work, with the obligation visible; that does not authorize releasing the unaudited epic.

### F4. High: Approval and evidence are not bound to a specific revision

Evidence: [plan approval header](.apm/templates/PLAN.md#L1), [developer approval check](.apm/agents/sdp.developer.agent.md#L19), and [history entry format](.apm/templates/HISTORY.md#L9).

The approval header and append-only history are useful foundations. They do not identify an immutable plan revision, starting code snapshot, or exact candidate reviewed. A changed plan can retain `status: approved`; a security result can refer to code that a subsequent QA repair changed. The templates also do not require complete approver identity/time validation.

The global instructions already require approved upstream artifacts. It would be inaccurate to claim that approval checks are entirely absent simply because each specialist does not repeat them. The substantive gap is revision binding and executable validation, not missing repetition.

**Recommendation:** Bind approval to the plan body digest, upstream artifact revisions, and an execution policy. Bind every assurance result to a candidate snapshot. A changed contract invalidates approval; changed product code invalidates candidate assurance. Human-readable fields and hashes improve consistency but are not tamper-proof authorization when the same agent can edit them.

### F5. High: Current scope rules optimize document size rather than delivery coherence

Evidence: [one-day sizing rule](.apm/agents/sdp.analyst.agent.md#L24), [plan scope limits](.apm/templates/PLAN.md#L11), and [developer file restriction](.apm/agents/sdp.developer.agent.md#L38).

An eight-file maximum, a 300-line guideline, mandatory splitting, and roughly one developer-day per story can fragment one useful capability into several approval cycles. Conversely, a two-file authorization change can fit those limits while carrying substantial risk. Restricting edits to an exact file list also forces avoidable stops for predictable adjacent tests, generated clients, or dependency files.

**Recommendation:** Replace mechanical caps with a capability boundary, risk class, uncertainty assessment, verification obligations, and approved resource budget. Keep file and line estimates as review information, not permission boundaries. Retain module/path boundaries and explicit exclusions to prevent unrelated changes.

### F6. High: Specialist separation is instructional, not enforced by tool restrictions

Evidence: [reviewer configuration](.apm/agents/sdp.reviewer.agent.md#L1), [security configuration](.apm/agents/sdp.security.agent.md#L1), and [QA configuration](.apm/agents/sdp.qa.agent.md#L1).

These agents do not declare tool allowlists. Their roles describe reviewing and testing, but the definitions do not enforce source-write separation. In an unattended flow, a reviewer that repairs code while reviewing can invalidate its own evidence and conceal responsibility for the change.

**Recommendation:** Only the developer writes product code. Review/security return findings; QA executes approved validation and returns evidence. The coordinator records state and reports. A terminal-capable agent is not technically read-only merely because it lacks an edit tool: strict environments need sandboxing or controlled command execution. Prompt restrictions alone are not a security boundary.

### F7. High: Test guidance permits deleting a failing test without requiring justification

Evidence: [write-tests guidance](.apm/skills/write-tests/SKILL.md#L28) says, "Don't skip failing tests - fix or delete them" (punctuation normalized).

An inexpensive implementation agent optimizing for green checks could interpret deletion as an acceptable repair. Other testing standards require meaningful coverage, but this sentence introduces a conflicting shortcut precisely where unattended execution needs stronger constraints.

**Recommendation:** Require a root-cause explanation for every removed or weakened assertion. Obsolete tests may be replaced only with evidence that the approved behavior changed and equivalent required coverage remains. A green suite with reduced acceptance coverage must fail assurance.

### F8. Medium: Retry semantics differ between global policy, agents, and history

Evidence: [central loop breaker](.apm/instructions/sdlc-process.instructions.md), [reviewer loop breaker](.apm/agents/sdp.reviewer.agent.md#L46), and [history escalation rule](.apm/templates/HISTORY.md#L22).

The global rule refers to two failed hardening cycles on a story. The specialists and history discuss failure of the same step twice, and specialist wording about the second failure versus a further failure is ambiguous. A review failure followed by a security failure can therefore be counted differently. This becomes a cost and termination defect once transitions are automatic.

**Recommendation:** Count rejected candidate snapshots centrally, independently of which stage rejected them. Define the retry ceiling precisely and persist it across sessions. Missing tools, interrupted runs, and unavailable environments are `blocked`, not quality failures and not passes.

### F9. Medium: Plans and results are too loosely structured for low-interpretation execution

Evidence: [implementation and test placeholders](.apm/templates/PLAN.md#L28), [developer outputs](.apm/agents/sdp.developer.agent.md#L49), [QA outputs](.apm/agents/sdp.qa.agent.md#L48), and [history template](.apm/templates/HISTORY.md#L5).

The plan provides steps, tests, risks, and rollback notes, but does not require acceptance IDs per step, precise contract changes, validation commands, expected outcomes, permitted discretion, or stop conditions. QA has Pass/Fail but no explicit Not Run/Blocked result. Narrative reports lack a shared schema for automatic routing.

**Recommendation:** Use a composed execution contract and a common stage-result envelope. Require observed evidence, not a verbal "tests passed." A lower-cost worker should execute resolved decisions, not reconstruct missing architecture.

### F10. Medium: Cost-aware model routing is not configured

Evidence: [planner configuration](.apm/agents/sdp.planner.agent.md#L1), [developer configuration](.apm/agents/sdp.developer.agent.md#L1), and [reviewer configuration](.apm/agents/sdp.reviewer.agent.md#L1). Concrete role definitions omit `model`; the [generic agent template](.apm/templates/template.agent.md#L3) already exposes it.

The intended inexpensive-implementation/premium-assurance split is therefore left to the user's selected model, not expressed as policy or recorded evidence. A new Markdown field naming a model profile would not itself change runtime selection.

**Recommendation:** Map project-owned role profiles to supported agent model configuration, preflight availability and permitted cost tiers, and record the actual model when the runtime exposes it. Missing required assurance models must block or use an explicitly approved equivalent, never silently downgrade assurance.

## 2. Recommendation

**Keep the six gates. Replace manual dispatch inside Gates 5-6 with a supervised delivery run bounded by two human decisions: approve the execution contract, then accept the verified result.**

The current strengths are worth preserving: canonical distributed templates, separate specialist roles, approved artifacts, traceability, explicit security policies, scoped context maps, and a loop-breaker concept. The problem is not excessive engineering discipline. It is using humans to transport context between roles.

The proposed unit of approval is a **delivery package**: one coherent, demonstrable capability with a clear acceptance boundary. It may implement several related backlog stories. Internal steps remain small enough to verify, but do not each require human approval or a separate planning cycle.

Do not replace developer-day estimates with promises that AI will complete any week-sized feature in one or two hours. Tool latency, integration environments, unknown requirements, and verification frequently dominate. Size by what can be specified, executed, and independently verified together; measure actual runtime and cost afterward.

## 3. Target Workflow

All commands in this section are proposed UX, not currently implemented commands. Existing `/audit-security` and `/qa-validate` remain the actual manual prompt names.

1. `/plan-task` produces a draft delivery contract and a concise decision brief. A premium plan-readiness check identifies unresolved decisions before asking the human to approve; it cannot approve on the human's behalf.
2. One explicit action, such as "Approve and run delivery DP-12 revision 3," records approval and starts a coordinator. A proposed `/deliver` entry point can express this combined action; it must identify the exact revision and reject an ambiguous "go ahead."
3. The coordinator checks approved artifacts, scope, worktree baseline, tools, models, security policy, validation prerequisites, and resource limits.
4. The developer implements the approved internal steps and runs focused checks. It returns a structured result to the coordinator, not another agent invocation.
5. The coordinator runs code review, the required security review, then QA against the same candidate. Explicit waivers remain waivers, never security sign-offs.
6. On an in-scope defect, the coordinator authorizes a bounded repair using finding IDs. Any changed candidate re-enters assurance from code review. Contract changes stop for amendment and reapproval.
7. Success produces an acceptance brief and `awaiting-acceptance`. The user accepts, requests a bounded correction, or rejects the delivery. No automatic acceptance.
8. After acceptance, offer the next package for planning. Drafting the next plan may be opt-in; approving or implementing it remains a separate decision.

Normal execution should require no intermediate stage-dispatch messages. Tool-permission prompts, missing credentials, material ambiguity, or safety blocks may still require interaction. Workflow automation does not authorize suppressing platform security controls.

### Transition Contract

| State/result | Allowed next action | Mandatory guard |
| --- | --- | --- |
| Draft | Await approval | No product-code writes |
| Approved | Preflight | Approval matches contract and policy revisions |
| Preflight passed | Implement | Valid baseline, models, tools, security policy, and budget |
| Implementation ready | Review | Candidate identified; required implementation checks recorded |
| Review passed | Security or QA | Resolve approved policy and outstanding epic obligations |
| Security passed | QA | Sign-off references current candidate |
| QA passed | Await acceptance | All required evidence current; no blocking findings or due obligations |
| Quality failure | Repair or escalate | Repair remains in scope and retry budget remains |
| Missing evidence/environment | Blocked | Never coerce Unknown or Not Run to Pass |
| Scope or contract drift | Await amendment | No worker may rewrite its own authorization |
| Human acceptance | Accepted | Accept exact verified candidate; no subsequent product changes |

### Coordinator Ownership

Add a proposed `sdp.orchestrator` role. It owns dispatch, state, evidence aggregation, and escalation, but does not design features, repair code, or invent verdicts. Workers return results to this one owner; they do not recursively call one another. This keeps the first implementation sequential, avoids nested-agent requirements, and prevents multiple agents from racing to update the same state.

Retain manual prompts for isolated checks and environments without orchestration support. Manual results may satisfy a pipeline stage only when their provenance, policy, and candidate identity validate against the same result contract.

## 4. Composed Plans

Evolve the existing [plan template](.apm/templates/PLAN.md) into two views of the same contract, not two competing specifications.

### Human Decision Brief

Keep the first section short enough for a serious review:

- Outcome and demo: what will work when the delivery is accepted.
- Included stories and AC IDs; explicit non-goals.
- Public behavior, data, security, and compatibility changes.
- Important design decisions and their tradeoffs.
- Size, risk, uncertainty, and assurance requirements.
- Allowed autonomy, resource limits, and stop conditions.
- Verification and rollback strategy; outstanding decisions must be resolved before approval.

### Execution Contract

| Required section | What the implementer and assurance agents receive |
| --- | --- |
| Identity | Delivery ID, revision, approved body digest, upstream artifact references, approver, timestamp |
| Behavioral contract | AC IDs, preconditions, invariants, observable outcomes, errors and edge cases |
| Change boundary | Allowed modules/path patterns, expected files, excluded areas, dependency and migration constraints |
| Design decisions | Selected interfaces, data shapes, reuse points, compatibility rules, explicitly rejected alternatives |
| Context map | Authoritative files/symbols and why they matter; permission for focused discovery inside the boundary |
| Work graph | Ordered steps or dependencies, each with inputs, intended change, AC IDs, and an executable check |
| Verification matrix | AC-to-test mapping, commands, working directories, prerequisites, expected results, evidence locations |
| Autonomy policy | Permitted implementation choices, allowed repair categories, escalation triggers, forbidden actions |
| Operational limits | Resource ceiling, repair ceiling, model profiles, environment and network permissions |
| Recovery | Local reversal, compatibility fallback, migration recovery and interruption/resume rules |

Be strict about behavior and interfaces, not exact code text. Allow a developer to choose private helper names, reuse an existing utility, and add a relevant test within approved modules. Require reapproval for a new service, dependency outside policy, changed public contract, weakened AC, or expanded data/security boundary.

**Example:** "Organization invitation lifecycle" could include invitation creation, token persistence, email adapter integration, acceptance, expiration, audit events, UI states, and tests. It is one package if the design resolves the contracts and all parts serve the same outcome. Steps can be verified independently without becoming eight separately approved stories. An organization-wide identity redesign is a separate decision and outside this package.

**Readiness rule:** Every AC has an observable check; every step traces to an AC or approved non-functional obligation; every material decision is resolved; every external prerequisite is available or causes preflight to block. A contract that fails this rule is not made executable by assigning a stronger implementation model.

## 5. Capability-Based Sizing

Use three independent labels: **delivery size**, **risk**, and **uncertainty**. Do not infer security rigor from size or implementation-model price.

| Size | Delivery shape | Execution approach |
| --- | --- | --- |
| S | One bounded behavior change with known contracts | One package, short work graph, focused assurance |
| M | One end-to-end capability crossing established layers | One package with internal integration checkpoints |
| L | A cohesive subsystem capability with several interacting flows | One package when contracts are resolved; staged implementation and aggregate regression evidence |
| XL | Multiple independently useful capabilities, unresolved architecture, or independently hazardous rollout units | Discovery/design or split along outcomes, ownership, or rollback boundaries |

**Risk:** Low, Moderate, High, based on blast radius, privilege, sensitive data, reversibility, and external exposure. A two-file tenant-isolation fix may be S/High; a broad mechanical API-client update may be L/Low. High risk requires stronger evidence even when code is small.

**Uncertainty:** Resolved, Bounded, or Open. Bounded uncertainty permits named implementation choices within the contract. Open uncertainty about public behavior, data loss, or architecture blocks approval and needs discovery. Do not hide uncertainty in a larger T-shirt size.

Split when outcomes can be accepted separately, rollbacks must be independent, ownership boundaries require different approvals, verification cannot cover the combined candidate, or the human cannot meaningfully understand the decision brief. Do not split solely because a diff crosses eight files or 300 lines.

Large approval packages do not require a single enormous model context. Dispatch one internal step at a time with the relevant contract slice, preserve progress on disk, and perform whole-package assurance at the end. The developer gains fewer approval interruptions without losing focused implementation checks.

## 6. Model and Cost Strategy

| Role | Recommended profile | Cost-control mechanism |
| --- | --- | --- |
| Planner and plan-readiness review | Strong reasoning | Resolve expensive ambiguity before coding |
| Coordinator | Reliable orchestration with permitted assurance-model cost tier | Minimal narrative, compact state and results, no repeated exploration |
| Developer | Economical coding model proven on the project's stack | Narrow execution packets and executable checks |
| Code reviewer | Strong independent reasoning | Inspect actual diff and contracts, not just developer summaries |
| Security | Strong security reasoning where policy requires it | Threat and boundary context; do not audit irrelevant surfaces repeatedly |
| QA | Strong reasoning plus actual test execution | Independent AC-derived scenarios and regression evidence |

Current VS Code Local documentation supports named custom-agent models, model fallback lists, and coordinator-to-subagent invocation. It also states that explicit subagent model selections are constrained by the main model's cost tier. A cheapest-possible coordinator may therefore be unable to invoke premium assurance workers. Validate this on the supported harness before selecting a default; use a permitted coordinator tier with short prompts rather than assuming arbitrary cross-tier dispatch.

Profiles are SDP policy concepts, not native model IDs. Map them to models available in the user's environment; do not ship invented IDs or assume one provider's pricing. Configure approved equivalent fallbacks only. Do not use experimental automatic model routing as a correctness dependency.

Record stage latency, dispatch count, repair count, blocked reason, and model identity where available. Record token/credit consumption only when exposed reliably; otherwise mark it unavailable and use measurable call/time ceilings. Optimize **cost per accepted capability**, not price per implementation request. Cheaper coding that repeatedly fails premium review can cost more overall.

Premium agents are not proof of correctness. They need independent contexts, raw code, actual test results, and a requirement-derived oracle. QA should look for missing cases and weakened tests rather than merely rerun the implementer's favorable examples. Model escalation is bounded by approval and budget, not an endless repair strategy.

## 7. State, Evidence, and Recovery

Keep approved intent separate from mutable execution state. Use the existing [active pointer](.apm/templates/ACTIVE.md) for navigation and [history log](.apm/templates/HISTORY.md) for the human-readable audit trail. Add one proposed structured run record per delivery, not a new Markdown document for every subtask. Preserve approved plan revisions before the current plan is replaced.

The run record should contain a schema version, run/delivery IDs, plan digest, upstream revisions, baseline identity, candidate identity, current stage, step completion, findings, rejected-candidate count, pending audits, resource consumption, and acceptance decision. Choose one structured serialization and validate it with a real parser and schema, not loose text matching.

Every worker result must contain:

- Stage, run ID, plan digest, candidate identity, and actual model when available.
- Verdict: Pass, Fail, Blocked, or a policy-authorized Not Applicable.
- Findings with stable IDs, severity, AC/contract reference, evidence, and required correction.
- Checks executed, command/environment, result, and an artifact/log reference; explicitly list checks not run.
- Scope changes, unresolved questions, and recommended next action, which the coordinator independently validates.

Candidate identity must include the actual worktree contents under review, including relevant untracked files, not only `HEAD`. Approval digests exclude mutable approval metadata to avoid self-reference. Product/source changes after assurance invalidate results; appending report metadata does not. Environment and dependency fingerprints also matter when interpreting test evidence.

On resume, validate the plan, baseline, candidate, and last completed stage before dispatch. Interrupted validation is not a pass. Avoid rerunning completed side-effecting steps blindly: inspect migration state, command completion markers, and external effects first. Preserve unrelated user changes and block on conflicting concurrent edits; do not reset the worktree to make recovery easier.

**Initial repair policy:** One automatic repair round after the first rejected candidate. A second rejected candidate escalates, even if the failures came from different stages. This makes the existing two-failure intent unambiguous. An environment block does not consume a quality-failure count, but cannot trigger infinite infrastructure retries. Budget exhaustion, material scope drift, and destructive operations stop immediately.

Any product-code repair invalidates prior assurance for that candidate. Initially rerun the complete required assurance chain; optimize reuse later only if dependency-aware evidence invalidation is demonstrated. Deferred epic audits must inspect the aggregate approved epic changes, not merely the last delivery's diff.

## 8. Implementation Approach and Limits

### Recommended First Release: Coordinator With Explicit Contracts

Use a top-level custom agent with the documented `agent` tool set and an `agents` allowlist for developer, reviewer, security, and QA. Configure workers to return results rather than invoke one another. Keep the initial pipeline sequential, with a single source-code writer and a single state writer.

This is feasible as a customization-layer workflow, but prompt obedience alone is not deterministic enforcement. Publish the exact tested VS Code/Copilot harness and minimum versions. Current documentation distinguishes Local and Agent Host behavior, including prompt-file support; do not advertise the same automation semantics across every target in [apm.yml](apm.yml).

### Hardening Layer: Deterministic Validation

Add schema and transition checks for contract approval, candidate freshness, required stage results, retry limits, and closure obligations. Where supported, hooks or a small runner can enforce selected tool and state guards. Hooks are runtime-dependent and cannot by themselves provide a durable scheduler, authenticated human approval, or a complete sandbox.

For durable background execution, authenticated approval, isolated worktrees, or reliable recovery across closed editor sessions, use a dedicated runner/extension or CI integration in a later release. Do not claim that adding a coordinator Markdown file supplies those guarantees. Keep install-time dependencies minimal; any runtime dependency needs an explicit compatibility and installation decision.

### Alternatives Not Recommended

- Changing every handoff to `send: true`: still requires button selection and supplies no conditional state machine.
- Merging all roles into one large agent: reduces dispatch but removes independent assurance and model specialization.
- Unrestricted agent-to-agent recursion: obscures retry ownership, context, and costs.
- Running several code-writing workers in the same worktree: introduces conflicts and evidence races before it offers proven value.
- Automatically accepting or merging after QA: confuses technical validation with human authorization.

## 9. Adoption Plan

| Phase | Change | Exit evidence |
| --- | --- | --- |
| 1. Contract alignment | Resolve final acceptance, deferred audit closure, retries, test deletion, composed plans, and capability sizing | Consistent rules and representative approved-plan examples; manual mode still works |
| 2. Supervised pipeline | Add coordinator and one approval-and-run entry point; stage-result schema and model preflight | An approved package completes through QA without stage-dispatch prompts and stops for acceptance |
| 3. Recovery and enforcement | Persist revision-bound state, validate transitions, handle interruptions and baseline drift | Fault-injection scenarios cannot skip checks, reuse stale evidence, or exceed repair limits |
| 4. Cost calibration | Compare economical implementation with stronger alternatives on real delivery packages | Measured cost per accepted capability, defect escapes, intervention count, and latency |

Implement source changes in [.apm](.apm) first. Synchronize its agents, prompts, process instructions, plan/backlog/epic/design templates, state/history templates, and the affected test skill. Update [README.md](README.md) to explain manual versus supervised modes, supported harnesses, approvals, and recovery. Regenerate [AGENTS.md](AGENTS.md) through the repository's compilation workflow rather than editing generated rules manually.

The current [Bash installer](install.sh) recursively copies canonical source into client `.github/`, so files added within the existing tree do not necessarily require new copy logic. Nevertheless, test actual destinations, both installers, non-destructive upgrades, and preservation of client configuration. New runtime helpers, model configuration, or hook files require explicit packaging verification. Mixed old/new policies after a non-overwriting upgrade should produce a compatibility warning or preflight block, not silent partial automation.

Do not hand-edit archived build outputs. Regenerate supported distributions through the existing packaging process when implementation is approved. Distribution parity is a release gate, not something established by this review.

## 10. Required Acceptance Scenarios

1. An unapproved plan or a plan modified after approval cannot write product code.
2. One explicit approval-and-run action executes implementation, review, required security, and QA without manual stage dispatch, then waits for human acceptance.
3. QA success alone cannot mark the package accepted or authorize the next package, merge, or deployment.
4. A final delivery with an outstanding epic audit cannot close the epic before aggregate audit and final QA evidence exist.
5. An authorized waiver is recorded as a waiver; missing or contradictory security policy blocks preflight.
6. A first rejected candidate can receive one in-scope repair; a second rejection at any stage escalates.
7. An unavailable tool/model, interrupted test, or absent environment produces Blocked, never Pass.
8. A repair or user edit to candidate code invalidates stale review, security, and QA evidence.
9. Resume does not repeat completed destructive or external side effects and does not overwrite unrelated user work.
10. Reviewer/security cannot silently modify product code; QA cannot erase tests to manufacture a pass.
11. A cohesive capability exceeding eight files or 300 lines can be approved when its contracts and evidence are complete; a tiny high-risk change still receives appropriate assurance.
12. Model fallbacks, budget exhaustion, and scope amendments follow the approved policy rather than agent convenience.

Evaluate these with representative fixtures and scripted worker results before live agent trials. Then run end-to-end trials in each advertised harness. Prompt linting alone cannot establish orchestration correctness.

## 11. Acceptance Brief

The final human checkpoint should contain a short, inspectable delivery summary:

- Delivered outcome and demo or reproducible behavior check.
- AC coverage with links to actual evidence and the exact candidate identity.
- Review, security-policy disposition, and QA verdicts.
- Important contract changes, deviations, remaining risks, and tracked non-blocking debt.
- Actual resource use where available, plus rollback/recovery notes.
- One clear decision: accept this candidate, request a bounded correction, or reject it.

This restores developer attention to deciding what to build and whether the result is acceptable, rather than manually advancing a pipeline. The stronger contract is what makes larger delivery packages and economical implementation practical; automation alone does not.

## Review Notes

**Method:** Static review of the canonical plugin, a read-only specialist pass, direct verification of central findings, and consultation of official VS Code documentation. The specialist pass was not treated as authoritative where it conflicted with source or platform documentation. No application TECH file or active feature was present; none was created for this maintainer review. No gate agent was run and no behavior change was authorized.

**Platform references:** [Custom agents and handoffs](https://code.visualstudio.com/docs/copilot/customization/custom-agents) and [subagents, model selection, and orchestration](https://code.visualstudio.com/docs/copilot/agents/subagents), consulted 2026-09-25. These establish documented capabilities, not a successful runtime test in this repository.

**Change accounting:** Added this root-level review only. No changes to [.apm](.apm), because recommendations require a separately approved implementation effort. [README.md](README.md), [install.sh](install.sh), and [install.ps1](install.ps1) remain unchanged because current behavior, distributed structure, commands, and setup expectations were not changed. Installer syntax checking does not constitute installation or multi-agent integration testing.

**Validation performed:** All 44 Markdown links were checked for local target existence and source-line bounds where applicable; document content is ASCII and editor diagnostics reported no errors. The required raw `bash -n install.sh` check failed at line 33 on existing CRLF line endings. An LF-normalized stream passed Bash syntax checking without modifying the installer. Thus the raw-check requirement remains unsatisfied in this checkout; installation and proposed pipeline behavior remain untested.