# 03_tools_and_service_contracts.md
# AI Content Factory — Tools and Service Contracts

> Document: 03  
> Version: 1.0  
> Owner: Luis — CEO & System Owner  
> Project: AI Content Factory  
> Purpose: Define the technical contracts for tools and services used by agents and workflows.

---

# 1. Purpose

This document defines the service and tool contracts required for AI Content Factory v1.

Agents already define what tools they need.

This document defines how those tools should behave technically.

It specifies:

- Tool name.
- Purpose.
- Authorized agents.
- Required inputs.
- Expected outputs.
- Tables affected.
- Validation rules.
- Error handling.
- Security rules.

This document bridges the gap between:

```text
Agent documentation
Workflow documentation
PostgreSQL schema
Backend implementation
OpenClaw tool configuration
External APIs
```

---

# 2. Core Principle

Tools should be deterministic whenever possible.

Agents should decide what needs to happen.

Tools should execute clearly defined actions.

Tools should not invent strategy, rewrite content, approve publication, or bypass workflow rules.

---

# 3. Tool Execution Rules

All tools must follow these rules:

1. Validate required inputs.
2. Validate workflow state when relevant.
3. Never expose secrets.
4. Never publish without valid approval.
5. Log significant failures.
6. Return structured output.
7. Avoid silent recovery.
8. Use PostgreSQL as source of truth.
9. Preserve traceability.
10. Respect `CONSTITUTION.md`.

---

# 4. Approval Flow Rule

All CEO-facing publication approvals must follow:

```text
Damian prepares package
        ↓
Javier validates package
        ↓
Magnus presents package to Luis
        ↓
Luis decides through Magnus
        ↓
Magnus routes decision to Javier
        ↓
Javier validates decision
        ↓
Damian publishes only if approved
```

No tool may allow normal direct approval communication from Damian to Luis.

No publication tool may publish unless approval is valid.

Valid approval requires:

```text
approved_by = Luis
approval_routed_by = Magnus
validated_by = Javier
approval_status = APPROVED
approval_request.content_version = content_post.content_version
```

---

# 5. Tool Categories

v1 tool categories:

```text
database tools
workflow tools
approval tools
telegram tools
content tools
research tools
media tools
publishing tools
metrics tools
cost tools
knowledge tools
logging tools
```

---

# 6. Shared Response Format

All tools should return a structured response.

Default success format:

```json
{
  "status": "success",
  "tool_name": "",
  "request_id": "",
  "data": {},
  "warnings": [],
  "errors": []
}
```

Default failure format:

```json
{
  "status": "error",
  "tool_name": "",
  "request_id": "",
  "error": {
    "type": "",
    "message": "",
    "retry_safe": false,
    "recommended_next_action": ""
  },
  "data": {},
  "warnings": []
}
```

---

# 7. Shared Error Types

Standard error types:

```text
missing_required_input
invalid_workflow_state
invalid_approval_route
invalid_content_version
platform_limit_exceeded
external_api_error
rate_limited
authentication_error
permission_denied
database_error
validation_error
not_found
duplicate_request
unsafe_action_blocked
unknown_error
```

---

# 8. Database Tools

## 8.1 database_read

### Purpose

Read records from PostgreSQL.

### Authorized Agents

```text
Magnus
Javier
Bruno
Elena
Damian
```

Access should be limited by role.

### Input

```json
{
  "table_or_view": "",
  "filters": {},
  "limit": 50,
  "order_by": "",
  "columns": []
}
```

### Output

```json
{
  "status": "success",
  "rows": [],
  "row_count": 0
}
```

### Tables / Views

Role-based read access:

```text
projects
platforms
social_pages
niches
content_ideas
research_notes
content_posts
media_assets
approval_requests
publications
post_metrics
agent_runs
api_costs
learnings
publication_performance_summary
daily_api_cost_summary
approval_flow_summary
```

### Validation Rules

- Deny raw secret fields.
- Deny unrestricted large reads unless explicitly allowed.
- Enforce role-based access.

---

## 8.2 database_write

### Purpose

