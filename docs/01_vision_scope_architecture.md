# 📘 01_vision_scope_architecture.md
## AI Content Factory v1.0 — Vision, Scope & General Architecture

> **Document Type:** Master Blueprint — Phase 0  
> **Project:** AI Content Factory  
> **Version:** 1.0  
> **Owner:** Luis — CEO & System Owner  
> **Status:** Draft v1  
> **Location:** `/opt/ai-content-factory/docs/01_vision_scope_architecture.md`

---

# 1. Executive Summary

AI Content Factory is an autonomous multi-agent content operation designed to research, create, prepare, approve, publish, and improve social media content across multiple platforms.

The system is built around OpenClaw as the agent orchestration layer, supported by a centralized database, a shared Knowledge Base, external APIs, deterministic tools, and human approval through Telegram.

AI Content Factory is not designed to simply generate posts.

It is designed to operate as a digital media company powered by AI agents.

The main goal is to create repeatable, measurable, and improving content workflows that can grow social media audiences, increase engagement, build communities, and eventually support monetization.

---

# 2. Project Vision

AI Content Factory exists to help Luis build and operate multiple social media content pages with a professional, scalable, and data-driven workflow.

The long-term vision is to create a system capable of managing several content brands across different niches and platforms, while continuously learning from performance data.

The platform begins as an internal content operation for Luis's own pages.

In the future, it may evolve into a product, service, or SaaS offering for third parties.

---

# 3. Strategic Objectives

## 3.1 Short-Term Objectives

The initial phase focuses on validating the content pipeline.

Primary goals:

- Produce content consistently.
- Maintain human approval before public publishing.
- Validate the OpenClaw multi-agent workflow.
- Validate Telegram approval.
- Validate PostgreSQL persistence.
- Validate image generation workflow.
- Validate Facebook publishing workflow.
- Track metrics from published content.
- Learn which formats generate better engagement.

Initial 30-day target:

- Gain at least 100 additional followers.
- Reach at least 3,000 people.
- Generate approximately 90 prepared publications.
- Confirm that the workflow works end-to-end.

---

## 3.2 Medium-Term Objectives

After the workflow is stable, AI Content Factory should expand toward multiple niches and formats.

Medium-term goals:

- Grow the first active page to at least 500 total followers.
- Improve weekly engagement metrics.
- Introduce additional niches.
- Introduce multiple page strategies.
- Test Reels, image posts, carousels, memes, and interactive posts.
- Build a reusable Knowledge Base.
- Improve the approval and feedback loop.
- Start preparing for monetization.

---

## 3.3 Long-Term Objectives

Long-term, AI Content Factory should become a scalable content infrastructure.

Long-term goals:

- Operate multiple pages across different niches.
- Support multiple social networks.
- Automate publishing under approved policies.
- Track cost per content piece.
- Track content performance by niche, format, platform, and hook.
- Support semi-autonomous strategy adjustments.
- Build a reusable content engine that could eventually become a service for third parties.

---

# 4. Initial Scope

## 4.1 Included in v1

AI Content Factory v1 includes:

- OpenClaw-based multi-agent orchestration.
- Five-agent structure.
- Human-in-the-loop approval.
- Telegram approval workflow.
- Facebook page content generation.
- Facebook image posts.
- Facebook Reels preparation.
- Basic image generation integration.
- PostgreSQL as operational data store.
- Knowledge Base for reusable editorial knowledge.
- Weekly performance review.
- Basic cost tracking.
- Basic content metrics tracking.
- Manual approval before publishing.

---

## 4.2 Excluded from v1

The following items are not part of the initial version:

- Fully autonomous public publishing.
- Paid ads automation.
- Full SaaS multi-tenant infrastructure.
- Client billing.
- Advanced video editing automation.
- Deep analytics dashboard.
- Automatic revenue optimization.
- Automated comment replies.
- Automated direct messages.
- High-frequency posting.
- Storage or processing of user PII from social media audiences.

These capabilities may be considered in future versions.

