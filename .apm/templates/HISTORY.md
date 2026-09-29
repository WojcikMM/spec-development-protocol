# History: <Feature Title>

Append-only log of completed work and hardening outcomes for `spec/<slug>/`. Do not edit or delete prior entries — append new ones.

## Entry Format

Copy this block per completed story or hardening event:

```md
### <ISO date> — STORY-<N>: <title>
- Gate: <5 Implementation | 6 Hardening>
- Actor: <sdp.developer | sdp.reviewer | sdp.security | sdp.qa | sdp.orchestrator>
- Summary: <what was done / what was found>
- Severity (if finding): <Critical | High | Medium | Low>
- Security review: <per-story audit result | epic-level deferred | waived: "<reason>">
- Rejected-candidate count for this delivery package: <n>
- Outcome: <Approved | Request Changes | Pass | Fail | Blocked | Escalated to user>
```

## Delivery Run Record and Worker Envelope

Initialize `spec/<slug>/deliveries/<delivery-id>.json` from `.github/templates/DELIVERY-RUN.json`. Both modes use the same record. The coordinator writes it under supervision; the currently invoked role writes it manually (a read-only reviewer returns a record for the next role to persist). Append narrative summaries here, keeping previous entries intact. Workers return this JSON envelope for each stage; the state owner validates and appends it to `stage_results`:

```json
{
  "schema_version": 1,
  "run_id": "<run-id>",
  "delivery_id": "<slug>-DP-<N>",
  "plan_revision": "<revision>",
  "plan_digest": "<recorded at approval>",
  "baseline_id": "<baseline manifest sha256>",
  "candidate_id": null,
  "stage": "review",
  "verdict": "blocked",
  "reason": "<missing evidence, failure, or policy disposition>",
  "findings": [],
  "checks_run": [{"command": "<command or inspection>", "environment": "<fingerprint>", "result": "<actual result and exit code>", "evidence": "<log or artifact reference>"}],
  "checks_not_run": ["<anything skipped, and why>"],
  "ac_coverage": [],
  "files_touched": [],
  "scope_changes": [],
  "unresolved_questions": [],
  "recommended_next_action": "<action>",
  "actor_model": null,
  "timestamp": "<ISO 8601>"
}
```

### Validation Contract

Parse JSON with an available structured parser before state transitions; these instructions are validation requirements, not a shipped runtime validator. Missing tooling or an invalid envelope blocks progression.

- Require every envelope field above; identity strings must match the run. `candidate_id` may be null only for `blocked`; `actor_model` is null unless the runtime exposes it. Never invent evidence or model names.
- `stage` is one of `preflight`, `implement`, `review`, `security`, `qa`, `acceptance`; `verdict` is `pass`, `fail`, `blocked`, or `not_applicable`. The latter requires the exact deferral/waiver reason. QA pass is not acceptance.
- `findings` entries require `id`, `severity` (`Critical|High|Medium|Low`), `ac_ref`, `evidence`, `required_fix`; retain stable IDs through repair. `ac_coverage` entries require `ac_id`, `result`, `evidence`; every required AC needs passing evidence for QA pass. Missing checks explicitly list reasons and cannot satisfy a required check.
- Manifest entries require `path` (repository-relative), `sha256` (file content hash), and `state` (`present|deleted`); a deletion has null content hash. Sort paths ordinally, serialize entries as compact UTF-8 JSON with fixed key order `path,sha256,state`, and SHA-256 that array. Include relevant tracked/untracked content, tests, configuration and dependency files; explicitly list approved reporting/generated exclusions. Baseline and candidate identities are not HEAD alone.
- Each `pending_audit` entry requires `epic_id`, `baseline_id`, `covered_deliveries`, `status` (`pending|audited|closed`), and `evidence`. Copy all unresolved obligations from previous package records; ACTIVE lists the epic IDs still open. Only aggregate-audit plus final-QA evidence closes an obligation.
- `completed_steps` require `step_id`, `candidate_id`, `checks`, `external_effects` and `completion_evidence`. Reconcile these on resume before repeating commands. Resources and ceilings carry across resumes; null telemetry means unavailable, not zero.
- `rejected_candidates` stores unique candidate IDs; its length equals the non-negative integer `rejected_candidate_count`. First rejection permits one repair, second escalates; blocked stages do not increment it. Never count the same candidate twice.
- `final_status` uses ACTIVE's vocabulary. `acceptance.decision` is `pending|accepted|rejected|correction-requested`, with candidate/user/time required for a decision. Acceptance requires fresh plan/candidate/evidence and no due audit. A state mismatch blocks, never auto-corrects to passed.

## Acceptance Entry

On QA pass, append the acceptance brief and record the human decision once it is made — do not mark acceptance until the user explicitly decides:

```md
### <ISO date> — ACCEPTANCE: DP-<N>
- Candidate: <candidate_id>
- AC coverage: <STORY-N:AC1 -> evidence link, ...>
- Verdicts: Review <verdict>, Security <verdict/deferred/waived>, QA <verdict>
- Deviations / remaining risks: <list, or "none">
- Demonstration and recovery: <reproducible check, rollback notes>
- Resource use: <measured dispatch/time, unavailable telemetry explicitly noted>
- Decision: <pending | accepted | rejected | correction requested: "<what>">
- Decided by: <user name>, <ISO date>
```

## Escalation Log

If a delivery package's candidate is rejected twice (by review, security, or QA, in any combination), log the escalation here per the Loop Breaker rule in `sdlc-process.instructions.md`:

```md
### <ISO date> — ESCALATION: DP-<N>
- Failed stage(s): <reviewer | security | qa, for each rejection>
- Rejected-candidate count: 2
- Decision requested from user: <descope | split package | accept documented risk>
- Resolution: <pending | resolved: description>
```