Write controlled operational records to PostgreSQL.

### Authorized Agents

```text
Javier
Bruno
Elena
Damian
```

Magnus may request writes through Javier unless a specific workflow allows direct strategic records.

### Input

```json
{
  "table": "",
  "operation": "insert | update",
  "filters": {},
  "data": {}
}
```

### Output

```json
{
  "status": "success",
  "table": "",
  "operation": "",
  "record_id": "",
  "updated_rows": 0
}
```

### Validation Rules

- Validate table allowlist.
- Validate required fields.
- Validate workflow state transitions.
- Validate approval rules when touching approval/publication fields.
- Never write credentials.

---

# 9. Workflow Tools

## 9.1 workflow_state_read

### Purpose

Read current workflow state for a content item or workflow ID.

### Authorized Agents

```text
Javier
Magnus
Damian
```

### Input

```json
{
  "workflow_id": "",
  "content_post_id": ""
}
```

### Output

```json
{
  "workflow_id": "",
  "content_post_id": "",
  "current_state": "",
  "content_version": 1,
  "approval_status": "",
  "publication_status": "",
  "last_updated_at": ""
}
```

---

## 9.2 workflow_state_write

### Purpose

Update workflow state.

### Authorized Agents

```text
Javier
```

Damian may update publication-related states only through publication tools.

### Input

```json
{
  "workflow_id": "",
  "content_post_id": "",
  "from_state": "",
  "to_state": "",
  "reason": "",
  "updated_by": "Javier"
}
```

### Output

```json
{
  "status": "success",
  "workflow_id": "",
  "content_post_id": "",
  "previous_state": "",
  "current_state": ""
}
```

### Validation Rules

Allowed lifecycle:

```text
IDEA
RESEARCH_REQUESTED
RESEARCH_COMPLETED
CONTENT_DRAFTED
READY_FOR_APPROVAL_PACKAGE
READY_FOR_MAGNUS_REVIEW
WAITING_FOR_LUIS_DECISION
APPROVED
NEEDS_CHANGES
REJECTED
DISCARDED
SCHEDULED
PUBLISHED
METRICS_COLLECTED
ANALYZED
```

Invalid transitions must be blocked.

---

## 9.3 agent_task_dispatch

### Purpose

Assign a task to an agent.

### Authorized Agents

```text
Javier
Magnus
```

Magnus may request tasks from Javier.

Javier dispatches operational tasks.

### Input

```json
{
  "workflow_id": "",
  "target_agent": "",
  "task_name": "",
  "task_goal": "",
  "required_inputs": [],
  "expected_output_schema": {},
  "priority": "low | medium | high",
  "deadline": ""
}
```

### Output

```json
{
  "status": "dispatched",
  "workflow_id": "",
  "task_id": "",
  "target_agent": "",
  "created_at": ""
}
```

---

# 10. Approval Tools

## 10.1 approval_package_builder

### Purpose

Build a structured publication approval package.

### Authorized Agents

```text
Damian
```

### Input

```json
{
  "content_post_id": 301,
  "content_version": 1,
  "page": "",
  "platform": "facebook",
  "content_type": "image_post",
  "niche": "",
  "hook": "",
  "post_copy": "",
  "call_to_action": "",
  "hashtags": [],
  "media": {
    "media_asset_id": "",
    "media_url": "",
    "media_prompt": ""
  },
  "scheduled_time": "",
  "risk_notes": []
}
```

### Output

```json
{
  "approval_request_id": 701,
  "content_post_id": 301,
  "content_version": 1,
  "prepared_by": "Damian",
  "prepared_for": "Magnus",
  "route_through": "Javier",
  "approval_package": {},
  "status": "PREPARED"
}
```

### Writes To

```text
approval_requests
content_posts
```

### Validation Rules

- Required content fields must exist.
- Content version must match `content_posts.content_version`.
- Package must be prepared for Magnus.
- Package must route through Javier.
- Status should become `PREPARED`.
- Publication must remain blocked.

---

## 10.2 approval_package_validator

### Purpose

Validate Damian's approval package before Magnus sees it.