---

# 5. Primary Platforms

## 5.1 Initial Platform

The first supported platform is:

- Facebook

Initial Facebook content types:

- Image posts
- Reels
- Memes
- Interactive posts
- Short educational or entertaining captions

---

## 5.2 Future Platforms

Future supported platforms may include:

- TikTok
- Instagram
- X
- Threads
- LinkedIn
- YouTube Shorts
- Pinterest

The architecture must be platform-extensible from the beginning.

No core agent should be hardcoded exclusively for Facebook unless the task is specifically platform-related.

---

# 6. Initial Niches

## 6.1 Primary Initial Niche

The first active niche is:

- Viral humor

This niche is chosen because it allows fast testing of:

- Hooks
- Shareability
- Relatability
- Meme formats
- Visual styles
- CTA styles
- Audience reactions

---

## 6.2 Secondary Niches

After validating the workflow, the system may expand into:

- Motivation
- Mindset
- Stoicism
- Personal finance
- Investing
- Stock market
- Technology and AI

Each niche should be treated as a separate content product line.

Each niche must have its own performance benchmarks, voice, content patterns, and audience learnings.

---

# 7. Organizational Model

AI Content Factory follows a Manager-Worker architecture.

Luis is the CEO and final approval authority.

Magnus owns product strategy.

Javier owns operations.

Bruno owns research.

Elena owns content creation.

Damian owns publication readiness and delivery.

---

# 8. Agent Structure

```text
Luis — CEO & System Owner
        │
        ▼
Magnus — Product Owner
        │
        ▼
Javier — Operations Director
        │
 ┌──────┼────────┐
 ▼      ▼        ▼
Bruno  Elena   Damian
```

---

# 9. Agent Responsibilities

## 9.1 Luis — CEO & System Owner

Luis owns the business direction and final editorial authority.

Responsibilities:

- Define strategic priorities.
- Approve or reject publication packages.
- Provide feedback through Telegram.
- Decide when automation policies may be enabled.
- Override operational decisions when necessary.
- Protect the long-term direction of the company.

Luis is not an AI agent.

Luis is the human authority of the system.

---

## 9.2 Magnus — Product Owner

Magnus owns product strategy and growth direction.

Responsibilities:

- Analyze page performance.
- Understand audience behavior.
- Detect growth opportunities.
- Propose experiments.
- Prioritize niches.
- Recommend content direction.
- Review weekly metrics.
- Convert performance data into strategic recommendations.

Magnus thinks in terms of business value, growth, retention, engagement, and monetization potential.

Magnus does not directly publish content.

---

## 9.3 Javier — Operations Director

Javier owns execution and workflow coordination.

Responsibilities:

- Coordinate agent tasks.
- Enforce workflow order.
- Validate required inputs and outputs.
- Trigger Bruno, Elena, and Damian.
- Check cost thresholds.
- Check cache before unnecessary API usage.
- Ensure tasks are logged.
- Prevent incomplete content from reaching approval.
- Escalate failures to Luis when necessary.

Javier thinks in terms of operational reliability.

Javier does not create the content himself unless explicitly instructed.

---

## 9.4 Bruno — Researcher

Bruno owns discovery and research.

Responsibilities:

- Research trends.
- Analyze competitors.
- Find relevant topic angles.
- Summarize useful signals.
- Detect risks.
- Verify factual information.
- Provide structured research output to Elena.

Bruno must never invent data, sources, or trends.

If a fact cannot be verified, Bruno must clearly mark it as uncertain.

---

## 9.5 Elena — Creator

Elena owns content creation.

Responsibilities:

- Transform research into publishable content.
- Write captions.
- Write hooks.
- Generate CTA options.
- Generate hashtags.
- Generate image prompts.
- Adapt content to niche and platform.
- Maintain human, natural, non-robotic writing.
- Apply the brand voice.
- Prepare content drafts for approval.

Elena must create content in neutral Latin American Spanish unless explicitly instructed otherwise.

Elena does not publish.

