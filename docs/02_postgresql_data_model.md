# 02_postgresql_data_model.md
# AI Content Factory — PostgreSQL Data Model

> Document: 02  
> Version: 1.1  
> Owner: Luis — CEO & System Owner  
> Status: Updated for Magnus-centered CEO approval flow

---

# 1. Purpose

This document defines the PostgreSQL data model for AI Content Factory.

The database is the operational source of truth for:

- Projects.
- Platforms.
- Social pages.
- Niches.
- Content ideas.
- Research.
- Drafts.
- Media assets.
- Approval requests.
- Approval routing.
- Publications.
- Metrics.
- Agent runs.
- API costs.
- Learnings.

---

# 2. Core Data Flow

Default content flow:

```text
social_pages
  ↓
niches
  ↓
content_ideas
  ↓
research_notes
  ↓
content_posts
  ↓
media_assets
  ↓
approval_requests
  ↓
publications
  ↓
post_metrics
  ↓
learnings
```

Updated approval route:

```text
Damian prepares approval package
        ↓
Javier validates it
        ↓
Magnus presents it to Luis
        ↓
Luis decides through Magnus
        ↓
Javier validates routed decision
        ↓
Damian publishes only if approved
```

---

# 3. Main Tables

The core tables are:

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

---

# 4. Important Approval Concepts

The approval model must support:

- Luis as final decision maker.
- Magnus as CEO Approval Interface.
- Javier as operational validator.
- Damian as approval package preparer and publisher.
- Version-specific approval.
- Decision feedback.
- Traceable publication permission.

Important fields:

```text
approval_requests.prepared_by
approval_requests.validated_by
approval_requests.presented_by
approval_requests.decided_by
approval_requests.decision_routed_by
approval_requests.content_version
approval_requests.decision
approval_requests.status
approval_requests.feedback
approval_requests.decided_at
approval_requests.presented_at
approval_requests.validated_at
```

Publication is valid only if:

```text
approval_status = APPROVED
decided_by = Luis
decision_routed_by = Magnus
validated_by = Javier
approval_requests.content_version = content_posts.content_version
```

---

# 5. Table Purposes

## projects

Stores high-level projects.

Example:

```text
AI Content Factory
```

## platforms

Stores supported platforms.

Examples:

```text
facebook
instagram
tiktok
x
```

## social_pages

Stores managed pages/accounts.

Includes:

- Project.
- Platform.
- Page name.
- External page ID.
- Status.

Does not store raw credentials.

## niches

Stores page-level niche definitions.

Examples:

- Viral humor.
- Mindset.
- Finance.

## content_ideas

Stores ideas before final content exists.

Important statuses:

```text
NEW
RESEARCH_REQUESTED
RESEARCHED
DRAFTED
DISCARDED
ARCHIVED
```

## research_notes

Stores Bruno's research outputs.

Includes:

- Summary.
- Findings.
- Sources.
- Risks.
- Confidence.

## content_posts

Stores content drafts and workflow state.

Important fields:

- Platform content type.
- Language.
- Hook.
- Copy.
- CTA.
- Hashtags.
- Image prompt.
- Video prompt.
- Status.
- Content version.

Updated statuses:

```text
DRAFT
CONTENT_DRAFTED
READY_FOR_APPROVAL_PACKAGE
READY_FOR_MAGNUS_REVIEW
WAITING_FOR_LUIS_DECISION
NEEDS_CHANGES
APPROVED
REJECTED
DISCARDED
SCHEDULED
PUBLISHED
FAILED
ARCHIVED
```

## media_assets

Stores media metadata.

The database stores references, not large binary files.

Important fields:

- Asset type.
- Provider.
- Prompt.
- URL or storage path.
- Status.

## approval_requests

Stores approval packages and decisions.

This table is central to the Magnus approval flow.

It records:

- Damian prepared the package.
- Javier validated the package.
- Magnus presented it to Luis.
- Luis made the decision.
- Magnus routed the decision.
- Which content version was approved or rejected.

Important statuses:

```text
DRAFT
PREPARED
VALIDATED
PRESENTED
PENDING
APPROVED
NEEDS_CHANGES
REJECTED
DISCARDED
EXPIRED
```

Important decisions:

```text
APPROVE
NEEDS_CHANGES
REJECT
DISCARD
```

## publications

Stores platform publication records.

Includes:

- Content post.
- Platform.
- Page.
- Status.
- Scheduled time.
- Published time.
- External post ID.
- External URL.
- Approval request ID.

