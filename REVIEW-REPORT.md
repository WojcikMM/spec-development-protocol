# SDP Framework Review Report

Date: 2026-10-07

## 1. Purpose

This report reviews the current Spec Development Protocol (SDP) content in
[`.apm/`](./.apm/) before any behavioral changes are made.

The review covers:

- the six-gate SDLC process;
- custom agents;
- prompts and handoffs;
- skills;
- templates and generated artifacts;
- shared instructions;
- the supervised `/deliver` workflow;
- code-comment behavior;
- developer experience and future directions.

This is a static design review. It does not include measured runtime or token
benchmarks from executing a representative delivery. No framework behavior was
changed as part of this report.

## 2. Executive Summary

SDP has a strong foundation: it separates intent, design, implementation, and
assurance; it prevents unapproved implementation; it makes acceptance criteria
testable; and it keeps final acceptance with a human.

The main problem is that the framework now optimizes for auditability and
interruption recovery more than for everyday developer flow. The supervised
path repeats the same controls across the process instruction, orchestrator,
workers, prompts, templates, run record, history, and README. This creates:

- too much ceremony for low- and moderate-risk changes;
- repeated context loading and verification;
- excessive persistent documentation;
- command syntax that exposes internal orchestration identifiers to users;
- duplicated review and validation work;
- conservative blocking behavior for metadata failures that are not product
  risks;
- reduced developer agency.

The recommended direction is:

1. Make the common path simple:
   `/plan-task` -> review `PLAN.md` -> `/deliver` -> accept or describe changes.
2. Let bare `/deliver` resolve the current package from `spec/ACTIVE.md`.
3. Treat invoking `/deliver` after reviewing the current plan as explicit plan
   approval.
4. Scale assurance by risk and changed boundaries instead of always applying
   the full sequence.
5. Keep traceability in specs, tests, and final reports - not in source-code
   comments.
6. Persist only decision-grade evidence by default.
7. Move hashes, manifests, immutable plan archives, environment fingerprints,
   and exact candidate IDs to an opt-in compliance profile.
8. Accept natural-language correction feedback and automatically route it to a
   bounded repair or replanning step.

The framework should keep its quality gates, but make the cost of each gate
proportional to risk.

## 3. Inventory and Evidence

The canonical source contains 54 files:

| Area | Files | Lines | Words | Main role |
| --- | ---: | ---: | ---: | --- |
| Agents | 10 | 620 | 5,761 | Role behavior and handoffs |
| Instructions | 2 | 362 | 5,022 | Global coding and SDLC contract |
| Prompts | 10 | 147 | 1,177 | User entry points |
| Skills | 19 | 716 | 4,008 | Implementation guidance and template assets |
| Templates | 13 | 543 | 2,892 | Runtime artifacts and extension starters |
| **Total** | **54** | **2,388** | **18,860** | |

Important observations:

- Agents and instructions contain 10,783 words, about 57% of all package words.
- All 13 files in [`.apm/templates/`](./.apm/templates/) are mirrored
  byte-for-byte in
  [`.apm/skills/sdp-templates/assets/`](./.apm/skills/sdp-templates/assets/).
  The mirror adds 543 lines, 2,892 words, and 15.9% of package bytes.
- The mirror is currently required by APM packaging, but the direct installer
  copies both locations into client repositories.
- The process contract is repeated in
  [`sdlc-process.instructions.md`](./.apm/instructions/sdlc-process.instructions.md),
  [`sdp.orchestrator.agent.md`](./.apm/agents/sdp.orchestrator.agent.md),
  the four Gate 5/6 worker agents, their prompts, `PLAN.md`, `HISTORY.md`,
  `DELIVERY-RUN.json`, and the README.
- The current supervised path tracks a plan digest, upstream content hashes,
  HEAD, baseline and candidate manifests, environment fingerprint, stage
  envelopes, resource counters, rejection counters, audit obligations, and an
  exact acceptance candidate.

## 4. What Works Well

### 4.1 Clear separation of intent and implementation

The PRD -> backlog -> design -> plan progression is understandable and useful
for non-trivial work. It reduces premature coding and gives cheaper
implementation models a stronger contract.

### 4.2 Human control at meaningful points

The framework correctly avoids treating a passing automated check as a product
decision. Human acceptance after validation is a good principle.

### 4.3 Good role boundaries

The developer writes product code while reviewer, security, and QA inspect it.
This is a sound assurance model for high-risk work.

