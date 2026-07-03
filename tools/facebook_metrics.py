#!/usr/bin/env python3
"""
AI Content Factory — facebook_metrics

Collects Facebook post metrics and writes snapshots to post_metrics.

Usage:
  python tools/facebook_metrics.py --publication-id 501 --collection-window 24h
"""

from __future__ import annotations

import argparse
from decimal import Decimal
from typing import Any, Dict

from db import execute_returning_one, fetch_one
from facebook_client import FacebookAPIError, get as fb_get
from output import error, success


TOOL_NAME = "facebook_metrics"


def _load_publication(publication_id: int) -> Dict[str, Any]:
    row = fetch_one(
        """
        SELECT
          p.id AS publication_id,
          p.external_post_id,
          p.status,
          p.content_post_id
        FROM publications p
        WHERE p.id = %s
        """,
        (publication_id,),
    )
    if not row:
        raise ValueError(f"Publication not found: {publication_id}")
    if not row.get("external_post_id"):
        raise ValueError(f"Publication {publication_id} does not have external_post_id.")
    return row


def _metric_value(insights: Dict[str, Any], metric_name: str) -> int:
    for item in insights.get("data", []):
        if item.get("name") == metric_name:
            values = item.get("values") or []
            if values:
                value = values[-1].get("value", 0)
                if isinstance(value, dict):
                    return int(sum(value.values()))
                return int(value or 0)
    return 0


def _collect(external_post_id: str) -> Dict[str, int]:
    # Facebook metrics availability depends on post type and permissions.
    # These are common page post insights; unavailable metrics default to 0.
    metrics = [
        "post_impressions",
        "post_impressions_unique",
        "post_reactions_by_type_total",
        "post_clicks",
    ]

    insights = fb_get(f"{external_post_id}/insights", {"metric": ",".join(metrics)})

    impressions = _metric_value(insights, "post_impressions")
    reach = _metric_value(insights, "post_impressions_unique")
    reactions = _metric_value(insights, "post_reactions_by_type_total")
    clicks = _metric_value(insights, "post_clicks")

    # Comments and shares may require different endpoints/permissions.
    # These default to 0 unless extended later.
    return {
        "reach": reach,
        "impressions": impressions,
        "likes": reactions,
        "comments": 0,
        "shares": 0,
        "saves": 0,
        "new_followers": 0,
        "video_views": 0,
        "average_watch_time_seconds": 0,
        "retention_rate": 0,
        "engagement_rate": 0,
        "raw_metrics": {
            "insights": insights,
            "clicks": clicks,
            "note": "comments/shares may require additional Graph API endpoints or permissions"
        }
    }


def _engagement_rate(metrics: Dict[str, Any]) -> Decimal:
    reach = int(metrics.get("reach") or 0)
    if reach <= 0:
        return Decimal("0")
    engagements = (
        int(metrics.get("likes") or 0)
        + int(metrics.get("comments") or 0)
        + int(metrics.get("shares") or 0)
        + int(metrics.get("saves") or 0)
    )
    return Decimal(engagements) / Decimal(reach)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--publication-id", type=int, required=True)
    parser.add_argument("--collection-window", required=True, choices=["24h", "72h", "7d"])
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    try:
        pub = _load_publication(args.publication_id)

        if args.dry_run:
            success(TOOL_NAME, {
                "dry_run": True,
                "publication_id": args.publication_id,
                "external_post_id": pub["external_post_id"],
                "collection_window": args.collection_window,
            })
            return

        metrics = _collect(pub["external_post_id"])
        metrics["engagement_rate"] = float(_engagement_rate(metrics))

        row = execute_returning_one(
            """
            INSERT INTO post_metrics (
              publication_id,
              collection_window,
              reach,
              impressions,
              likes,
              comments,
              shares,
              saves,
              new_followers,
              video_views,
              average_watch_time_seconds,
              retention_rate,
              engagement_rate,
              raw_metrics
            )
            VALUES (
              %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s::jsonb
            )
            RETURNING id AS post_metrics_id, collected_at
            """,
            (
                args.publication_id,
                args.collection_window,
                metrics["reach"],
                metrics["impressions"],
                metrics["likes"],
                metrics["comments"],
                metrics["shares"],
                metrics["saves"],
                metrics["new_followers"],
                metrics["video_views"],
                metrics["average_watch_time_seconds"],
                metrics["retention_rate"],
                metrics["engagement_rate"],
                __import__("json").dumps(metrics["raw_metrics"], ensure_ascii=False),
            ),
        )

        success(TOOL_NAME, {
            "publication_id": args.publication_id,
            "post_metrics_id": row.get("post_metrics_id"),
            "collected_at": str(row.get("collected_at")),
            "collection_window": args.collection_window,
            "metrics": metrics,
        })
    except FacebookAPIError as exc:
        error(TOOL_NAME, "external_api_error", str(exc), retry_safe=True,
              recommended_next_action="Check Facebook permissions and retry if safe.")
    except Exception as exc:
        error(TOOL_NAME, "unknown_error", str(exc), retry_safe=False,
              recommended_next_action="Notify Javier and inspect logs.")


if __name__ == "__main__":
    main()