Publication must reference the approval request used.

## post_metrics

Stores metrics snapshots.

Includes:

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
- Raw metrics JSON.

## agent_runs

Stores agent execution records.

Useful for traceability and debugging.

## api_costs

Stores provider/model/tool cost records.

Useful for cost control.

## learnings

Stores durable insights.

Examples:

- A hook pattern works.
- A CTA fails.
- A time slot underperforms.
- Luis repeatedly rejects robotic tone.
- A niche angle is strong.

---

# 6. Entity Relationship Overview

Simplified relationship:

```text
projects
  └── social_pages
        ├── niches
        ├── content_ideas
        │     └── research_notes
        └── content_posts
              ├── media_assets
              ├── approval_requests
              └── publications
                    └── post_metrics

agent_runs
  └── api_costs

social_pages / niches / content_posts
  └── learnings
```

---

# 7. Approval Request Lifecycle

Approval request lifecycle:

```text
DRAFT
PREPARED
VALIDATED
PRESENTED
PENDING
APPROVED / NEEDS_CHANGES / REJECTED / DISCARDED / EXPIRED
```

Operational meaning:

- `DRAFT`: Package is being assembled.
- `PREPARED`: Damian prepared it.
- `VALIDATED`: Javier validated it.
- `PRESENTED`: Magnus presented it to Luis.
- `PENDING`: Waiting for Luis's decision.
- `APPROVED`: Luis approved the current version.
- `NEEDS_CHANGES`: Luis requested revision.
- `REJECTED`: Luis rejected it.
- `DISCARDED`: Luis discarded it.
- `EXPIRED`: Request is no longer valid.

---

# 8. Content Versioning

`content_posts.content_version` tracks the current version of a draft.

`approval_requests.content_version` stores the version shown to Luis.

If content changes after approval, `content_posts.content_version` should increment.

Publication is blocked when:

```text
approval_requests.content_version != content_posts.content_version
```

This prevents publishing a version Luis did not approve.

---

# 9. Recommended Views

## publication_performance_summary

Summarizes publication and metrics performance.

Used by Magnus.

## daily_api_cost_summary

Summarizes daily costs.

Used by Javier and Magnus.

## approval_flow_summary

Recommended view showing:

- Content post.
- Current content version.
- Approval request.
- Approval status.
- Prepared by.
- Validated by.
- Presented by.
- Decided by.
- Decision routed by.
- Whether approval is valid for publication.

---

# 10. Useful Queries

## Pending Luis Decision

Find items waiting for Luis through Magnus:

```sql
SELECT *
FROM approval_requests
WHERE status IN ('PRESENTED', 'PENDING')
ORDER BY created_at ASC;
```

## Approved and Ready to Publish

Find approved content ready for Damian:

```sql
SELECT cp.*
FROM content_posts cp
JOIN approval_requests ar ON ar.content_post_id = cp.id
WHERE ar.status = 'APPROVED'
  AND ar.decision = 'APPROVE'
  AND ar.decided_by = 'Luis'
  AND ar.decision_routed_by = 'Magnus'
  AND ar.validated_by = 'Javier'
  AND ar.content_version = cp.content_version
  AND cp.status = 'APPROVED';
```

## Invalid Approval Route

Find records that should not publish:

```sql
SELECT *
FROM approval_requests
WHERE status = 'APPROVED'
  AND (
    decided_by IS DISTINCT FROM 'Luis'
    OR decision_routed_by IS DISTINCT FROM 'Magnus'
    OR validated_by IS DISTINCT FROM 'Javier'
  );
```

---

# 11. v1 Limitations

v1 does not include:

- Multi-tenant SaaS support.
- Client billing.
- User roles and permissions.
- Advanced campaign hierarchy.
- Full experiment tables.
- Comment moderation.
- DM automation.
- Revenue data warehouse.

---

# 12. Future Tables

Potential future tables:

```text
campaigns
experiments
content_variants
approval_rules
automation_policies
scheduled_jobs
webhook_events
comments
audience_segments
revenue_events
platform_accounts
```

---

# 13. Final Principle

The database must make the workflow auditable.

If a post is published, the system must be able to answer:

- Who created the content?
- Who prepared the package?
- Who validated it?
- Who presented it to Luis?
- What exactly did Luis approve?
- Who routed the decision?
- What version was approved?
- Who published it?
- When was it published?
- What happened after publication?
