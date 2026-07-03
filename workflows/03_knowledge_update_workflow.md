# 03_knowledge_update_workflow.md
# AI Content Factory — Knowledge Update Workflow

> Workflow: 03  
> Version: 1.0  
> Owner: Luis — CEO & System Owner  
> Primary Agent: Magnus — Product Owner & CEO Approval Interface  
> Operational Coordinator: Javier — Operations Director

---

# 1. Purpose

This workflow defines how AI Content Factory proposes, validates, approves, and applies updates to the Knowledge Base.

The Knowledge Base is the system's durable organizational memory.

It should evolve based on:

- Metrics.
- Luis's feedback.
- Approval outcomes.
- Rejected content.
- Successful experiments.
- Failed experiments.
- Platform behavior.
- Research patterns.
- Brand voice refinements.

---

# 2. Knowledge Base Role

The Knowledge Base stores durable guidance for agents.

It is separate from:

- PostgreSQL operational state.
- Temporary chat memory.
- Agent execution logs.
- One-time task instructions.

Knowledge Base files may include:

```text
knowledge/brand_voice.md
knowledge/content_patterns.md
knowledge/facebook_strategy.md
knowledge/viral_hooks.md
knowledge/cta_library.md
knowledge/image_style_guide.md
knowledge/niche_humor.md
knowledge/niche_mindset.md
knowledge/niche_finance.md
knowledge/learning_log.md
```

---

# 3. When to Propose a Knowledge Update

A Knowledge Base update should be proposed when there is a durable or useful learning.

Examples:

- A hook pattern repeatedly performs well.
- A CTA repeatedly fails.
- Luis repeatedly requests the same kind of change.
- A visual style improves shares.
- A niche angle shows strong demand.
- A topic creates unexpected risk.
- A platform rule changes.
- A workflow issue repeats.
- A rejected post reveals a brand preference.
- A successful experiment should be reused.

---

# 4. When Not to Update Knowledge

Do not update durable Knowledge Base files when:

- There is only one weak signal.
- Metrics are incomplete.
- The result is probably random.
- The insight is too vague.
- The finding is not actionable.
- The update conflicts with `CONSTITUTION.md`.
- The update would change brand voice without Luis approval.
- The update is based on invented or uncertain data.

Weak signals may be stored as experimental learnings, not permanent rules.

---

# 5. Agents Involved

## Magnus

Owns strategic interpretation and proposes most Knowledge Base updates.

Magnus decides whether a learning is durable, experimental, or not worth storing.

## Javier

Coordinates the update workflow and ensures the correct file is updated only after validation and approval when required.

## Bruno

May propose research-based updates, especially trends, risks, source guidance, or competitor patterns.

## Elena

May propose creative updates, especially voice, hooks, CTAs, formats, and prompt patterns.

## Damian

May propose publication and metrics-based updates, especially scheduling, platform limits, approval package issues, or metrics collection learnings.

## Luis

Approves updates that affect core strategy, brand voice, automation policy, budget policy, public approval policy, or constitutional rules.

Luis communicates through Magnus.

---

# 6. Knowledge Update Categories

Recommended categories:

```text
brand_voice
hook_pattern
cta_pattern
visual_style
platform_strategy
niche_strategy
risk_rule
workflow_rule
approval_learning
publishing_learning
cost_learning
experiment_result
```

---

# 7. Confidence Levels

Every update proposal must include confidence.

| Confidence | Meaning |
|---|---|
| Low | Weak signal, early observation, or incomplete evidence. |
| Medium | Repeated signal or reasonable evidence, but not definitive. |
| High | Consistent signal across multiple posts, reviews, or experiments. |

Low-confidence updates must be marked as experimental.

---

# 8. Update Types

Allowed update types:

```text
ADD
REVISE
ARCHIVE
PROMOTE_EXPERIMENTAL_TO_DURABLE
```

Meaning:

- `ADD`: Add a new learning or rule.
- `REVISE`: Change existing guidance.
- `ARCHIVE`: Mark outdated guidance as no longer active.
- `PROMOTE_EXPERIMENTAL_TO_DURABLE`: Convert a validated experimental learning into stable guidance.

---

# 9. Approval Requirements

Luis approval is required when the update affects:

- `CONSTITUTION.md`
- `FOUNDATION.md`
- Core brand voice.
- Human approval flow.
- Agent authority.
- Budget policy.
- Platform risk policy.
- Automation policy.
- Public-facing ethical standards.
- Major niche direction.

