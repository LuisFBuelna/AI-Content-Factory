#!/usr/bin/env python3
"""
AI Content Factory — facebook_publish

Publishes an approved content post to Facebook.

Usage:
  python tools/facebook_publish.py --content-post-id 301 --approval-request-id 701

This tool validates:
  - approval_status = APPROVED
  - decision = APPROVE
  - decided_by = Luis
  - decision_routed_by = Magnus
  - validated_by = Javier
  - approval_request.content_version = content_post.content_version
"""

from __future__ import annotations

import argparse
from typing import Any, Dict, Optional

from approval import ApprovalValidationError, validate_approval_for_publication
from config import get_facebook_config
from db import execute_returning_one, fetch_one
from facebook_client import FacebookAPIError, post as fb_post
from output import error, success


TOOL_NAME = "facebook_publish"


def _get_media_asset(content_post_id: int) -> Optional[Dict[str, Any]]:
    return fetch_one(
        """
        SELECT id, asset_type, storage_url, storage_path, status
        FROM media_assets
        WHERE content_post_id = %s
          AND asset_type IN ('image', 'video')
          AND status IN ('GENERATED', 'APPROVED', 'USED')
        ORDER BY created_at DESC
        LIMIT 1
        """,
        (content_post_id,),
    )


def _compose_message(post_copy: str, call_to_action: Optional[str], hashtags: Any) -> str:
    parts = [post_copy.strip()]
    if call_to_action:
        parts.append(call_to_action.strip())

    if hashtags:
        if isinstance(hashtags, list):
            parts.append(" ".join(str(tag) for tag in hashtags))
        else:
            parts.append(str(hashtags))

    return "\n\n".join(part for part in parts if part)


def _publish_to_facebook(ctx: Dict[str, Any], dry_run: bool) -> Dict[str, Any]:
    cfg = get_facebook_config()
    media = _get_media_asset(ctx["content_post_id"])
    message = _compose_message(ctx.get("post_copy") or "", ctx.get("call_to_action"), ctx.get("hashtags"))

    if not message:
        raise ValueError("post_copy is empty; cannot publish.")

    if dry_run:
        return {
            "dry_run": True,
            "would_publish_to_page_id": cfg.page_id,
            "content_post_id": ctx["content_post_id"],
            "approval_request_id": ctx["approval_request_id"],
            "message_preview": message[:500],
            "media_asset": media,
        }

    # For image posts with a public image URL, use /photos.
    # For text-only posts, use /feed.
    if media and media.get("asset_type") == "image" and media.get("storage_url"):
        result = fb_post(
            f"{cfg.page_id}/photos",
            {
                "url": media["storage_url"],
                "caption": message,
                "published": "true",
            },
        )
        external_post_id = result.get("post_id") or result.get("id")
    else:
        result = fb_post(
            f"{cfg.page_id}/feed",
            {
                "message": message,
            },
        )
        external_post_id = result.get("id")

    if not external_post_id:
        raise FacebookAPIError(f"Facebook response did not include post id: {result}")

    external_url = f"https://facebook.com/{external_post_id}"

    pub = execute_returning_one(
        """
        INSERT INTO publications (
          content_post_id,
          approval_request_id,
          social_page_id,
          platform_id,
          status,
          published_at,
          external_post_id,
          external_post_url,
          publication_action,
          published_by_agent,
          metadata
        )
        SELECT
          cp.id,
          %s,
          cp.social_page_id,
          sp.platform_id,
          'PUBLISHED',
          NOW(),
          %s,
          %s,
          'publish_now',
          'Damian',
          %s::jsonb
        FROM content_posts cp
        JOIN social_pages sp ON sp.id = cp.social_page_id
        WHERE cp.id = %s
        RETURNING id AS publication_id
        """,
        (
            ctx["approval_request_id"],
            external_post_id,
            external_url,
            '{"source_tool":"facebook_publish"}',
            ctx["content_post_id"],
        ),
    )

    execute_returning_one(
        """
        UPDATE content_posts
        SET status = 'PUBLISHED', updated_at = NOW()
        WHERE id = %s
        RETURNING id
        """,
        (ctx["content_post_id"],),
    )

    if media:
        execute_returning_one(
            """
            UPDATE media_assets
            SET status = 'USED'
            WHERE id = %s
            RETURNING id
            """,
            (media["id"],),
        )

    return {
        "publication_id": pub.get("publication_id"),
        "content_post_id": ctx["content_post_id"],
        "approval_request_id": ctx["approval_request_id"],
        "external_post_id": external_post_id,
        "external_post_url": external_url,
        "media_asset": media,
        "facebook_response": result,
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--content-post-id", type=int, required=True)
    parser.add_argument("--approval-request-id", type=int, required=True)
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    try:
        ctx = validate_approval_for_publication(args.content_post_id, args.approval_request_id)
        data = _publish_to_facebook(ctx, dry_run=args.dry_run)
        success(TOOL_NAME, data)
    except ApprovalValidationError as exc:
        error(TOOL_NAME, "invalid_approval_route", str(exc), retry_safe=False,
              recommended_next_action="Ask Javier to validate approval route through Magnus.")
    except FacebookAPIError as exc:
        error(TOOL_NAME, "external_api_error", str(exc), retry_safe=True,
              recommended_next_action="Check Facebook API response, token permissions, and retry if safe.")
    except Exception as exc:
        error(TOOL_NAME, "unknown_error", str(exc), retry_safe=False,
              recommended_next_action="Notify Javier and inspect logs.")


if __name__ == "__main__":
    main()