### Authorized Agents

```text
Javier
```

### Input

```json
{
  "approval_request_id": 701,
  "content_post_id": 301,
  "validated_by": "Javier"
}
```

### Output

```json
{
  "status": "VALIDATED",
  "approval_request_id": 701,
  "content_post_id": 301,
  "valid": true,
  "issues": [],
  "ready_for_magnus": true
}
```

### Writes To

```text
approval_requests
content_posts
```

### Validation Rules

- Package status must be `PREPARED`.
- Required fields must be present.
- Risk notes must exist.
- Media asset or prompt must exist when required.
- Platform limits should be checked.
- `validated_by` must be `Javier`.
- Status should become `VALIDATED`.
- Content post status should become `READY_FOR_MAGNUS_REVIEW`.

---

## 10.3 approval_status_read

### Purpose

Read current approval status and approval validity.

### Authorized Agents

```text
Magnus
Javier
Damian
```

### Input

```json
{
  "approval_request_id": 701,
  "content_post_id": 301
}
```

### Output

```json
{
  "approval_request_id": 701,
  "content_post_id": 301,
  "approval_status": "APPROVED",
  "decision": "APPROVE",
  "decided_by": "Luis",
  "decision_routed_by": "Magnus",
  "validated_by": "Javier",
  "approval_content_version": 1,
  "current_content_version": 1,
  "valid_for_publication": true
}
```

---

# 11. Telegram CEO Approval Tools

## 11.1 telegram_ceo_approval_request

### Purpose

Send a publication approval request to Luis through Telegram.

### Authorized Agents

```text
Magnus
```

### Input

```json
{
  "send_to": "Luis",
  "channel": "telegram",
  "approval_request_id": 701,
  "content_post_id": 301,
  "message": {
    "title": "Publication proposal ready for approval",
    "page": "",
    "platform": "facebook",
    "content_type": "image_post",
    "niche": "",
    "hook": "",
    "copy": "",
    "cta": "",
    "hashtags": [],
    "media_preview_or_prompt": "",
    "scheduled_time": "",
    "strategic_reason": "",
    "risk_notes": [],
    "decision_options": [
      "APPROVE",
      "NEEDS_CHANGES",
      "REJECT",
      "DISCARD"
    ]
  }
}
```

### Output

```json
{
  "status": "sent",
  "approval_request_id": 701,
  "external_message_id": "telegram-message-id",
  "sent_at": ""
}
```

### Writes To

```text
approval_requests
```

### Validation Rules

- Tool can only be used by Magnus.
- Approval request must be `VALIDATED`.
- `validated_by` must be `Javier`.
- Decision options must include only allowed values.
- Status should become `PRESENTED` or `PENDING`.
- `presented_by` must be `Magnus`.

---

## 11.2 ceo_decision_capture

### Purpose

Capture Luis's decision from Telegram.

### Authorized Agents

```text
Magnus
```

### Input

```json
{
  "approval_request_id": 701,
  "content_post_id": 301,
  "decision_from": "Luis",
  "decision": "APPROVE | NEEDS_CHANGES | REJECT | DISCARD",
  "feedback": "",
  "decided_at": ""
}
```

### Output

```json
{
  "status": "captured",
  "approval_request_id": 701,
  "content_post_id": 301,
  "decision_from": "Luis",
  "decision": "APPROVE",
  "feedback": "",
  "decided_at": ""
}
```

### Writes To

```text
approval_requests
```

### Validation Rules

- Tool can only be used by Magnus.
- `decision_from` must be `Luis`.
- Decision must be one of the allowed values.
- Ambiguous responses must not be captured as approval.
- `decided_by` must be `Luis`.

---

## 11.3 approval_decision_route_to_javier

### Purpose

Route Luis's decision from Magnus to Javier.

### Authorized Agents

```text
Magnus
```

### Input

```json
{
  "send_to": "Javier",
  "approval_request_id": 701,
  "content_post_id": 301,
  "decision_from": "Luis",
  "decision": "APPROVE | NEEDS_CHANGES | REJECT | DISCARD",
  "feedback": "",
  "authorized_by": "Luis",
  "notes_for_damian": ""
}
```

