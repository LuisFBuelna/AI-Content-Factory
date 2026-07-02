-- ============================================================
-- AI Content Factory v1.0
-- PostgreSQL Schema
-- File: /opt/ai-content-factory/database/schema.sql
-- Owner: Luis — CEO & System Owner
-- ============================================================

-- Recommended PostgreSQL version: 14+
-- This schema is intentionally simple, readable, and scalable for v1.

-- ============================================================
-- 1. EXTENSIONS
-- ============================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================
-- 2. HELPER FUNCTIONS
-- ============================================================

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- 3. CORE TABLES
-- ============================================================

CREATE TABLE IF NOT EXISTS projects (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS platforms (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(80) NOT NULL UNIQUE,
    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS social_pages (
    id BIGSERIAL PRIMARY KEY,
    project_id BIGINT NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
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

CREATE TABLE IF NOT EXISTS niches (
    id BIGSERIAL PRIMARY KEY,
    social_page_id BIGINT NOT NULL REFERENCES social_pages(id) ON DELETE CASCADE,

    name VARCHAR(120) NOT NULL,
    description TEXT,
    priority INTEGER NOT NULL DEFAULT 1,

    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================
-- 4. CONTENT PIPELINE TABLES
-- ============================================================

CREATE TABLE IF NOT EXISTS content_ideas (
    id BIGSERIAL PRIMARY KEY,

    social_page_id BIGINT NOT NULL REFERENCES social_pages(id) ON DELETE CASCADE,
    niche_id BIGINT REFERENCES niches(id) ON DELETE SET NULL,

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

CREATE TABLE IF NOT EXISTS research_notes (
    id BIGSERIAL PRIMARY KEY,

    content_idea_id BIGINT NOT NULL REFERENCES content_ideas(id) ON DELETE CASCADE,

    agent_name VARCHAR(80) NOT NULL DEFAULT 'Bruno',

    research_summary TEXT NOT NULL,
    key_findings JSONB,
    sources JSONB,
    risks JSONB,

    confidence_score NUMERIC(5,2),

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS content_posts (
    id BIGSERIAL PRIMARY KEY,

    content_idea_id BIGINT REFERENCES content_ideas(id) ON DELETE SET NULL,
    social_page_id BIGINT NOT NULL REFERENCES social_pages(id) ON DELETE CASCADE,
    niche_id BIGINT REFERENCES niches(id) ON DELETE SET NULL,

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

CREATE TABLE IF NOT EXISTS media_assets (
    id BIGSERIAL PRIMARY KEY,

    content_post_id BIGINT NOT NULL REFERENCES content_posts(id) ON DELETE CASCADE,

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

-- ============================================================
-- 5. APPROVAL AND PUBLICATION TABLES
-- ============================================================

CREATE TABLE IF NOT EXISTS approval_requests (
    id BIGSERIAL PRIMARY KEY,

    content_post_id BIGINT NOT NULL REFERENCES content_posts(id) ON DELETE CASCADE,

    requested_by_agent VARCHAR(80) NOT NULL DEFAULT 'Damian',

    approval_channel VARCHAR(50) NOT NULL DEFAULT 'telegram',
    external_message_id VARCHAR(255),

    approval_status VARCHAR(50) NOT NULL DEFAULT 'PENDING',

    reviewer_name VARCHAR(120) DEFAULT 'Luis',
    reviewer_feedback TEXT,

    requested_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    responded_at TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS publications (
    id BIGSERIAL PRIMARY KEY,

    content_post_id BIGINT NOT NULL REFERENCES content_posts(id) ON DELETE CASCADE,
    social_page_id BIGINT NOT NULL REFERENCES social_pages(id) ON DELETE CASCADE,
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

CREATE TABLE IF NOT EXISTS post_metrics (
    id BIGSERIAL PRIMARY KEY,

    publication_id BIGINT NOT NULL REFERENCES publications(id) ON DELETE CASCADE,

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

-- ============================================================
-- 6. OBSERVABILITY AND COST TABLES
-- ============================================================

CREATE TABLE IF NOT EXISTS agent_runs (
    id BIGSERIAL PRIMARY KEY,

    workflow_id UUID,
    agent_name VARCHAR(80) NOT NULL,
    task_name VARCHAR(120) NOT NULL,

    related_content_post_id BIGINT REFERENCES content_posts(id) ON DELETE SET NULL,
    related_content_idea_id BIGINT REFERENCES content_ideas(id) ON DELETE SET NULL,

    input_summary TEXT,
    output_summary TEXT,

    status VARCHAR(40) NOT NULL DEFAULT 'STARTED',

    error_message TEXT,

    started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    finished_at TIMESTAMPTZ,

    duration_ms INTEGER
);

CREATE TABLE IF NOT EXISTS api_costs (
    id BIGSERIAL PRIMARY KEY,

    agent_run_id BIGINT REFERENCES agent_runs(id) ON DELETE SET NULL,

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

-- ============================================================
-- 7. LEARNING TABLE
-- ============================================================

CREATE TABLE IF NOT EXISTS learnings (
    id BIGSERIAL PRIMARY KEY,

    social_page_id BIGINT REFERENCES social_pages(id) ON DELETE CASCADE,
    niche_id BIGINT REFERENCES niches(id) ON DELETE SET NULL,
    content_post_id BIGINT REFERENCES content_posts(id) ON DELETE SET NULL,

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

-- ============================================================
-- 8. BASIC CHECK CONSTRAINTS
-- ============================================================

ALTER TABLE projects
ADD CONSTRAINT chk_projects_status
CHECK (status IN ('ACTIVE', 'INACTIVE', 'ARCHIVED'));

ALTER TABLE platforms
ADD CONSTRAINT chk_platforms_status
CHECK (status IN ('ACTIVE', 'INACTIVE', 'ARCHIVED'));

ALTER TABLE social_pages
ADD CONSTRAINT chk_social_pages_status
CHECK (status IN ('ACTIVE', 'INACTIVE', 'ARCHIVED'));

ALTER TABLE niches
ADD CONSTRAINT chk_niches_status
CHECK (status IN ('ACTIVE', 'INACTIVE', 'ARCHIVED'));

ALTER TABLE content_ideas
ADD CONSTRAINT chk_content_ideas_status
CHECK (status IN (
    'NEW',
    'RESEARCH_REQUESTED',
    'RESEARCHED',
    'DRAFTED',
    'DISCARDED',
    'ARCHIVED'
));

ALTER TABLE content_posts
ADD CONSTRAINT chk_content_posts_type
CHECK (platform_content_type IN (
    'image_post',
    'reel',
    'carousel',
    'meme',
    'text_post',
    'story'
));

ALTER TABLE content_posts
ADD CONSTRAINT chk_content_posts_status
CHECK (status IN (
    'DRAFT',
    'READY_FOR_APPROVAL',
    'NEEDS_CHANGES',
    'APPROVED',
    'REJECTED',
    'DISCARDED',
    'SCHEDULED',
    'PUBLISHED',
    'FAILED',
    'ARCHIVED'
));

ALTER TABLE media_assets
ADD CONSTRAINT chk_media_assets_type
CHECK (media_type IN (
    'image',
    'video',
    'thumbnail',
    'audio'
));

ALTER TABLE media_assets
ADD CONSTRAINT chk_media_assets_status
CHECK (status IN (
    'GENERATED',
    'APPROVED',
    'REJECTED',
    'USED',
    'FAILED',
    'ARCHIVED'
));

ALTER TABLE approval_requests
ADD CONSTRAINT chk_approval_requests_status
CHECK (approval_status IN (
    'PENDING',
    'APPROVED',
    'NEEDS_CHANGES',
    'REJECTED',
    'DISCARDED',
    'EXPIRED'
));

ALTER TABLE publications
ADD CONSTRAINT chk_publications_status
CHECK (publication_status IN (
    'PENDING',
    'SCHEDULED',
    'PUBLISHED',
    'FAILED',
    'DELETED',
    'ARCHIVED'
));

ALTER TABLE agent_runs
ADD CONSTRAINT chk_agent_runs_status
CHECK (status IN (
    'STARTED',
    'COMPLETED',
    'FAILED',
    'SKIPPED',
    'CANCELLED'
));

ALTER TABLE learnings
ADD CONSTRAINT chk_learnings_status
CHECK (status IN (
    'ACTIVE',
    'ARCHIVED',
    'REJECTED'
));

-- ============================================================
-- 9. INDEXES
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_social_pages_project_id
ON social_pages(project_id);

CREATE INDEX IF NOT EXISTS idx_social_pages_platform_id
ON social_pages(platform_id);

CREATE INDEX IF NOT EXISTS idx_niches_social_page_id
ON niches(social_page_id);

CREATE INDEX IF NOT EXISTS idx_content_ideas_page_status
ON content_ideas(social_page_id, status);

CREATE INDEX IF NOT EXISTS idx_content_ideas_niche_id
ON content_ideas(niche_id);

CREATE INDEX IF NOT EXISTS idx_research_notes_content_idea_id
ON research_notes(content_idea_id);

CREATE INDEX IF NOT EXISTS idx_content_posts_page_status
ON content_posts(social_page_id, status);

CREATE INDEX IF NOT EXISTS idx_content_posts_niche_id
ON content_posts(niche_id);

CREATE INDEX IF NOT EXISTS idx_content_posts_scheduled_at
ON content_posts(scheduled_at);

CREATE INDEX IF NOT EXISTS idx_media_assets_content_post_id
ON media_assets(content_post_id);

CREATE INDEX IF NOT EXISTS idx_approval_requests_status
ON approval_requests(approval_status);

CREATE INDEX IF NOT EXISTS idx_approval_requests_content_post_id
ON approval_requests(content_post_id);

CREATE INDEX IF NOT EXISTS idx_publications_status
ON publications(publication_status);

CREATE INDEX IF NOT EXISTS idx_publications_content_post_id
ON publications(content_post_id);

CREATE INDEX IF NOT EXISTS idx_post_metrics_publication_captured
ON post_metrics(publication_id, captured_at);

CREATE INDEX IF NOT EXISTS idx_agent_runs_agent_status
ON agent_runs(agent_name, status);

CREATE INDEX IF NOT EXISTS idx_agent_runs_workflow_id
ON agent_runs(workflow_id);

CREATE INDEX IF NOT EXISTS idx_api_costs_created_at
ON api_costs(created_at);

CREATE INDEX IF NOT EXISTS idx_api_costs_provider_model
ON api_costs(provider, model_name);

CREATE INDEX IF NOT EXISTS idx_learnings_niche_status
ON learnings(niche_id, status);

CREATE INDEX IF NOT EXISTS idx_learnings_page_status
ON learnings(social_page_id, status);

-- ============================================================
-- 10. UPDATED_AT TRIGGERS
-- ============================================================

DROP TRIGGER IF EXISTS trg_projects_updated_at ON projects;
CREATE TRIGGER trg_projects_updated_at
BEFORE UPDATE ON projects
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

DROP TRIGGER IF EXISTS trg_social_pages_updated_at ON social_pages;
CREATE TRIGGER trg_social_pages_updated_at
BEFORE UPDATE ON social_pages
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

DROP TRIGGER IF EXISTS trg_niches_updated_at ON niches;
CREATE TRIGGER trg_niches_updated_at
BEFORE UPDATE ON niches
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

DROP TRIGGER IF EXISTS trg_content_ideas_updated_at ON content_ideas;
CREATE TRIGGER trg_content_ideas_updated_at
BEFORE UPDATE ON content_ideas
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

DROP TRIGGER IF EXISTS trg_content_posts_updated_at ON content_posts;
CREATE TRIGGER trg_content_posts_updated_at
BEFORE UPDATE ON content_posts
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

DROP TRIGGER IF EXISTS trg_publications_updated_at ON publications;
CREATE TRIGGER trg_publications_updated_at
BEFORE UPDATE ON publications
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

DROP TRIGGER IF EXISTS trg_learnings_updated_at ON learnings;
CREATE TRIGGER trg_learnings_updated_at
BEFORE UPDATE ON learnings
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- ============================================================
-- 11. VIEWS
-- ============================================================

CREATE OR REPLACE VIEW publication_performance_summary AS
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

CREATE OR REPLACE VIEW daily_api_cost_summary AS
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

-- ============================================================
-- 12. SEED DATA
-- ============================================================

INSERT INTO projects (name, description)
VALUES (
    'AI Content Factory',
    'Autonomous multi-agent content operation for social media growth.'
)
ON CONFLICT DO NOTHING;

INSERT INTO platforms (name)
VALUES
('facebook'),
('instagram'),
('tiktok'),
('x')
ON CONFLICT (name) DO NOTHING;

-- ============================================================
-- 13. OPTIONAL SAMPLE DATA
-- ============================================================
-- Uncomment and adjust when you create your first real page.
--
-- INSERT INTO social_pages (
--     project_id,
--     platform_id,
--     page_name,
--     page_handle,
--     external_page_id
-- )
-- SELECT
--     p.id,
--     pl.id,
--     'My Viral Humor Page',
--     '@myviralhumorpage',
--     NULL
-- FROM projects p
-- JOIN platforms pl ON pl.name = 'facebook'
-- WHERE p.name = 'AI Content Factory';
--
-- INSERT INTO niches (
--     social_page_id,
--     name,
--     description,
--     priority
-- )
-- SELECT
--     sp.id,
--     'viral_humor',
--     'Relatable viral humor for Mexico and Latin America.',
--     1
-- FROM social_pages sp
-- WHERE sp.page_name = 'My Viral Humor Page';

-- ============================================================
-- END OF SCHEMA
-- ============================================================