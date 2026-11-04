#!/usr/bin/env python3
"""Sync ~/.config/ai-keys/env into fish credentials + environment.d.

Keeps secrets out of the Nix store. Invoked by home-manager activation.
"""

from __future__ import annotations

import os
from pathlib import Path


def fish_quote(value: str) -> str:
    return "'" + value.replace("'", r"'\''") + "'"


def main() -> int:
    home = Path(os.environ.get("HOME", Path.home()))
    ai_keys = home / ".config/ai-keys/env"
    cred_dir = home / ".config/ai-agents"
    env_dir = home / ".config/environment.d"
    cred_fish = cred_dir / "credentials.fish"
    env_link = env_dir / "50-ai-keys.conf"

    cred_dir.mkdir(parents=True, exist_ok=True)
    env_dir.mkdir(parents=True, exist_ok=True)

    if not ai_keys.is_file():
        print(f"NOTE: {ai_keys} missing — create it with KEY=value lines (mode 600).")
        return 0

    keys: dict[str, str] = {}
    order: list[str] = []
    for raw in ai_keys.read_text().splitlines():
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        if line.startswith("export "):
            line = line[7:].strip()
        if "=" not in line:
            continue
        key, val = line.split("=", 1)
        key = key.strip()
        val = val.strip().strip('"').strip("'")
        if not key.isidentifier():
            continue
        if key not in keys:
            order.append(key)
        keys[key] = val

    # Alias Gemini → Google for goose / hermes / pi-compatible tools.
    if "GEMINI_API_KEY" in keys and "GOOGLE_API_KEY" not in keys:
        order.append("GOOGLE_API_KEY")
        keys["GOOGLE_API_KEY"] = keys["GEMINI_API_KEY"]

    lines = [
        "# Generated from ~/.config/ai-keys/env — do not commit",
        "# Sourced by programs.fish (login + interactive).",
    ]
    for key in order:
        lines.append(f"set -gx {key} {fish_quote(keys[key])}")

    cred_fish.write_text("\n".join(lines) + "\n")
    cred_fish.chmod(0o600)

    if env_link.exists() or env_link.is_symlink():
        env_link.unlink()
    env_link.symlink_to("../ai-keys/env")
    print(f"synced AI keys → {cred_fish} and {env_link}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
