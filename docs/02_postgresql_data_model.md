# 📘 02_postgresql_data_model.md
## AI Content Factory v1.0 — PostgreSQL Data Model

> **Document Type:** Master Blueprint — Phase 1  
> **Project:** AI Content Factory  
> **Version:** 1.0  
> **Owner:** Luis — CEO & System Owner  
> **Status:** Draft v1  
> **Location:** `/opt/ai-content-factory/docs/02_postgresql_data_model.md`

---

# 1. Purpose

This document defines the initial PostgreSQL data model for AI Content Factory v1.0.

The goal of this database is to provide a clear, reliable, and scalable operational foundation for:

- Managing content pages.
- Storing content ideas.
- Tracking research.
- Saving generated posts.
- Managing human approval.
- Storing publication records.
- Capturing performance metrics.
- Logging agent activity.
- Tracking API/model costs.
- Supporting weekly learning and optimization.

The model is intentionally simple for v1.

It avoids unnecessary complexity while preserving enough structure to support future growth.

---

# 2. Design Principles

The PostgreSQL model follows these principles:

- Keep the schema easy to understand.
- Store operational state in the database.
- Avoid storing large binary files inside PostgreSQL.
- Store image/video URLs or file paths, not raw media.
- Make every publication traceable.
- Make every cost attributable.
- Make every metric measurable.
- Make every agent execution auditable.
- Support multiple pages and niches from the beginning.
- Support future platforms beyond Facebook.
- Avoid over-engineering v1.

---

# 3. Core Data Flow

The database supports the following lifecycle:

```text
Page
  ↓
Niche
  ↓
Content Idea
  ↓
Research
  ↓
Content Draft
  ↓
Approval
  ↓
Publication
  ↓
Metrics
  ↓
Learning
```

---

# 4. Main Entities

The v1 data model contains the following core tables:

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

This is enough for v1 without making the system difficult to maintain.

---

# 5. Entity Relationship Overview

```text
projects
  └── social_pages
        ├── niches
        └── content_ideas
              ├── research_notes
              └── content_posts
                    ├── media_assets
                    ├── approval_requests
                    ├── publications
                    │     └── post_metrics
                    └── agent_runs

agent_runs
  └── api_costs

learnings
  └── social_pages / niches / content_posts
```

---

# 6. Table: projects

Stores high-level business projects.

For v1, there may be only one project: `AI Content Factory`.