---

## 9.6 Damian — Publisher

Damian owns publication readiness and delivery.

Responsibilities:

- Prepare approval packages.
- Send content to Luis through Telegram.
- Receive approval, rejection, or correction requests.
- Publish only approved content.
- Schedule approved content.
- Store publication status.
- Collect performance metrics.
- Update PostgreSQL.
- Report publication outcomes.

Damian must never publish unapproved content.

---

# 10. High-Level Workflow

The standard content workflow is:

```text
1. Magnus identifies opportunity or strategy.
2. Javier creates operational task.
3. Bruno researches topic, trend, or competitor pattern.
4. Elena creates the content package.
5. Damian prepares approval package.
6. Luis approves, rejects, or requests changes via Telegram.
7. Damian publishes approved content.
8. Damian collects metrics after publication.
9. Magnus reviews performance weekly.
10. Knowledge Base is updated with useful learnings.
```

---

# 11. Publication Lifecycle

Each publication moves through the following states:

```text
IDEA
  ↓
RESEARCH_REQUESTED
  ↓
RESEARCH_COMPLETED
  ↓
CONTENT_DRAFTED
  ↓
READY_FOR_APPROVAL
  ↓
APPROVED / REJECTED / NEEDS_CHANGES
  ↓
SCHEDULED
  ↓
PUBLISHED
  ↓
METRICS_COLLECTED
  ↓
ANALYZED
```

---

# 12. Human Approval Flow

Human approval is mandatory in v1.

The approval flow should happen through Telegram.

Damian must send Luis a structured approval package containing:

- Page name
- Platform
- Content type
- Proposed copy
- Proposed image or video
- Hashtags
- CTA
- Suggested publication time
- Risk notes
- Cost notes when relevant
- Approval options

Luis must be able to choose:

- Approve
- Request changes
- Reject
- Discard

If Luis requests changes, Damian returns the item to Javier.

Javier determines whether the correction should be assigned to Elena, Bruno, or Magnus.

---

# 13. System Architecture

## 13.1 High-Level Architecture

```text
                    Luis
                     │
                     ▼
                Telegram
                     │
                     ▼
                  Damian
                     │
                     ▼
                PostgreSQL
                     ▲
                     │
       ┌─────────────┼─────────────┐
       │             │             │
    Magnus        Javier        Metrics
       │             │
       ▼             ▼
    Strategy      Workflow
                     │
        ┌────────────┼────────────┐
        ▼            ▼            ▼
      Bruno        Elena       Tools/APIs
```

---

## 13.2 Technical Components

The system consists of:

- OpenClaw
- PostgreSQL
- Telegram Bot integration
- Image generation API
- Facebook Graph API
- Web search/fetch tools
- File writer tools
- Scheduler
- Cost logger
- Metrics collector
- Knowledge Base files
- Agent identity files
- Workflow definitions

---

# 14. Data Architecture Overview

PostgreSQL is the operational source of truth.

It should store:

- Projects
- Pages
- Niches
- Topics
- Ideas
- Research outputs
- Content drafts
- Approval status
- Publications
- Images
- Metrics
- Costs
- Logs
- Experiments
- Learnings

The Knowledge Base stores long-term organizational knowledge.

The database stores operational and analytical data.

Temporary agent memory is not considered persistent.

---

# 15. Knowledge Architecture

The Knowledge Base contains reusable editorial and strategic knowledge.

Initial Knowledge Base files:

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

`brand_voice.md` already defines the global voice and niche-specific tone.

Future knowledge files should evolve based on results and Luis's feedback.

---

# 16. Agent File Architecture

Each agent should have its own folder.

Recommended structure:

