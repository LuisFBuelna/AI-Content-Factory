#!/usr/bin/env python3
"""
AI Content Factory — telegram_approval

Sends a CEO approval request to Luis through Telegram.

Usage:
  python tools/telegram_approval.py --approval-request-id 701 --content-post-id 301

Only Magnus should invoke this tool in the default operating model.
"""

from __future__ import annotations

import argparse
from typing import Any, Dict

import requests

from config import get_telegram_config
from db import execute_returning_one, fetch_one
from output import error, success


TOOL_NAME = "telegram_approval"


def _load_package(approval_request_id: int, content_post_id: int) -> Dict[str, Any]:
    row = fetch_one(
        """
        SELECT
          ar.id AS approval_request_id,
          ar.content_post_id,
          ar.status,
          ar.validated_by,
          ar.approval_package,
          cp.content_version,
          cp.title,
          cp.hook,
          cp.post_copy,
          cp.call_to_action,
          cp.hashtags,
          cp.platform_content_type
        FROM approval_requests ar
        JOIN content_posts cp ON cp.id = ar.content_post_id
        WHERE ar.id = %s AND ar.content_post_id = %s
        """,
        (approval_request_id, content_post_id),
    )
    if not row:
        raise ValueError("Approval request not found.")
    if row.get("status") not in ("VALIDATED", "PRESENTED", "PENDING"):
        raise ValueError(f"Approval request must be VALIDATED/PRESENTED/PENDING, got {row.get('status')}")
    if row.get("validated_by") != "Javier":
        raise ValueError(f"Approval request must be validated by Javier, got {row.get('validated_by')}")
    return row


def _build_message(row: Dict[str, Any]) -> str:
    package = row.get("approval_package") or {}

    page = package.get("page", "")
    platform = package.get("platform", "facebook")
    content_type = package.get("content_type", row.get("platform_content_type", ""))
    niche = package.get("niche", "")
    hook = package.get("hook", row.get("hook") or "")
    copy = package.get("post_copy", row.get("post_copy") or "")
    cta = package.get("call_to_action", row.get("call_to_action") or "")
    hashtags = package.get("hashtags", row.get("hashtags") or [])
    media = package.get("media", {})
    media_prompt = media.get("media_prompt") or package.get("media_prompt", "")
    scheduled_time = package.get("scheduled_time", "")
    risk_notes = package.get("risk_notes", [])
    strategic_reason = package.get("strategic_reason", "")

    if isinstance(hashtags, list):
        hashtags_text = " ".join(str(tag) for tag in hashtags)
    else:
        hashtags_text = str(hashtags)

    risk_text = "None" if not risk_notes else "\n".join(f"- {r}" for r in risk_notes)

    return f"""📌 Publication proposal ready

Page: {page}
Platform: {platform}
Type: {content_type}
Niche: {niche}

Hook:
{hook}

Copy:
{copy}

CTA:
{cta}

Hashtags:
{hashtags_text}

Media:
{media_prompt}

Scheduled time:
{scheduled_time}

Strategic reason:
{strategic_reason}

Risk notes:
{risk_text}

Decision options:
APPROVE / NEEDS_CHANGES / REJECT / DISCARD
"""


def _send_telegram(message: str, approval_request_id: int, content_post_id: int, dry_run: bool) -> Dict[str, Any]:
    cfg = get_telegram_config()

    keyboard = {
        "inline_keyboard": [
            [
                {"text": "✅ APPROVE", "callback_data": f"APPROVE:{approval_request_id}:{content_post_id}"},
                {"text": "✏️ CHANGES", "callback_data": f"NEEDS_CHANGES:{approval_request_id}:{content_post_id}"}
            ],
            [
                {"text": "❌ REJECT", "callback_data": f"REJECT:{approval_request_id}:{content_post_id}"},
                {"text": "🗑 DISCARD", "callback_data": f"DISCARD:{approval_request_id}:{content_post_id}"}
            ]
        ]
    }

    if dry_run:
        return {
            "dry_run": True,
            "chat_id": cfg.luis_chat_id,
            "message": message,
            "reply_markup": keyboard,
        }

    url = f"https://api.telegram.org/bot{cfg.bot_token}/sendMessage"
    response = requests.post(
        url,
        json={
            "chat_id": cfg.luis_chat_id,
            "text": message,
            "reply_markup": keyboard,
        },
        timeout=30,
    )
    body = response.json()

    if response.status_code >= 400 or not body.get("ok"):
        raise RuntimeError(f"Telegram API error: {body}")

    message_id = str(body["result"]["message_id"])

    execute_returning_one(
        """
        UPDATE approval_requests
        SET
          status = 'PENDING',
          presented_by = 'Magnus',
          presented_at = NOW(),
          external_message_id = %s,
          updated_at = NOW()
        WHERE id = %s
        RETURNING id
        """,
        (message_id, approval_request_id),
    )

    execute_returning_one(
        """
        UPDATE content_posts
        SET status = 'WAITING_FOR_LUIS_DECISION', updated_at = NOW()
        WHERE id = %s
        RETURNING id
        """,
        (content_post_id,),
    )

    return {
        "approval_request_id": approval_request_id,
        "content_post_id": content_post_id,
        "telegram_message_id": message_id,
        "telegram_response": body,
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--approval-request-id", type=int, required=True)
    parser.add_argument("--content-post-id", type=int, required=True)
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    try:
        row = _load_package(args.approval_request_id, args.content_post_id)
        message = _build_message(row)
        data = _send_telegram(message, args.approval_request_id, args.content_post_id, args.dry_run)
        success(TOOL_NAME, data)
    except Exception as exc:
        error(TOOL_NAME, "unknown_error", str(exc), retry_safe=False,
              recommended_next_action="Notify Javier/Magnus and inspect logs.")


if __name__ == "__main__":
    main()
