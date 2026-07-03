# 01_content_publication_workflow.md
# AI Content Factory — Content Publication Workflow

> Workflow: 01  
> Version: 1.0  
> Owner: Luis — CEO & System Owner  
> Applies To: Facebook v1 publication pipeline  
> Approval Interface: Magnus  
> Final Approval Authority: Luis

---

# 1. Purpose

This workflow defines how AI Content Factory moves a content idea from strategy to research, drafting, approval, publication, metrics collection, and learning.

This workflow enforces the official approval route:

```text
Agents → Javier → Magnus → Luis
Luis → Magnus → Javier → Agents
```

Luis does not communicate directly with Damian, Elena, Bruno, or Javier during normal operation.

Magnus is the default CEO-facing interface.

Damian publishes only after Luis explicitly approves the current content version through Magnus and Javier.

---

# 2. Workflow Goals

This workflow exists to ensure that every publication is:

- Strategically justified.
- Researched when needed.
- Created in the correct brand voice.
- Validated by Javier.
- Presented to Luis through Magnus.
- Explicitly approved by Luis.
- Published only by Damian after valid approval.
- Recorded in PostgreSQL.
- Measured after publication.
- Used for learning.

---

# 3. Agents Involved

## Magnus — Product Owner & CEO Approval Interface

Magnus defines product direction, reviews strategic alignment, presents approval proposals to Luis, captures Luis's decision, and routes that decision back to Javier.

## Javier — Operations Director

Javier coordinates the workflow, assigns tasks, validates outputs, checks cost and quality gates, and routes work to the correct agent.

## Bruno — Researcher

Bruno researches trends, competitors, sources, risks, and content angles.

## Elena — Creator

Elena creates content drafts, hooks, CTAs, captions, hashtags, scripts, and media prompts.

## Damian — Publisher

Damian prepares approval packages, publishes approved content, records publication data, and collects metrics.

## Luis — CEO & System Owner

Luis approves, requests changes, rejects, or discards publication proposals through Magnus.

---

# 4. Workflow States

The standard lifecycle is:

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

State meanings:

| State | Meaning |
|---|---|
| IDEA | Initial content idea exists. |
| RESEARCH_REQUESTED | Javier assigned research to Bruno. |
| RESEARCH_COMPLETED | Bruno returned usable research. |
| CONTENT_DRAFTED | Elena created a complete content draft. |
| READY_FOR_APPROVAL_PACKAGE | Draft is ready for Damian package preparation. |
| READY_FOR_MAGNUS_REVIEW | Damian package passed Javier validation. |
| WAITING_FOR_LUIS_DECISION | Magnus presented the proposal to Luis. |
| APPROVED | Luis approved the current content version. |
| NEEDS_CHANGES | Luis requested revision. |
| REJECTED | Luis rejected the proposal. |
| DISCARDED | Luis discarded the proposal. |
| SCHEDULED | Damian scheduled approved content. |
| PUBLISHED | Damian published approved content. |
| METRICS_COLLECTED | Damian collected at least one metrics snapshot. |
| ANALYZED | Magnus reviewed performance and extracted learning. |

---

# 5. High-Level Flow

```text
1. Magnus identifies or approves content direction.
2. Javier creates or updates the workflow.
3. Javier assigns Bruno if research is needed.
4. Bruno returns structured research.
5. Javier validates Bruno's output.
6. Javier assigns Elena to create content.
7. Elena returns complete content draft.
8. Javier validates Elena's output.
9. Javier assigns Damian to prepare approval package.
10. Damian prepares approval package for Magnus.
11. Javier validates Damian's package.
12. Javier notifies Magnus.
13. Magnus presents proposal to Luis through Telegram.
14. Luis decides through Magnus.
15. Magnus routes Luis's decision to Javier.
16. Javier routes operational next step.
17. Damian publishes only if approved.
18. Damian records publication and collects metrics.
19. Magnus analyzes results.
20. Durable learnings are proposed for Knowledge Base.
```

---

# 6. Detailed Step-by-Step Workflow

## Step 1 — Strategy or Idea Selection

Trigger:

- Magnus identifies a content opportunity.
- Luis requests a content direction.
- Javier receives a scheduled content requirement.
- A previous learning suggests recycling a successful pattern.

