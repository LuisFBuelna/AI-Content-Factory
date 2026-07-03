#!/usr/bin/env python3
"""
AI Content Factory — Tool Configuration

Shared environment configuration for local Python tools.

Required production file:
  /opt/ai-content-factory/.env.production

These tools read environment variables directly. Load them with your shell,
Docker, OpenClaw runtime, or a process manager.
"""

from __future__ import annotations

import os
from dataclasses import dataclass


class ConfigError(RuntimeError):
    pass


def _required(name: str) -> str:
    value = os.getenv(name)
    if value is None or value.strip() == "":
        raise ConfigError(f"Missing required environment variable: {name}")
    return value.strip()


def _optional(name: str, default: str = "") -> str:
    value = os.getenv(name)
    if value is None:
        return default
    return value.strip()


@dataclass(frozen=True)
class DatabaseConfig:
    host: str
    port: int
    db: str
    user: str
    password: str


@dataclass(frozen=True)
class FacebookConfig:
    graph_api_version: str
    page_id: str
    page_access_token: str


@dataclass(frozen=True)
class TelegramConfig:
    bot_token: str
    luis_chat_id: str


@dataclass(frozen=True)
class SafetyConfig:
    require_approval: bool
    approved_by: str
    routed_by: str
    validated_by: str


def get_database_config() -> DatabaseConfig:
    return DatabaseConfig(
        host=_required("POSTGRES_HOST"),
        port=int(_optional("POSTGRES_PORT", "5432")),
        db=_required("POSTGRES_DB"),
        user=_required("POSTGRES_USER"),
        password=_required("POSTGRES_PASSWORD"),
    )


def get_facebook_config() -> FacebookConfig:
    return FacebookConfig(
        graph_api_version=_optional("FACEBOOK_GRAPH_API_VERSION", "v20.0"),
        page_id=_required("FACEBOOK_PAGE_ID"),
        page_access_token=_required("FACEBOOK_PAGE_ACCESS_TOKEN"),
    )


def get_telegram_config() -> TelegramConfig:
    return TelegramConfig(
        bot_token=_required("TELEGRAM_BOT_TOKEN"),
        luis_chat_id=_required("TELEGRAM_LUIS_CHAT_ID"),
    )


def get_safety_config() -> SafetyConfig:
    return SafetyConfig(
        require_approval=_optional("PUBLISHING_REQUIRE_APPROVAL", "true").lower() == "true",
        approved_by=_optional("PUBLISHING_REQUIRE_APPROVED_BY", "Luis"),
        routed_by=_optional("PUBLISHING_REQUIRE_APPROVAL_ROUTED_BY", "Magnus"),
        validated_by=_optional("PUBLISHING_REQUIRE_VALIDATED_BY", "Javier"),
    )
