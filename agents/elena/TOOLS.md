# tools.md
## Elena — Creator

> This file defines the tools Elena may use or request through the system.

---

# 1. Tool Philosophy

Elena uses tools to create better content, align voice, generate variations, and prepare complete creative outputs.

Elena does not use tools to publish content.

Elena does not use tools to approve content.

Elena should prefer existing research, Knowledge Base files, and approved examples before generating new creative directions.

---

# 2. Minimum Tool Set for v1

Elena needs the following tool categories:

```text
knowledge_read
research_read
content_draft_write
approved_examples_read
brand_voice_checker
risk_note_checker
prompt_builder
revision_request_handler
```

---

# 3. Knowledge Read Tool

Elena must be able to read:

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

- Align content with brand voice.
- Match the target niche.
- Avoid known weak patterns.
- Reuse validated hooks and CTAs.
- Maintain language consistency.

---

# 4. Research Read Tool

## Tool Intent

```text
research_read
```

## Purpose

Elena reads Bruno's research before creating content.

## Example Input

```json
{
  "content_idea_id": 101,
  "research_note_id": 501
}
```

## Expected Output

```json
{
  "research_summary": "Office frustration humor is a safe and relatable angle.",
  "key_findings": [
    "Meeting jokes are broadly relatable.",
    "Short captions are easier to share."
  ],
  "content_angles": [
    "Meetings that should have been emails",
    "Boss says it is quick but takes 40 minutes"
  ],
  "risks": [],
  "confidence": "medium"
}
```

---

# 5. Content Draft Write Tool

## Tool Intent

```text
content_draft_write
```

## Purpose

Elena saves completed drafts to PostgreSQL or the workflow system.

## Example Input

```json
{
  "content_idea_id": 101,
  "social_page_id": 1,
  "niche_id": 1,
  "platform_content_type": "image_post",
  "language": "es-LATAM",
  "hook": "Cuando la junta era de 10 minutos pero ya van 47.",
  "post_copy": "La junta era para revisar 'un tema rápido' y de pronto ya están hablando del plan estratégico del 2031.",
  "call_to_action": "Etiqueta a alguien que siempre dice: 'es rapidísimo'.",
  "hashtags": [
    "#Trabajo",
    "#Oficina",
    "#Humor"
  ],
  "image_prompt": "A funny office meeting scene with tired employees sitting around a conference table, one person presenting endless slides, exaggerated expressions, clean social media illustration style, no real people.",
  "risk_notes": []
}
```

## Expected Output

```json
{
  "status": "saved",
  "content_post_id": 301,
  "next_state": "CONTENT_DRAFTED"
}
```

---

# 6. Approved Examples Read Tool

## Tool Intent

```text
approved_examples_read
```

## Purpose

Elena reads prior approved posts to preserve voice consistency.

## Example Input

```json
{
  "niche": "viral_humor",
  "platform": "facebook",
  "limit": 5,
  "only_approved": true
}
```

## Expected Output

```json
{
  "examples": [
    {
      "hook": "",
      "post_copy": "",
      "call_to_action": "",
      "hashtags": [],
      "performance_summary": ""
    }
  ]
}
```

---

# 7. Brand Voice Checker

## Tool Intent

```text
brand_voice_checker
```

## Purpose

Elena uses this tool to check whether a draft sounds aligned with the selected niche and brand voice.

## Example Input

```json
{
  "niche": "viral_humor",
  "language": "es-LATAM",
  "draft": {
    "hook": "Cuando la junta era de 10 minutos pero ya van 47.",
    "post_copy": "La junta era para revisar 'un tema rápido' y de pronto ya están hablando del plan estratégico del 2031.",
    "call_to_action": "Etiqueta a alguien que siempre dice: 'es rapidísimo'."
  }
}
```

## Expected Output

```json
{
  "passed": true,
  "voice_alignment": "high",
  "issues": [],
  "suggestions": []
}
```

---

# 8. Risk Note Checker

## Tool Intent

```text
risk_note_checker
```

## Purpose

Elena uses this tool to identify creative risks before sending the draft forward.

## Example Input

```json
{
  "niche": "viral_humor",
  "platform": "facebook",
  "draft": {
    "hook": "",
    "post_copy": "",
    "image_prompt": ""
  }
}
```

## Expected Output

```json
{
  "risk_level": "low",
  "risk_notes": [],
  "required_changes": []
}
```

---

# 9. Prompt Builder

## Tool Intent

```text
prompt_builder
```

## Purpose

Elena uses this tool to create structured image or video prompts.

## Example Output

```json
{
  "image_prompt": {
    "subject": "tired employees in an office meeting",
    "scene": "conference room with an endless slide presentation",
    "mood": "funny and relatable",
    "style": "clean social media illustration",
    "composition": "wide shot, exaggerated facial expressions",
    "text_in_image": "optional short meme text at the top",
    "avoid": [
      "real people",
      "brand logos",
      "offensive stereotypes",
      "messy text"
    ]
  }
}
```

---

# 10. Revision Request Handler

## Tool Intent

```text
revision_request_handler
```

## Purpose

Elena uses this when Luis or Javier requests changes.

## Example Input

```json
{
  "original_draft": {
    "hook": "Work meetings can often become longer than expected.",
    "post_copy": "Sometimes professional environments create situations where meetings extend unnecessarily and affect productivity."
  },
  "feedback": "Make it less robotic and more casual.",
  "niche": "viral_humor",
  "platform": "facebook"
}
```

## Expected Output

```json
{
  "revision_summary": "Made the copy shorter, more casual, and more relatable.",
  "revised_draft": {
    "hook": "La junta era de 10 minutos. Ya vamos en el tema 17.",
    "post_copy": "Y todavía alguien dijo: 'aprovechando que estamos todos...'",
    "call_to_action": "¿A quién le pasó?",
    "hashtags": [
      "#Trabajo",
      "#Oficina",
      "#Humor"
    ],
    "image_prompt": "A humorous office meeting scene with tired employees and an endless slide presentation, expressive cartoon-like style, social media meme format, no real people.",
    "risk_notes": []
  }
}
```

---

# 11. Tools Elena Should Not Use Directly

Elena should not directly use:

```text
facebook_publishing
telegram_approval_sender
credential_management
public_comment_reply
automated_messaging
raw_secret_access
direct_media_upload
metrics_collector
```

These belong to Damian, Javier, or system administration depending on workflow design.

---

# 12. Future Tools

Future Elena tools may include:

```text
caption_variant_generator
hook_score_predictor
cta_library_search
visual_style_recommender
script_timing_estimator
meme_layout_generator
carousel_outline_builder
```

These should be added only after the v1 workflow is stable.

---

# 13. Final Tool Principle

Elena uses tools to improve creativity, consistency, and completeness.

A tool is useful only when it improves:

- Voice quality
- Clarity
- Hook strength
- CTA quality
- Prompt quality
- Revision quality
- Approval readiness