```text
agents/
├── magnus/
│   ├── identity.md
│   ├── SOUL.md
│   ├── RULES.md
│   ├── EXAMPLES.md
│   └── tools.md
│
├── javier/
│   ├── identity.md
│   ├── SOUL.md
│   ├── RULES.md
│   ├── EXAMPLES.md
│   └── tools.md
│
├── bruno/
│   ├── identity.md
│   ├── SOUL.md
│   ├── RULES.md
│   ├── EXAMPLES.md
│   └── tools.md
│
├── elena/
│   ├── identity.md
│   ├── SOUL.md
│   ├── RULES.md
│   ├── EXAMPLES.md
│   └── tools.md
│
└── damian/
    ├── identity.md
    ├── SOUL.md
    ├── RULES.md
    ├── EXAMPLES.md
    └── tools.md
```

---

# 17. Root Project Structure

Recommended root structure:

```text
/opt/ai-content-factory/
├── CONSTITUTION.md
├── FOUNDATION.md
├── README.md
│
├── docs/
│   └── 01_vision_scope_architecture.md
│
├── knowledge/
│   ├── brand_voice.md
│   └── ...
│
├── agents/
│   ├── magnus/
│   ├── javier/
│   ├── bruno/
│   ├── elena/
│   └── damian/
│
├── database/
│   ├── schema.sql
│   ├── migrations/
│   └── seeds/
│
├── workflows/
│   ├── facebook_content_pipeline.md
│   ├── approval_flow.md
│   └── metrics_review.md
│
├── tools/
│   ├── publisher_api/
│   ├── image_generation/
│   ├── web_research/
│   └── metrics_collector/
│
├── deployment/
│   ├── docker-compose.yml
│   ├── .env.example
│   └── nginx/
│
└── logs/
```

---

# 18. Model Strategy

AI Content Factory should use the cheapest model capable of solving each task with acceptable quality.

Recommended model strategy:

| Task | Preferred Model Type |
|---|---|
| Product strategy | Strong reasoning model |
| Workflow coordination | Cost-efficient reasoning model |
| Research summarization | Low-cost model |
| Competitor analysis | Low-cost or medium-cost model |
| Content creation | High-quality writing model |
| Final rewrite | High-quality writing model |
| Approval packaging | Tool or low-cost model |
| Publishing | Deterministic tool |
| Metrics collection | Deterministic tool |
| Weekly analysis | Reasoning model |

Model usage should be logged.

Cost per publication should be measurable.

---

# 19. Image Generation Strategy

Image generation should balance quality and cost.

Possible providers:

- FLUX API
- OpenAI image models
- Stability AI
- Fal.ai hosted image models
- Local Stable Diffusion or FLUX-based workflows
- Other compatible image-generation APIs

Recommended v1 strategy:

- Use API-based image generation for reliability.
- Store generated images outside PostgreSQL.
- Store only metadata, URLs, and file paths in PostgreSQL.
- Prefer reusable visual patterns.
- Reuse or remix successful image concepts when appropriate.
- Avoid generating unnecessary duplicate images.

Images should match the niche voice defined in `knowledge/brand_voice.md`.

---

# 20. Publication and Scheduling Strategy

In v1, publication should be manual-approved and tool-executed.

Damian prepares content.

Luis approves.

Damian publishes.

Publication timing should include randomness.

Posts should avoid deterministic publishing patterns such as exactly 12:00 or 15:00.

Scheduling should respect the daily frequency limits defined in `CONSTITUTION.md`.

---

# 21. Metrics Strategy

The system must collect and store performance metrics.

Priority metrics:

- Reach
- Likes
- Comments
- Shares
- New followers
- Reel retention
- Publication time
- Content type
- CTA type
- Hook type
- Image style

Once monetization becomes available, revenue metrics must also be tracked.

Metrics must feed Magnus's weekly review.

---

# 22. Learning Loop

AI Content Factory must improve over time.

The learning loop is:

```text
Publish content
  ↓
Collect metrics
  ↓
Analyze results
  ↓
Extract learnings
  ↓
Update Knowledge Base
  ↓
Adjust future strategy
```

Learnings should be specific.

Bad learning:

```text
Humor works.
```

Good learning:

```text
Office humor with short captions and exaggerated workplace situations generated more shares than generic memes during weekday afternoons.
```

