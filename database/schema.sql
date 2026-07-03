-- ============================================================
-- AI Content Factory v1.1
-- PostgreSQL Schema
-- Updated for Magnus-centered CEO approval flow
-- Owner: Luis — CEO & System Owner
-- This schema is intentionally simple, readable, and scalable for v1.
-- ============================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================
-- Helper function: updated_at
-- ============================================================

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- projects
-- ============================================================

CREATE TABLE IF NOT EXISTS projects (
  id BIGSERIAL PRIMARY KEY,
  uuid UUID NOT NULL DEFAULT uuid_generate_v4(),
  name VARCHAR(150) NOT NULL,
  description TEXT,
  status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT chk_projects_status
    CHECK (status IN ('ACTIVE', 'INACTIVE', 'ARCHIVED'))
);

CREATE UNIQUE INDEX IF NOT EXISTS ux_projects_uuid ON projects(uuid);
CREATE INDEX IF NOT EXISTS idx_projects_status ON projects(status);

CREATE TRIGGER trg_projects_updated_at
BEFORE UPDATE ON projects
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

-- ============================================================
-- platforms
-- ============================================================

CREATE TABLE IF NOT EXISTS platforms (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR(80) NOT NULL UNIQUE,
  display_name VARCHAR(120) NOT NULL,
  status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT chk_platforms_status
    CHECK (status IN ('ACTIVE', 'INACTIVE', 'ARCHIVED'))
);

CREATE INDEX IF NOT EXISTS idx_platforms_status ON platforms(status);

-- ============================================================
-- social_pages
-- ============================================================

CREATE TABLE IF NOT EXISTS social_pages (
  id BIGSERIAL PRIMARY KEY,
  project_id BIGINT NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  platform_id BIGINT NOT NULL REFERENCES platforms(id),
  name VARCHAR(150) NOT NULL,
  handle VARCHAR(150),
  external_page_id VARCHAR(255),
  page_url TEXT,
  status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
  metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT chk_social_pages_status
    CHECK (status IN ('ACTIVE', 'INACTIVE', 'ARCHIVED'))
);

CREATE INDEX IF NOT EXISTS idx_social_pages_project_id ON social_pages(project_id);
CREATE INDEX IF NOT EXISTS idx_social_pages_platform_id ON social_pages(platform_id);
CREATE INDEX IF NOT EXISTS idx_social_pages_status ON social_pages(status);

CREATE TRIGGER trg_social_pages_updated_at
BEFORE UPDATE ON social_pages
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

-- ============================================================
-- niches
-- ============================================================

CREATE TABLE IF NOT EXISTS niches (
  id BIGSERIAL PRIMARY KEY,
  social_page_id BIGINT NOT NULL REFERENCES social_pages(id) ON DELETE CASCADE,
  name VARCHAR(120) NOT NULL,
  description TEXT,
  language_code VARCHAR(20) NOT NULL DEFAULT 'es-LATAM',
  status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
  metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT chk_niches_status
    CHECK (status IN ('ACTIVE', 'INACTIVE', 'ARCHIVED'))
);

CREATE INDEX IF NOT EXISTS idx_niches_social_page_id ON niches(social_page_id);
CREATE INDEX IF NOT EXISTS idx_niches_status ON niches(status);

CREATE TRIGGER trg_niches_updated_at
BEFORE UPDATE ON niches
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

-- ============================================================
-- content_ideas
-- ============================================================

CREATE TABLE IF NOT EXISTS content_ideas (
  id BIGSERIAL PRIMARY KEY,
  uuid UUID NOT NULL DEFAULT uuid_generate_v4(),
  social_page_id BIGINT NOT NULL REFERENCES social_pages(id) ON DELETE CASCADE,
  niche_id BIGINT REFERENCES niches(id) ON DELETE SET NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  source_type VARCHAR(80),
  source_url TEXT,
  priority INTEGER NOT NULL DEFAULT 0,
  status VARCHAR(40) NOT NULL DEFAULT 'NEW',
  created_by_agent VARCHAR(80),
  metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT chk_content_ideas_status
    CHECK (status IN ('NEW', 'RESEARCH_REQUESTED', 'RESEARCHED', 'DRAFTED', 'DISCARDED', 'ARCHIVED'))
);