### Output

```json
{
  "status": "routed",
  "approval_request_id": 701,
  "content_post_id": 301,
  "sent_to": "Javier",
  "decision_routed_by": "Magnus",
  "next_operational_step": ""
}
```

### Writes To

```text
approval_requests
```

### Validation Rules

- Tool can only be used by Magnus.
- Decision must already be captured.
- `decision_routed_by` must be `Magnus`.
- `routed_at` must be recorded.

---

## 11.4 approval_decision_receiver_from_magnus

### Purpose

Allow Javier to receive Luis's decision from Magnus and update workflow state.

### Authorized Agents

```text
Javier
```

### Input

```json
{
  "received_from": "Magnus",
  "approval_request_id": 701,
  "content_post_id": 301,
  "decision_from": "Luis",
  "decision": "APPROVE | NEEDS_CHANGES | REJECT | DISCARD",
  "feedback": "",
  "authorized_by": "Luis"
}
```

### Output

```json
{
  "status": "received",
  "approval_request_id": 701,
  "content_post_id": 301,
  "decision": "APPROVE",
  "next_operational_action": "instruct_damian_to_publish"
}
```

### Writes To

```text
approval_requests
content_posts
```

### Validation Rules

- `received_from` must be `Magnus`.
- `authorized_by` must be `Luis`.
- Decision route must exist.
- Javier must update workflow based on decision.

---

# 12. Research Tools

## 12.1 web_search

### Purpose

Search the web for public trends, topics, competitors, or factual context.

### Authorized Agents

```text
Bruno
```

Magnus may request research through Javier and Bruno.

### Input

```json
{
  "query": "",
  "language": "es",
  "region": "LATAM",
  "max_results": 10
}
```

### Output

```json
{
  "results": [
    {
      "title": "",
      "url": "",
      "domain": "",
      "snippet": "",
      "source_type": "search_result"
    }
  ]
}
```

### Validation Rules

- Do not store sensitive personal data.
- Do not treat weak sources as verified facts.
- Cite or store source metadata when used.

---

## 12.2 web_fetch

### Purpose

Fetch and summarize specific web pages.

### Authorized Agents

```text
Bruno
```

### Input

```json
{
  "url": "",
  "extract": "main_content"
}
```

### Output

```json
{
  "url": "",
  "title": "",
  "main_content": "",
  "metadata": {
    "author": "",
    "published_at": ""
  }
}
```

---

## 12.3 research_note_write

### Purpose

Save Bruno's research into PostgreSQL.

### Authorized Agents

```text
Bruno
```

### Input

```json
{
  "content_idea_id": 101,
  "agent_name": "Bruno",
  "research_summary": "",
  "key_findings": [],
  "sources": [],
  "risks": [],
  "confidence_score": 65.0
}
```

### Output

```json
{
  "status": "saved",
  "research_note_id": 501
}
```

### Writes To

```text
research_notes
content_ideas
```

---

# 13. Content Tools

## 13.1 content_draft_write

### Purpose

Save Elena's content draft into PostgreSQL.

### Authorized Agents

```text
Elena
```

### Input

```json
{
  "content_idea_id": 101,
  "social_page_id": 1,
  "niche_id": 1,
  "platform_content_type": "image_post",
  "language_code": "es-LATAM",
  "title": "",
  "hook": "",
  "post_copy": "",
  "call_to_action": "",
  "hashtags": [],
  "image_prompt": "",
  "video_prompt": "",
  "script": {},
  "risk_notes": []
}
```

### Output

```json
{
  "status": "saved",
  "content_post_id": 301,
  "content_version": 1,
  "next_state": "CONTENT_DRAFTED"
}
```

### Writes To

```text
content_posts
content_ideas
```

### Validation Rules

- Required copy fields must be present.
- Language must default to `es-LATAM`.
- Content version starts at `1`.
- Revisions must increment `content_version`.

---

## 13.2 content_revision_write

### Purpose

Save a revised content draft.

### Authorized Agents

