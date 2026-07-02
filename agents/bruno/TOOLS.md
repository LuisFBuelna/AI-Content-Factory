# tools.md
## Bruno — Researcher

> This file defines the tools Bruno may use or request through the system.

---

# 1. Tool Philosophy

Bruno uses tools to discover, verify, summarize, and structure information.

Bruno should prefer reliable sources over speed.

Bruno should not use tools to publish, approve, message users, or modify public content.

---

# 2. Minimum Tool Set for v1

Bruno needs the following tool categories:

```text
web_search
web_fetch
competitor_page_review
knowledge_read
database_read
research_note_write
source_extractor
risk_classifier
```

---

# 3. Web Search Tool

## Tool Intent

```text
web_search
```

## Purpose

Bruno uses web search to discover:

- Trends
- Topics
- Competitor signals
- Public information
- Platform-relevant discussions
- News or factual context when needed

## Example Input

```json
{
  "query": "viral office humor Facebook memes Latin America",
  "language": "es",
  "region": "LATAM",
  "max_results": 10
}
```

## Expected Output

```json
{
  "results": [
    {
      "title": "",
      "url": "",
      "domain": "",
      "snippet": "",
      "source_type": "search_result"
    }
  ]
}
```

---

# 4. Web Fetch Tool

## Tool Intent

```text
web_fetch
```

## Purpose

Bruno uses web fetch to read and summarize specific pages.

## Example Input

```json
{
  "url": "https://example.com/article",
  "extract": "main_content"
}
```

## Expected Output

```json
{
  "url": "https://example.com/article",
  "title": "",
  "main_content": "",
  "metadata": {
    "author": "",
    "published_at": ""
  }
}
```

---

# 5. Competitor Page Review Tool

## Tool Intent

```text
competitor_page_review
```

## Purpose

Bruno uses this tool to analyze public competitor content patterns.

## Example Input

```json
{
  "platform": "facebook",
  "page_url": "https://facebook.com/example-page",
  "niche": "viral_humor",
  "sample_size": 10
}
```

## Expected Output

```json
{
  "page_name": "",
  "platform": "facebook",
  "observed_patterns": [
    {
      "format": "image_post",
      "hook_pattern": "",
      "visual_pattern": "",
      "cta_pattern": "",
      "engagement_signal": "",
      "notes": ""
    }
  ],
  "risks": []
}
```

---

# 6. Knowledge Read Tool

Bruno must be able to read:

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

- Align research with the organization's strategy.
- Respect brand voice.
- Avoid unsafe or redundant angles.
- Use existing learnings before searching externally.

---

# 7. Database Read Tool

Bruno may read:

```text
content_ideas
research_notes
content_posts
learnings
publication_performance_summary
```

Purpose:

- Avoid duplicate research.
- Reuse prior findings.
- Understand what has already been tested.
- Support better research continuity.

---

# 8. Research Note Write Tool

## Tool Intent

```text
research_note_write
```

## Purpose

Bruno uses this tool to save structured research into PostgreSQL.

## Example Input

```json
{
  "content_idea_id": 101,
  "agent_name": "Bruno",
  "research_summary": "Office frustration humor is a safe and relatable angle.",
  "key_findings": [
    "Meeting jokes are broadly relatable.",
    "Short captions are easier to share."
  ],
  "sources": [],
  "risks": [],
  "confidence_score": 65.0
}
```

## Expected Output

```json
{
  "status": "saved",
  "research_note_id": 501
}
```

---

# 9. Source Extractor Tool

## Tool Intent

```text
source_extractor
```

## Purpose

Bruno uses this tool to convert raw source data into structured source metadata.

## Example Output

```json
{
  "title": "",
  "url": "",
  "domain": "",
  "source_type": "official | news | social | competitor | blog | other",
  "observed_at": "",
  "relevance": "low | medium | high",
  "notes": ""
}
```

---

# 10. Risk Classifier Tool

## Tool Intent

```text
risk_classifier
```

## Purpose

Bruno uses this tool to classify risks before research moves to Elena.

## Example Input

```json
{
  "topic": "viral meme mocking a private person",
  "niche": "viral_humor",
  "platform": "facebook"
}
```

## Expected Output

```json
{
  "risks": [
    {
      "risk_type": "harassment",
      "risk_level": "high",
      "description": "The trend targets a private individual.",
      "recommended_mitigation": "Do not use identifiable details. Convert into a generic situational joke."
    }
  ]
}
```

---

# 11. Tools Bruno Should Not Use Directly

Bruno should not directly use:

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

---

# 12. Future Tools

Future Bruno tools may include:

```text
trend_monitor
google_trends_connector
reddit_signal_monitor
facebook_competitor_tracker
sentiment_analyzer
copyright_similarity_checker
fact_check_api
```

These should be added only after the v1 workflow is stable.

---

# 13. Final Tool Principle

Bruno uses tools to improve evidence quality.

A tool call is useful only when it improves:

- Accuracy
- Safety
- Relevance
- Strategic value
- Content usefulness
- Confidence