Luis approval may not be required when the update is:

- A low-risk experimental learning.
- A minor content pattern note.
- A metrics-based observation.
- A non-core CTA performance note.
- A temporary strategy note.

When uncertain, route to Magnus and ask whether Luis approval is required.

---

# 10. Workflow States

Knowledge update lifecycle:

```text
UPDATE_PROPOSED
EVIDENCE_REVIEWED
CLASSIFIED
APPROVAL_REQUIRED
WAITING_FOR_LUIS_DECISION
APPROVED
NEEDS_CHANGES
REJECTED
APPLIED
ARCHIVED
```

---

# 11. Step-by-Step Workflow

## Step 1 — Update Proposal

Any agent may propose a Knowledge Base update through Javier.

Default proposal format:

```json
{
  "proposal_id": "ku-2026-07-07-001",
  "proposed_by": "Magnus",
  "target_file": "knowledge/viral_hooks.md",
  "update_type": "ADD",
  "category": "hook_pattern",
  "confidence": "medium",
  "summary": "Office frustration hooks may drive comments on Facebook humor pages.",
  "evidence": [
    {
      "source_type": "weekly_review",
      "reference_id": "wr-2026-07-07-facebook-001",
      "finding": "Office humor posts outperformed generic memes in comments and shares."
    }
  ],
  "suggested_text": "Experimental learning: Office frustration hooks may drive comments on Facebook humor pages. Continue validating with more samples.",
  "requires_luis_approval": false
}
```

State:

```text
UPDATE_PROPOSED
```

---

## Step 2 — Javier Reviews Completeness

Javier checks:

- Target file exists or should exist.
- Update type is valid.
- Evidence is present.
- Confidence is assigned.
- Suggested text is clear.
- No conflict with `CONSTITUTION.md`.
- Whether Luis approval may be required.

Expected output:

```json
{
  "proposal_id": "ku-2026-07-07-001",
  "reviewed_by": "Javier",
  "complete": true,
  "missing_fields": [],
  "possible_conflicts": [],
  "next_step": "Send to Magnus for classification."
}
```

State:

```text
EVIDENCE_REVIEWED
```

---

## Step 3 — Magnus Classifies the Update

Magnus decides whether the update is:

- Experimental.
- Durable.
- Needs more evidence.
- Requires Luis approval.
- Should be rejected.

Expected output:

```json
{
  "proposal_id": "ku-2026-07-07-001",
  "classified_by": "Magnus",
  "classification": "experimental_learning",
  "requires_luis_approval": false,
  "reasoning": "The signal is useful but not yet strong enough to become a durable rule.",
  "approved_for_application": true,
  "next_action_for_javier": "Apply as experimental note in knowledge/viral_hooks.md."
}
```

State:

```text
CLASSIFIED
```

---

# 12. Branch A — No Luis Approval Required

If Magnus decides Luis approval is not required, Javier applies the update or assigns the update operation.

Expected output:

```json
{
  "proposal_id": "ku-2026-07-07-001",
  "status": "APPROVED",
  "approved_by": "Magnus",
  "approval_scope": "operational_knowledge_update",
  "target_file": "knowledge/viral_hooks.md",
  "next_step": "Apply update."
}
```

State transition:

```text
CLASSIFIED → APPROVED → APPLIED
```

---

# 13. Branch B — Luis Approval Required

If the update affects core policy, brand voice, agent authority, or approval flow, Magnus presents it to Luis.

Approval request format:

```json
{
  "request_type": "knowledge_update_approval",
  "proposal_id": "ku-2026-07-07-002",
  "target_file": "knowledge/brand_voice.md",
  "update_type": "REVISE",
  "reason": "Luis repeatedly requested less robotic humor copy.",
  "evidence": [
    "4 approval requests returned with feedback: too robotic.",
    "Rejected drafts used formal phrasing inconsistent with humor voice."
  ],
  "suggested_text": "For viral humor, avoid polished corporate phrasing. Prefer short, casual, human sentences that sound like everyday conversation.",
  "decision_options": [
    "APPROVE",
    "NEEDS_CHANGES",
    "REJECT",
    "DISCARD"
  ]
}
```

Luis decides through Magnus.

State transition:

```text
APPROVAL_REQUIRED → WAITING_FOR_LUIS_DECISION
```

---

# 14. Luis Decision Handling

## APPROVE

Apply the update.