Responsible agent:

```text
Magnus
```

Expected output:

```json
{
  "workflow_trigger": "strategy_direction",
  "platform": "facebook",
  "niche": "viral_humor",
  "objective": "Increase comments using relatable office humor.",
  "hypothesis": "Office frustration hooks may generate more comments than generic memes.",
  "success_metric": "comments and shares",
  "risk_level": "low",
  "next_action_for_javier": "Create a content workflow and request research from Bruno."
}
```

State transition:

```text
IDEA
```

---

## Step 2 — Javier Creates Workflow

Responsible agent:

```text
Javier
```

Javier must:

- Create workflow ID.
- Create or update `content_ideas`.
- Check required context.
- Check whether similar research already exists.
- Check cost status.
- Decide whether Bruno is needed.

Expected output:

```json
{
  "workflow_id": "wf-facebook-humor-office-001",
  "content_idea_id": 101,
  "current_state": "IDEA",
  "platform": "facebook",
  "niche": "viral_humor",
  "objective": "Create office humor content for Facebook.",
  "requires_research": true,
  "next_agent": "Bruno"
}
```

State transition:

```text
IDEA → RESEARCH_REQUESTED
```

---

## Step 3 — Bruno Research

Responsible agent:

```text
Bruno
```

Bruno must provide:

- Research summary.
- Key findings.
- Content angles.
- Audience signals.
- Sources when applicable.
- Risks.
- Unknowns.
- Confidence level.
- Recommended next step.

Expected output:

```json
{
  "research_summary": "Office frustration humor is a safe and relatable angle for Facebook.",
  "key_findings": [
    "Meeting jokes are broadly relatable.",
    "Short captions are easier to understand and share.",
    "Work frustration can trigger comments and tagging."
  ],
  "content_angles": [
    {
      "angle": "Meetings that should have been emails",
      "risk_level": "low"
    },
    {
      "angle": "Boss says it is quick but takes 40 minutes",
      "risk_level": "low"
    }
  ],
  "audience_signals": [
    "People may tag coworkers.",
    "People may comment with similar situations."
  ],
  "sources": [],
  "risks": [],
  "unknowns": [
    "Actual page response must be validated with metrics."
  ],
  "confidence": "medium",
  "recommended_next_step": "Ask Elena to create 3 Facebook image post drafts."
}
```

Javier quality gate:

- Output includes required fields.
- Risk level is acceptable.
- Angles are usable.
- No unsafe or plagiarized direction.

State transition:

```text
RESEARCH_REQUESTED → RESEARCH_COMPLETED
```

---

## Step 4 — Elena Creates Content Draft

Responsible agent:

```text
Elena
```

Elena must create content aligned with:

- Bruno's research.
- Magnus's strategy.
- Brand voice.
- Target platform.
- Target niche.
- Neutral Latin American Spanish.

Expected output:

```json
{
  "platform": "facebook",
  "content_type": "image_post",
  "niche": "viral_humor",
  "language": "neutral_latin_american_spanish",
  "drafts": [
    {
      "title": "La junta rápida",
      "hook": "Cuando la junta era de 10 minutos pero ya van 47.",
      "post_copy": "La junta era para revisar 'un tema rápido' y de pronto ya están hablando del plan estratégico del 2031.",
      "call_to_action": "Etiqueta a alguien que siempre dice: 'es rapidísimo'.",
      "hashtags": [
        "#Trabajo",
        "#Oficina",
        "#Humor"
      ],
      "image_prompt": "A funny office meeting scene with tired employees sitting around a conference table, one person presenting endless slides, exaggerated expressions, clean social media illustration style, no real people, no offensive stereotypes.",
      "risk_notes": []
    }
  ],
  "recommended_option": "La junta rápida",
  "confidence": "high"
}
```

Javier quality gate:

- Content is complete.
- Language is `es-LATAM`.
- Hook exists.
- CTA exists.
- Hashtags exist.
- Image or video prompt exists when needed.
- Risk notes exist.
- Content does not violate `CONSTITUTION.md`.

State transition:

```text
RESEARCH_COMPLETED → CONTENT_DRAFTED
```

---

## Step 5 — Damian Prepares Approval Package

Responsible agent:

```text
Damian
```

Damian must prepare a package for Magnus to present to Luis.

Damian must not send the package directly to Luis.

Expected output:

```json
{
  "approval_package_status": "prepared_for_magnus",
  "content_post_id": 301,
  "approval_request_id": 701,
  "prepared_by": "Damian",
  "prepared_for": "Magnus",
  "final_decision_authority": "Luis",
  "approval_package": {
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

State transition:

```text
CONTENT_DRAFTED → READY_FOR_APPROVAL_PACKAGE
```

---

## Step 6 — Javier Validates Approval Package

Responsible agent:

```text
Javier
```

Javier validates:

- Package is complete.
- Media exists or prompt exists.
- Risk notes are included.
- Schedule is valid.
- Platform limits would not be violated.
- Content version matches current draft.
- Package is ready for Magnus.

Expected output:

```json
{
  "workflow_id": "wf-facebook-humor-office-001",
  "content_post_id": 301,
  "approval_request_id": 701,
  "validated_by": "Javier",
  "approval_package_valid": true,
  "next_agent": "Magnus",
  "requested_action": "Present proposal to Luis for approval decision."
}
```

State transition:

```text
READY_FOR_APPROVAL_PACKAGE → READY_FOR_MAGNUS_REVIEW
```

---

## Step 7 — Magnus Presents Proposal to Luis

Responsible agent:

```text
Magnus
```

Magnus must show Luis the proposal through Telegram.

Magnus must include:

- Page.
- Platform.
- Content type.
- Niche.
- Hook.
- Copy.
- CTA.
- Hashtags.
- Media preview or prompt.
- Suggested schedule.
- Strategic reason.
- Risk notes.
- Decision options.

Expected Telegram approval request:

```json
{
  "request_type": "publication_approval",
  "content_post_id": 301,
  "approval_request_id": 701,
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
  "strategic_reason": "This tests office frustration humor as a comment-driving Facebook format.",
  "risk_notes": [],
  "decision_options": [
    "APPROVE",
    "NEEDS_CHANGES",
    "REJECT",
    "DISCARD"
  ]
}
```

State transition:

```text
READY_FOR_MAGNUS_REVIEW → WAITING_FOR_LUIS_DECISION
```

---

## Step 8 — Luis Decision

Responsible human:

```text
Luis
```

Luis chooses:

```text
APPROVE
NEEDS_CHANGES
REJECT
DISCARD
```

Magnus must capture the decision.

Decision capture format:

```json
{
  "content_post_id": 301,
  "approval_request_id": 701,
  "decision_from": "Luis",
  "decision": "APPROVE",
  "feedback": "",
  "decided_at": "2026-07-03T18:40:00-06:00"
}
```

Magnus must not infer approval from silence or ambiguous comments.

---

# 7. Decision Branches

## Branch A — Luis Approves

Magnus routes decision to Javier:

```json
{
  "message_type": "approval_decision_from_luis",
  "content_post_id": 301,
  "approval_request_id": 701,
  "decision": "APPROVE",
  "feedback": "",
  "authorized_by": "Luis",
  "send_to": "Javier",
  "notes_for_damian": "Publish only this approved content version."
}
```

Javier validates:

```text
approved_by = Luis
approval_routed_by = Magnus
validated_by = Javier
approved_content_version = current_content_version
approval_status = APPROVED
```

Then Javier instructs Damian.

State transition:

```text
WAITING_FOR_LUIS_DECISION → APPROVED
```

---

## Branch B — Luis Requests Changes

Magnus routes feedback to Javier.

Javier sends task to Elena or the appropriate agent.

Expected route:

```json
{
  "decision": "NEEDS_CHANGES",
  "feedback": "Make it less robotic and more casual.",
  "next_agent": "Elena",
  "required_action": "Revise draft and return for approval package update."
}
```

State transition:

```text
WAITING_FOR_LUIS_DECISION → NEEDS_CHANGES → CONTENT_DRAFTED
```

A new approval package must be created after revision.

---

## Branch C — Luis Rejects

Javier marks proposal as rejected.

Magnus may extract learning from rejection.

State transition:

```text
WAITING_FOR_LUIS_DECISION → REJECTED
```

Rejected content must not be published.

---

## Branch D — Luis Discards

Javier marks proposal as discarded.

The item is removed from active workflow.

State transition:

```text
WAITING_FOR_LUIS_DECISION → DISCARDED
```

Discarded content must not be published.

---

# 8. Publication Step

Responsible agent:

```text
Damian
```

Damian may publish only when:

```text
approval_status = APPROVED
approved_by = Luis
approval_routed_by = Magnus
validated_by = Javier
approval_request.content_version = content_post.content_version
```

Expected publication input:

```json
{
  "content_post_id": 301,
  "approval_request_id": 701,
  "approval_status": "APPROVED",
  "approved_by": "Luis",
  "approval_routed_by": "Magnus",
  "validated_by": "Javier",
  "publication_action": "publish_now",
  "platform": "facebook"
}
```

Expected publication output:

```json
{
  "content_post_id": 301,
  "publication_status": "PUBLISHED",
  "platform": "facebook",
  "external_post_id": "fb-post-123456",
  "external_post_url": "https://facebook.com/example/posts/123456",
  "published_at": "2026-07-03T20:00:00-06:00",
  "next_step": "Schedule metrics collection at 24h, 72h, and 7d."
}
```

State transition:

```text
APPROVED → SCHEDULED → PUBLISHED
```

or:

```text
APPROVED → PUBLISHED
```

---

# 9. Metrics Collection

Responsible agent:

```text
Damian
```

Default collection windows:

```text
24 hours after publication
72 hours after publication
7 days after publication
```

Expected output:

```json
{
  "publication_id": 501,
  "metrics_status": "collected",
  "collection_window": "24h",
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
  }
}
```

State transition:

```text
PUBLISHED → METRICS_COLLECTED
```

---

# 10. Analysis and Learning

Responsible agent:

```text
Magnus
```

Magnus reviews:

- Reach.
- Comments.
- Shares.
- Saves.
- Follower growth.
- Rejection or revision feedback.
- Cost.
- Approval rate.
- Performance against hypothesis.

Expected output:

```json
{
  "content_post_id": 301,
  "analysis_summary": "The office humor post performed above the average share rate and generated useful comment activity.",
  "pattern_detected": "Workplace frustration hooks may drive comments.",
  "confidence": "medium",
  "recommended_next_step": "Test 3 more variations before adding as a durable learning.",
  "knowledge_update_suggestion": {
    "target_file": "knowledge/viral_hooks.md",
    "update_type": "add",
    "status": "experimental",
    "suggested_text": "Office frustration hooks may drive comments on Facebook humor pages. Validate with more samples."
  }
}
```

State transition:

```text
METRICS_COLLECTED → ANALYZED
```

---

# 11. Blocking Rules

Publication must be blocked if:

- Approval is missing.
- Approval is pending.
- Approval was not given by Luis.
- Approval was not routed by Magnus.
- Approval was not validated by Javier.
- Content version changed after approval.
- Media asset is missing.
- Platform limits are exceeded.
- Risk flags require escalation.
- Publication tool fails validation.

Blocking output:

```json
{
  "publication_status": "blocked",
  "content_post_id": 301,
  "blocker": "Approval route is invalid.",
  "publication_allowed": false,
  "risk_flags": [
    "invalid_approval_route"
  ],
  "next_step": "Notify Javier and request approval route validation."
}
```

---

# 12. Error Handling

All significant failures must be logged.

Error record format:

```json
{
  "workflow_id": "",
  "content_post_id": "",
  "agent_name": "",
  "task_name": "",
  "error_type": "",
  "error_message": "",
  "current_state": "",
  "retry_safe": false,
  "recommended_next_action": "",
  "notify_javier": true
}
```

Unknown state must be treated as failure until resolved.

---

# 13. Cost Rules

Before expensive steps, Javier must check:

- Existing database data.
- Cached research.
- Knowledge Base.
- Lower-cost model availability.
- Budget thresholds.

If cost reaches emergency thresholds, Javier must notify Magnus.

Magnus notifies Luis only when needed.

---

# 14. Final Rule

No content becomes public unless Luis explicitly approves the exact current content version through Magnus and Javier.

If approval is unclear, do not publish.

If the content version is unclear, do not publish.

If the risk is unclear, do not publish.