```text
Elena
```

### Input

```json
{
  "content_post_id": 301,
  "previous_content_version": 1,
  "revision_reason": "",
  "hook": "",
  "post_copy": "",
  "call_to_action": "",
  "hashtags": [],
  "image_prompt": "",
  "video_prompt": "",
  "script": {},
  "risk_notes": []
}
```

### Output

```json
{
  "status": "saved",
  "content_post_id": 301,
  "new_content_version": 2,
  "next_state": "CONTENT_DRAFTED"
}
```

### Validation Rules

- Must increment `content_version`.
- Previous approval is no longer valid if content changed.
- New approval package is required.

---

# 14. Media Tools

## 14.1 image_generation

### Purpose

Generate an image asset from an approved or draft image prompt.

### Authorized Agents

```text
Javier
Damian
```

Elena writes prompts but does not necessarily execute media generation unless workflow allows it.

### Input

```json
{
  "content_post_id": 301,
  "prompt": "",
  "provider": "openai | flux | stability | local",
  "style": "",
  "size": "",
  "metadata": {}
}
```

### Output

```json
{
  "status": "generated",
  "media_asset_id": 901,
  "storage_url": "",
  "storage_path": "",
  "provider": "",
  "mime_type": "image/png",
  "width": 1024,
  "height": 1024
}
```

### Writes To

```text
media_assets
api_costs
```

### Validation Rules

- Prompt must exist.
- Prompt must not violate policy.
- Cost must be checked when provider is paid.
- Generated media should be reviewed before publication.

---

## 14.2 media_asset_read

### Purpose

Read metadata for a media asset.

### Authorized Agents

```text
Javier
Damian
Magnus
```

### Input

```json
{
  "media_asset_id": 901
}
```

### Output

```json
{
  "media_asset_id": 901,
  "asset_type": "image",
  "status": "GENERATED",
  "storage_url": "",
  "storage_path": "",
  "prompt": "",
  "metadata": {}
}
```

---

# 15. Publishing Tools

## 15.1 platform_limit_checker

### Purpose

Check whether publishing would exceed platform limits.

### Authorized Agents

```text
Javier
Damian
```

### Input

```json
{
  "platform": "facebook",
  "social_page_id": 1,
  "content_type": "image_post",
  "time_window": "24_hours"
}
```

### Output

```json
{
  "allowed": true,
  "limit": 2,
  "current_count": 1,
  "content_type": "image_post",
  "period": "24_hours",
  "reason": ""
}
```

### Validation Rules

Default Facebook limits:

```text
Maximum 2 image posts per 24 hours per page.
Maximum 1 Reel per 24 hours per page.
```

---

## 15.2 facebook_publish

### Purpose

Publish approved content to Facebook.

### Authorized Agents

```text
Damian
```

### Input

```json
{
  "content_post_id": 301,
  "approval_request_id": 701,
  "social_page_id": 1,
  "platform": "facebook",
  "post_copy": "",
  "media_asset_id": 901,
  "hashtags": [],
  "approved_by": "Luis",
  "approval_routed_by": "Magnus",
  "validated_by": "Javier"
}
```

### Output

```json
{
  "status": "published",
  "external_post_id": "",
  "external_post_url": "",
  "published_at": ""
}
```

### Writes To

```text
publications
content_posts
```

### Validation Rules

Publication must be blocked unless:

```text
approval_status = APPROVED
decision = APPROVE
decided_by = Luis
decision_routed_by = Magnus
validated_by = Javier
approval_request.content_version = content_post.content_version
platform_limit_checker.allowed = true
```

---

## 15.3 facebook_schedule

### Purpose

Schedule approved content on Facebook.

### Authorized Agents

```text
Damian
```

### Input

```json
{
  "content_post_id": 301,
  "approval_request_id": 701,
  "social_page_id": 1,
  "scheduled_time": "",
  "approved_by": "Luis",
  "approval_routed_by": "Magnus",
  "validated_by": "Javier"
}
```

### Output

```json
{
  "status": "scheduled",
  "external_schedule_id": "",
  "scheduled_time": ""
}
```