### 4.4 Strong change-boundary concept

The plan's allowed paths, explicit exclusions, and dependency constraints help
prevent scope creep. This is more useful than line-count limits.

### 4.5 Capability-based sizing

Size, risk, and uncertainty are treated independently. This is a meaningful
improvement over estimating work only by file count, line count, or elapsed
time.

### 4.6 Explicit security policy

Per-story, epic-level, and waived security review modes are better than either
always skipping security or blindly running the same audit for every change.

### 4.7 Useful focused skills

The implementation skills are short and practical. In particular,
[`write-tests/SKILL.md`](./.apm/skills/write-tests/SKILL.md) discourages deleting
tests merely to pass a gate, and the API, UI, migration, and error-handling
skills provide useful boundary-specific checks.

## 5. Findings and Recommendations

### P0 - Simplify the default `/deliver` contract

#### Current behavior

[`deliver.prompt.md`](./.apm/prompts/deliver.prompt.md) requires actions and
identifiers such as:

```text
/deliver approve-and-run <delivery-id> <plan-revision>
/deliver run <delivery-id> <plan-revision>
/deliver accept <delivery-id> <candidate-id>
```

Bare `/deliver` deliberately refuses to run. This is safe, but it makes users
operate the orchestrator's internal state machine.

#### Why it hurts

- The active feature and package already exist in `spec/ACTIVE.md`.
- The current plan already contains the delivery identity.
- The user has just reviewed `PLAN.md`.
- IDs and revisions are implementation details in the common case.
- Exact acceptance candidate syntax adds friction at the moment when the user
  should evaluate the outcome, not manage protocol metadata.

#### Recommendation

Make this the default flow:

```text
/plan-task
review spec/<active-feature>/PLAN.md
/deliver
review acceptance brief
"accept" OR describe what is wrong
```

Bare `/deliver` should:

1. Read `spec/ACTIVE.md`.
2. Resolve the current draft `PLAN.md`.
3. Show a compact plan identity and outcome.
4. Treat the user's invocation as approval of that current visible plan.
5. Record approval metadata automatically.
6. Run implementation and proportionate assurance.
7. Stop with an acceptance brief.

Explicit ID-based commands can remain as advanced recovery commands when more
than one package is active or state is ambiguous.

### P0 - Introduce proportional assurance profiles

#### Current behavior

Supervised delivery normally dispatches developer -> reviewer -> security ->
QA, with full candidate identity checks and full assurance restarted after a
repair.

#### Why it hurts

For a low-risk change, reviewer, security, and QA can independently inspect the
same diff, tests, acceptance criteria, plan boundary, and evidence. This is the
largest likely source of repeated work, latency, and model cost.

#### Recommendation

Use three profiles:

| Profile | Intended use | Default assurance |
| --- | --- | --- |
| Lean | Small, low-risk, resolved work | Developer validation + independent reviewer |
| Balanced | Normal product work | Developer + reviewer; security and QA triggered by risk/change type |
| Compliance | Regulated, high-risk, or explicitly requested | Current identity, audit, and evidence controls |

`Balanced` should be the default. The plan's existing size, risk, uncertainty,
security boundary, data boundary, migration, and public-contract fields can
select required assurance.

Examples:

- Documentation-only: validate links/format; no security or QA agent.
- Internal refactor with unchanged behavior: tests + reviewer.
- UI behavior: reviewer + focused UI/acceptance validation.
- Authentication, authorization, secrets, external input, or sensitive data:
  reviewer + security + QA.
- Migration: reviewer + migration validation + rollback evidence.

This keeps quality while avoiding the same fixed pipeline for every change.

### P0 - Add an explicit source-code comment policy

#### Current behavior

[`coding-standards.instructions.md`](./.apm/instructions/coding-standards.instructions.md)
says comments should explain "why", not "what". That is directionally correct,
but it does not explicitly forbid temporary traceability comments. Plans
strongly emphasize story IDs and AC IDs, so implementation models may copy
those identifiers into production code.

#### Recommendation

Add a clear policy to coding standards, the developer agent, and reviewer:

Source-code comments must not contain:

- story, epic, task, ticket, delivery, or acceptance-criterion IDs;
- descriptions of the implementation step just performed;
- change-history notes such as "added for STORY-12";
- obvious restatements of code;
- temporary planning notes, completed TODOs, or conversational explanations.

Comments are appropriate only when they preserve durable information that
cannot be expressed clearly in code, such as:

- a non-obvious business invariant;
- a compatibility constraint;
- a security rationale;
- an external protocol quirk;
- a deliberate trade-off that a future maintainer might otherwise undo.

Traceability belongs in the plan, tests, commit/PR description, and final
delivery summary - not in production code.

The reviewer should classify unnecessary traceability comments as cleanup
findings, and the developer should remove them before handoff.

### P1 - Reduce `PLAN.md` to implementation-grade information

#### Current behavior

[`PLAN.md`](./.apm/templates/PLAN.md) includes:

- delivery identity and immutable revision;
- upstream file hashes;
- model policy reference;
- decision brief;
- capability sizing;
- context map;
- security coverage;
- change boundary;
- work graph;
- verification matrix;
- autonomy policy;
- resource and repair ceilings;
- recovery and resume notes.

#### Why it hurts

The plan mixes four concerns:

1. human decision support;
2. developer implementation instructions;
3. orchestrator runtime configuration;
4. compliance/recovery metadata.

This makes plans longer and more expensive to create and read. It also makes
cheap implementation models spend context on orchestration rather than code.

#### Recommendation

The default plan should contain only:

1. Outcome and demo.
2. Included acceptance criteria and non-goals.
3. Relevant context and settled decisions.
4. Change boundary.
5. Ordered implementation steps.
6. Verification checks.
7. Risks, migration, and rollback only when applicable.
8. Open decisions the implementer may make.

Move model selection, dispatch budgets, hash identity, run counters, and resume
metadata out of the human plan. Store them in optional runtime configuration or
the compliance run record.

The plan should remain detailed enough that an economical implementation model
can execute it safely. The goal is not a tiny plan; it is a plan without
orchestrator bookkeeping.

### P1 - Replace strict identity machinery in the default profile

#### Current behavior

The framework does not merely "stick with commit numbers." HEAD is one input,
but the more expensive mechanism is a path-sorted SHA-256 manifest of tracked
and relevant untracked files, plus upstream hashes, a plan digest, candidate
hashes, and environment identity.

#### Value

This provides strong evidence that reviewer, security, QA, and acceptance refer
to the same working tree. It is useful for regulated delivery and interrupted
multi-session work.

#### Cost

- expensive preflight and re-verification;
- fragile when unrelated working-tree changes exist;
- difficult for agents to implement consistently without runtime helpers;
- metadata failures block delivery even when code quality is unaffected;
- no tamper-proof guarantee despite the ceremony.

#### Recommendation

For Lean and Balanced profiles:

- use the current working-tree diff as the candidate;
- record changed paths and whether the tree changed after review;
- re-run assurance when product files change;
- optionally record the current Git revision for orientation;
- do not hash every file;
- do not hash upstream Markdown artifacts;
- do not require a plan body digest;
- do not require the user to provide a candidate ID.

Keep full manifests and hashes for Compliance profile or explicit requests.

### P1 - Persist less documentation

#### Current behavior

A supervised package may create or update:

- `PLAN.md`;
- an archived immutable plan;
- `ACTIVE.md`;
- `deliveries/<delivery-id>.json`;
- multiple `HISTORY.md` entries;
- stage result envelopes;
- an acceptance brief;
- escalation and correction entries.

The same verdict, identity, findings, checks, and AC coverage can appear in the
worker response, run JSON, history narrative, acceptance brief, and active
state.

#### Recommendation

Use one source for each concern:

| Concern | Default source |
| --- | --- |
| Current feature/package pointer | `ACTIVE.md` |
| Approved implementation contract | `PLAN.md` |
| Machine resume checkpoint | Minimal run-state JSON, only while active |
| Final human-readable outcome | One delivery entry in `HISTORY.md` |
| Detailed command output | Existing CI/test logs, not copied into Markdown |

In the default profile:

- append one final history entry, plus unresolved blocking findings;
- do not append a narrative entry for every successful stage;
- store evidence references rather than reproducing evidence;
- remove completed transient run state unless resume/audit retention is needed;
- archive plans only when a project opts into that retention policy.

### P1 - Make correction feedback conversational

#### Current behavior

The user must issue `request-changes` with delivery ID, candidate ID, and a
correction. The orchestrator then classifies scope and counts a rejection.

#### Recommendation

After the acceptance brief, any non-acceptance feedback should be interpreted
as one of:

- bounded correction inside the approved outcome;
- changed requirement or expanded scope;
- rejection.

