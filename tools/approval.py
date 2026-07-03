#!/usr/bin/env python3
"""
AI Content Factory — Approval Validation Helpers
"""

from __future__ import annotations

from typing import Any, Dict, Optional

from config import get_safety_config
from db import fetch_one


class ApprovalValidationError(RuntimeError):
    pass


def load_approval_context(content_post_id: int, approval_request_id: int) -> Dict[str, Any]:
    row = fetch_one(
        """
        SELECT
          cp.id AS content_post_id,
          cp.content_version AS current_content_version,
          cp.status AS content_status,
          cp.social_page_id,
          cp.platform_content_type,
          cp.post_copy,
          cp.call_to_action,
          cp.hashtags,
          cp.image_prompt,
          cp.video_prompt,
          cp.scheduled_time AS content_scheduled_time,
          ar.id AS approval_request_id,
          ar.status AS approval_status,
          ar.decision,
          ar.decided_by,
          ar.decision_routed_by,
          ar.validated_by,
          ar.content_version AS approval_content_version,
          ar.approval_package,
          ar.feedback
        FROM content_posts cp
        JOIN approval_requests ar ON ar.content_post_id = cp.id
        WHERE cp.id = %s AND ar.id = %s
        """,
        (content_post_id, approval_request_id),
    )
    if not row:
        raise ApprovalValidationError(
            f"No approval context found for content_post_id={content_post_id}, "
            f"approval_request_id={approval_request_id}"
        )
    return row


def validate_approval_for_publication(content_post_id: int, approval_request_id: int) -> Dict[str, Any]:
    cfg = get_safety_config()
    ctx = load_approval_context(content_post_id, approval_request_id)

    if not cfg.require_approval:
        return ctx

    errors = []

    if ctx.get("approval_status") != "APPROVED":
        errors.append(f"approval_status must be APPROVED, got {ctx.get('approval_status')}")

    if ctx.get("decision") != "APPROVE":
        errors.append(f"decision must be APPROVE, got {ctx.get('decision')}")

    if ctx.get("decided_by") != cfg.approved_by:
        errors.append(f"decided_by must be {cfg.approved_by}, got {ctx.get('decided_by')}")

    if ctx.get("decision_routed_by") != cfg.routed_by:
        errors.append(f"decision_routed_by must be {cfg.routed_by}, got {ctx.get('decision_routed_by')}")

    if ctx.get("validated_by") != cfg.validated_by:
        errors.append(f"validated_by must be {cfg.validated_by}, got {ctx.get('validated_by')}")

    if ctx.get("approval_content_version") != ctx.get("current_content_version"):
        errors.append(
            "approval content_version does not match current content_version "
            f"({ctx.get('approval_content_version')} != {ctx.get('current_content_version')})"
        )

    if errors:
        raise ApprovalValidationError("; ".join(errors))

    return ctx