---

# 23. Cost Control

Every model call, image generation call, web search call, and publishing action should be traceable.

The system should store:

- Provider
- Model
- Input tokens
- Output tokens
- Estimated cost
- Actual cost when available
- Task type
- Agent name
- Workflow ID
- Timestamp

Budget protection should follow `CONSTITUTION.md`.

The system should support circuit breaker behavior when daily cost thresholds are reached.

---

# 24. Reliability Requirements

The system should be designed to handle failures safely.

Required behavior:

- Never publish unapproved content.
- Never silently ignore failed tasks.
- Never lose publication state.
- Never overwrite approved content without tracking changes.
- Never expose credentials in logs.
- Always record workflow failures.
- Always preserve enough context to retry safely.

---

# 25. Security Requirements

Security principles:

- Secrets live in environment variables or secret stores.
- Secrets must not be committed to Git.
- Agents must not log credentials.
- Tokens should be rotated when exposed.
- Public actions require explicit approval.
- Database access should be limited by role when possible.
- External API access should be isolated through tools or service layers.

---

# 26. Deployment Vision

The recommended production deployment target is a VPS.

Initial deployment may include:

- OpenClaw
- PostgreSQL
- Telegram bot integration
- Publisher service
- Scheduler
- Metrics collector
- Docker Compose
- Nginx if external APIs are exposed
- Backup scripts

Recommended path:

```text
Local development
  ↓
VPS deployment
  ↓
Stable workflow
  ↓
Monitoring and backups
  ↓
Multi-page expansion
```

---

# 27. Future Expansion

Future versions may include:

- Multi-page dashboard
- Multi-platform publishing
- Automatic A/B testing
- Automated content recycling
- Revenue tracking
- Competitor monitoring
- Trend alerts
- Advanced analytics
- Semi-autonomous publishing policies
- Client support
- SaaS multi-tenant mode

---

# 28. Key Architectural Decisions

## Decision 1: Human Approval First

AI Content Factory v1 requires Luis's approval before public publishing.

Reason:

- Protect brand quality.
- Prevent accidental public mistakes.
- Build trust in the system.
- Allow learning from Luis's feedback.

---

## Decision 2: PostgreSQL as Operational Source of Truth

Operational state belongs in PostgreSQL.

Reason:

- Reliability.
- Queryability.
- Metrics tracking.
- Workflow recovery.
- Future dashboard support.

---

## Decision 3: Knowledge Base for Long-Term Learning

Permanent editorial knowledge belongs in Markdown knowledge files or structured database records.

Reason:

- Agents should not rely on temporary memory.
- Knowledge must be editable.
- Learnings must survive restarts.
- Strategy must evolve over time.

---

## Decision 4: Tools Over LLMs When Possible

Deterministic actions should be handled by tools.

Reason:

- Lower cost.
- Higher reliability.
- Easier debugging.
- Better security.

---

## Decision 5: Separate Strategy, Operations, Creation, and Delivery

The system separates responsibilities between agents.

Reason:

- Clear ownership.
- Lower prompt complexity.
- Better observability.
- Easier iteration.
- Fewer duplicated responsibilities.

---

# 29. Open Questions

The following items remain open for future design documents:

- Exact PostgreSQL schema.
- Exact OpenClaw workflow configuration.
- Exact Telegram approval UI format.
- Exact Facebook Graph API integration.
- Exact image provider for v1.
- Exact VPS deployment configuration.
- Exact cost monitoring implementation.
- Exact backup strategy.
- Exact agent identity files.
- Exact Knowledge Base update protocol.

---

# 30. Final Statement

AI Content Factory v1 is designed as a professional, human-supervised, multi-agent content operation.

Its purpose is not to replace Luis's judgment.

Its purpose is to multiply Luis's ability to test ideas, produce content, learn from audiences, and grow digital media assets.

The system should always remain:

- Governed
- Observable
- Cost-aware
- Human-approved
- Platform-safe
- Learning-oriented
- Built for long-term growth