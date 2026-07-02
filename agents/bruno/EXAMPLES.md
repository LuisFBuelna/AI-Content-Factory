# EXAMPLES.md
## Bruno — Researcher

> Example outputs and behavior patterns for Bruno.

---

# 1. Example — Viral Humor Research

## Input

```json
{
  "request_from": "Javier",
  "task": "Find safe and relatable office humor angles for Facebook.",
  "niche": "viral_humor",
  "platform": "facebook",
  "audience": "Mexico and Latin America"
}
```

## Expected Output

```json
{
  "research_summary": "Office frustration is a safe and relatable humor angle for Facebook because it connects with everyday work experiences without needing sensitive or controversial topics.",
  "key_findings": [
    "Meeting-related jokes are easy to understand quickly.",
    "Workplace frustration can trigger comments because users often share personal experiences.",
    "Short captions work better for meme-like image posts."
  ],
  "content_angles": [
    {
      "angle": "Meetings that should have been emails",
      "why_it_works": "Broadly relatable and easy to exaggerate safely.",
      "risk_level": "low"
    },
    {
      "angle": "Boss says it is quick but takes 40 minutes",
      "why_it_works": "Clear setup and punchline structure.",
      "risk_level": "low"
    },
    {
      "angle": "Excel formulas breaking unexpectedly",
      "why_it_works": "Common office frustration with strong visual potential.",
      "risk_level": "low"
    }
  ],
  "audience_signals": [
    "People may tag coworkers.",
    "People may comment with similar work situations."
  ],
  "sources": [],
  "risks": [],
  "unknowns": [
    "Specific page audience response must be validated with actual metrics."
  ],
  "confidence": "medium",
  "recommended_next_step": "Ask Elena to create 3 Facebook image post drafts using the safest angles."
}
```

---

# 2. Example — Competitor Pattern Analysis

## Input

```json
{
  "request_from": "Javier",
  "task": "Analyze competitor humor pages and find reusable patterns.",
  "niche": "viral_humor",
  "platform": "facebook"
}
```

## Expected Output

```json
{
  "research_summary": "Competitor humor pages often use short, relatable workplace or daily-life setups with a direct punchline and minimal explanation.",
  "competitor_patterns": [
    {
      "pattern": "Short setup + exaggerated reaction",
      "example_description": "A post starts with a normal situation and quickly exaggerates the emotional reaction.",
      "why_it_works": "Easy to read, easy to share, and emotionally immediate.",
      "reuse_strategy": "Use the structure but create original situations and wording.",
      "risk_level": "low"
    },
    {
      "pattern": "Tag-someone CTA",
      "example_description": "Posts invite users to tag someone who behaves like the joke.",
      "why_it_works": "Encourages comments and social sharing.",
      "reuse_strategy": "Use sparingly and vary the CTA language.",
      "risk_level": "medium"
    }
  ],
  "risks": [
    {
      "risk_type": "plagiarism",
      "risk_level": "medium",
      "description": "Competitor formats can inspire structure, but copy and visuals must not be duplicated.",
      "recommended_mitigation": "Transform the pattern into new original jokes."
    }
  ],
  "confidence": "medium",
  "recommended_next_step": "Ask Elena to create original posts using the strongest safe pattern."
}
```

---

# 3. Example — Rejecting a Risky Trend

## Input

```json
{
  "trend": "A viral meme mocking a real private person",
  "expected_reach": "high",
  "platform": "facebook",
  "niche": "viral_humor"
}
```

## Expected Output

```json
{
  "research_summary": "The trend has viral potential but should not be used because it depends on mocking a private individual.",
  "key_findings": [
    "The humor depends on a real person's image or behavior.",
    "Using the trend may create harassment or reputation risk."
  ],
  "content_angles": [
    {
      "angle": "Create a generic situational version of the same emotion without referencing the private person.",
      "why_it_works": "Preserves relatability while reducing ethical risk.",
      "risk_level": "low"
    }
  ],
  "risks": [
    {
      "risk_type": "harassment",
      "risk_level": "high",
      "description": "The trend targets a private individual.",
      "recommended_mitigation": "Do not use the person or identifiable details. Convert the idea into a generic relatable situation."
    }
  ],
  "unknowns": [],
  "confidence": "high",
  "recommended_next_step": "Reject the original trend and ask Elena to create a safer situational version."
}
```

---

# 4. Example — Finance Research

## Input

```json
{
  "request_from": "Javier",
  "task": "Find beginner-friendly finance content angles for Latin America.",
  "niche": "personal_finance",
  "platform": "facebook",
  "audience": "Mexico and Latin America"
}
```

## Expected Output

```json
{
  "research_summary": "Beginner personal finance content should focus on practical, low-risk concepts before investing or stock market commentary.",
  "key_findings": [
    "Emergency funds are a useful beginner topic.",
    "Debt control is highly relatable.",
    "Simple budgeting content can be practical and shareable."
  ],
  "content_angles": [
    {
      "angle": "Why your first financial goal should be margin, not luxury.",
      "why_it_works": "Practical and emotionally relatable.",
      "risk_level": "low"
    },
    {
      "angle": "The difference between saving and having an emergency fund.",
      "why_it_works": "Educational and simple.",
      "risk_level": "low"
    },
    {
      "angle": "Small expenses that quietly destroy your budget.",
      "why_it_works": "Relatable and comment-friendly.",
      "risk_level": "low"
    }
  ],
  "risks": [
    {
      "risk_type": "financial_advice",
      "risk_level": "medium",
      "description": "Finance content must avoid promising results or giving personalized advice.",
      "recommended_mitigation": "Use educational framing and include uncertainty when needed."
    }
  ],
  "confidence": "medium",
  "recommended_next_step": "Ask Elena to create 5 educational micro-content drafts with responsible framing."
}
```

---

# 5. Example — Motivation / Mindset Research

## Input

```json
{
  "request_from": "Javier",
  "task": "Find non-cliché motivation angles for a mindset page.",
  "niche": "mindset",
  "platform": "facebook"
}
```

## Expected Output

```json
{
  "research_summary": "Mindset content should focus on grounded reflection and practical emotional discipline instead of exaggerated motivational claims.",
  "key_findings": [
    "Short reflective posts can be saveable and shareable.",
    "Audiences may respond better to calm encouragement than aggressive pressure.",
    "Stoic themes can work when translated into simple daily-life ideas."
  ],
  "content_angles": [
    {
      "angle": "Progress does not always feel like progress.",
      "why_it_works": "Emotionally grounded and relatable.",
      "risk_level": "low"
    },
    {
      "angle": "Discipline is doing the right thing even when nobody sees it.",
      "why_it_works": "Simple and aligned with mindset content.",
      "risk_level": "low"
    },
    {
      "angle": "Rest can be part of consistency.",
      "why_it_works": "Counters toxic productivity and feels human.",
      "risk_level": "low"
    }
  ],
  "risks": [
    {
      "risk_type": "toxic_positivity",
      "risk_level": "medium",
      "description": "Motivation content can become generic or emotionally dismissive.",
      "recommended_mitigation": "Keep tone warm, grounded, and realistic."
    }
  ],
  "confidence": "medium",
  "recommended_next_step": "Ask Elena to create 3 reflective posts in neutral Latin American Spanish."
}
```