### Writes To

```text
publications
content_posts
```

### Validation Rules

Same approval validation as `facebook_publish`.

---

## 15.4 publication_record_write

### Purpose

Store publication or scheduling result.

### Authorized Agents

```text
Damian
```

### Input

```json
{
  "content_post_id": 301,
  "approval_request_id": 701,
  "social_page_id": 1,
  "platform_id": 1,
  "status": "PUBLISHED | SCHEDULED | FAILED",
  "external_post_id": "",
  "external_post_url": "",
  "external_schedule_id": "",
  "scheduled_time": "",
  "published_at": ""
}
```

### Output

```json
{
  "status": "saved",
  "publication_id": 501
}
```

### Writes To

```text
publications
content_posts
```

---

# 16. Metrics Tools

## 16.1 metrics_collector

### Purpose

Collect performance metrics from the publishing platform.

### Authorized Agents

```text
Damian
```

### Input

```json
{
  "publication_id": 501,
  "platform": "facebook",
  "external_post_id": "",
  "collection_window": "24h | 72h | 7d"
}
```

### Output

```json
{
  "status": "collected",
  "publication_id": 501,
  "collected_at": "",
  "collection_window": "24h",
  "metrics": {
    "reach": 0,
    "impressions": 0,
    "likes": 0,
    "comments": 0,
    "shares": 0,
    "saves": 0,
    "new_followers": 0,
    "video_views": 0,
    "average_watch_time_seconds": 0,
    "retention_rate": 0,
    "engagement_rate": 0,
    "raw_metrics": {}
  }
}
```

### Writes To

```text
post_metrics
```

### Collection Timing

Default metrics snapshots:

```text
24 hours after publication
72 hours after publication
7 days after publication
```

Meaning:

```text
24h = early signal
72h = reliable short-term signal
7d = weekly review and learning signal
```

### Validation Rules

- Publication must exist.
- External post ID must exist.
- Failed metric collection must be logged.
- Missing data must not be invented.
- Each snapshot should be stored separately.

---

## 16.2 metrics_query

### Purpose

Read performance metrics for analysis.

### Authorized Agents

```text
Magnus
Javier
```

### Input

```json
{
  "period": "last_7_days",
  "platform": "facebook",
  "page_id": 1,
  "niche": "viral_humor",
  "content_type": "image_post"
}
```

### Output

```json
{
  "period": "",
  "platform": "",
  "page_id": 1,
  "top_posts": [],
  "weak_posts": [],
  "averages": {
    "reach": 0,
    "comments": 0,
    "shares": 0,
    "engagement_rate": 0
  },
  "follower_growth": 0,
  "data_quality": "complete | partial | insufficient",
  "notes": []
}
```

### Reads From

```text
publication_performance_summary
post_metrics
publications
content_posts
```

---

# 17. Cost Tools

## 17.1 cost_query

### Purpose

Read cost usage and budget status.

### Authorized Agents

```text
Magnus
Javier
```

### Input

```json
{
  "period": "today | last_7_days | current_month",
  "group_by": [
    "provider",
    "model_name",
    "operation_type",
    "agent_name"
  ],
  "include_budget_status": true
}
```

### Output

```json
{
  "total_cost_usd": 0,
  "budget_limit_usd": 0,
  "budget_usage_percent": 0,
  "by_provider": [],
  "by_model": [],
  "by_operation_type": [],
  "warnings": []
}
```

### Reads From

```text
daily_api_cost_summary
api_costs
agent_runs
```

---

## 17.2 api_cost_write

### Purpose

Store API/tool usage cost records.

### Authorized Agents / Services

```text
system
Javier
tool_runtime
```

### Input

```json
{
  "agent_run_id": "",
  "provider": "",
  "model_name": "",
  "operation_type": "",
  "input_tokens": 0,
  "output_tokens": 0,
  "total_tokens": 0,
  "unit_count": 0,
  "cost_usd": 0
}
```

### Output

```json
{
  "status": "saved",
  "api_cost_id": 1
}
```

### Writes To

