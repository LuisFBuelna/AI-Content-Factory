# AI Content Factory

> Multi-agent content operation for creating, approving, publishing, measuring, and improving social media content.

---

# 1. Overview

AI Content Factory is a human-approved AI content system designed to grow social media pages as digital media assets.

The system uses specialized agents, PostgreSQL, workflows, tools, and Telegram approval to produce content safely and repeatedly.

Initial focus:

```text
Platform: Facebook
Language: Neutral Latin American Spanish
Initial niche: Viral humor
Approval interface: Magnus via Telegram
Final authority: Luis
```

---

# 2. Core Operating Rule

Public content requires explicit approval from Luis.

The default approval flow is:

```text
Agents → Javier → Magnus → Luis
Luis → Magnus → Javier → Agents
```

This means:

- Damian prepares publication packages.
- Javier validates them.
- Magnus shows them to Luis.
- Luis approves, requests changes, rejects, or discards.
- Magnus routes Luis's decision back to Javier.
- Damian publishes only after valid approval.

Valid publication approval requires:

```text
approved_by = Luis
approval_routed_by = Magnus
validated_by = Javier
approval_status = APPROVED
approval_request.content_version = content_post.content_version
```

---

# 3. Agent Roles

## Luis — CEO & System Owner

Final decision maker and system owner.

## Magnus — Product Owner & CEO Approval Interface

Owns strategy, growth analysis, weekly reviews, learning interpretation, and Telegram communication with Luis.

## Javier — Operations Director

Owns workflow coordination, task routing, quality gates, cost checks, and operational control.

## Bruno — Researcher

Owns research, trends, competitor analysis, sources, risks, and content angles.

## Elena — Creator

Owns copy, hooks, CTAs, captions, hashtags, scripts, image prompts, and revisions.

## Damian — Publisher

Owns approval package preparation, publishing after approval, publication records, and metrics collection.

---

# 4. Project Structure

Recommended production path:

```text
/opt/ai-content-factory/
├── CONSTITUTION.md
├── FOUNDATION.md
├── README.md
├── docs/
│   ├── 01_vision_scope_architecture.md
│   ├── 02_postgresql_data_model.md
│   └── 03_tools_and_service_contracts.md
├── knowledge/
│   └── brand_voice.md
├── agents/
│   ├── magnus/
│   ├── javier/
│   ├── bruno/
│   ├── elena/
│   └── damian/
├── workflows/
│   ├── 01_content_publication_workflow.md
│   ├── 02_weekly_review_workflow.md
│   └── 03_knowledge_update_workflow.md
├── database/
│   ├── schema.sql
│   ├── migrations/
│   └── seeds/
├── deployment/
│   └── docker-compose.yml
├── storage/
├── logs/
└── backups/
```

---

# 5. Key Documents

## Governance

```text
CONSTITUTION.md
FOUNDATION.md
```

## Architecture

```text
docs/01_vision_scope_architecture.md
docs/02_postgresql_data_model.md
docs/03_tools_and_service_contracts.md
```

## Workflows

```text
workflows/01_content_publication_workflow.md
workflows/02_weekly_review_workflow.md
workflows/03_knowledge_update_workflow.md
```

## Agent Profiles

Each agent has:

```text
identity.md
SOUL.md
RULES.md
EXAMPLES.md
tools.md
```

---

# 6. Environment

Production environment file:

```text
.env.production
```

This file must not be committed.

Recommended `.gitignore` entries:

```gitignore
.env
.env.local
.env.production
.env.prod
.env.*.local

!.env.example
!.env.template
```

---

# 7. Running with Docker Compose

From the project root:

```bash
docker compose --env-file .env.production -f deployment/docker-compose.yml up -d
```

To stop:

```bash
docker compose -f deployment/docker-compose.yml down
```

To view logs:

```bash
docker compose -f deployment/docker-compose.yml logs -f
```

---

# 8. Services

The initial Docker Compose stack defines:

```text
postgres          → Main PostgreSQL database
adminer           → Simple database UI
publisher-service → Future publishing and metrics service
openclaw          → Future agent orchestration service
```

`publisher-service` and `openclaw` currently use placeholder images until their implementations are created.

---

# 9. Database

Schema file:

```text
database/schema.sql
```

PostgreSQL is the operational source of truth for:

- Content ideas.
- Research notes.
- Content drafts.
- Media assets.
- Approval requests.
- Publication records.
- Metrics snapshots.
- Agent runs.
- API costs.
- Learnings.

---

# 10. Metrics

Default metrics collection windows:

```text
24h after publication  → early signal
72h after publication  → reliable short-term signal
7d after publication   → weekly review and learning signal
```

Responsibilities:

```text
Damian → collects and writes metrics into post_metrics
Javier → validates completeness and coordinates retries
Magnus → analyzes metrics and presents insights to Luis
```

---

# 11. Current Platform Rules

Default Facebook limits:

```text
Maximum 2 image posts per page per 24 hours
Maximum 1 Reel per page per 24 hours
Use timing variation
Avoid repetitive content patterns
```

These limits are defined in `CONSTITUTION.md` and may be changed by Luis.

---

# 12. Security Rules

Never commit:

- `.env.production`
- API keys
- OAuth tokens
- Passwords
- Facebook access tokens
- Telegram bot tokens
- Private credentials

Agents may reference secret names, but must not expose secret values.

---

# 13. Suggested Commit Convention

Examples:

```bash
git commit -m "docs: add core operational workflows"
git commit -m "docs: add tools and service contracts"
git commit -m "chore: add deployment docker compose"
git commit -m "docs: update approval flow through Magnus"
```

---

# 14. MVP Implementation Order

Recommended next implementation order:

```text
1. PostgreSQL deployment
2. Database migrations
3. Publisher service skeleton
4. Telegram approval service
5. Approval request flow
6. Facebook publish integration
7. Metrics collector
8. OpenClaw tool bindings
9. First end-to-end dry run
10. First approved Facebook post
```

---

# 15. Final Principle

AI Content Factory is not a random content generator.

It is a controlled operating system for building social media assets through strategy, approval, publication, measurement, and learning.
