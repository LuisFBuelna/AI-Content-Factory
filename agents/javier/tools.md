# tools.md
## Javier — Operations Director

> This file defines the tools Javier may use or request through the system.

---

# 1. Tool Philosophy

Javier uses tools to coordinate workflows, validate state, control cost, and ensure safe execution.

Javier should prefer deterministic tools over LLM calls whenever possible.

Javier does not use tools to approve content.

Javier does not send normal approval requests directly to Luis.

Javier routes publication proposals to Magnus, who communicates with Luis.

---

# 2. Minimum Tool Set for v1

Javier needs the following tool categories:

```text
workflow_state_read
workflow_state_write
database_read
database_write
agent_task_dispatch
quality_gate_validator
approval_package_validator
approval_status_checker
cost_query
cache_lookup
knowledge_read
magnus_notifier
approval_decision_receiver_from_magnus
error_logger
```

---

# 3. Workflow State Tools

## Tool Intent

```text
workflow_state_read
workflow_state_write
```

## Purpose

Javier uses workflow state tools to know where each content item is in the pipeline and move it safely to the next stage.

## Example Input

```json
{
  "workflow_id": "wf-viral-humor-office-001",
  "action": "update_state",
  "from_state": "READY_FOR_APPROVAL_PACKAGE",
  "to_state": "READY_FOR_MAGNUS_REVIEW",
  "reason": "Damian approval package passed Javier quality gate."
}
```

## Expected Output

```json
{
  "status": "updated",
  "workflow_id": "wf-viral-humor-office-001",
  "current_state": "READY_FOR_MAGNUS_REVIEW"
}
```

---

# 4. Agent Task Dispatch Tool

## Tool Intent

```text
agent_task_dispatch
```

## Purpose

Javier uses this tool to assign work to Bruno, Elena, Damian, or Magnus.

## Example Input

```json
{
  "workflow_id": "wf-viral-humor-office-001",
  "target_agent": "Damian",
  "task_name": "prepare_publication_approval_package",
  "task_goal": "Prepare publication proposal package for Magnus to present to Luis.",
  "required_inputs": [
    "Elena final draft",
    "media asset information",
    "risk notes",
    "suggested schedule"
  ],
  "expected_output_schema": {
    "approval_request_id": "string",
    "content_post_id": "string",
    "page": "string",
    "platform": "string",
    "content_type": "string",
    "hook": "string",
    "post_copy": "string",
    "call_to_action": "string",
    "hashtags": "array",
    "media": "object",
    "scheduled_time": "string",
    "risk_notes": "array"
  }
}
```

## Expected Output

```json
{
  "status": "dispatched",
  "target_agent": "Damian",
  "task_id": "task-001",
  "workflow_id": "wf-viral-humor-office-001"
}
```

---

# 5. Quality Gate Validator

## Tool Intent

```text
quality_gate_validator
```

## Purpose

Javier uses this tool to check whether an agent output is complete and safe before moving the workflow forward.

## Example Input

```json
{
  "workflow_id": "wf-viral-humor-office-001",
  "agent": "Damian",
  "output": {
    "content_post_id": 301,
    "approval_request_id": 701,
    "hook": "Cuando la junta era de 10 minutos pero ya van 47.",
    "post_copy": "La junta era para revisar 'un tema rápido' y de pronto ya están hablando del plan estratégico del 2031.",
    "call_to_action": "Etiqueta a alguien que siempre dice: 'es rapidísimo'.",
    "hashtags": [
      "#Trabajo",
      "#Oficina",
      "#Humor"
    ],
    "media": {
      "media_asset_id": 901,
      "media_prompt": "A funny office meeting scene with tired employees."
    },
    "scheduled_time": "2026-07-03T20:00:00-06:00",
    "risk_notes": []
  },
  "required_fields": [
    "content_post_id",
    "approval_request_id",
    "hook",
    "post_copy",
    "call_to_action",
    "hashtags",
    "media",
    "scheduled_time",
    "risk_notes"
  ]
}
```

## Expected Output

```json
{
  "passed": true,
  "missing_fields": [],
  "risk_flags": [],
  "notes": "Output is complete and ready for Magnus review."
}
```

---

# 6. Approval Package Validator

## Tool Intent

```text
approval_package_validator
```

## Purpose

Javier validates Damian's approval package before sending it to Magnus.

## Example Input

```json
{
  "approval_request_id": 701,
  "content_post_id": 301,
  "prepared_by": "Damian"
}
```

## Expected Output

```json
{
  "valid": true,
  "ready_for_magnus": true,
  "issues": [],
  "next_step": "Notify Magnus that the publication proposal is ready for Luis review."
}
```

---

# 7. Magnus Notifier

## Tool Intent

```text
magnus_notifier
```

## Purpose

Javier uses this tool to notify Magnus about workflow events, especially publication proposals ready for CEO approval.