```json
{
  "proposal_id": "ku-2026-07-07-002",
  "decision_from": "Luis",
  "decision": "APPROVE",
  "routed_by": "Magnus",
  "next_step": "Apply update to target file."
}
```

State:

```text
APPROVED → APPLIED
```

## NEEDS_CHANGES

Revise proposal text and present again if needed.

```json
{
  "proposal_id": "ku-2026-07-07-002",
  "decision_from": "Luis",
  "decision": "NEEDS_CHANGES",
  "feedback": "Make the rule shorter and more direct.",
  "next_step": "Revise suggested text."
}
```

State:

```text
NEEDS_CHANGES
```

## REJECT

Do not apply the update.

```json
{
  "proposal_id": "ku-2026-07-07-002",
  "decision_from": "Luis",
  "decision": "REJECT",
  "feedback": "Do not change brand voice yet.",
  "next_step": "Mark proposal rejected."
}
```

State:

```text
REJECTED
```

## DISCARD

Remove proposal from active update workflow.

```json
{
  "proposal_id": "ku-2026-07-07-002",
  "decision_from": "Luis",
  "decision": "DISCARD",
  "next_step": "Archive proposal without applying."
}
```

State:

```text
ARCHIVED
```

---

# 15. Applying the Update

When applying an update, Javier must ensure:

- Correct target file.
- Exact approved text.
- No accidental deletion of existing useful guidance.
- Version or date note is added when useful.
- Update is committed to repository.
- Proposal record is marked applied.

Recommended applied update record:

```json
{
  "proposal_id": "ku-2026-07-07-001",
  "target_file": "knowledge/viral_hooks.md",
  "applied_by": "Javier",
  "approved_by": "Magnus",
  "approval_required_from_luis": false,
  "applied_at": "2026-07-07T15:00:00-06:00",
  "commit_message": "docs: update viral hook learnings"
}
```

---

# 16. Suggested Knowledge Entry Format

For pattern files:

```markdown
## Experimental Learning — Office Frustration Hooks

Status: Experimental  
Confidence: Medium  
Source: Weekly Review 2026-07-07  
Niche: Viral Humor  
Platform: Facebook  

Office frustration hooks may drive comments on Facebook humor pages.

Evidence:
- Office humor posts outperformed generic memes in comments and shares during the review period.

Usage:
- Test short captions based on everyday workplace frustration.
- Avoid targeting specific people or companies.

Review again after:
- At least 8 to 12 comparable posts.
```

For durable learnings:

```markdown
## Durable Learning — Natural CTAs

Status: Durable  
Confidence: High  
Source: Multiple weekly reviews  

Natural CTAs perform better than generic engagement-bait CTAs.

Use:
- "¿A quién le pasó?"
- "Sí o no."
- "Etiqueta a alguien que siempre dice eso."

Avoid:
- "Dale like y comparte para más contenido increíble."
```

---

# 17. Knowledge Conflict Handling

If a proposed update conflicts with existing guidance:

Javier must flag the conflict.

Magnus must decide whether to:

- Reject the update.
- Revise the update.
- Archive old guidance.
- Ask Luis for approval.
- Request more evidence.

Conflict report format:

```json
{
  "proposal_id": "ku-2026-07-07-003",
  "conflict_detected": true,
  "target_file": "knowledge/brand_voice.md",
  "conflicting_section": "Emoji Policy",
  "existing_guidance": "Use emojis moderately.",
  "proposed_guidance": "Avoid emojis completely.",
  "recommendation": "Do not change global policy based on limited data. Add experimental note instead."
}
```

---

# 18. Repository Commit Guidance

Knowledge updates should be committed with clear messages.

Examples:

```bash
git add knowledge/viral_hooks.md
git commit -m "docs: add experimental office humor hook learning"
```

```bash
git add knowledge/brand_voice.md
git commit -m "docs: refine humor voice guidelines"
```

```bash
git add knowledge/facebook_strategy.md
git commit -m "docs: update Facebook posting strategy"
```

---

# 19. Quality Gates

A Knowledge Base update is complete only when:

- Proposal has evidence.
- Confidence is assigned.
- Target file is correct.
- Approval requirement is determined.
- Luis approval is obtained when required.
- Update is applied cleanly.
- The update is traceable.
- The repository is committed.

---

# 20. Final Rule

The Knowledge Base should become smarter, not heavier.

Do not add noise.

Only add guidance that improves future decisions, content quality, safety, or learning.
