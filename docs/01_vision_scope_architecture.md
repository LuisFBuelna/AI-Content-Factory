# 01_vision_scope_architecture.md
# AI Content Factory — Vision, Scope, and Architecture

> Document: 01  
> Version: 1.1  
> Owner: Luis — CEO & System Owner  
> Status: Updated for Magnus-centered CEO approval flow

---

# 1. Executive Summary

AI Content Factory is a multi-agent content operation designed to create, approve, publish, measure, and improve social media content.

The system combines:

- OpenClaw for orchestration.
- PostgreSQL for operational state.
- Knowledge Base files for durable organizational knowledge.
- Specialized AI agents.
- Deterministic publishing tools.
- Telegram approval through Magnus.
- Facebook as the first publishing platform.

The system is human-in-the-loop by default.

Luis approves public content through Magnus.

Damian publishes only after approval is routed through Magnus and validated by Javier.

---

# 2. Vision

The vision is to build a repeatable media production system capable of growing multiple social media pages across niches and platforms.

The system should:

- Generate ideas.
- Research trends.
- Create content.
- Prepare media.
- Request approval.
- Publish approved content.
- Collect metrics.
- Learn from performance.
- Improve strategy over time.

The long-term objective is to build valuable digital media assets and prepare for monetization.

---

# 3. Scope v1

## Included

v1 includes:

- Multi-agent workflow.
- Five core agents.
- Facebook content preparation.
- Human approval through Magnus.
- PostgreSQL data model.
- Knowledge Base.
- Basic media asset tracking.
- Publication records.
- Metrics snapshots.
- Cost tracking.
- Workflow logs.
- Weekly performance review.

## Excluded

v1 does not include:

- Fully autonomous publishing.
- Paid ads.
- Client billing.
- SaaS tenant management.
- Advanced dashboards.
- Automated comment replies.
- Automated DMs.
- High-frequency posting.
- Autonomous budget changes.
- Autonomous strategy changes.

---

# 4. Core Agents

## Luis — CEO & System Owner

Luis has final authority.

Luis approves, requests changes, rejects, or discards publication proposals.

Luis normally communicates through Magnus.

## Magnus — Product Owner & CEO Approval Interface

Magnus owns:

- Product strategy.
- Growth analysis.
- Experiment recommendations.
- Weekly reviews.
- Learning interpretation.
- CEO-facing approval communication.

Magnus presents publication proposals to Luis through Telegram and routes Luis's decision back to Javier.

Magnus does not approve content on behalf of Luis.

## Javier — Operations Director

Javier owns:

- Workflow execution.
- Task delegation.
- Quality gates.
- Cost checks.
- Error handling.
- Approval package validation.
- Routing packages to Magnus.
- Routing Luis's decision to the correct agent.

## Bruno — Researcher

Bruno owns:

- Trend research.
- Competitor analysis.
- Topic discovery.
- Source clarity.
- Risk notes.
- Content angles.

## Elena — Creator

Elena owns:

- Copywriting.
- Hooks.
- CTAs.
- Hashtags.
- Captions.
- Reels scripts.
- Image and video prompts.
- Revisions.

## Damian — Publisher

Damian owns:

- Approval package preparation.
- Publication readiness.
- Scheduling after approval.
- Publishing after approval.
- Publication records.
- Metrics collection.

Damian does not contact Luis directly during normal operation.

---

# 5. Updated Approval Architecture

The default human approval flow is:

```text
Agents → Javier → Magnus → Luis
Luis → Magnus → Javier → Agents
```

Publication proposal flow:

```text
Magnus defines strategy
        ↓
Javier creates workflow
        ↓
Bruno researches
        ↓
Elena creates content
        ↓
Damian prepares approval package
        ↓
Javier validates package
        ↓
Magnus presents proposal to Luis via Telegram
        ↓
Luis chooses APPROVE / NEEDS_CHANGES / REJECT / DISCARD
        ↓
Magnus routes decision to Javier
        ↓
Javier routes operational action
        ↓
Damian publishes only if approved
        ↓
Damian collects metrics
        ↓
Magnus analyzes results
```

This design keeps Luis from needing to communicate with every agent.

Magnus becomes the single default CEO interface.

---

# 6. Approval Decision Options

Luis must be presented with:

```text
APPROVE
NEEDS_CHANGES
REJECT
DISCARD
```

Meaning:

- `APPROVE`: Publish or schedule the current content version.
- `NEEDS_CHANGES`: Return for revision.
- `REJECT`: Do not publish; preserve as learning.
- `DISCARD`: Remove from active workflow.

Approval must be explicit.

Silence is not approval.

---

# 7. Approval Validity

A publication approval is valid only if:

```text
approved_by = Luis
approval_routed_by = Magnus
validated_by = Javier
approved_content_version = current_content_version
approval_status = APPROVED
```

If any of these values are missing, stale, or unclear, publication is blocked.

---

# 8. Publication Lifecycle

Updated lifecycle:

```text
IDEA
RESEARCH_REQUESTED
RESEARCH_COMPLETED
CONTENT_DRAFTED
READY_FOR_APPROVAL_PACKAGE
READY_FOR_MAGNUS_REVIEW
WAITING_FOR_LUIS_DECISION
APPROVED / NEEDS_CHANGES / REJECTED / DISCARDED
SCHEDULED
PUBLISHED
METRICS_COLLECTED
ANALYZED
```

