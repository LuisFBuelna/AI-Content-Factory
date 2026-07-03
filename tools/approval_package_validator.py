#!/usr/bin/env python3
"""
AI Content Factory — approval_package_validator

Validates an approval package as Javier.

Usage:
  python tools/approval_package_validator.py --approval-request-id 701 --content-post-id 301
"""

from __future__ import annotations

import argparse

from db import execute_returning_one, fetch_one
from output import error, success


TOOL_NAME = "approval_package_validator"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--approval-request-id", type=int, required=True)
    parser.add_argument("--content-post-id", type=int, required=True)
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    try:
        row = fetch_one(
            """
            SELECT
              ar.id,
              ar.status,
              ar.content_version AS approval_content_version,
              ar.approval_package,
              cp.content_version AS current_content_version
            FROM approval_requests ar
            JOIN content_posts cp ON cp.id = ar.content_post_id
            WHERE ar.id = %s AND ar.content_post_id = %s
            """,
            (args.approval_request_id, args.content_post_id),
        )

        if not row:
            raise ValueError("Approval request not found.")
        if row.get("status") != "PREPARED":
            raise ValueError(f"Approval request must be PREPARED, got {row.get('status')}")
        if row.get("approval_content_version") != row.get("current_content_version"):
            raise ValueError("Approval package content version does not match current content version.")

        package = row.get("approval_package") or {}
        required = ["page", "platform", "content_type", "niche", "hook", "post_copy", "call_to_action", "hashtags", "media", "scheduled_time", "approval_options"]
        missing = [field for field in required if field not in package or package.get(field) in (None, "")]
        if missing:
            raise ValueError(f"Approval package missing required fields: {missing}")

        if args.dry_run:
            success(TOOL_NAME, {
                "dry_run": True,
                "approval_request_id": args.approval_request_id,
                "content_post_id": args.content_post_id,
                "would_set_status": "VALIDATED",
                "validated_by": "Javier",
            })
            return

        updated = execute_returning_one(
            """
            UPDATE approval_requests
            SET status = 'VALIDATED', validated_by = 'Javier', validated_at = NOW(), updated_at = NOW()
            WHERE id = %s
            RETURNING id, status, validated_by, validated_at
            """,
            (args.approval_request_id,),
        )

        execute_returning_one(
            """
            UPDATE content_posts
            SET status = 'READY_FOR_MAGNUS_REVIEW', updated_at = NOW()
            WHERE id = %s
            RETURNING id
            """,
            (args.content_post_id,),
        )

        success(TOOL_NAME, {
            "approval_request_id": args.approval_request_id,
            "content_post_id": args.content_post_id,
            "valid": True,
            "ready_for_magnus": True,
            "updated": updated,
        })
    except Exception as exc:
        error(TOOL_NAME, "validation_error", str(exc), retry_safe=False,
              recommended_next_action="Return approval package to Damian or content draft to Elena.")


if __name__ == "__main__":
    main()