```text
api_costs
```

---

# 18. Knowledge Tools

## 18.1 knowledge_read

### Purpose

Read Knowledge Base files.

### Authorized Agents

```text
Magnus
Javier
Bruno
Elena
Damian
```

### Input

```json
{
  "file_path": "knowledge/brand_voice.md"
}
```

### Output

```json
{
  "file_path": "",
  "content": "",
  "last_modified_at": ""
}
```

### Validation Rules

- Read-only by default.
- Do not read secrets.
- Only allow approved knowledge paths.

---

## 18.2 knowledge_update_recommendation

### Purpose

Propose a Knowledge Base update.

### Authorized Agents

```text
Magnus
Javier
Bruno
Elena
Damian
```

### Input

```json
{
  "target_file": "",
  "update_type": "ADD | REVISE | ARCHIVE | PROMOTE_EXPERIMENTAL_TO_DURABLE",
  "category": "",
  "reason": "",
  "evidence": [],
  "suggested_text": "",
  "confidence": "low | medium | high",
  "requires_luis_approval": false
}
```

### Output

```json
{
  "status": "proposed",
  "proposal_id": "",
  "requires_luis_approval": false,
  "next_action_for_javier": ""
}
```

---

## 18.3 knowledge_update_apply

### Purpose

Apply an approved Knowledge Base update.

### Authorized Agents

```text
Javier
```

### Input

```json
{
  "proposal_id": "",
  "target_file": "",
  "approved_by": "Magnus | Luis",
  "approval_routed_by": "Magnus",
  "exact_text_to_apply": "",
  "update_type": ""
}
```

### Output

```json
{
  "status": "applied",
  "target_file": "",
  "applied_at": "",
  "commit_suggested": true
}
```

### Validation Rules

- Update must be approved.
- Luis approval required for core policy or brand voice changes.
- Do not overwrite entire files unintentionally.
- Preserve traceability.

---

# 19. Logging Tools

## 19.1 error_logger

### Purpose

Log significant tool, workflow, or agent errors.

### Authorized Agents

```text
Magnus
Javier
Bruno
Elena
Damian
system
```

### Input

```json
{
  "workflow_id": "",
  "content_post_id": "",
  "agent_name": "",
  "tool_name": "",
  "task_name": "",
  "error_type": "",
  "error_message": "",
  "current_state": "",
  "retry_safe": false,
  "recommended_next_action": "",
  "notify_javier": true
}
```

### Output

```json
{
  "status": "logged",
  "error_id": ""
}
```

### Writes To

```text
agent_runs
metadata/log system
```

---

## 19.2 agent_run_write

### Purpose

Create or update agent run records.

### Authorized Agents / Services

```text
system
Javier
tool_runtime
```

### Input

```json
{
  "agent_name": "",
  "task_name": "",
  "workflow_id": "",
  "content_idea_id": "",
  "content_post_id": "",
  "status": "STARTED | COMPLETED | FAILED | SKIPPED | CANCELLED",
  "input_summary": "",
  "output_summary": "",
  "error_message": ""
}
```

### Output

```json
{
  "status": "saved",
  "agent_run_id": ""
}
```

### Writes To

```text
agent_runs
```

---

# 20. Service Contracts

This section defines backend services that may expose the tools.

---

## 20.1 PostgreSQL Service

### Purpose

Persistent operational source of truth.

### Owns

```text
projects
platforms
social_pages
niches
content_ideas
research_notes
content_posts
media_assets
approval_requests
publications
post_metrics
agent_runs
api_costs
learnings
```

### Required Capabilities

- Read records.
- Write records.
- Enforce constraints.
- Support views.
- Support migrations.
- Support backups.

---

## 20.2 Telegram Approval Service

### Purpose

Handle CEO communication through Magnus.

### Owns

```text
telegram_ceo_approval_request
ceo_decision_capture
```

### Required Capabilities

- Send approval package to Luis.
- Provide decision buttons or commands.
- Capture decision.
- Capture feedback text.
- Store Telegram external message ID.
- Route decision to Magnus tooling.

### Security Requirements

