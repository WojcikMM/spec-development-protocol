# History: <Feature Title>

Keep one concise entry per delivery outcome. Add separate entries only for an
unresolved block or escalation. Detailed command output stays in existing
test/CI logs and is referenced rather than copied here.

## Delivery Entry

```md
### <ISO date> - <delivery-id>: <title>
- Outcome: <delivered behavior>
- Profile: <Lean | Balanced | Compliance>
- Acceptance criteria: <behavior -> evidence reference>
- Verdicts: Review <result>; Security <result/not applicable>; QA <result/not applicable>
- Changed paths: <concise list>
- Checks: <command or evidence reference and result>
- Deviations / remaining risks: <none or list>
- Decision: <awaiting acceptance | accepted | rejected | changes requested>
- Decided by: <identity and time, when decided>
```

## Blocking or Escalation Entry

```md
### <ISO date> - BLOCKED: <delivery-id>
- Stage: <implement | review | security | qa | acceptance>
- Reason: <actionable blocker or repeated autonomous rejection>
- Material findings: <stable IDs and evidence>
- Decision needed: <specific user choice>
```

## Compact Worker Result

The active run checkpoint stores compact structured results:

```json
{
  "stage": "review",
  "verdict": "pass",
  "findings": [],
  "checks": [
    {
      "name": "<check>",
      "result": "<actual result>",
      "evidence": "<log, test, or artifact reference>"
    }
  ],
  "changed_paths": [],
  "scope_changes": [],
  "recommended_next_action": "<action>"
}
```

Valid verdicts are `pass`, `fail`, `blocked`, and `not_applicable`.
`not_applicable` requires a policy reason. Never invent evidence or telemetry.

Compliance profile may extend the run record with plan/upstream integrity,
baseline/candidate manifests, environment identity, and detailed retained
evidence as required by `TECH.md`.