For a bounded correction, the framework should summarize its interpretation,
repair, and rerun only invalidated assurance. For changed requirements, it
should explain why replanning is required.

The automatic repair ceiling should limit autonomous repeated attempts, not
penalize explicit human-guided feedback. User-requested corrections should not
force the user to learn internal candidate identifiers.

### P1 - Remove duplicated policy from role files

#### Current behavior

The same rules for candidate identity, verdict vocabulary, rejection counts,
shared-state ownership, security routing, and acceptance are repeated across
the process instruction and multiple agent files.

#### Risks

- more tokens loaded per role;
- higher maintenance cost;
- contradictions after partial updates;
- mixed-version installations block `/deliver`;
- agents focus on protocol restatement rather than their specialty.

#### Recommendation

Keep one normative contract in
[`sdlc-process.instructions.md`](./.apm/instructions/sdlc-process.instructions.md).
Agent files should contain only:

- mission;
- role-specific inputs;
- role-specific checks;
- prohibited actions;
- compact output contract.

Prompts should describe the user-visible action, not restate the agent.
Templates should describe their fields, not repeat process policy.

Where the runtime supports reusable references, link to a shared worker
envelope instead of copying its semantics into every role.

### P1 - Simplify state

#### Current behavior

[`ACTIVE.md`](./.apm/templates/ACTIVE.md) has both `status` and `final_status`,
along with `current_gate`, `current_story`, and `pending_audit`. The run record
adds `current_stage`, completed steps, rejection state, audit state, and
acceptance state.

#### Recommendation

Use one package state vocabulary, for example:

```text
planned -> delivering -> awaiting-acceptance -> accepted
                           |                     |
                           -> changes-requested  -> rejected
```

Keep feature completion separate from package state only if multiple packages
are active. Derive gate/stage from the package state where possible rather than
storing overlapping fields that can disagree.

### P2 - Make security routing risk-triggered by default

#### Current behavior

`per-story` is the default security policy, while `epic-level` and `waived`
require reasons. This encourages a formal security agent run for many changes
that do not alter a security boundary.

#### Recommendation

Keep baseline security checks always on in coding and review, but dispatch the
specialist security agent when the change affects:

- authentication or authorization;
- secrets or credentials;
- external/untrusted input;
- sensitive data;
- cryptography;
- network trust boundaries;
- dependency or infrastructure security;
- an explicitly regulated control.

Allow projects to choose "security always" in Compliance profile.

### P2 - Clarify overlap between reviewer and QA

The reviewer already checks correctness, edge cases, plan alignment, test
quality, and regressions. QA independently derives scenarios from every AC and
checks regressions. Both are valuable for risky user journeys, but overlap for
small changes.

Recommended distinction:

- Reviewer: Is the change technically correct, maintainable, and safe?
- QA: Does the delivered behavior satisfy externally observable acceptance
  criteria in a representative environment?

If QA cannot exercise behavior beyond the same unit tests and diff already
reviewed, it should be skipped or folded into review for Lean/Balanced work.

### P2 - Treat template mirroring as a build artifact

The APM skill asset mirror is required for package compatibility, and the
existing sync script protects byte identity. However, users and maintainers
still see both copies, and the direct installer installs both.

Recommendations:

- continue authoring only [`.apm/templates/`](./.apm/templates/);
- generate the skill assets during pack/release;
- if packaging permits, exclude mirrored assets from direct installation;
- clearly mark generated assets as generated and non-editable;
- avoid loading both template roots into model context.

### P2 - Revisit global coding rules that are too absolute

Some global rules are valid goals but are overly universal:

- "one assertion focus per test";
- health endpoints on all services;
- metrics at all boundaries;
- branch per story/task;
- ADRs for significant decisions.

These can create unnecessary work in scripts, libraries, prototypes, and small
legacy changes. Move stack- or project-specific requirements to `TECH.md` and
use "when applicable" criteria in global instructions.

## 6. Proposed Target Workflow

### 6.1 Normal happy path

```text
1. /plan-task
   - Uses spec/ACTIVE.md.
   - Offers a story/package choice only if selection is ambiguous.
   - Writes a concise, implementation-grade PLAN.md.

2. Developer reads PLAN.md.

3. /deliver
   - Resolves ACTIVE.md and current PLAN.md.
   - Records approval implied by this explicit command.
   - Selects Lean, Balanced, or Compliance assurance from project policy and
     plan risk.
   - Implements, validates, and reports progress without requiring IDs.

4. Acceptance brief
   - Outcome demonstrated.
   - Acceptance criteria summarized.
   - Checks and material findings listed.
   - Remaining risks stated.

5. Human response
   - "accept"
   - or natural-language correction, such as:
     "The empty state is wrong; keep the action visible and disable it."
```

