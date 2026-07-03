#!/usr/bin/env python3
"""
AI Content Factory — approval_package_builder

Builds an approval_request from an existing content_post.

Usage:
  python tools/approval_package_builder.py --content-post-id 301 --page-name "Viral Humor Page" --platform facebook --niche viral_humor --scheduled-time "2026-07-03T20:00:00-06:00"
"""

from __future__ import annotations

import argparse
import json
from typing import Any, Dict, Optional

from db import execute_returning_one, fetch_one
from output import error, success


TOOL_NAME = "approval_package_builder"


def _latest_media(content_post_id: int) -> Optional[Dict[str, Any]]:
    return fetch_one(
        """
        SELECT id AS media_asset_id, asset_type, storage_url AS media_url, prompt AS media_prompt, status
        FROM media_assets
        WHERE content_post_id = %s
        ORDER BY created_at DESC
        LIMIT 1
        """,
        (content_post_id,),
    )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--content-post-id", type=int, required=True)
    parser.add_argument("--page-name", required=True)
    parser.add_argument("--platform", default="facebook")
    parser.add_argument("--niche", required=True)
    parser.add_argument("--scheduled-time", default="")
    parser.add_argument("--strategic-reason", default="")
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    try:
        cp = fetch_one(
            """
            SELECT
              id,
              content_version,
              platform_content_type,
              title,
              hook,
              post_copy,
              call_to_action,
              hashtags,
              image_prompt,
              video_prompt,
              status
            FROM content_posts
            WHERE id = %s
            """,
            (args.content_post_id,),
        )

        if not cp:
            raise ValueError(f"content_post not found: {args.content_post_id}")

        media = _latest_media(args.content_post_id) or {
            "media_asset_id": "",
            "media_url": "",
            "media_prompt": cp.get("image_prompt") or cp.get("video_prompt") or "",
        }

        package = {
            "page": args.page_name,
            "platform": args.platform,
            "content_type": cp.get("platform_content_type"),
            "niche": args.niche,
            "hook": cp.get("hook"),
            "post_copy": cp.get("post_copy"),
            "call_to_action": cp.get("call_to_action"),
            "hashtags": cp.get("hashtags") or [],
            "media": media,
            "scheduled_time": args.scheduled_time,
            "strategic_reason": args.strategic_reason,
            "risk_notes": [],
            "approval_options": ["APPROVE", "NEEDS_CHANGES", "REJECT", "DISCARD"],
        }

        if args.dry_run:
            success(TOOL_NAME, {
                "dry_run": True,
                "content_post_id": args.content_post_id,
                "content_version": cp.get("content_version"),
                "approval_package": package,
            })
            return

        row = execute_returning_one(
            """
            INSERT INTO approval_requests (
              content_post_id,
              content_version,
              status,
              decision,
              prepared_by,
              approval_package
            )
            VALUES (%s, %s, 'PREPARED', NULL, 'Damian', %s::jsonb)
            RETURNING id AS approval_request_id, status
            """,
            (args.content_post_id, cp.get("content_version"), json.dumps(package, ensure_ascii=False)),
        )

        execute_returning_one(
            """
            UPDATE content_posts
            SET status = 'READY_FOR_APPROVAL_PACKAGE', updated_at = NOW()
            WHERE id = %s
            RETURNING id
            """,
            (args.content_post_id,),
        )

        success(TOOL_NAME, {
            "approval_request_id": row.get("approval_request_id"),
            "content_post_id": args.content_post_id,
            "content_version": cp.get("content_version"),
            "prepared_by": "Damian",
            "prepared_for": "Magnus",
            "route_through": "Javier",
            "approval_package": package,
            "status": row.get("status"),
        })
    except Exception as exc:
        error(TOOL_NAME, "unknown_error", str(exc), retry_safe=False,
              recommended_next_action="Notify Javier and inspect content_post completeness.")


if __name__ == "__main__":
    main()
