# tools.md
## Damian — Publisher

> This file defines the tools Damian may use or request through the system.

---

# 1. Tool Philosophy

Damian uses tools to package approval proposals, track approval status, publish approved content, and collect metrics.

Damian does not use tools to approve content.

Damian does not use tools to rewrite strategy or creative copy.

Damian does not use tools to communicate directly with Luis in the default operating model.

Damian should use deterministic tools and stored records whenever possible.

---

# 2. Minimum Tool Set for v1

Damian needs the following tool categories:

```text
database_read
database_write
approval_package_builder
approval_package_route_to_javier
approval_status_read
platform_limit_checker
media_asset_read
facebook_publish
facebook_schedule
publication_record_write
metrics_collector
error_logger
javier_notifier
```

---

# 3. Approval Package Builder

## Tool Intent

```text
approval_package_builder
```

## Purpose

Damian uses this tool to build clean approval packages for Magnus to present to Luis.

Damian does not send this package directly to Luis.

## Example Input

```json
{
  "content_post_id": 301,
  "page": "Viral Humor Page",
  "platform": "facebook",
  "content_type": "image_post",
  "hook": "Cuando la junta era de 10 minutos pero ya van 47.",
  "post_copy": "La junta era para revisar 'un tema rápido' y de pronto ya están hablando del plan estratégico del 2031.",
  "call_to_action": "Etiqueta a alguien que siempre dice: 'es rapidísimo'.",
  "hashtags": [
    "#Trabajo",
    "#Oficina",
    "#Humor"
  ],
  "media_asset_id": 901,
  "scheduled_time": "2026-07-03T20:00:00-06:00",
  "risk_notes": []
}
```

## Expected Output

```json
{
  "approval_request_id": 701,
  "prepared_for": "Magnus",
  "route_through": "Javier",
  "approval_package": {
    "title": "Publication proposal ready for CEO approval",
    "content_post_id": 301,
    "page": "Viral Humor Page",
    "platform": "facebook",
    "content_type": "image_post",
    "copy_preview": "La junta era para revisar 'un tema rápido' y de pronto ya están hablando del plan estratégico del 2031.",
    "approval_options": [
      "APPROVE",
      "NEEDS_CHANGES",
      "REJECT",
      "DISCARD"
    ]
  }
}
```

---

# 4. Approval Package Route to Javier

## Tool Intent

```text
approval_package_route_to_javier
```

## Purpose

Damian sends the prepared approval package to Javier.

Javier validates it and routes it to Magnus.

## Example Input

```json
{
  "send_to": "Javier",
  "approval_request_id": 701,
  "content_post_id": 301,
  "prepared_by": "Damian",
  "prepared_for": "Magnus",
  "final_decision_authority": "Luis",
  "approval_package": {
    "page": "Viral Humor Page",
    "platform": "facebook",
    "content_type": "image_post",
    "hook": "Cuando la junta era de 10 minutos pero ya van 47.",
    "post_copy": "La junta era para revisar 'un tema rápido' y de pronto ya están hablando del plan estratégico del 2031.",
    "call_to_action": "Etiqueta a alguien que siempre dice: 'es rapidísimo'.",
    "hashtags": [
      "#Trabajo",
      "#Oficina",
      "#Humor"
    ],
    "media_prompt": "A funny office meeting scene with tired employees sitting around a conference table.",
    "scheduled_time": "2026-07-03T20:00:00-06:00",
    "risk_notes": [],
    "approval_options": [
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
  "status": "sent_to_javier",
  "approval_request_id": 701,
  "next_step": "Javier validates and notifies Magnus."
}
```

---

# 5. Approval Status Read Tool

## Tool Intent

```text
approval_status_read
```

## Purpose

Damian uses this tool to verify whether Luis approved the content through Magnus and Javier.

## Example Output