### 6.2 Correction path

```text
User feedback
  -> classify as bounded correction or contract change
  -> show one-sentence interpretation
  -> bounded repair, or return to planning
  -> rerun only assurance invalidated by the changed files/risk
  -> new acceptance brief
```

### 6.3 Resume path

`/deliver` should detect an interrupted active run and offer to resume it. An
explicit `/deliver resume <id>` should be needed only when several resumable
runs exist.

### 6.4 Advanced path

Retain explicit subcommands for automation, troubleshooting, and compliance:

```text
/deliver --profile compliance
/deliver resume <delivery-id>
/deliver inspect
/deliver reject
```

The advanced path should not define the everyday UX.

## 7. Recommended Artifact Model

### Keep

- `PRD.md` for meaningful product changes.
- `BACKLOG.md` and epic details for multi-story features.
- `DESIGN.md` when architecture or contracts need a durable decision.
- `PLAN.md` for implementation instructions and verification.
- `ACTIVE.md` as the active pointer.
- `HISTORY.md` as a concise decision and outcome log.

### Make conditional

- PRD/backlog/design for tiny fixes with an already clear contract.
- Dedicated security report.
- Dedicated QA stage.
- rollback section when there is no stateful or externally visible risk.
- immutable plan archive.
- detailed run record.

### Remove from default persistent output

- per-stage success narratives;
- full file-content hash manifests;
- duplicated command logs;
- resource counters when the runtime cannot reliably expose them;
- exact model telemetry when not provided by the runtime;
- repeated copies of the same findings and AC evidence.

## 8. Agent-by-Agent Review

| Agent | Assessment | Main improvement |
| --- | --- | --- |
| `sdp.prd` | Focused and useful | Permit a lightweight change brief when a full PRD is disproportionate |
| `sdp.analyst` | Good INVEST and security framing | Avoid repeating sizing/security policy in every downstream artifact |
| `sdp.architect` | Right-sized design intent is good | Make design optional for low-risk changes with established patterns |
| `sdp.planner` | Produces useful implementation detail | Remove runtime/compliance metadata from default plans |
| `sdp.developer` | Strong boundary and test discipline | Add explicit no-traceability-comments rule; reduce metadata duties |
| `sdp.reviewer` | Valuable independent assurance | Own technical correctness; avoid duplicating externally observable QA |
| `sdp.security` | Strong for sensitive changes | Trigger by security boundary/risk rather than default per-story |
| `sdp.qa` | Good AC orientation | Run when behavior can be independently exercised; otherwise fold into review |
| `sdp.orchestrator` | Sound separation of duties | Become a thin router; infer active state and hide IDs/hashes in normal mode |
| `sdp.discover` | Simple and practical | Add confidence/evidence summary without over-scanning the repository |

## 9. Prompts Review

The small gate prompts are generally clear. The problem is the supervised
prompt:

- [`plan-task.prompt.md`](./.apm/prompts/plan-task.prompt.md) teaches users that
  approval requires digest computation.
- [`deliver.prompt.md`](./.apm/prompts/deliver.prompt.md) exposes the action
  router rather than presenting a simple product workflow.
- manual hardening prompts repeat supervised-mode details that belong in shared
  process documentation.

Prompt recommendations:

- `/plan-task [optional story]`: infer from ACTIVE and ask only on ambiguity.
- `/deliver`: approve and deliver the active plan.
- `/deliver --strict`: opt into compliance controls.
- `/accept`: optional alias, but natural-language acceptance should work.
- keep manual specialist prompts for expert control and debugging.

## 10. Skills Review

The five implementation skills are concise and mostly useful. Improvements:

- load skills only when their boundary is touched;
- remove universal requirements that are stack-specific;
- keep skills focused on executable checks rather than generic principles;
- add a small "durable comments only" rule to UI/API skills where generated
  comments are common;
- make migration rollback requirements sensitive to the migration technology
  and irreversible approved operations;
- retain the strong test-deletion safeguard.

The `sdp-templates` skill exists mainly as a transport mechanism. It should not
be treated as behavioral model context unless templates must be read.