- Telegram bot token must be stored in environment variables or secret manager.
- Luis chat ID must be configured.
- Only Luis's authorized chat ID may approve content.

---

## 20.3 Publisher Service

### Purpose

Execute approved publishing actions.

### Owns

```text
facebook_publish
facebook_schedule
publication_record_write
metrics_collector
platform_limit_checker
```

### Required Capabilities

- Validate approval route.
- Validate content version.
- Validate platform limits.
- Publish or schedule content.
- Store external post IDs.
- Collect metrics.
- Log failures.

### Security Requirements

- Facebook tokens must not be exposed to agents.
- Tokens must be stored securely.
- Publication endpoints must require internal authorization.
- Direct publish endpoints must validate approval before platform calls.

---

## 20.4 Media Service

### Purpose

Generate and store media assets.

### Owns

```text
image_generation
media_asset_read
```

### Required Capabilities

- Generate image assets.
- Store metadata in PostgreSQL.
- Store media file in configured storage.
- Track provider and cost.
- Return media asset ID.

---

## 20.5 Knowledge Service

### Purpose

Read and update Knowledge Base files.

### Owns

```text
knowledge_read
knowledge_update_recommendation
knowledge_update_apply
```

### Required Capabilities

- Read approved knowledge files.
- Apply approved updates.
- Prevent path traversal.
- Preserve file integrity.
- Support Git workflow.

---

# 21. Minimum Implementation Order

Recommended implementation order:

```text
1. database_read
2. database_write
3. workflow_state_read
4. workflow_state_write
5. content_draft_write
6. approval_package_builder
7. approval_package_validator
8. telegram_ceo_approval_request
9. ceo_decision_capture
10. approval_decision_route_to_javier
11. approval_status_read
12. platform_limit_checker
13. facebook_publish
14. publication_record_write
15. metrics_collector
16. metrics_query
17. cost_query
18. knowledge_read
19. knowledge_update_recommendation
20. knowledge_update_apply
```

This order supports a minimal end-to-end MVP.

---

# 22. Minimal MVP Tool Set

The absolute minimum for the first working demo:

```text
database_read
database_write
workflow_state_write
content_draft_write
approval_package_builder
approval_package_validator
telegram_ceo_approval_request
ceo_decision_capture
approval_decision_route_to_javier
approval_status_read
facebook_publish
publication_record_write
metrics_collector
metrics_query
```

---

# 23. Security Rules

Tools must never expose:

- API keys.
- OAuth tokens.
- Passwords.
- Raw credentials.
- Private user data.
- Internal secret values.

Agents may reference secret names, but not secret values.

Example allowed:

```text
Use FACEBOOK_PAGE_ACCESS_TOKEN from environment variables.
```

Example forbidden:

```text
Here is the Facebook token: ...
```

---

# 24. Environment Variables Preview

The following variables should be defined later in `.env.example`:

```env
POSTGRES_HOST=
POSTGRES_PORT=
POSTGRES_DB=
POSTGRES_USER=
POSTGRES_PASSWORD=

TELEGRAM_BOT_TOKEN=
TELEGRAM_LUIS_CHAT_ID=

FACEBOOK_APP_ID=
FACEBOOK_APP_SECRET=
FACEBOOK_PAGE_ID=
FACEBOOK_PAGE_ACCESS_TOKEN=

OPENAI_API_KEY=
DEEPSEEK_API_KEY=
BRAVE_API_KEY=

MEDIA_STORAGE_PROVIDER=
MEDIA_STORAGE_BUCKET=
MEDIA_STORAGE_REGION=
MEDIA_STORAGE_ACCESS_KEY_ID=
MEDIA_STORAGE_SECRET_ACCESS_KEY=
```

---

# 25. Final Rule

Tools exist to make the agent system executable, safe, traceable, and reliable.

A tool is valid only if it preserves:

- Luis's authority.
- Magnus's CEO interface role.
- Javier's operational control.
- Damian's publication boundary.
- PostgreSQL as source of truth.
- Approval validity.
- Content version integrity.
- Platform safety.
