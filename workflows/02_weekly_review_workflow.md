# 02_weekly_review_workflow.md
# AI Content Factory — Weekly Review Workflow

> Workflow: 02  
> Version: 1.0  
> Owner: Luis — CEO & System Owner  
> Primary Agent: Magnus — Product Owner & CEO Approval Interface  
> Operational Coordinator: Javier — Operations Director

---

# 1. Purpose

This workflow defines how AI Content Factory reviews weekly content performance, extracts insights, identifies strategic opportunities, and proposes improvements.

The weekly review is owned by Magnus.

Javier coordinates required data collection.

Damian provides publication and metrics records.

Bruno may provide trend or competitor context.

Elena may later receive revision or creation direction based on findings.

Luis receives a concise strategic summary through Magnus.

---

# 2. Goals

The weekly review should answer:

- What worked?
- What failed?
- What should be repeated?
- What should be stopped?
- What should be tested next?
- What did Luis reject or ask to change?
- What did the audience respond to?
- What did the system learn?
- What should be added to the Knowledge Base?
- What should change next week?

---

# 3. Review Cadence

Default cadence:

```text
Weekly
```

Recommended review day:

```text
Monday morning or Monday afternoon
```

The exact schedule may be changed by Luis.

---

# 4. Agents Involved

## Magnus

Owns the weekly review and strategic interpretation.

## Javier

Coordinates data collection, validates completeness, and turns Magnus's recommendations into operational tasks.

## Damian

Provides publication records and metrics snapshots.

## Bruno

Provides trend or competitor context if needed.

## Elena

Receives creative improvement tasks after the review.

## Luis

Receives a concise summary and may approve strategic direction or request changes.

---

# 5. Required Inputs

Javier must ensure Magnus has access to:

- Publications from the review period.
- Metrics snapshots.
- Approval outcomes.
- Luis feedback.
- Rejected proposals.
- Revision requests.
- Cost summary.
- Active learnings.
- Previous weekly recommendations.
- Current platform limits.
- Any major errors or blockers.

Recommended input query:

```json
{
  "review_period": {
    "start": "2026-07-01",
    "end": "2026-07-07"
  },
  "platform": "facebook",
  "page_id": 1,
  "include": [
    "publications",
    "post_metrics",
    "approval_requests",
    "rejected_content",
    "needs_changes_feedback",
    "api_costs",
    "active_learnings",
    "workflow_errors"
  ]
}
```

Metrics responsibilities are divided as follows:

## Damian — Publisher

Damian is responsible for:

- Collecting metrics from the publishing platforms.
- Writing metrics snapshots into the `post_metrics` table.
- Updating publication records when needed.
- Reporting metric collection failures to Javier.

## Javier — Operations Director

Javier is responsible for:

- Validating that required metrics were collected.
- Checking whether metrics are complete enough for review.
- Flagging missing or incomplete metrics.
- Coordinating retry attempts when metric collection fails.
- Preparing the operational data package for Magnus.

## Magnus — Product Owner & CEO Approval Interface

Magnus is responsible for:

- Reading metrics summaries and performance views.
- Interpreting performance.
- Comparing results against strategy and experiments.
- Preparing weekly strategic summaries.
- Presenting insights and recommendations to Luis through Telegram.

---

# 6. Workflow States

Weekly review states:

```text
REVIEW_REQUESTED
DATA_COLLECTION_STARTED
DATA_COLLECTION_COMPLETED
MAGNUS_ANALYSIS_STARTED
MAGNUS_ANALYSIS_COMPLETED
RECOMMENDATIONS_READY
LUIS_SUMMARY_SENT
OPERATIONAL_TASKS_CREATED
KNOWLEDGE_UPDATES_PROPOSED
REVIEW_CLOSED
```

---

# 7. Step-by-Step Workflow

## Step 1 — Javier Starts Weekly Review

Responsible agent:

```text
Javier
```

Expected output:

```json
{
  "workflow_type": "weekly_review",
  "review_id": "wr-2026-07-07-facebook-001",
  "period": {
    "start": "2026-07-01",
    "end": "2026-07-07"
  },
  "platform": "facebook",
  "page_id": 1,
  "status": "REVIEW_REQUESTED",
  "next_step": "Collect metrics, approval outcomes, costs, and workflow issues."
}
```

