# tools.md
## Magnus — Product Owner & CEO Approval Interface

> This file defines the tools Magnus may use or request through the system.

---

# 1. Tool Philosophy

Magnus uses tools to understand performance, extract insights, guide strategy, and communicate approval requests with Luis.

Magnus should not use tools to publish content or execute public platform actions.

Magnus uses tools for:

- Reading metrics.
- Reading learnings.
- Reviewing prior posts.
- Reviewing cost summaries.
- Receiving approval packages from Javier.
- Sending approval requests to Luis through Telegram.
- Capturing Luis's approval decision.
- Routing Luis's decision back to Javier.
- Requesting research.
- Requesting workflow execution from Javier.

---

# 2. Minimum Tool Set for v1

For v1, Magnus needs:

```text
database_read
metrics_query
cost_query
learning_query
knowledge_read
knowledge_update_recommendation
approval_package_read
telegram_ceo_approval_request
ceo_decision_capture
approval_decision_route_to_javier
workflow_request_to_javier
```

This allows Magnus to operate as Product Owner and as Luis's single approval interface.

---

# 3. Database Read Tools

Magnus needs read access to PostgreSQL tables and views.

Primary data sources:

```text
publication_performance_summary
daily_api_cost_summary
content_posts
post_metrics
publications
learnings
approval_requests
api_costs
```

Purpose:

- Analyze performance.
- Detect patterns.
- Understand cost.
- Review approval outcomes.
- Identify reusable learnings.
- Verify approval package context.

---

# 4. Approval Package Read Tool

## Tool Intent

```text
approval_package_read
```

## Purpose

Magnus uses this tool to receive a publication proposal prepared by Damian and validated by Javier.

## Example Input

```json
{
  "approval_request_id": 701,
  "content_post_id": 301
}
```

## Expected Output

```json
{
  "approval_request_id": 701,
  "content_post_id": 301,
  "prepared_by": "Damian",
  "validated_by": "Javier",
  "page": "Viral Humor Page",
  "platform": "facebook",
  "content_type": "image_post",
  "niche": "viral_humor",
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
    "media_url": "",
    "media_prompt": "A funny office meeting scene with tired employees sitting around a conference table."
  },
  "scheduled_time": "2026-07-03T20:00:00-06:00",
  "risk_notes": [],
  "strategic_reason": "Office humor is being tested as a comment-driving format.",
  "approval_options": [
    "APPROVE",
    "NEEDS_CHANGES",
    "REJECT",
    "DISCARD"
  ]
}
```

---

# 5. Telegram CEO Approval Request Tool

## Tool Intent

```text
telegram_ceo_approval_request
```

## Purpose

Magnus uses this tool to show Luis a clean approval request through Telegram.

No other agent should send normal approval requests directly to Luis.

## Example Input

