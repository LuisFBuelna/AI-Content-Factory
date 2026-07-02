# tools.md
## Javier — Operations Director

> This file defines the tools Javier may use or request through the system.

---

# 1. Tool Philosophy

Javier uses tools to coordinate workflows, validate state, control cost, and ensure safe execution.

Javier should prefer deterministic tools over LLM calls whenever possible.

Javier does not use tools to approve content.

Javier does not publish content directly unless the workflow assigns the publishing operation to Damian and approval has already been recorded.

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
approval_status_checker
cost_query
cache_lookup
knowledge_read
telegram_escalation
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
  "from_state": "RESEARCH_COMPLETED",
  "to_state": "CONTENT_DRAFTING",
  "reason": "Bruno research output passed quality gate."
}
```

## Expected Output

```json
{
  "status": "updated",
  "workflow_id": "wf-viral-humor-office-001",
  "current_state": "CONTENT_DRAFTING"
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
  "target_agent": "Bruno",
  "task_name": "research_office_humor_angles",
  "task_goal": "Find 5 safe and relatable office humor angles for Facebook.",
  "required_inputs": [
    "Magnus strategy request",
    "knowledge/brand_voice.md"
  ],
  "expected_output_schema": {
    "research_summary": "string",
    "key_findings": "array",
    "content_angles": "array",
    "risks": "array",
    "confidence": "low | medium | high"
  }
}
```

## Expected Output

```json
{
  "status": "dispatched",
  "target_agent": "Bruno",
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
  "agent": "Elena",
  "output": {
    "post_copy": "El jefe: 'es algo rápido'. También el jefe: abre una junta de 47 minutos.",
    "hook": "El jefe: 'es algo rápido'.",
    "call_to_action": "Etiqueta a alguien que siempre dice eso.",
    "hashtags": [
      "#Trabajo",
      "#Oficina",
      "#Humor"
    ],
    "image_prompt": "A humorous office scene showing a tired employee in a long meeting."
  },
  "required_fields": [
    "post_copy",
    "hook",
    "call_to_action",
    "hashtags",
    "image_prompt"
  ]
}
```

## Expected Output

```json
{
  "passed": true,
  "missing_fields": [],
  "risk_flags": [],
  "notes": "Output is complete."
}
```

---

# 6. Approval Status Checker

## Tool Intent

```text
approval_status_checker
```

## Purpose

Javier uses this tool to confirm whether Luis has approved a content package.

## Example Input

```json
{
  "content_post_id": 101,
  "workflow_id": "wf-viral-humor-office-001"
}
```

## Expected Output

```json
{
  "content_post_id": 101,
  "approval_status": "APPROVED",
  "approved_by": "Luis",
  "approved_at": "2026-07-02T20:30:00Z"
}
```

If the output is anything other than `APPROVED`, publication must not continue.

---

# 7. Cost Query Tool

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

# 8. Cache Lookup Tool

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

If cache is valid, Javier should reuse it or ask Magnus whether fresh research is required.

---

# 9. Database Tools

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

Javier should not directly modify:

```text
post_metrics
publications
approval_requests
```

unless the workflow explicitly defines it.

Those are usually handled by Damian or system tools.

---

# 10. Telegram Escalation Tool

## Tool Intent

```text
telegram_escalation
```

## Purpose

Javier uses this tool to notify Luis about operational blockers or critical issues.

## Example Input

```json
{
  "send_to": "Luis",
  "channel": "telegram",
  "severity": "high",
  "message": "Workflow wf-viral-humor-office-001 is blocked because approval status is unclear. Publication has been paused."
}
```

## Expected Output

```json
{
  "status": "sent",
  "external_message_id": "telegram-message-id"
}
```

Use this tool only for important issues.

Do not spam Luis with internal noise.

---

# 11. Error Logger

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
  "agent_name": "Elena",
  "task_name": "create_content_draft",
  "error_type": "missing_required_fields",
  "error_message": "Elena output did not include image_prompt.",
  "current_state": "CONTENT_DRAFTING",
  "proposed_resolution": "Return task to Elena for correction."
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

# 12. Tools Javier Should Not Use Directly

Javier should not directly use:

```text
facebook_publish_now
raw_secret_access
credential_rotation
file_delete
public_comment_reply
automated_dm
```

These require special authorization, separate workflows, or belong to Damian/system administration.

---

# 13. Future Tools

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

# 14. Final Tool Principle

Javier uses tools to make execution reliable.

A tool is useful only when it improves:

- Workflow clarity
- Safety
- Traceability
- Cost control
- Quality control
- Approval discipline
- Operational reliability
