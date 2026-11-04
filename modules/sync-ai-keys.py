#!/usr/bin/env python3
"""Sync ~/.config/ai-keys/env into shell credentials + environment.d.

Keeps secrets out of the Nix store. Invoked by home-manager activation.
Writes:
  ~/.config/ai-agents/credentials.fish
  ~/.config/ai-agents/credentials.zsh
  ~/.config/environment.d/50-ai-keys.conf -> ../ai-keys/env
"""

from __future__ import annotations

import os
from pathlib import Path


def shell_single_quote(value: str) -> str:
    """Quote for both fish `set -gx` and zsh/bash `export`."""
    return "'" + value.replace("'", r"'\''") + "'"


def load_keys(ai_keys: Path) -> tuple[dict[str, str], list[str]]:
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

    return keys, order


def main() -> int:
    home = Path(os.environ.get("HOME", Path.home()))
    ai_keys = home / ".config/ai-keys/env"
    cred_dir = home / ".config/ai-agents"
    env_dir = home / ".config/environment.d"
    cred_fish = cred_dir / "credentials.fish"
    cred_zsh = cred_dir / "credentials.zsh"
    env_link = env_dir / "50-ai-keys.conf"

    cred_dir.mkdir(parents=True, exist_ok=True)
    env_dir.mkdir(parents=True, exist_ok=True)

    if not ai_keys.is_file():
        print(f"NOTE: {ai_keys} missing — create it with KEY=value lines (mode 600).")
        return 0

    keys, order = load_keys(ai_keys)

    fish_lines = [
        "# Generated from ~/.config/ai-keys/env — do not commit",
        "# Sourced by programs.fish (login + interactive).",
    ]
    zsh_lines = [
        "# Generated from ~/.config/ai-keys/env — do not commit",
        "# Sourced by programs.zsh (.zshenv + .zshrc).",
    ]
    for key in order:
        quoted = shell_single_quote(keys[key])
        fish_lines.append(f"set -gx {key} {quoted}")
        zsh_lines.append(f"export {key}={quoted}")

    for path, lines in ((cred_fish, fish_lines), (cred_zsh, zsh_lines)):
        path.write_text("\n".join(lines) + "\n")
        path.chmod(0o600)

    if env_link.exists() or env_link.is_symlink():
        env_link.unlink()
    env_link.symlink_to("../ai-keys/env")
    print(f"synced AI keys → {cred_fish}, {cred_zsh}, and {env_link}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