These states should be represented in PostgreSQL and enforced by Javier.

---

# 9. Technical Architecture

Core components:

```text
OpenClaw
  ├── Agent orchestration
  ├── Task routing
  └── Tool calls

PostgreSQL
  ├── Content ideas
  ├── Research notes
  ├── Content posts
  ├── Media assets
  ├── Approval requests
  ├── Publications
  ├── Metrics
  ├── Agent runs
  ├── API costs
  └── Learnings

Telegram Bot
  └── Magnus-facing CEO approval interface

Publisher Service
  ├── Facebook Graph API
  ├── Scheduling
  ├── Publication records
  └── Metrics collection

Knowledge Base
  ├── Brand voice
  ├── Platform strategy
  ├── Niche guides
  ├── Hook library
  ├── CTA library
  └── Learning log
```

---

# 10. PostgreSQL Role

PostgreSQL is the operational source of truth.

It stores:

- Workflow states.
- Content drafts.
- Approval requests.
- Approval routing.
- Version numbers.
- Publication records.
- Metrics.
- Costs.
- Agent runs.
- Learnings.

Approval routing fields must support:

```text
prepared_by = Damian
validated_by = Javier
presented_by = Magnus
approved_by = Luis
approval_routed_by = Magnus
approved_content_version
current_content_version
```

---

# 11. Telegram Role

Telegram is the default CEO approval channel.

Magnus uses Telegram to show Luis:

- Page.
- Platform.
- Content type.
- Hook.
- Copy.
- CTA.
- Hashtags.
- Media preview or prompt.
- Scheduled time.
- Strategic reason.
- Risk notes.
- Decision options.

Luis responds to Magnus.

Magnus records and routes the decision.

---

# 12. Publishing Service Role

The publishing service should be deterministic.

It should:

- Read approved publication tasks.
- Validate approval route.
- Validate content version.
- Check platform limits.
- Publish or schedule.
- Record external IDs and URLs.
- Collect metrics.
- Report errors.

It should not decide what to publish.

---

# 13. Data Architecture Overview

Main entities:

- `projects`
- `platforms`
- `social_pages`
- `niches`
- `content_ideas`
- `research_notes`
- `content_posts`
- `media_assets`
- `approval_requests`
- `publications`
- `post_metrics`
- `agent_runs`
- `api_costs`
- `learnings`

Important approval fields:

- `content_posts.content_version`
- `approval_requests.content_version`
- `approval_requests.prepared_by`
- `approval_requests.validated_by`
- `approval_requests.presented_by`
- `approval_requests.decided_by`
- `approval_requests.decision_routed_by`
- `approval_requests.decision`
- `approval_requests.status`
- `approval_requests.feedback`

---

# 14. Knowledge Architecture

Recommended knowledge files:

```text
knowledge/
├── brand_voice.md
├── content_patterns.md
├── facebook_strategy.md
├── viral_hooks.md
├── cta_library.md
├── image_style_guide.md
├── niche_humor.md
├── niche_mindset.md
├── niche_finance.md
└── learning_log.md
```

---

# 15. Agent File Structure

Recommended structure:

```text
agents/
├── magnus/
│   ├── identity.md
│   ├── SOUL.md
│   ├── RULES.md
│   ├── EXAMPLES.md
│   └── tools.md
├── javier/
├── bruno/
├── elena/
└── damian/
```

---

# 16. Root Project Structure

Recommended root:

```text
/opt/ai-content-factory/
├── CONSTITUTION.md
├── FOUNDATION.md
├── README.md
├── docs/
│   ├── 01_vision_scope_architecture.md
│   └── 02_postgresql_data_model.md
├── knowledge/
├── agents/
├── database/
│   ├── schema.sql
│   ├── migrations/
│   └── seeds/
├── workflows/
├── tools/
├── deployment/
└── logs/
```

---

# 17. Metrics Strategy

The system should track:

- Reach.
- Impressions.
- Likes.
- Comments.
- Shares.
- Saves.
- New followers.
- Video views.
- Watch time.
- Retention.
- Engagement rate.
- Approval rate.
- Rejection reasons.
- Cost per content item.

Magnus uses these metrics for strategy.

---

# 18. Cost Strategy

The system should prefer:

1. Existing database data.
2. Cached research.
3. Knowledge Base.
4. Deterministic tools.
5. Local models.
6. Low-cost remote models.
7. Higher-cost remote models when justified.

Budget rules come from `CONSTITUTION.md`.

---

# 19. Key Design Decisions

Key decisions for v1:

- Luis approves public content.
- Magnus is the single default CEO interface.
- Javier coordinates operations.
- Damian does not contact Luis directly.
- PostgreSQL is the operational source of truth.
- Knowledge Base stores durable learnings.
- Public actions require explicit approval.
- Publishing tools are deterministic.
- Metrics drive learning.

---

# 20. Next Documents

Recommended next documents:

```text
workflows/01_content_publication_workflow.md
workflows/02_weekly_review_workflow.md
workflows/03_knowledge_update_workflow.md
docs/03_agent_interaction_protocol.md
docs/04_telegram_approval_interface.md
```