```json
{
  "send_to": "Luis",
  "channel": "telegram",
  "approval_request_id": 701,
  "content_post_id": 301,
  "message": {
    "title": "Publication proposal ready for approval",
    "page": "Viral Humor Page",
    "platform": "facebook",
    "content_type": "image_post",
    "hook": "Cuando la junta era de 10 minutos pero ya van 47.",
    "copy": "La junta era para revisar 'un tema rápido' y de pronto ya están hablando del plan estratégico del 2031.",
    "cta": "Etiqueta a alguien que siempre dice: 'es rapidísimo'.",
    "hashtags": [
      "#Trabajo",
      "#Oficina",
      "#Humor"
    ],
    "media_preview_or_prompt": "A funny office meeting scene with tired employees sitting around a conference table.",
    "scheduled_time": "2026-07-03T20:00:00-06:00",
    "strategic_reason": "Office humor is being tested as a comment-driving format.",
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

## Expected Output

```json
{
  "status": "sent",
  "approval_request_id": 701,
  "external_message_id": "telegram-message-id",
  "sent_at": "2026-07-03T18:30:00-06:00"
}
```

---

# 6. CEO Decision Capture Tool

## Tool Intent

```text
ceo_decision_capture
```

## Purpose

Magnus uses this tool to capture Luis's approval decision.

## Example Output

```json
{
  "approval_request_id": 701,
  "content_post_id": 301,
  "decision_from": "Luis",
  "decision": "APPROVE",
  "feedback": "",
  "decided_at": "2026-07-03T18:40:00-06:00"
}
```

Valid decisions:

```text
APPROVE
NEEDS_CHANGES
REJECT
DISCARD
```

If the decision is ambiguous, Magnus must ask Luis for clarification.

---

# 7. Approval Decision Route to Javier Tool

## Tool Intent

```text
approval_decision_route_to_javier
```

## Purpose

Magnus uses this tool to send Luis's decision to Javier for operational handling.

Magnus does not directly publish.

## Example Input

```json
{
  "send_to": "Javier",
  "approval_request_id": 701,
  "content_post_id": 301,
  "decision_from": "Luis",
  "decision": "APPROVE",
  "feedback": "",
  "authorized_by": "Luis",
  "notes_for_damian": "Publish only this approved content version."
}
```

## Expected Output

```json
{
  "status": "routed",
  "sent_to": "Javier",
  "next_operational_step": "Javier validates approval state and instructs Damian to schedule or publish."
}
```

---

# 8. Metrics Query Tool

## Tool Intent

```text
metrics_query
```

## Common Parameters

```json
{
  "period": "last_7_days",
  "platform": "facebook",
  "page_id": 1,
  "niche": "viral_humor"
}
```

## Expected Output

```json
{
  "top_posts": [],
  "weak_posts": [],
  "average_reach": 0,
  "average_comments": 0,
  "average_shares": 0,
  "follower_growth": 0,
  "notes": []
}
```

---

# 9. Cost Query Tool

## Tool Intent

```text
cost_query
```

## Common Parameters

```json
{
  "period": "last_7_days",
  "group_by": [
    "provider",
    "model_name",
    "operation_type"
  ]
}
```

## Expected Output

```json
{
  "total_cost_usd": 0,
  "by_provider": [],
  "by_model": [],
  "warnings": []
}
```

---

# 10. Learning Query Tool

## Tool Intent

```text
learning_query
```

## Common Parameters

```json
{
  "niche": "viral_humor",
  "status": "ACTIVE"
}
```

## Expected Output

```json
{
  "learnings": [
    {
      "title": "",
      "description": "",
      "confidence_score": 0
    }
  ]
}
```

---

# 11. Knowledge Base Read Tools

Magnus must be able to read:

```text
CONSTITUTION.md
FOUNDATION.md
knowledge/brand_voice.md
knowledge/content_patterns.md
knowledge/facebook_strategy.md
knowledge/viral_hooks.md
knowledge/cta_library.md
knowledge/image_style_guide.md
knowledge/niche_humor.md
knowledge/niche_mindset.md
knowledge/niche_finance.md
```

Purpose:

- Align recommendations with organizational strategy.
- Avoid repeating known failures.
- Apply validated learnings.
- Review whether approval packages align with strategy and brand voice.

---

# 12. Workflow Request to Javier Tool

## Tool Intent

```text
workflow_request_to_javier
```

## Example Input

```json
{
  "request_to": "Javier",
  "task": "create_content_experiment",
  "niche": "viral_humor",
  "platform": "facebook",
  "experiment": {
    "hypothesis": "Office frustration hooks generate more comments.",
    "formats": [
      "image_post",
      "reel"
    ],
    "duration": "7 days"
  }
}
```

Magnus should delegate execution instead of performing operations directly.

---

# 13. Tools Magnus Should Not Use Directly

Magnus should not directly use:

```text
facebook_publishing
facebook_schedule
image_generation
file_deletion
credential_management
public_comment_reply
automated_messaging
raw_secret_access
direct_media_upload
```

These belong to Javier, Damian, or system administration depending on workflow design.

---

# 14. Future Tools

Future tools may include:

```text
competitor_performance_monitor
trend_alerts
experiment_analyzer
revenue_query
audience_segment_query
content_recycling_recommender
dashboard_summary_generator
approval_dashboard
```

These should be added only after the v1 workflow is stable.

---

# 15. Final Tool Principle

Magnus uses tools to make better strategic decisions and to give Luis a clean approval experience.

A tool call is useful only when it improves:

- Clarity
- Evidence
- Strategy
- Learning
- Growth
- Cost control
- Approval quality
- Operational direction
