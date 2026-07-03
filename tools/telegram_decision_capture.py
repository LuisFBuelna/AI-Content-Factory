#!/usr/bin/env python3
"""
AI Content Factory — telegram_decision_capture

Captures Luis's decision and routes it through Magnus/Javier.

This is a CLI-friendly tool for MVP testing. In production, this logic can be
called by a Telegram webhook handler.

Usage:
  python tools/telegram_decision_capture.py --approval-request-id 701 --content-post-id 301 --decision APPROVE
  python tools/telegram_decision_capture.py --approval-request-id 701 --content-post-id 301 --decision NEEDS_CHANGES --feedback "Make it less robotic."
"""

from __future__ import annotations

import argparse

from db import execute_returning_one, fetch_one
from output import error, success


TOOL_NAME = "telegram_decision_capture"

VALID_DECISIONS = {"APPROVE", "NEEDS_CHANGES", "REJECT", "DISCARD"}


def _status_for_decision(decision: str) -> str:
    return {
        "APPROVE": "APPROVED",
        "NEEDS_CHANGES": "NEEDS_CHANGES",
        "REJECT": "REJECTED",
        "DISCARD": "DISCARDED",
    }[decision]


def _content_status_for_decision(decision: str) -> str:
    return {
        "APPROVE": "APPROVED",
        "NEEDS_CHANGES": "NEEDS_CHANGES",
        "REJECT": "REJECTED",
        "DISCARD": "DISCARDED",
    }[decision]


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--approval-request-id", type=int, required=True)
    parser.add_argument("--content-post-id", type=int, required=True)
    parser.add_argument("--decision", required=True, choices=sorted(VALID_DECISIONS))
    parser.add_argument("--feedback", default="")
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    try:
        row = fetch_one(
            """
            SELECT id, content_post_id, status, validated_by, presented_by
            FROM approval_requests
            WHERE id = %s AND content_post_id = %s
            """,
            (args.approval_request_id, args.content_post_id),
        )
        if not row:
            raise ValueError("Approval request not found.")
        if row.get("validated_by") != "Javier":
            raise ValueError("Approval request must be validated by Javier.")
        if row.get("presented_by") != "Magnus":
            raise ValueError("Approval request must be presented by Magnus.")

        approval_status = _status_for_decision(args.decision)
        content_status = _content_status_for_decision(args.decision)

        if args.dry_run:
            success(TOOL_NAME, {
                "dry_run": True,
                "approval_request_id": args.approval_request_id,
                "content_post_id": args.content_post_id,
                "decision": args.decision,
                "would_set_approval_status": approval_status,
                "would_set_content_status": content_status,
            })
            return

        updated = execute_returning_one(
            """
            UPDATE approval_requests
            SET
              status = %s,
              decision = %s,
              decided_by = 'Luis',
              decision_routed_by = 'Magnus',
              decided_at = NOW(),
              routed_at = NOW(),
              feedback = %s,
              updated_at = NOW()
            WHERE id = %s AND content_post_id = %s
            RETURNING id, status, decision, decided_by, decision_routed_by, decided_at, routed_at
            """,
            (approval_status, args.decision, args.feedback, args.approval_request_id, args.content_post_id),
        )

        execute_returning_one(
            """
            UPDATE content_posts
            SET status = %s, updated_at = NOW()
            WHERE id = %s
            RETURNING id
            """,
            (content_status, args.content_post_id),
        )

        success(TOOL_NAME, {
            "approval_request_id": args.approval_request_id,
            "content_post_id": args.content_post_id,
            "decision_from": "Luis",
            "decision": args.decision,
            "approval_status": approval_status,
            "decision_routed_by": "Magnus",
            "validated_by": "Javier",
            "feedback": args.feedback,
            "updated": updated,
        })
    except Exception as exc:
        error(TOOL_NAME, "unknown_error", str(exc), retry_safe=False,
              recommended_next_action="Notify Magnus/Javier and inspect approval route.")


if __name__ == "__main__":
    main()