## Example Input

```json
{
  "send_to": "Magnus",
  "message_type": "publication_proposal_ready_for_luis",
  "workflow_id": "wf-viral-humor-office-001",
  "content_post_id": 301,
  "approval_request_id": 701,
  "prepared_by": "Damian",
  "validated_by": "Javier",
  "requested_action": "Present approval package to Luis and return decision."
}
```

## Expected Output

```json
{
  "status": "sent",
  "sent_to": "Magnus",
  "next_state": "WAITING_FOR_LUIS_DECISION"
}
```

---

# 8. Approval Decision Receiver From Magnus

## Tool Intent

```text
approval_decision_receiver_from_magnus
```

## Purpose

Javier receives Luis's decision only through Magnus during normal operation.

## Example Input

```json
{
  "received_from": "Magnus",
  "approval_request_id": 701,
  "content_post_id": 301,
  "decision_from": "Luis",
  "decision": "APPROVE",
  "feedback": "",
  "authorized_by": "Luis"
}
```

## Expected Output

```json
{
  "status": "received",
  "decision": "APPROVE",
  "next_operational_action": "Validate approval and instruct Damian to schedule or publish."
}
```

---

# 9. Approval Status Checker

## Tool Intent

```text
approval_status_checker
```

## Purpose

Javier uses this tool to confirm whether Luis has approved a content package through Magnus.

## Example Input

```json
{
  "content_post_id": 301,
  "workflow_id": "wf-viral-humor-office-001"
}
```

## Expected Output

```json
{
  "content_post_id": 301,
  "approval_status": "APPROVED",
  "approved_by": "Luis",
  "approval_routed_by": "Magnus",
  "approved_at": "2026-07-02T20:30:00Z"
}
```

If the output is anything other than `APPROVED`, publication must not continue.

---

# 10. Cost Query Tool

## Tool Intent

```text
cost_query
```

## Purpose

Javier uses this tool before assigning expensive work.

## Example Input

```json
{
  "period": "today",
  "include_budget_status": true,
  "group_by": [
    "provider",
    "operation_type"
  ]
}
```

## Expected Output

```json
{
  "total_cost_usd": 1.42,
  "budget_limit_usd": 1.50,
  "budget_usage_percent": 94.67,
  "warnings": [
    "Daily text budget is above 90%."
  ]
}
```

---

# 11. Cache Lookup Tool

## Tool Intent

```text
cache_lookup
```

## Purpose

Javier checks cached work before assigning duplicate tasks.

## Example Input

```json
{
  "lookup_type": "research",
  "niche": "viral_humor",
  "topic": "office frustration humor",
  "max_age_days": 14
}
```

## Expected Output

```json
{
  "cache_hit": true,
  "source": "research_notes",
  "record_id": 77,
  "summary": "Recent office frustration humor research exists and is reusable."
}
```

---

# 12. Database Tools

Javier needs controlled read and write access to PostgreSQL.

## Read Access

Primary tables and views:

```text
content_ideas
research_notes
content_posts
approval_requests
publications
post_metrics
agent_runs
api_costs
learnings
publication_performance_summary
daily_api_cost_summary
```

## Write Access

Javier may write operational updates to:

```text
content_ideas
content_posts
agent_runs
api_costs
```

Javier should not directly modify final approval records unless the workflow defines him as updating state after Magnus routes Luis's decision.

---

# 13. Error Logger

## Tool Intent

```text
error_logger
```

## Purpose

Javier logs workflow failures and unexpected states.

## Example Input

```json
{
  "workflow_id": "wf-viral-humor-office-001",
  "agent_name": "Damian",
  "task_name": "prepare_publication_approval_package",
  "error_type": "missing_required_fields",
  "error_message": "Damian output did not include scheduled_time.",
  "current_state": "READY_FOR_APPROVAL_PACKAGE",
  "proposed_resolution": "Return task to Damian for correction."
}
```

## Expected Output

```json
{
  "status": "logged",
  "error_id": "err-001"
}
```

---

# 14. Tools Javier Should Not Use Directly

Javier should not directly use:

```text
facebook_publish_now
telegram_ceo_approval_request
raw_secret_access
credential_rotation
file_delete
public_comment_reply
automated_dm
```

`telegram_ceo_approval_request` belongs to Magnus in the default operating model.

---

# 15. Future Tools

Future Javier tools may include:

```text
workflow_dashboard
queue_manager
scheduler_control
platform_health_monitor
retry_manager
rate_limit_monitor
job_priority_manager
backup_verifier
```

These should be added only after v1 workflow is stable.

---

# 16. Final Tool Principle

Javier uses tools to make execution reliable and to route CEO-facing decisions through Magnus.

A tool is useful only when it improves:

- Workflow clarity
- Safety
- Traceability
- Cost control
- Quality control
- Approval discipline
- Operational reliability
