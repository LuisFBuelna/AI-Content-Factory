#!/usr/bin/env python3
"""
AI Content Factory — Facebook Graph API Client
"""

from __future__ import annotations

from typing import Any, Dict, Optional

import requests

from config import get_facebook_config


class FacebookAPIError(RuntimeError):
    pass


def _base_url() -> str:
    cfg = get_facebook_config()
    return f"https://graph.facebook.com/{cfg.graph_api_version}"


def _token() -> str:
    return get_facebook_config().page_access_token


def post(endpoint: str, data: Dict[str, Any]) -> Dict[str, Any]:
    payload = dict(data)
    payload["access_token"] = _token()

    url = f"{_base_url()}/{endpoint.lstrip('/')}"
    response = requests.post(url, data=payload, timeout=30)

    try:
        body = response.json()
    except Exception:
        body = {"raw": response.text}

    if response.status_code >= 400 or "error" in body:
        raise FacebookAPIError(f"Facebook API error: {body}")

    return body


def get(endpoint: str, params: Optional[Dict[str, Any]] = None) -> Dict[str, Any]:
    query = dict(params or {})
    query["access_token"] = _token()

    url = f"{_base_url()}/{endpoint.lstrip('/')}"
    response = requests.get(url, params=query, timeout=30)

    try:
        body = response.json()
    except Exception:
        body = {"raw": response.text}

    if response.status_code >= 400 or "error" in body:
        raise FacebookAPIError(f"Facebook API error: {body}")

    return body
