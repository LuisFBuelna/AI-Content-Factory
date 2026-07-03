#!/usr/bin/env python3
"""
AI Content Factory — JSON Output Helpers
"""

from __future__ import annotations

import json
import sys
from typing import Any, Dict, Optional


def success(tool_name: str, data: Dict[str, Any], warnings: Optional[list] = None) -> None:
    print(json.dumps({
        "status": "success",
        "tool_name": tool_name,
        "data": data,
        "warnings": warnings or [],
        "errors": []
    }, ensure_ascii=False, indent=2))


def error(
    tool_name: str,
    error_type: str,
    message: str,
    retry_safe: bool = False,
    recommended_next_action: str = "",
    data: Optional[Dict[str, Any]] = None,
    warnings: Optional[list] = None,
    exit_code: int = 1
) -> None:
    print(json.dumps({
        "status": "error",
        "tool_name": tool_name,
        "error": {
            "type": error_type,
            "message": message,
            "retry_safe": retry_safe,
            "recommended_next_action": recommended_next_action
        },
        "data": data or {},
        "warnings": warnings or []
    }, ensure_ascii=False, indent=2))
    sys.exit(exit_code)
