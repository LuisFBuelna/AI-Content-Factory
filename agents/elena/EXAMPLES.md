# EXAMPLES.md
## Elena — Creator

> Example outputs and behavior patterns for Elena.

---

# 1. Example — Viral Humor Image Post

## Input

```json
{
  "request_from": "Javier",
  "platform": "facebook",
  "content_type": "image_post",
  "niche": "viral_humor",
  "research_angle": "Meetings that should have been emails",
  "target_audience": "Mexico and Latin America"
}
```

## Expected Output

```json
{
  "platform": "facebook",
  "content_type": "image_post",
  "niche": "viral_humor",
  "language": "neutral_latin_american_spanish",
  "drafts": [
    {
      "title": "La junta rápida",
      "hook": "Cuando la junta era de 10 minutos pero ya van 47.",
      "post_copy": "La junta era para revisar 'un tema rápido' y de pronto ya están hablando del plan estratégico del 2031.",
      "call_to_action": "Etiqueta a alguien que siempre dice: 'es rapidísimo'.",
      "hashtags": [
        "#Trabajo",
        "#Oficina",
        "#Humor",
        "#VidaLaboral"
      ],
      "image_prompt": "A funny office meeting scene with tired employees sitting around a conference table, one person presenting endless slides, exaggerated expressions, clean social media illustration style, relatable workplace humor, no real people, no offensive stereotypes.",
      "video_prompt": "",
      "risk_notes": [],
      "revision_notes": ""
    }
  ],
  "recommended_option": "La junta rápida",
  "confidence": "high"
}
```

---

# 2. Example — Rewriting Robotic Copy

## Input

```json
{
  "request_from": "Javier",
  "luis_feedback": "This sounds too robotic. Make it more natural.",
  "original_draft": {
    "hook": "Work meetings can often become longer than expected.",
    "post_copy": "Sometimes professional environments create situations where meetings extend unnecessarily and affect productivity."
  }
}
```

## Expected Output

```json
{
  "original_issue": "The original draft sounded formal, generic, and unnatural for a humor post.",
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

# 3. Example — Mindset Post

## Input

```json
{
  "request_from": "Javier",
  "platform": "facebook",
  "content_type": "image_post",
  "niche": "mindset",
  "angle": "Progress does not always feel visible."
}
```

## Expected Output

```json
{
  "platform": "facebook",
  "content_type": "image_post",
  "niche": "mindset",
  "language": "neutral_latin_american_spanish",
  "drafts": [
    {
      "title": "Progreso invisible",
      "hook": "No todo avance se nota de inmediato.",
      "post_copy": "A veces estás cambiando en silencio. Mejorando hábitos, pensando distinto, eligiendo mejor. Que todavía no se vea no significa que no esté pasando.",
      "call_to_action": "Guárdalo para cuando sientas que no avanzas.",
      "hashtags": [
        "#Mindset",
        "#CrecimientoPersonal",
        "#Disciplina",
        "#Proceso"
      ],
      "image_prompt": "A calm minimalist image of a person walking at sunrise on a quiet path, reflective mood, warm natural light, inspirational but grounded, no luxury symbols, no exaggerated success imagery.",
      "video_prompt": "",
      "risk_notes": [],
      "revision_notes": ""
    }
  ],
  "recommended_option": "Progreso invisible",
  "confidence": "high"
}
```

---

# 4. Example — Finance Educational Post

## Input

```json
{
  "request_from": "Javier",
  "platform": "facebook",
  "content_type": "image_post",
  "niche": "personal_finance",
  "angle": "Emergency fund basics",
  "audience": "Mexico and Latin America"
}
```

## Expected Output

```json
{
  "platform": "facebook",
  "content_type": "image_post",
  "niche": "personal_finance",
  "language": "neutral_latin_american_spanish",
  "drafts": [
    {
      "title": "Fondo de emergencia",
      "hook": "Antes de invertir, construye margen.",
      "post_copy": "Un fondo de emergencia no te hace rico, pero puede evitar que una mala semana se convierta en una deuda de meses. Empieza pequeño, pero empieza.",
      "call_to_action": "Guárdalo si estás ordenando tus finanzas.",
      "hashtags": [
        "#FinanzasPersonales",
        "#Ahorro",
        "#EducacionFinanciera",
        "#Dinero"
      ],
      "image_prompt": "A clean educational finance graphic showing a simple emergency fund concept, piggy bank or savings jar, calm trustworthy style, Latin American audience, no luxury cars, no guaranteed wealth imagery.",
      "video_prompt": "",
      "risk_notes": [
        "Educational content only. Avoid personalized financial advice or guaranteed results."
      ],
      "revision_notes": ""
    }
  ],
  "recommended_option": "Fondo de emergencia",
  "confidence": "medium"
}
```

---

# 5. Example — Reel Script

## Input

```json
{
  "request_from": "Javier",
  "platform": "facebook",
  "content_type": "reel",
  "niche": "viral_humor",
  "angle": "When someone says the task is easy but it is not."
}
```

## Expected Output

```json
{
  "platform": "facebook",
  "content_type": "reel",
  "niche": "viral_humor",
  "language": "neutral_latin_american_spanish",
  "script": {
    "opening_hook": "Cuando te dicen: 'eso sale rápido'.",
    "scene_sequence": [
      {
        "scene": 1,
        "visual": "Person confidently opens laptop.",
        "on_screen_text": "Eso sale rápido."
      },
      {
        "scene": 2,
        "visual": "Person slowly realizes the task is much bigger.",
        "on_screen_text": "3 horas después..."
      },
      {
        "scene": 3,
        "visual": "Person staring at 18 open tabs and a broken spreadsheet.",
        "on_screen_text": "¿Quién hizo esto?"
      }
    ],
    "voiceover": "Yo confiando en que sí era algo rápido. Spoiler: no era algo rápido.",
    "on_screen_text": [
      "Eso sale rápido",
      "3 horas después...",
      "¿Quién hizo esto?"
    ],
    "caption": "Nunca es 'rapidito'. Nunca.",
    "call_to_action": "Etiqueta a quien siempre dice eso.",
    "hashtags": [
      "#Trabajo",
      "#Humor",
      "#Oficina",
      "#VidaLaboral"
    ]
  },
  "video_prompt": "A short funny office-style Reel showing a person starting a simple task and gradually becoming overwhelmed, expressive acting, quick cuts, relatable work humor, no real brand logos.",
  "risk_notes": [],
  "confidence": "high"
}
```
