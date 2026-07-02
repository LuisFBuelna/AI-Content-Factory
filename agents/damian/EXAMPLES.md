# EXAMPLES.md
## Damian — Publisher

> Example outputs and behavior patterns for Damian.

---

# 1. Example — Approval Package Prepared for Magnus

## Input

```json
{
  "request_from": "Javier",
  "content_post_id": 301,
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
  "media_prompt": "A funny office meeting scene with tired employees sitting around a conference table.",
  "scheduled_time": "2026-07-03T20:00:00-06:00",
  "risk_notes": []
}
```

## Expected Output

```json
{
  "approval_package_status": "prepared_for_magnus",
  "content_post_id": 301,
  "approval_request_id": 701,
  "send_to": "Javier",
  "next_recipient": "Magnus",
  "final_decision_authority": "Luis",
  "approval_package": {
    "title": "Publication proposal ready for CEO approval",
    "page": "Viral Humor Page",
    "platform": "facebook",
    "content_type": "image_post",
    "niche": "viral_humor",
    "copy_preview": "La junta era para revisar 'un tema rápido' y de pronto ya están hablando del plan estratégico del 2031.",
    "hook": "Cuando la junta era de 10 minutos pero ya van 47.",
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
  },
  "publication_blocked_until_luis_approves": true
}
```

---

# 2. Example — Approval Received Through Magnus

## Input

```json
{
  "content_post_id": 301,
  "approval_request_id": 701,
  "decision_from": "Luis",
  "decision_routed_by": "Magnus",
  "validated_by": "Javier",
  "decision": "APPROVE",
  "approved_at": "2026-07-03T18:40:00-06:00"
}
```

## Expected Output

```json
{
  "content_post_id": 301,
  "approval_request_id": 701,
  "approval_status": "APPROVED",
  "approved_by": "Luis",
  "approval_routed_by": "Magnus",
  "validated_by": "Javier",
  "approved_at": "2026-07-03T18:40:00-06:00",
  "next_step": "Schedule or publish according to the approved scheduled time.",
  "publication_allowed": true
}
```

---

# 3. Example — Blocking Publication Without Routed Approval

## Input

```json
{
  "content_post_id": 301,
  "approval_status": "APPROVED",
  "approved_by": "Luis",
  "approval_routed_by": null,
  "requested_action": "publish_now"
}
```

## Expected Output

```json
{
  "content_post_id": 301,
  "publication_status": "blocked",
  "blocker": "Approval was not routed through Magnus and validated by Javier.",
  "publication_allowed": false,
  "risk_flags": [
    "approval_route_invalid"
  ],
  "next_step": "Ask Javier to verify approval routing before publication."
}
```

---

# 4. Example — Blocking Publication While Pending

## Input

```json
{
  "content_post_id": 301,
  "approval_status": "PENDING",
  "requested_action": "publish_now"
}
```

## Expected Output

```json
{
  "content_post_id": 301,
  "publication_status": "blocked",
  "blocker": "Approval status is PENDING.",
  "publication_allowed": false,
  "risk_flags": [
    "publication_without_approval"
  ],
  "next_step": "Wait for Luis approval through Magnus or ask Javier to request decision follow-up."
}
```

---

# 5. Example — Needs Changes Routed Through Magnus

## Input

```json
{
  "content_post_id": 301,
  "approval_request_id": 701,
  "decision_from": "Luis",
  "decision_routed_by": "Magnus",
  "validated_by": "Javier",
  "decision": "NEEDS_CHANGES",
  "feedback": "Make it less robotic and more casual."
}
```

## Expected Output

```json
{
  "content_post_id": 301,
  "approval_status": "NEEDS_CHANGES",
  "publication_allowed": false,
  "next_agent": "Elena",
  "next_step": "Return draft to Elena through Javier for revision.",
  "feedback_for_revision": "Make it less robotic and more casual.",
  "notify_javier": true
}
```

---

# 6. Example — Successful Publication

## Input

```json
{
  "content_post_id": 301,
  "approval_status": "APPROVED",
  "approved_by": "Luis",
  "approval_routed_by": "Magnus",
  "validated_by": "Javier",
  "publication_action": "publish_now",
  "platform": "facebook"
}
```

## Expected Output

```json
{
  "content_post_id": 301,
  "publication_status": "PUBLISHED",
  "platform": "facebook",
  "external_post_id": "fb-post-123456",
  "external_post_url": "https://facebook.com/example/posts/123456",
  "published_at": "2026-07-03T20:00:00-06:00",
  "next_step": "Schedule metrics collection at 24h, 72h, and 7d.",
  "notify_javier": true
}
```

---

# 7. Example — Platform Limit Block

## Input

```json
{
  "page": "Viral Humor Page",
  "platform": "facebook",
  "content_type": "image_post",
  "posts_last_24_hours": {
    "image_post": 2,
    "reel": 0
  },
  "requested_action": "schedule"
}
```

## Expected Output

```json
{
  "publication_status": "blocked",
  "blocker": "Facebook image post limit reached for the last 24 hours.",
  "publication_allowed": false,
  "platform_limit": {
    "content_type": "image_post",
    "limit": 2,
    "current_count": 2,
    "period": "24_hours"
  },
  "next_step": "Ask Javier to reschedule the post outside the 24-hour window."
}
```

---

# 8. Example — Metrics Collection

## Input

```json
{
  "publication_id": 501,
  "platform": "facebook",
  "external_post_id": "fb-post-123456",
  "collection_time": "24h_after_publication"
}
```

## Expected Output

```json
{
  "publication_id": 501,
  "metrics_status": "collected",
  "collected_at": "2026-07-04T20:00:00-06:00",
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
    "engagement_rate": 0.1125
  },
  "next_step": "Store metrics snapshot and make available for Magnus weekly review."
}
```
