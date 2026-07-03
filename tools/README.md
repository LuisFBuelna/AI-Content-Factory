# AI Content Factory — Python Tools

These are local deterministic Python tools for the MVP.

They allow agents to trigger real actions while keeping critical validation inside code.

---

## Tools included

```text
config.py
db.py
approval.py
facebook_client.py
approval_package_builder.py
approval_package_validator.py
telegram_approval.py
telegram_decision_capture.py
facebook_publish.py
facebook_schedule.py
facebook_metrics.py
```

---

## Install dependencies

```bash
pip install -r tools/requirements.txt
```

---

## Required environment

Load `.env.production` before running tools.

Example:

```bash
set -a
source .env.production
set +a
```

---

## Approval flow

Normal approval flow:

```text
Damian → approval_package_builder.py
Javier → approval_package_validator.py
Magnus → telegram_approval.py
Magnus → telegram_decision_capture.py
Damian → facebook_publish.py or facebook_schedule.py
Damian → facebook_metrics.py
```

---

## Example commands

Build approval package:

```bash
python tools/approval_package_builder.py \
  --content-post-id 301 \
  --page-name "Viral Humor Page" \
  --platform facebook \
  --niche viral_humor \
  --scheduled-time "2026-07-03T20:00:00-06:00"
```

Validate package:

```bash
python tools/approval_package_validator.py \
  --approval-request-id 701 \
  --content-post-id 301
```

Send approval request to Luis through Magnus:

```bash
python tools/telegram_approval.py \
  --approval-request-id 701 \
  --content-post-id 301
```

Capture Luis decision manually for MVP testing:

```bash
python tools/telegram_decision_capture.py \
  --approval-request-id 701 \
  --content-post-id 301 \
  --decision APPROVE
```

Publish:

```bash
python tools/facebook_publish.py \
  --content-post-id 301 \
  --approval-request-id 701
```

Collect metrics:

```bash
python tools/facebook_metrics.py \
  --publication-id 501 \
  --collection-window 24h
```

---

## Safety

`facebook_publish.py` and `facebook_schedule.py` validate:

```text
approval_status = APPROVED
decision = APPROVE
decided_by = Luis
decision_routed_by = Magnus
validated_by = Javier
approval_request.content_version = content_post.content_version
```

If any condition fails, publication is blocked.