```sql
CREATE TABLE projects (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

## Notes

Example:

```text
AI Content Factory
```

This table allows future expansion if the system becomes a service for third parties.

---

# 7. Table: platforms

Stores supported social platforms.

```sql
CREATE TABLE platforms (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(80) NOT NULL UNIQUE,
    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

## Initial records

```sql
INSERT INTO platforms (name) VALUES
('facebook'),
('instagram'),
('tiktok'),
('x');
```

---

# 8. Table: social_pages

Stores the social media pages managed by AI Content Factory.

```sql
CREATE TABLE social_pages (
    id BIGSERIAL PRIMARY KEY,
    project_id BIGINT NOT NULL REFERENCES projects(id),
    platform_id BIGINT NOT NULL REFERENCES platforms(id),

    page_name VARCHAR(150) NOT NULL,
    page_handle VARCHAR(150),
    external_page_id VARCHAR(255),

    default_language VARCHAR(20) NOT NULL DEFAULT 'es-LATAM',
    timezone VARCHAR(80) NOT NULL DEFAULT 'America/Mexico_City',

    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    UNIQUE(platform_id, external_page_id)
);
```

## Notes

This table lets the system manage multiple Facebook pages or future TikTok/Instagram accounts.

No API tokens should be stored here.

Credentials must live in environment variables or a secret store.

---

# 9. Table: niches

Stores the content niche associated with a page.

```sql
CREATE TABLE niches (
    id BIGSERIAL PRIMARY KEY,
    social_page_id BIGINT NOT NULL REFERENCES social_pages(id),

    name VARCHAR(120) NOT NULL,
    description TEXT,
    priority INTEGER NOT NULL DEFAULT 1,

    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

## Example niches

```text
viral_humor
mindset
stoicism
personal_finance
investing
stock_market
```

---

# 10. Table: content_ideas

Stores candidate ideas before they become posts.

```sql
CREATE TABLE content_ideas (
    id BIGSERIAL PRIMARY KEY,

    social_page_id BIGINT NOT NULL REFERENCES social_pages(id),
    niche_id BIGINT REFERENCES niches(id),

    title VARCHAR(255) NOT NULL,
    summary TEXT,
    source_type VARCHAR(50) NOT NULL DEFAULT 'agent',
    source_reference TEXT,

    idea_score NUMERIC(5,2),
    priority INTEGER NOT NULL DEFAULT 1,

    status VARCHAR(40) NOT NULL DEFAULT 'NEW',

    created_by_agent VARCHAR(80),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

## Recommended statuses

```text
NEW
RESEARCH_REQUESTED
RESEARCHED
DRAFTED
DISCARDED
ARCHIVED
```

## Notes

Ideas are not posts yet.

An idea may eventually produce one or more posts.

---

# 11. Table: research_notes

Stores research outputs produced mainly by Bruno.

```sql
CREATE TABLE research_notes (
    id BIGSERIAL PRIMARY KEY,

    content_idea_id BIGINT NOT NULL REFERENCES content_ideas(id),

    agent_name VARCHAR(80) NOT NULL DEFAULT 'Bruno',

    research_summary TEXT NOT NULL,
    key_findings JSONB,
    sources JSONB,
    risks JSONB,

    confidence_score NUMERIC(5,2),

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

## JSONB examples

### key_findings

```json
[
  "Office humor posts with short captions receive high comment rates.",
  "Relatable frustration performs better than generic jokes."
]
```

### sources

```json
[
  {
    "title": "Competitor page example",
    "url": "https://example.com",
    "type": "competitor",
    "observed_at": "2026-07-02T12:00:00Z"
  }
]
```

### risks

```json
[
  {
    "type": "platform_safety",
    "level": "low",
    "description": "No sensitive topic detected."
  }
]
```

---

# 12. Table: content_posts

Stores the actual generated content package.

This is the central table of the content workflow.

```sql
CREATE TABLE content_posts (
    id BIGSERIAL PRIMARY KEY,

    content_idea_id BIGINT REFERENCES content_ideas(id),
    social_page_id BIGINT NOT NULL REFERENCES social_pages(id),
    niche_id BIGINT REFERENCES niches(id),

    platform_content_type VARCHAR(50) NOT NULL,
    title VARCHAR(255),

    post_copy TEXT NOT NULL,
    hook TEXT,
    call_to_action TEXT,
    hashtags JSONB,

    image_prompt TEXT,
    video_prompt TEXT,

    language VARCHAR(20) NOT NULL DEFAULT 'es-LATAM',

    status VARCHAR(50) NOT NULL DEFAULT 'DRAFT',

    created_by_agent VARCHAR(80) DEFAULT 'Elena',
    reviewed_by_agent VARCHAR(80),

    scheduled_at TIMESTAMPTZ,
    approved_at TIMESTAMPTZ,
    published_at TIMESTAMPTZ,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

## Recommended platform_content_type values

```text
image_post
reel
carousel
meme
text_post
story
```

## Recommended statuses

```text
DRAFT
READY_FOR_APPROVAL
NEEDS_CHANGES
APPROVED
REJECTED
DISCARDED
SCHEDULED
PUBLISHED
FAILED
ARCHIVED
```

---

# 13. Table: media_assets

Stores metadata for generated or uploaded media.

Do not store raw images or videos in PostgreSQL.

```sql
CREATE TABLE media_assets (
    id BIGSERIAL PRIMARY KEY,

    content_post_id BIGINT NOT NULL REFERENCES content_posts(id),

    media_type VARCHAR(30) NOT NULL,
    provider VARCHAR(80),
    model_name VARCHAR(120),

    prompt TEXT,
    negative_prompt TEXT,

    storage_url TEXT,
    local_path TEXT,
    external_asset_id TEXT,

    width INTEGER,
    height INTEGER,
    duration_seconds INTEGER,

    status VARCHAR(40) NOT NULL DEFAULT 'GENERATED',

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

## Recommended media_type values

```text
image
video
thumbnail
audio
```

## Recommended status values

```text
GENERATED
APPROVED
REJECTED
USED
FAILED
ARCHIVED
```

---

# 14. Table: approval_requests

Stores approval requests sent to Luis through Telegram.

```sql
CREATE TABLE approval_requests (
    id BIGSERIAL PRIMARY KEY,

    content_post_id BIGINT NOT NULL REFERENCES content_posts(id),

    requested_by_agent VARCHAR(80) NOT NULL DEFAULT 'Damian',

    approval_channel VARCHAR(50) NOT NULL DEFAULT 'telegram',
    external_message_id VARCHAR(255),

    approval_status VARCHAR(50) NOT NULL DEFAULT 'PENDING',

    reviewer_name VARCHAR(120) DEFAULT 'Luis',

    reviewer_feedback TEXT,

    requested_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    responded_at TIMESTAMPTZ
);
```

## Recommended approval_status values

```text
PENDING
APPROVED
NEEDS_CHANGES
REJECTED
DISCARDED
EXPIRED
```

## Notes

This table is important because the system must prove that public content was approved before publishing.

---

# 15. Table: publications

Stores actual publication records after content is posted to a platform.

```sql
CREATE TABLE publications (
    id BIGSERIAL PRIMARY KEY,

    content_post_id BIGINT NOT NULL REFERENCES content_posts(id),
    social_page_id BIGINT NOT NULL REFERENCES social_pages(id),
    platform_id BIGINT NOT NULL REFERENCES platforms(id),

    external_post_id VARCHAR(255),
    external_url TEXT,

    publication_status VARCHAR(50) NOT NULL DEFAULT 'PENDING',

    scheduled_at TIMESTAMPTZ,
    published_at TIMESTAMPTZ,

    error_message TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

## Recommended publication_status values

```text
PENDING
SCHEDULED
PUBLISHED
FAILED
DELETED
ARCHIVED
```

---

# 16. Table: post_metrics

Stores performance metrics for published posts.

Metrics are time-series records.

A single publication may have multiple metric snapshots.

```sql
CREATE TABLE post_metrics (
    id BIGSERIAL PRIMARY KEY,

    publication_id BIGINT NOT NULL REFERENCES publications(id),

    captured_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    reach INTEGER DEFAULT 0,
    impressions INTEGER DEFAULT 0,
    likes INTEGER DEFAULT 0,
    comments INTEGER DEFAULT 0,
    shares INTEGER DEFAULT 0,
    saves INTEGER DEFAULT 0,
    new_followers INTEGER DEFAULT 0,

    video_views INTEGER DEFAULT 0,
    video_watch_time_seconds INTEGER DEFAULT 0,
    video_avg_watch_time_seconds NUMERIC(10,2),
    video_retention_rate NUMERIC(5,2),

    engagement_rate NUMERIC(8,4),

    raw_metrics JSONB
);
```

## Notes

This table allows metric snapshots such as:

```text
1 hour after publication
6 hours after publication
24 hours after publication
7 days after publication
```

This is better than storing only one final metric row.

---

# 17. Table: agent_runs

Stores execution logs for every agent task.

```sql
CREATE TABLE agent_runs (
    id BIGSERIAL PRIMARY KEY,

    workflow_id UUID,
    agent_name VARCHAR(80) NOT NULL,
    task_name VARCHAR(120) NOT NULL,

    related_content_post_id BIGINT REFERENCES content_posts(id),
    related_content_idea_id BIGINT REFERENCES content_ideas(id),

    input_summary TEXT,
    output_summary TEXT,

    status VARCHAR(40) NOT NULL DEFAULT 'STARTED',

    error_message TEXT,

    started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    finished_at TIMESTAMPTZ,

    duration_ms INTEGER
);
```

## Recommended status values

```text
STARTED
COMPLETED
FAILED
SKIPPED
CANCELLED
```

---

# 18. Table: api_costs

Stores model/API usage and estimated costs.

```sql
CREATE TABLE api_costs (
    id BIGSERIAL PRIMARY KEY,

    agent_run_id BIGINT REFERENCES agent_runs(id),

    provider VARCHAR(80) NOT NULL,
    model_name VARCHAR(120),

    operation_type VARCHAR(80) NOT NULL,

    input_tokens INTEGER DEFAULT 0,
    output_tokens INTEGER DEFAULT 0,

    input_cost_usd NUMERIC(12,6) DEFAULT 0,
    output_cost_usd NUMERIC(12,6) DEFAULT 0,
    total_cost_usd NUMERIC(12,6) DEFAULT 0,

    request_id VARCHAR(255),

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

## Recommended operation_type values

```text
llm_completion
image_generation
web_search
web_fetch
embedding
transcription
tts
publication_api
```

---

# 19. Table: learnings

Stores reusable insights discovered by Magnus or the system.

```sql
CREATE TABLE learnings (
    id BIGSERIAL PRIMARY KEY,

    social_page_id BIGINT REFERENCES social_pages(id),
    niche_id BIGINT REFERENCES niches(id),
    content_post_id BIGINT REFERENCES content_posts(id),

    learning_type VARCHAR(80) NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,

    evidence JSONB,

    confidence_score NUMERIC(5,2),
    status VARCHAR(40) NOT NULL DEFAULT 'ACTIVE',

    created_by_agent VARCHAR(80) DEFAULT 'Magnus',

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

## Recommended learning_type values

```text
hook
format
timing
image_style
cta
niche
audience
platform
failure
opportunity
```

## Example learning

```json
{
  "learning_type": "hook",
  "title": "Office frustration hooks drive comments",
  "description": "Short office humor posts using exaggerated workplace frustration generated more comments during weekdays.",
  "confidence_score": 72.5
}
```

---

# 20. Suggested Indexes

Indexes improve query performance without complicating the model.

```sql
CREATE INDEX idx_social_pages_project_id
ON social_pages(project_id);

CREATE INDEX idx_niches_social_page_id
ON niches(social_page_id);

CREATE INDEX idx_content_ideas_page_status
ON content_ideas(social_page_id, status);

CREATE INDEX idx_content_posts_page_status
ON content_posts(social_page_id, status);

CREATE INDEX idx_content_posts_scheduled_at
ON content_posts(scheduled_at);

CREATE INDEX idx_approval_requests_status
ON approval_requests(approval_status);

CREATE INDEX idx_publications_status
ON publications(publication_status);

CREATE INDEX idx_post_metrics_publication_captured
ON post_metrics(publication_id, captured_at);

CREATE INDEX idx_agent_runs_agent_status
ON agent_runs(agent_name, status);

CREATE INDEX idx_api_costs_created_at
ON api_costs(created_at);

CREATE INDEX idx_learnings_niche_status
ON learnings(niche_id, status);
```

---

# 21. Updated At Trigger

Most tables include `updated_at`.

Use this helper function:

```sql
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

Apply to tables that include `updated_at`:

```sql
CREATE TRIGGER trg_projects_updated_at
BEFORE UPDATE ON projects
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_social_pages_updated_at
BEFORE UPDATE ON social_pages
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_niches_updated_at
BEFORE UPDATE ON niches
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_content_ideas_updated_at
BEFORE UPDATE ON content_ideas
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_content_posts_updated_at
BEFORE UPDATE ON content_posts
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_publications_updated_at
BEFORE UPDATE ON publications
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_learnings_updated_at
BEFORE UPDATE ON learnings
FOR EACH ROW EXECUTE FUNCTION set_updated_at();
```

---

# 22. Recommended Views

Views help simplify reporting.

## 22.1 View: publication_performance_summary

```sql
CREATE VIEW publication_performance_summary AS
SELECT
    p.id AS publication_id,
    cp.id AS content_post_id,
    sp.page_name,
    pl.name AS platform,
    cp.platform_content_type,
    cp.title,
    cp.hook,
    cp.call_to_action,
    p.published_at,

    pm.captured_at AS last_metric_at,
    pm.reach,
    pm.impressions,
    pm.likes,
    pm.comments,
    pm.shares,
    pm.saves,
    pm.new_followers,
    pm.video_views,
    pm.video_retention_rate,
    pm.engagement_rate

FROM publications p
JOIN content_posts cp ON cp.id = p.content_post_id
JOIN social_pages sp ON sp.id = p.social_page_id
JOIN platforms pl ON pl.id = p.platform_id
LEFT JOIN LATERAL (
    SELECT *
    FROM post_metrics pm
    WHERE pm.publication_id = p.id
    ORDER BY pm.captured_at DESC
    LIMIT 1
) pm ON TRUE;
```

---

## 22.2 View: daily_api_cost_summary

```sql
CREATE VIEW daily_api_cost_summary AS
SELECT
    DATE(created_at) AS usage_date,
    provider,
    model_name,
    operation_type,
    COUNT(*) AS total_calls,
    SUM(input_tokens) AS total_input_tokens,
    SUM(output_tokens) AS total_output_tokens,
    SUM(total_cost_usd) AS total_cost_usd
FROM api_costs
GROUP BY
    DATE(created_at),
    provider,
    model_name,
    operation_type;
```

---

# 23. Simple Workflow Queries

## 23.1 Get posts ready for approval

```sql
SELECT *
FROM content_posts
WHERE status = 'READY_FOR_APPROVAL'
ORDER BY created_at ASC;
```

---

## 23.2 Get pending approval requests

```sql
SELECT
    ar.id AS approval_request_id,
    cp.id AS content_post_id,
    sp.page_name,
    cp.platform_content_type,
    cp.post_copy,
    cp.hashtags,
    cp.scheduled_at
FROM approval_requests ar
JOIN content_posts cp ON cp.id = ar.content_post_id
JOIN social_pages sp ON sp.id = cp.social_page_id
WHERE ar.approval_status = 'PENDING'
ORDER BY ar.requested_at ASC;
```

---

## 23.3 Get approved posts ready to schedule

```sql
SELECT *
FROM content_posts
WHERE status = 'APPROVED'
AND scheduled_at IS NOT NULL
ORDER BY scheduled_at ASC;
```

---

## 23.4 Get scheduled posts ready to publish

```sql
SELECT *
FROM content_posts
WHERE status = 'SCHEDULED'
AND scheduled_at <= NOW()
ORDER BY scheduled_at ASC;
```

---

## 23.5 Get weekly best-performing posts

```sql
SELECT *
FROM publication_performance_summary
WHERE published_at >= NOW() - INTERVAL '7 days'
ORDER BY shares DESC, comments DESC, reach DESC
LIMIT 10;
```

---

## 23.6 Get weekly cost summary

```sql
SELECT *
FROM daily_api_cost_summary
WHERE usage_date >= CURRENT_DATE - INTERVAL '7 days'
ORDER BY usage_date DESC;
```

---

# 24. Minimal Seed Data

```sql
INSERT INTO projects (name, description)
VALUES (
    'AI Content Factory',
    'Autonomous multi-agent content operation for social media growth.'
);

INSERT INTO platforms (name)
VALUES
('facebook'),
('instagram'),
('tiktok'),
('x')
ON CONFLICT (name) DO NOTHING;
```

---

# 25. Recommended v1 Implementation Order

Implement the database in this order:

```text
1. projects
2. platforms
3. social_pages
4. niches
5. content_ideas
6. research_notes
7. content_posts
8. media_assets
9. approval_requests
10. publications
11. post_metrics
12. agent_runs
13. api_costs
14. learnings
15. indexes
16. views
17. triggers
```

---

# 26. What This Model Supports

This v1 model supports:

- Multiple projects.
- Multiple platforms.
- Multiple social pages.
- Multiple niches.
- Content idea tracking.
- Research storage.
- Draft generation.
- Approval flow.
- Media tracking.
- Publishing records.
- Metrics history.
- Agent execution logs.
- API cost tracking.
- Learning extraction.

---

# 27. What This Model Does Not Yet Support

This v1 model does not fully support:

- Multi-tenant SaaS clients.
- User permissions and roles.
- Billing customers.
- Advanced campaign management.
- Complex A/B testing tables.
- Full media processing pipeline.
- Automated comments or inbox workflows.
- Advanced financial revenue tracking.
- Data warehouse-style analytics.

These may be added in future versions.

---

# 28. Future Extensions

Possible future tables:

```text
campaigns
experiments
experiment_variants
content_templates
audience_segments
revenue_events
platform_accounts
automation_policies
approval_rules
scheduled_jobs
webhook_events
```

These should not be added until the v1 workflow is stable.

---

# 29. Final Recommendation

This database model should be treated as the first stable operational schema for AI Content Factory v1.

It is simple enough to understand and implement quickly, but structured enough to support real growth, traceability, metric analysis, and future automation.

The most important tables for the business objective are:

- `content_posts`
- `approval_requests`
- `publications`
- `post_metrics`
- `api_costs`
- `learnings`

Together, these tables allow AI Content Factory to answer the most important business questions:

- What did we create?
- What did Luis approve?
- What was published?
- How did it perform?
- What did it cost?
- What did we learn?