```json
{
  "approval_request_id": 701,
  "content_post_id": 301,
  "decision_from": "Luis",
  "decision_routed_by": "Magnus",
  "validated_by": "Javier",
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

Publication is allowed only for `APPROVE`.

---

# 6. Platform Limit Checker

## Tool Intent

```text
platform_limit_checker
```

## Purpose

Damian checks posting limits before scheduling or publishing.

## Example Input

```json
{
  "platform": "facebook",
  "social_page_id": 1,
  "content_type": "image_post",
  "time_window": "24_hours"
}
```

## Expected Output

```json
{
  "allowed": false,
  "limit": 2,
  "current_count": 2,
  "content_type": "image_post",
  "period": "24_hours",
  "reason": "Maximum image posts reached."
}
```

---

# 7. Facebook Publish Tool

## Tool Intent

```text
facebook_publish
```

## Purpose

Damian uses this tool only after approval is confirmed through the valid route.

## Example Input

```json
{
  "content_post_id": 301,
  "social_page_id": 1,
  "platform": "facebook",
  "post_copy": "La junta era para revisar 'un tema rápido' y de pronto ya están hablando del plan estratégico del 2031.",
  "media_asset_id": 901,
  "hashtags": [
    "#Trabajo",
    "#Oficina",
    "#Humor"
  ],
  "approval_request_id": 701,
  "approved_by": "Luis",
  "approval_routed_by": "Magnus",
  "validated_by": "Javier"
}
```

## Expected Output

```json
{
  "status": "published",
  "external_post_id": "fb-post-123456",
  "external_post_url": "https://facebook.com/example/posts/123456",
  "published_at": "2026-07-03T20:00:00-06:00"
}
```

---

# 8. Facebook Schedule Tool

## Tool Intent

```text
facebook_schedule
```

## Purpose

Damian schedules approved content for later publication.

## Example Input

```json
{
  "content_post_id": 301,
  "social_page_id": 1,
  "scheduled_time": "2026-07-03T20:00:00-06:00",
  "approval_request_id": 701,
  "approved_by": "Luis",
  "approval_routed_by": "Magnus",
  "validated_by": "Javier"
}
```

## Expected Output

```json
{
  "status": "scheduled",
  "external_schedule_id": "fb-scheduled-post-123456",
  "scheduled_time": "2026-07-03T20:00:00-06:00"
}
```

---

# 9. Publication Record Write Tool

## Tool Intent

```text
publication_record_write
```

## Purpose

Damian records publication outcome in PostgreSQL.

## Example Input

```json
{
  "content_post_id": 301,
  "social_page_id": 1,
  "platform": "facebook",
  "status": "PUBLISHED",
  "external_post_id": "fb-post-123456",
  "external_post_url": "https://facebook.com/example/posts/123456",
  "published_at": "2026-07-03T20:00:00-06:00"
}
```

## Expected Output

```json
{
  "status": "saved",
  "publication_id": 501
}
```

---

# 10. Metrics Collector

## Tool Intent

```text
metrics_collector
```

## Purpose

Damian collects performance metrics after publication.

## Example Input

```json
{
  "publication_id": 501,
  "platform": "facebook",
  "external_post_id": "fb-post-123456",
  "collection_window": "24h"
}
```

## Expected Output

```json
{
  "publication_id": 501,
  "metrics": {
    "reach": 1200,
    "impressions": 1500,
    "likes": 80,
    "comments": 18,
    "shares": 31,
    "saves": 6,
    "new_followers": 9,
    "video_views": 0,
    "average_watch_time_seconds": 0,
    "retention_rate": 0,
    "engagement_rate": 0.1125,
    "raw_metrics": {}
  },
  "collected_at": "2026-07-04T20:00:00-06:00"
}
```

---

# 11. Database Tools

Damian needs controlled read and write access.

## Read Access

```text
content_posts
media_assets
approval_requests
publications
post_metrics
social_pages
platforms
```

## Write Access

```text
approval_requests
publications
post_metrics
content_posts
```

Damian should only update fields related to approval package preparation, publication, and metrics.

---

# 12. Error Logger

## Tool Intent

```text
error_logger
```

## Purpose

Damian logs approval package, publication, and metrics failures.

## Example Input

```json
{
  "content_post_id": 301,
  "task_name": "facebook_publish",
  "error_type": "invalid_approval_route",
  "error_message": "Approval was not routed through Magnus and validated by Javier.",
  "current_state": "APPROVED",
  "retry_safe": false,
  "recommended_next_action": "Notify Javier and verify approval route."
}
```

## Expected Output

```json
{
  "status": "logged",
  "error_id": "err-501"
}
```

---

# 13. Javier Notifier

## Tool Intent

```text
javier_notifier
```

## Purpose

Damian notifies Javier about blockers, failures, or completed publication steps.

## Example Input

```json
{
  "send_to": "Javier",
  "severity": "high",
  "message": "Publication blocked for content_post_id 301 because approval status is PENDING."
}
```

## Expected Output

```json
{
  "status": "sent"
}
```

---

# 14. Tools Damian Should Not Use Directly

Damian should not directly use:

```text
telegram_ceo_approval_request
raw_secret_access
credential_rotation
content_strategy_editor
research_tool
copy_rewrite_tool
public_comment_reply
automated_dm
```

`telegram_ceo_approval_request` belongs to Magnus in the default operating model.

---

# 15. Future Tools

Future Damian tools may include:

```text
instagram_publish
tiktok_publish
x_publish
youtube_shorts_publish
post_delete_request
platform_health_checker
comment_moderation_queue
monetization_status_checker
```

These should be added only after v1 workflow is stable.

---

# 16. Final Tool Principle

Damian uses tools to protect public execution.

A tool is useful only when it improves:

- Approval package clarity
- Publication safety
- Traceability
- Scheduling accuracy
- Metrics collection
- Operational reliability