---

## Step 2 — Damian Provides Metrics and Publication Data

Responsible agent:

```text
Damian
```

Expected output:

```json
{
  "review_id": "wr-2026-07-07-facebook-001",
  "publication_summary": {
    "total_published": 12,
    "image_posts": 9,
    "reels": 3,
    "failed_publications": 0
  },
  "top_posts": [
    {
      "content_post_id": 301,
      "content_type": "image_post",
      "topic": "office humor",
      "reach": 1200,
      "comments": 18,
      "shares": 31,
      "engagement_rate": 0.1125
    }
  ],
  "weak_posts": [
    {
      "content_post_id": 302,
      "content_type": "image_post",
      "topic": "generic meme",
      "reach": 250,
      "comments": 1,
      "shares": 2,
      "engagement_rate": 0.024
    }
  ],
  "metrics_quality": "partial | complete",
  "notes": []
}
```

---

## Step 3 — Javier Adds Approval and Cost Context

Responsible agent:

```text
Javier
```

Expected output:

```json
{
  "review_id": "wr-2026-07-07-facebook-001",
  "approval_summary": {
    "approval_requests": 15,
    "approved": 12,
    "needs_changes": 2,
    "rejected": 1,
    "discarded": 0
  },
  "common_luis_feedback": [
    "Make copy more natural.",
    "Avoid robotic phrasing."
  ],
  "cost_summary": {
    "total_cost_usd": 2.14,
    "highest_cost_operation": "image_generation",
    "budget_alerts": []
  },
  "workflow_issues": []
}
```

---

## Step 4 — Bruno Provides Optional Trend Context

Triggered only when needed.

Responsible agent:

```text
Bruno
```

Use Bruno when:

- Metrics suggest a new trend.
- A niche appears weak.
- Competitors are moving faster.
- Magnus asks for external context.
- A strategy shift is being considered.

Expected output:

```json
{
  "review_id": "wr-2026-07-07-facebook-001",
  "trend_context": [
    {
      "trend": "workplace frustration humor",
      "platform": "facebook",
      "relevance": "medium",
      "risk_level": "low",
      "notes": "The format appears safe and broadly relatable."
    }
  ],
  "competitor_patterns": [
    {
      "pattern": "short setup plus exaggerated reaction",
      "reuse_strategy": "Use original situations and wording.",
      "risk_level": "low"
    }
  ],
  "confidence": "medium"
}
```

---

## Step 5 — Magnus Analyzes the Week

Responsible agent:

```text
Magnus
```

Magnus must separate:

- Facts.
- Patterns.
- Hypotheses.
- Recommendations.
- Risks.

Expected output:

```json
{
  "review_id": "wr-2026-07-07-facebook-001",
  "period": {
    "start": "2026-07-01",
    "end": "2026-07-07"
  },
  "summary": "Office-related humor performed better than generic meme content this week.",
  "top_performing_content": [
    {
      "content_post_id": 301,
      "reason": "High shares and comments compared with weekly average."
    }
  ],
  "weak_content": [
    {
      "content_post_id": 302,
      "reason": "Low engagement and weak share rate."
    }
  ],
  "patterns_detected": [
    {
      "pattern": "Workplace frustration hooks generated more comments.",
      "confidence": "medium"
    }
  ],
  "approval_insights": [
    {
      "insight": "Luis repeatedly requested less robotic copy.",
      "confidence": "high"
    }
  ],
  "cost_insights": [
    {
      "insight": "Image generation remained within budget.",
      "confidence": "high"
    }
  ],
  "risks": [],
  "recommended_experiments": [
    {
      "hypothesis": "Short office frustration posts with interactive CTAs will increase comments.",
      "platform": "facebook",
      "niche": "viral_humor",
      "format": "image_post",
      "success_metric": "comments and shares",
      "duration": "7 days",
      "risk_level": "low"
    }
  ],
  "next_week_strategy": "Prioritize office humor and test 4 variations with natural CTAs.",
  "knowledge_updates": [
    {
      "target_file": "knowledge/viral_hooks.md",
      "update_type": "add",
      "status": "experimental",
      "suggested_text": "Office frustration hooks may be strong comment drivers for Facebook humor pages."
    }
  ],
  "confidence": "medium"
}
```