## 11. Developer Experience and Creative Work

The current language and mechanics can make development feel like factory work:
every step is a gate, every role produces a record, every deviation blocks, and
the implementation agent is told to execute the plan "exactly." This can reduce
ownership and suppress good local decisions.

Future versions should preserve intent control while increasing autonomy:

### 11.1 Specify outcomes and boundaries, not every keystroke

Plans should lock:

- observable behavior;
- contracts;
- safety constraints;
- non-goals;
- verification.

They should leave naming, local refactoring, helper extraction, and idiomatic
implementation choices to the developer unless those choices carry risk.

### 11.2 Add an explicit autonomy budget

Each plan can state:

- decisions the implementer owns;
- decisions that need a quick confirmation;
- decisions that require replanning.

This is more empowering than "execute exactly" while still preventing scope
creep.

### 11.3 Allow an implementation insight note

During implementation, the developer agent should be able to report:

```text
I found a simpler in-boundary approach that preserves the contract because ...
```

The orchestrator can accept it when outcome, risk, and verification remain
unchanged. Not every useful discovery should invalidate the plan.

### 11.4 Show meaningful progress, not protocol events

Progress updates should say:

- what capability is now working;
- what is being validated;
- what decision is needed.

Avoid narrating metadata writes, manifest construction, and state transitions.

### 11.5 Make gates proportional and explain their value

Developers accept ceremony more readily when each gate prevents a visible risk.
The framework should explain why a gate is active for this package and skip it
when it adds no independent confidence.

### 11.6 Support an exploration mode before commitment

Future SDP could allow a short, non-persistent technical exploration before the
final plan. This gives developers and agents room to investigate unfamiliar
code, compare approaches, and discover constraints without pretending the
first plan is already certain.

### 11.7 Measure outcomes

Track opt-in aggregate metrics such as:

- lead time from plan approval to acceptance;
- number of repeated inspections;
- percentage of security/QA runs that add unique findings;
- correction rounds;
- plan size versus implementation success;
- developer satisfaction.

Do not optimize the framework only for number of artifacts or formal
traceability completeness.

## 12. Suggested Implementation Roadmap

### Phase 1 - Immediate, high-value simplification

1. Add the source-code comment policy.
2. Make bare `/deliver` resolve `ACTIVE.md` and approve/run the visible plan.
3. Accept natural-language acceptance and corrections.
4. Simplify the default `PLAN.md`.
5. Remove exact candidate IDs from normal user commands.

### Phase 2 - Reduce repeated work

1. Add Lean, Balanced, and Compliance profiles.
2. Make reviewer/security/QA dispatch risk-based.
3. Separate reviewer and QA responsibilities.
4. Persist one final history summary instead of successful per-stage narratives.
5. Reduce default run state to a resume checkpoint.

### Phase 3 - Consolidate the framework

1. Make the process instruction the only normative workflow contract.
2. Shorten agent and prompt files to role-specific behavior.
3. Generate template mirrors only for packaging.
4. Add consistency validation for process vocabulary and template fields.
5. Add representative workflow benchmarks for elapsed time, agent calls,
   tokens, artifacts, and unique findings.

### Phase 4 - Developer creativity and feedback

1. Add autonomy budgets and in-boundary implementation discretion.
2. Add exploration mode.
3. Improve capability-oriented progress reporting.
4. Collect developer-experience feedback and tune ceremony by evidence.

## 13. Proposed Success Criteria

A future SDP revision should be considered improved when:

- a normal user can run `/plan-task`, read the plan, and run `/deliver` without
  supplying IDs, revisions, digests, or candidate hashes;
- low-risk delivery does not invoke assurance stages that cannot add
  independent evidence;
- source code contains no SDP story/task/AC commentary;
- the default plan is shorter while preserving outcome, boundary, decisions,
  steps, and verification;
- each fact has one persistent source of truth;
- a natural-language correction reliably triggers repair or replanning;
- strict auditability remains available as an opt-in profile;
- developers retain meaningful implementation discretion;
- quality is measured by accepted behavior and defect prevention, not document
  volume.

## 14. Final Assessment

SDP should not abandon specification, independent review, or human acceptance.
Those are its differentiators. It should remove protocol mechanics that users
must currently operate by hand and stop applying compliance-grade controls to
ordinary development by default.

The best next version is not "less disciplined." It is disciplined at the
decision points that matter, lightweight everywhere else, and explicit about
where developers are free to create.
