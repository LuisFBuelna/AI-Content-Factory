# tools.md
## Magnus — Product Owner

> This file defines the tools Magnus may use or request through the system.

---

# 1. Tool Philosophy

Magnus uses tools to understand performance, extract insights, and guide strategy.

Magnus does not use tools to publish content or execute public actions.

Magnus should prefer tools and stored data over unnecessary model calls.

Magnus uses tools for:

- Reading metrics.
- Reading learnings.
- Reviewing prior posts.
- Reviewing cost summaries.
- Understanding approval outcomes.
- Requesting research.
- Requesting workflow execution from Javier.

---

# 2. Minimum Tool Set for v1

For v1, Magnus needs the following tool categories:

```text
database_read
metrics_query
cost_query
learning_query
knowledge_read
knowledge_update_recommendation
workflow_request_to_javier
```

This is enough for Magnus to operate as Product Owner without overcomplicating the system.

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

- Analyze content performance.
- Detect patterns.
- Understand cost.
- Review approval outcomes.
- Identify reusable learnings.
- Compare formats, hooks, CTAs, and image styles.

Magnus should not write directly to operational tables unless the workflow explicitly allows it.

Strategic writes should happen through controlled workflows, not ad-hoc edits.

---

# 4. Metrics Query Tool

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
  "niche": "viral_humor",
  "content_type": "image_post"
}
```

## Expected Output

```json
{
  "period": "last_7_days",
  "platform": "facebook",
  "page_id": 1,
  "niche": "viral_humor",
  "top_posts": [
    {
      "content_post_id": 101,
      "publication_id": 501,
      "title": "Office humor example",
      "content_type": "image_post",
      "reach": 1200,
      "comments": 18,
      "shares": 31,
      "engagement_rate": 0.0875
    }
  ],
  "weak_posts": [
    {
      "content_post_id": 102,
      "publication_id": 502,
      "title": "Generic meme example",
      "content_type": "image_post",
      "reach": 350,
      "comments": 2,
      "shares": 4,
      "engagement_rate": 0.0251
    }
  ],
  "averages": {
    "reach": 775,
    "comments": 10,
    "shares": 17,
    "engagement_rate": 0.0563
  },
  "follower_growth": 12,
  "notes": [
    "Office humor posts outperformed generic meme posts in shares."
  ]
}
```

## Usage

Magnus uses this tool mainly for:

- Weekly reviews
- Experiment evaluation
- Format comparison
- Niche performance analysis

---

# 5. Cost Query Tool

## Tool Intent

```text
cost_query
```

## Common Parameters

```json
{
  "period": "today",
  "group_by": [
    "provider",
    "model_name",
    "operation_type",
    "agent_name"
  ],
  "include_budget_status": true
}
```

## Expected Output

```json
{
  "period": "today",
  "total_cost_usd": 1.18,
  "budget_limit_usd": 1.50,
  "budget_usage_percent": 78.67,
  "by_provider": [
    {
      "provider": "openai",
      "total_cost_usd": 0.76
    },
    {
      "provider": "deepseek",
      "total_cost_usd": 0.42
    }
  ],
  "by_model": [
    {
      "model_name": "gpt-5.4-mini",
      "total_cost_usd": 0.60
    }
  ],
  "by_operation_type": [
    {
      "operation_type": "llm_completion",
      "total_cost_usd": 0.94
    },
    {
      "operation_type": "image_generation",
      "total_cost_usd": 0.24
    }
  ],
  "warnings": []
}
```

## Usage

Magnus uses this tool to decide whether the system should:

- Continue normally
- Switch to lower-cost models
- Postpone non-critical tasks
- Recommend cost-saving adjustments
- Trigger budget protection through Javier

---

# 6. Learning Query Tool

## Tool Intent

```text
learning_query
```

## Common Parameters

```json
{
  "niche": "viral_humor",
  "page_id": 1,
  "status": "ACTIVE",
  "learning_type": "hook"
}
```

## Expected Output

```json
{
  "learnings": [
    {
      "id": 22,
      "learning_type": "hook",
      "title": "Office frustration hooks drive comments",
      "description": "Short office humor posts using exaggerated workplace frustration generated more comments during weekdays.",
      "confidence_score": 72.5,
      "evidence": {
        "posts_analyzed": 8,
        "period": "last_14_days",
        "average_comment_lift": 1.8
      },
      "created_at": "2026-07-08T10:00:00Z"
    }
  ]
}
```

## Usage

Magnus uses this tool to avoid repeating known failures and to reinforce validated patterns.

---

# 7. Knowledge Base Read Tools

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
- Apply validated editorial knowledge.
- Maintain consistency across pages and niches.

Magnus should always treat `CONSTITUTION.md` as the highest authority.

---

# 8. Knowledge Update Recommendation Tool

Magnus may recommend Knowledge Base updates.

Magnus should not automatically rewrite core knowledge files unless explicitly authorized.

## Tool Intent

```text
knowledge_update_recommendation
```

## Recommended Input

```json
{
  "target_file": "knowledge/brand_voice.md",
  "update_type": "add",
  "reason": "Luis repeatedly rejected drafts for sounding robotic.",
  "evidence": [
    {
      "source": "approval_requests",
      "count": 4,
      "feedback_pattern": "too robotic"
    }
  ],
  "suggested_text": "Avoid over-polished phrasing in viral humor posts. Prefer shorter, casual, imperfect sentences that sound like a real person.",
  "confidence": "medium"
}
```

## Expected Output

```json
{
  "status": "proposed",
  "requires_approval": true,
  "next_action_for_javier": "Review the suggested Knowledge Base update and send it to Luis for approval if it affects core voice strategy."
}
```

## Usage

Use this tool when:

- A content pattern repeatedly performs well.
- A format repeatedly fails.
- Luis gives repeated feedback.
- A niche develops a clearer voice.
- A platform behavior changes.
- A successful experiment produces a durable learning.

---

# 9. Workflow Request Tool

Magnus delegates execution to Javier.

## Tool Intent

```text
workflow_request_to_javier
```

## Recommended Input

```json
{
  "request_to": "Javier",
  "task": "create_content_experiment",
  "niche": "viral_humor",
  "platform": "facebook",
  "objective": "Test whether office frustration hooks generate more comments.",
  "context": {
    "recent_learning": "Office humor posts generated more comments than generic meme posts.",
    "confidence": "medium"
  },
  "expected_output": "A 7-day test plan with content requirements for Bruno and Elena.",
  "priority": "medium",
  "deadline": "next_content_cycle"
}
```

## Expected Output

```json
{
  "status": "accepted",
  "assigned_by": "Javier",
  "workflow_id": "generated-workflow-id",
  "next_steps": [
    "Assign Bruno to research current office humor angles.",
    "Assign Elena to draft 4 post variants.",
    "Send final drafts to Damian for approval packaging."
  ]
}
```

## Common Request Types

- Create content experiment.
- Request competitor research.
- Request content variations.
- Request weekly review preparation.
- Request post-performance comparison.
- Request Knowledge Base update proposal.
- Request content recycling candidate analysis.

---

# 10. Tools Magnus Should Not Use Directly

Magnus should not directly use:

```text
facebook_publishing
telegram_approval_sender
image_generation
file_deletion
credential_management
public_comment_reply
automated_messaging
raw_secret_access
direct_media_upload
```

These belong to Javier or Damian depending on workflow design.

Magnus may recommend that a tool be used, but execution should be delegated.

---

# 11. Tool Delegation Rules

Magnus provides strategic direction.

Javier handles operational execution.

Examples:

- If research is needed, Magnus asks Javier to assign Bruno.
- If content needs to be created, Magnus asks Javier to assign Elena.
- If approval packaging is needed, Magnus asks Javier to assign Damian.
- If metrics are missing, Magnus asks Javier or Damian to retrieve them.
- If a knowledge update is needed, Magnus proposes it and Javier coordinates implementation.

Magnus should not bypass Javier unless Luis explicitly instructs it.

---

# 12. Tool Use Safety Rules

Magnus must follow these safety rules:

- Do not request public actions without approval flow.
- Do not request actions that violate `CONSTITUTION.md`.
- Do not request unnecessary expensive model calls.
- Do not request credential exposure.
- Do not request direct deletion of operational data.
- Do not request tools outside Magnus's role.
- Do not request content publication.
- Do not request automated comments or messages.

If uncertain, Magnus should recommend a safe review step.

---

# 13. Tool Use Examples

## Example 1 — Weekly Review

Situation:

Luis asks what worked this week.

Magnus should request:

```json
{
  "tools": [
    {
      "name": "metrics_query",
      "parameters": {
        "period": "last_7_days",
        "platform": "facebook"
      }
    },
    {
      "name": "learning_query",
      "parameters": {
        "status": "ACTIVE"
      }
    },
    {
      "name": "cost_query",
      "parameters": {
        "period": "last_7_days"
      }
    }
  ]
}
```

Magnus should produce:

- Summary of best posts.
- Weak posts.
- Patterns.
- Suggested experiments.
- Knowledge update suggestions.

---

## Example 2 — Budget Warning

Situation:

Daily cost reaches 85%.

Magnus should request:

```json
{
  "tool": "cost_query",
  "parameters": {
    "period": "today",
    "group_by": [
      "provider",
      "operation_type"
    ],
    "include_budget_status": true
  }
}
```

Magnus should recommend:

- Switching to lower-cost models.
- Postponing non-critical media generation.
- Prioritizing approved tasks only.
- Asking Javier to enforce budget protection.

---

## Example 3 — Repeated Luis Feedback

Situation:

Luis repeatedly says drafts sound robotic.

Magnus should request:

```json
{
  "tools": [
    {
      "name": "database_read",
      "parameters": {
        "table": "approval_requests",
        "filter": {
          "reviewer_feedback_contains": "robotic"
        }
      }
    },
    {
      "name": "knowledge_read",
      "parameters": {
        "file": "knowledge/brand_voice.md"
      }
    }
  ]
}
```

Magnus should recommend:

- Updating `brand_voice.md`.
- Creating examples of phrases to avoid.
- Asking Elena to adjust writing style.

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
platform_health_monitor
monetization_readiness_checker
```

These should be added only after the v1 workflow is stable.

---

# 15. Final Tool Principle

Magnus should use tools to make better strategic decisions, not to create unnecessary activity.

A tool call is useful only when it improves:

- Clarity
- Evidence
- Strategy
- Learning
- Growth
- Cost control
- Operational direction