CREATE UNIQUE INDEX IF NOT EXISTS ux_content_ideas_uuid ON content_ideas(uuid);
CREATE INDEX IF NOT EXISTS idx_content_ideas_social_page_id ON content_ideas(social_page_id);
CREATE INDEX IF NOT EXISTS idx_content_ideas_niche_id ON content_ideas(niche_id);
CREATE INDEX IF NOT EXISTS idx_content_ideas_status ON content_ideas(status);

CREATE TRIGGER trg_content_ideas_updated_at
BEFORE UPDATE ON content_ideas
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

-- ============================================================
-- research_notes
-- ============================================================

CREATE TABLE IF NOT EXISTS research_notes (
  id BIGSERIAL PRIMARY KEY,
  content_idea_id BIGINT NOT NULL REFERENCES content_ideas(id) ON DELETE CASCADE,
  agent_name VARCHAR(80) NOT NULL DEFAULT 'Bruno',
  research_summary TEXT NOT NULL,
  key_findings JSONB NOT NULL DEFAULT '[]'::jsonb,
  sources JSONB NOT NULL DEFAULT '[]'::jsonb,
  risks JSONB NOT NULL DEFAULT '[]'::jsonb,
  confidence_score NUMERIC(5,2),
  metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_research_notes_content_idea_id ON research_notes(content_idea_id);
CREATE INDEX IF NOT EXISTS idx_research_notes_agent_name ON research_notes(agent_name);

-- ============================================================
-- content_posts
-- ============================================================

CREATE TABLE IF NOT EXISTS content_posts (
  id BIGSERIAL PRIMARY KEY,
  uuid UUID NOT NULL DEFAULT uuid_generate_v4(),
  content_idea_id BIGINT REFERENCES content_ideas(id) ON DELETE SET NULL,
  social_page_id BIGINT NOT NULL REFERENCES social_pages(id) ON DELETE CASCADE,
  niche_id BIGINT REFERENCES niches(id) ON DELETE SET NULL,

  platform_content_type VARCHAR(60) NOT NULL,
  language_code VARCHAR(20) NOT NULL DEFAULT 'es-LATAM',

  content_version INTEGER NOT NULL DEFAULT 1,

  title VARCHAR(255),
  hook TEXT,
  post_copy TEXT,
  call_to_action TEXT,
  hashtags JSONB NOT NULL DEFAULT '[]'::jsonb,

  image_prompt TEXT,
  video_prompt TEXT,
  script JSONB NOT NULL DEFAULT '{}'::jsonb,

  status VARCHAR(50) NOT NULL DEFAULT 'DRAFT',
  scheduled_time TIMESTAMPTZ,

  created_by_agent VARCHAR(80),
  last_updated_by_agent VARCHAR(80),

  metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT chk_content_posts_platform_content_type
    CHECK (platform_content_type IN ('image_post', 'reel', 'carousel', 'meme', 'text_post', 'story')),

  CONSTRAINT chk_content_posts_status
    CHECK (status IN (
      'DRAFT',
      'CONTENT_DRAFTED',
      'READY_FOR_APPROVAL_PACKAGE',
      'READY_FOR_MAGNUS_REVIEW',
      'WAITING_FOR_LUIS_DECISION',
      'NEEDS_CHANGES',
      'APPROVED',
      'REJECTED',
      'DISCARDED',
      'SCHEDULED',
      'PUBLISHED',
      'FAILED',
      'ARCHIVED'
    )),

  CONSTRAINT chk_content_posts_content_version
    CHECK (content_version >= 1)
);

CREATE UNIQUE INDEX IF NOT EXISTS ux_content_posts_uuid ON content_posts(uuid);
CREATE INDEX IF NOT EXISTS idx_content_posts_content_idea_id ON content_posts(content_idea_id);
CREATE INDEX IF NOT EXISTS idx_content_posts_social_page_id ON content_posts(social_page_id);
CREATE INDEX IF NOT EXISTS idx_content_posts_niche_id ON content_posts(niche_id);
CREATE INDEX IF NOT EXISTS idx_content_posts_status ON content_posts(status);
CREATE INDEX IF NOT EXISTS idx_content_posts_scheduled_time ON content_posts(scheduled_time);
CREATE INDEX IF NOT EXISTS idx_content_posts_content_version ON content_posts(content_version);

CREATE TRIGGER trg_content_posts_updated_at
BEFORE UPDATE ON content_posts
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

-- ============================================================
-- media_assets
-- ============================================================

CREATE TABLE IF NOT EXISTS media_assets (
  id BIGSERIAL PRIMARY KEY,
  uuid UUID NOT NULL DEFAULT uuid_generate_v4(),
  content_post_id BIGINT NOT NULL REFERENCES content_posts(id) ON DELETE CASCADE,
  asset_type VARCHAR(40) NOT NULL,
  provider VARCHAR(80),
  prompt TEXT,
  storage_url TEXT,
  storage_path TEXT,
  mime_type VARCHAR(120),
  width INTEGER,
  height INTEGER,
  duration_seconds NUMERIC(10,2),
  status VARCHAR(40) NOT NULL DEFAULT 'GENERATED',
  metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT chk_media_assets_asset_type
    CHECK (asset_type IN ('image', 'video', 'thumbnail', 'audio')),

  CONSTRAINT chk_media_assets_status
    CHECK (status IN ('GENERATED', 'APPROVED', 'REJECTED', 'USED', 'FAILED', 'ARCHIVED'))
);

CREATE UNIQUE INDEX IF NOT EXISTS ux_media_assets_uuid ON media_assets(uuid);
CREATE INDEX IF NOT EXISTS idx_media_assets_content_post_id ON media_assets(content_post_id);
CREATE INDEX IF NOT EXISTS idx_media_assets_status ON media_assets(status);

-- ============================================================
-- approval_requests
-- ============================================================

CREATE TABLE IF NOT EXISTS approval_requests (
  id BIGSERIAL PRIMARY KEY,
  uuid UUID NOT NULL DEFAULT uuid_generate_v4(),

  content_post_id BIGINT NOT NULL REFERENCES content_posts(id) ON DELETE CASCADE,
  content_version INTEGER NOT NULL,

  status VARCHAR(50) NOT NULL DEFAULT 'DRAFT',
  decision VARCHAR(40),

  -- Approval flow actors
  prepared_by VARCHAR(80) NOT NULL DEFAULT 'Damian',
  validated_by VARCHAR(80),
  presented_by VARCHAR(80),
  decided_by VARCHAR(80),
  decision_routed_by VARCHAR(80),

  -- Timestamps for routing and decision
  prepared_at TIMESTAMPTZ DEFAULT NOW(),
  validated_at TIMESTAMPTZ,
  presented_at TIMESTAMPTZ,
  decided_at TIMESTAMPTZ,
  routed_at TIMESTAMPTZ,

  -- External communication metadata
  approval_channel VARCHAR(80) NOT NULL DEFAULT 'telegram',
  external_message_id VARCHAR(255),

  -- Approval package snapshot shown to Luis
  approval_package JSONB NOT NULL DEFAULT '{}'::jsonb,

  -- Luis feedback or decision notes
  feedback TEXT,

  expires_at TIMESTAMPTZ,

  metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT chk_approval_requests_status
    CHECK (status IN (
      'DRAFT',
      'PREPARED',
      'VALIDATED',
      'PRESENTED',
      'PENDING',
      'APPROVED',
      'NEEDS_CHANGES',
      'REJECTED',
      'DISCARDED',
      'EXPIRED'
    )),

  CONSTRAINT chk_approval_requests_decision
    CHECK (
      decision IS NULL OR decision IN ('APPROVE', 'NEEDS_CHANGES', 'REJECT', 'DISCARD')
    ),

  CONSTRAINT chk_approval_requests_content_version
    CHECK (content_version >= 1)
);

CREATE UNIQUE INDEX IF NOT EXISTS ux_approval_requests_uuid ON approval_requests(uuid);
CREATE INDEX IF NOT EXISTS idx_approval_requests_content_post_id ON approval_requests(content_post_id);
CREATE INDEX IF NOT EXISTS idx_approval_requests_status ON approval_requests(status);
CREATE INDEX IF NOT EXISTS idx_approval_requests_decision ON approval_requests(decision);
CREATE INDEX IF NOT EXISTS idx_approval_requests_decided_by ON approval_requests(decided_by);
CREATE INDEX IF NOT EXISTS idx_approval_requests_decision_routed_by ON approval_requests(decision_routed_by);
CREATE INDEX IF NOT EXISTS idx_approval_requests_content_version ON approval_requests(content_version);

CREATE TRIGGER trg_approval_requests_updated_at
BEFORE UPDATE ON approval_requests
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

-- ============================================================
-- publications
-- ============================================================

CREATE TABLE IF NOT EXISTS publications (
  id BIGSERIAL PRIMARY KEY,
  uuid UUID NOT NULL DEFAULT uuid_generate_v4(),

  content_post_id BIGINT NOT NULL REFERENCES content_posts(id) ON DELETE CASCADE,
  approval_request_id BIGINT REFERENCES approval_requests(id) ON DELETE SET NULL,
  social_page_id BIGINT NOT NULL REFERENCES social_pages(id) ON DELETE CASCADE,
  platform_id BIGINT NOT NULL REFERENCES platforms(id),

  status VARCHAR(40) NOT NULL DEFAULT 'PENDING',

  scheduled_time TIMESTAMPTZ,
  published_at TIMESTAMPTZ,

  external_post_id VARCHAR(255),
  external_post_url TEXT,
  external_schedule_id VARCHAR(255),

  publication_action VARCHAR(40),

  published_by_agent VARCHAR(80) NOT NULL DEFAULT 'Damian',

  metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT chk_publications_status
    CHECK (status IN ('PENDING', 'SCHEDULED', 'PUBLISHED', 'FAILED', 'DELETED', 'ARCHIVED')),

  CONSTRAINT chk_publications_action
    CHECK (publication_action IS NULL OR publication_action IN ('publish_now', 'schedule'))
);

CREATE UNIQUE INDEX IF NOT EXISTS ux_publications_uuid ON publications(uuid);
CREATE INDEX IF NOT EXISTS idx_publications_content_post_id ON publications(content_post_id);
CREATE INDEX IF NOT EXISTS idx_publications_approval_request_id ON publications(approval_request_id);
CREATE INDEX IF NOT EXISTS idx_publications_social_page_id ON publications(social_page_id);
CREATE INDEX IF NOT EXISTS idx_publications_platform_id ON publications(platform_id);
CREATE INDEX IF NOT EXISTS idx_publications_status ON publications(status);
CREATE INDEX IF NOT EXISTS idx_publications_scheduled_time ON publications(scheduled_time);
CREATE INDEX IF NOT EXISTS idx_publications_published_at ON publications(published_at);

CREATE TRIGGER trg_publications_updated_at
BEFORE UPDATE ON publications
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

-- ============================================================
-- post_metrics
-- ============================================================

CREATE TABLE IF NOT EXISTS post_metrics (
  id BIGSERIAL PRIMARY KEY,
  publication_id BIGINT NOT NULL REFERENCES publications(id) ON DELETE CASCADE,

  collected_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  collection_window VARCHAR(40),

  reach INTEGER NOT NULL DEFAULT 0,
  impressions INTEGER NOT NULL DEFAULT 0,
  likes INTEGER NOT NULL DEFAULT 0,
  comments INTEGER NOT NULL DEFAULT 0,
  shares INTEGER NOT NULL DEFAULT 0,
  saves INTEGER NOT NULL DEFAULT 0,
  new_followers INTEGER NOT NULL DEFAULT 0,

  video_views INTEGER NOT NULL DEFAULT 0,
  average_watch_time_seconds NUMERIC(10,2) NOT NULL DEFAULT 0,
  retention_rate NUMERIC(8,4) NOT NULL DEFAULT 0,

  engagement_rate NUMERIC(10,6) NOT NULL DEFAULT 0,

  raw_metrics JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_post_metrics_publication_id ON post_metrics(publication_id);
CREATE INDEX IF NOT EXISTS idx_post_metrics_collected_at ON post_metrics(collected_at);

-- ============================================================
-- agent_runs
-- ============================================================

CREATE TABLE IF NOT EXISTS agent_runs (
  id BIGSERIAL PRIMARY KEY,
  uuid UUID NOT NULL DEFAULT uuid_generate_v4(),

  agent_name VARCHAR(80) NOT NULL,
  task_name VARCHAR(150),
  workflow_id VARCHAR(255),

  content_idea_id BIGINT REFERENCES content_ideas(id) ON DELETE SET NULL,
  content_post_id BIGINT REFERENCES content_posts(id) ON DELETE SET NULL,

  status VARCHAR(40) NOT NULL DEFAULT 'STARTED',
  input_summary TEXT,
  output_summary TEXT,
  error_message TEXT,

  started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  completed_at TIMESTAMPTZ,

  metadata JSONB NOT NULL DEFAULT '{}'::jsonb,

  CONSTRAINT chk_agent_runs_status
    CHECK (status IN ('STARTED', 'COMPLETED', 'FAILED', 'SKIPPED', 'CANCELLED'))
);

CREATE UNIQUE INDEX IF NOT EXISTS ux_agent_runs_uuid ON agent_runs(uuid);
CREATE INDEX IF NOT EXISTS idx_agent_runs_agent_name ON agent_runs(agent_name);
CREATE INDEX IF NOT EXISTS idx_agent_runs_status ON agent_runs(status);
CREATE INDEX IF NOT EXISTS idx_agent_runs_workflow_id ON agent_runs(workflow_id);
CREATE INDEX IF NOT EXISTS idx_agent_runs_content_post_id ON agent_runs(content_post_id);

-- ============================================================
-- api_costs
-- ============================================================

CREATE TABLE IF NOT EXISTS api_costs (
  id BIGSERIAL PRIMARY KEY,

  agent_run_id BIGINT REFERENCES agent_runs(id) ON DELETE SET NULL,

  provider VARCHAR(80) NOT NULL,
  model_name VARCHAR(150),
  operation_type VARCHAR(80) NOT NULL,

  input_tokens INTEGER NOT NULL DEFAULT 0,
  output_tokens INTEGER NOT NULL DEFAULT 0,
  total_tokens INTEGER NOT NULL DEFAULT 0,

  unit_count NUMERIC(14,4) NOT NULL DEFAULT 0,
  cost_usd NUMERIC(14,6) NOT NULL DEFAULT 0,

  metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_api_costs_agent_run_id ON api_costs(agent_run_id);
CREATE INDEX IF NOT EXISTS idx_api_costs_provider ON api_costs(provider);
CREATE INDEX IF NOT EXISTS idx_api_costs_model_name ON api_costs(model_name);
CREATE INDEX IF NOT EXISTS idx_api_costs_created_at ON api_costs(created_at);

-- ============================================================
-- learnings
-- ============================================================

CREATE TABLE IF NOT EXISTS learnings (
  id BIGSERIAL PRIMARY KEY,
  uuid UUID NOT NULL DEFAULT uuid_generate_v4(),

  social_page_id BIGINT REFERENCES social_pages(id) ON DELETE CASCADE,
  niche_id BIGINT REFERENCES niches(id) ON DELETE SET NULL,
  content_post_id BIGINT REFERENCES content_posts(id) ON DELETE SET NULL,

  learning_type VARCHAR(80) NOT NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,

  evidence JSONB NOT NULL DEFAULT '{}'::jsonb,
  confidence_score NUMERIC(5,2),

  proposed_by_agent VARCHAR(80),
  approved_by VARCHAR(80),

  status VARCHAR(40) NOT NULL DEFAULT 'ACTIVE',

  metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT chk_learnings_status
    CHECK (status IN ('ACTIVE', 'ARCHIVED', 'REJECTED'))
);

CREATE UNIQUE INDEX IF NOT EXISTS ux_learnings_uuid ON learnings(uuid);
CREATE INDEX IF NOT EXISTS idx_learnings_social_page_id ON learnings(social_page_id);
CREATE INDEX IF NOT EXISTS idx_learnings_niche_id ON learnings(niche_id);
CREATE INDEX IF NOT EXISTS idx_learnings_type ON learnings(learning_type);
CREATE INDEX IF NOT EXISTS idx_learnings_status ON learnings(status);

CREATE TRIGGER trg_learnings_updated_at
BEFORE UPDATE ON learnings
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

-- ============================================================
-- Views
-- ============================================================

CREATE OR REPLACE VIEW publication_performance_summary AS
SELECT
  p.id AS publication_id,
  p.content_post_id,
  p.social_page_id,
  p.platform_id,
  p.status AS publication_status,
  p.scheduled_time,
  p.published_at,
  p.external_post_id,
  p.external_post_url,
  cp.title,
  cp.platform_content_type,
  cp.content_version,
  cp.status AS content_status,
  sp.name AS social_page_name,
  pl.name AS platform_name,
  pm.collected_at AS latest_metrics_collected_at,
  pm.reach,
  pm.impressions,
  pm.likes,
  pm.comments,
  pm.shares,
  pm.saves,
  pm.new_followers,
  pm.video_views,
  pm.average_watch_time_seconds,
  pm.retention_rate,
  pm.engagement_rate
FROM publications p
JOIN content_posts cp ON cp.id = p.content_post_id
JOIN social_pages sp ON sp.id = p.social_page_id
JOIN platforms pl ON pl.id = p.platform_id
LEFT JOIN LATERAL (
  SELECT *
  FROM post_metrics pm2
  WHERE pm2.publication_id = p.id
  ORDER BY pm2.collected_at DESC
  LIMIT 1
) pm ON true;

CREATE OR REPLACE VIEW daily_api_cost_summary AS
SELECT
  DATE(created_at) AS cost_date,
  provider,
  model_name,
  operation_type,
  SUM(input_tokens) AS input_tokens,
  SUM(output_tokens) AS output_tokens,
  SUM(total_tokens) AS total_tokens,
  SUM(unit_count) AS unit_count,
  SUM(cost_usd) AS cost_usd
FROM api_costs
GROUP BY DATE(created_at), provider, model_name, operation_type
ORDER BY cost_date DESC;

CREATE OR REPLACE VIEW approval_flow_summary AS
SELECT
  ar.id AS approval_request_id,
  ar.content_post_id,
  cp.content_version AS current_content_version,
  ar.content_version AS approval_content_version,
  ar.status AS approval_status,
  ar.decision,
  ar.prepared_by,
  ar.validated_by,
  ar.presented_by,
  ar.decided_by,
  ar.decision_routed_by,
  ar.prepared_at,
  ar.validated_at,
  ar.presented_at,
  ar.decided_at,
  ar.routed_at,
  ar.feedback,
  CASE
    WHEN ar.status = 'APPROVED'
      AND ar.decision = 'APPROVE'
      AND ar.decided_by = 'Luis'
      AND ar.decision_routed_by = 'Magnus'
      AND ar.validated_by = 'Javier'
      AND ar.content_version = cp.content_version
    THEN true
    ELSE false
  END AS valid_for_publication
FROM approval_requests ar
JOIN content_posts cp ON cp.id = ar.content_post_id;

-- ============================================================
-- Seed data
-- ============================================================

INSERT INTO platforms (name, display_name)
VALUES
  ('facebook', 'Facebook'),
  ('instagram', 'Instagram'),
  ('tiktok', 'TikTok'),
  ('x', 'X')
ON CONFLICT (name) DO NOTHING;

INSERT INTO projects (name, description)
SELECT
  'AI Content Factory',
  'Multi-agent content factory for social media content creation, approval, publishing, metrics, and learning.'
WHERE NOT EXISTS (
  SELECT 1 FROM projects WHERE name = 'AI Content Factory'
);

-- ============================================================
-- End of schema
-- ============================================================