---

# 8. Luis Summary Through Magnus

Magnus sends Luis a concise summary.

Recommended format:

```json
{
  "message_type": "weekly_review_summary",
  "send_to": "Luis",
  "period": "2026-07-01 to 2026-07-07",
  "summary": "Office humor performed best this week. Generic memes were weaker.",
  "what_worked": [
    "Workplace frustration posts drove more comments and shares."
  ],
  "what_failed": [
    "Generic memes had weak engagement."
  ],
  "recommendation": "Next week, test 4 office humor posts with more natural CTAs.",
  "needs_luis_decision": false,
  "optional_luis_feedback": "Luis may confirm if this direction feels aligned."
}
```

Luis approval is not required for every weekly recommendation unless the recommendation changes core strategy, budget, public automation policy, or brand direction.

---

# 9. Operational Task Creation

After Magnus completes the review, Javier creates next-week tasks.

Expected output:

```json
{
  "review_id": "wr-2026-07-07-facebook-001",
  "created_tasks": [
    {
      "target_agent": "Bruno",
      "task": "Find 5 fresh office frustration humor angles.",
      "priority": "medium"
    },
    {
      "target_agent": "Elena",
      "task": "Create 4 Facebook image post drafts using interactive CTAs.",
      "priority": "medium"
    },
    {
      "target_agent": "Damian",
      "task": "Prepare approval packages for approved drafts.",
      "priority": "medium"
    }
  ],
  "status": "OPERATIONAL_TASKS_CREATED"
}
```

---

# 10. Knowledge Update Proposal

If Magnus detects durable or experimental learnings, create Knowledge Base update proposals.

Output format:

```json
{
  "review_id": "wr-2026-07-07-facebook-001",
  "knowledge_update_proposals": [
    {
      "target_file": "knowledge/viral_hooks.md",
      "update_type": "add",
      "confidence": "medium",
      "evidence": [
        "Office humor posts outperformed generic memes in comments and shares during the review period."
      ],
      "suggested_text": "Experimental learning: Office frustration hooks may drive comments on Facebook humor pages. Continue validating."
    }
  ],
  "requires_luis_approval": false
}
```

Knowledge updates that affect core brand voice or strategic direction should require Luis approval through Magnus.

---

# 11. Quality Gates

The weekly review is not complete until:

- Metrics are collected or missing metrics are explained.
- Approval outcomes are included.
- Luis feedback is reviewed.
- Cost summary is included.
- At least one recommendation is produced.
- Confidence levels are assigned.
- Next operational actions are clear.
- Knowledge update suggestions are recorded if relevant.

---

# 12. Failure Handling

If data is incomplete, Magnus must say so.

Example:

```json
{
  "review_status": "partial",
  "missing_data": [
    "72h metrics for 3 posts",
    "Follower growth data"
  ],
  "impact": "Confidence is reduced. Recommendations should be treated as experimental.",
  "next_step": "Damian should attempt metric collection again."
}
```

Do not invent missing data.

---

# 13. Cost Review

Weekly cost review should include:

- Total weekly cost.
- Cost by provider.
- Cost by model.
- Cost by operation type.
- Cost per published content item.
- Any budget threshold events.
- Suggested optimizations.

Example:

```json
{
  "cost_summary": {
    "total_cost_usd": 2.14,
    "cost_per_published_post": 0.18,
    "highest_cost_category": "image_generation",
    "recommendation": "Continue current model mix. No budget action required."
  }
}
```

---

# 14. Final Weekly Review Output

Final output should include:

```json
{
  "review_id": "",
  "period": "",
  "page": "",
  "platform": "",
  "executive_summary": "",
  "top_findings": [],
  "recommendations": [],
  "experiments_for_next_week": [],
  "knowledge_updates": [],
  "risks": [],
  "tasks_for_javier": [],
  "confidence": "low | medium | high"
}
```

---

# 15. Final Rule

The weekly review exists to make the next content cycle smarter.

If the review only reports numbers and does not produce decisions, experiments, or learnings, it is incomplete.
