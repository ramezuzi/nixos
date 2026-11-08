#!/usr/bin/env python3
"""Sync AI API keys into shell credentials + environment.d.

Source resolution order:
  1. $SOPS_AI_KEYS (explicit override)
  2. /run/secrets/ai-keys-env (sops-nix decrypted secret)
  3. ~/.config/ai-keys/env (legacy plaintext fallback)

Keeps secrets out of the Nix store. Invoked by home-manager activation.
Writes:
  ~/.config/ai-agents/credentials.fish
  ~/.config/ai-agents/credentials.zsh
  ~/.config/environment.d/50-ai-keys.conf -> resolved source
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

    # Tools that expect the same upstream key under their own variable name.
    aliases = {
        "OPENCODE_ZEN_API_KEY": "OPENCODE_API_KEY",
        "HAX_ANTHROPIC_API_KEY": "OPENROUTER_API_KEY",
    }
    for alias, source in aliases.items():
        if source in keys and alias not in keys:
            order.append(alias)
            keys[alias] = keys[source]

    return keys, order


def resolve_source(home: Path) -> Path | None:
    override = os.environ.get("SOPS_AI_KEYS")
    if override:
        path = Path(override).expanduser()
        return path if path.is_file() else None

    sops_secret = Path("/run/secrets/ai-keys-env")
    if sops_secret.is_file():
        return sops_secret

    legacy = home / ".config/ai-keys/env"
    return legacy if legacy.is_file() else None


def main() -> int:
    home = Path(os.environ.get("HOME", Path.home()))
    cred_dir = home / ".config/ai-agents"
    env_dir = home / ".config/environment.d"
    cred_fish = cred_dir / "credentials.fish"
    cred_zsh = cred_dir / "credentials.zsh"
    env_link = env_dir / "50-ai-keys.conf"

    cred_dir.mkdir(parents=True, exist_ok=True)
    env_dir.mkdir(parents=True, exist_ok=True)

    ai_keys = resolve_source(home)
    if ai_keys is None:
        print(
            "NOTE: no AI key source found — expected /run/secrets/ai-keys-env "
            "(sops-nix) or ~/.config/ai-keys/env (mode 600)."
        )
        return 0

    keys, order = load_keys(ai_keys)

    fish_lines = [
        f"# Generated from {ai_keys} — do not commit",
        "# Sourced by programs.fish (login + interactive).",
    ]
    zsh_lines = [
        f"# Generated from {ai_keys} — do not commit",
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
    if ai_keys.is_absolute() and not ai_keys.is_relative_to(home):
        env_link.symlink_to(ai_keys)
    else:
        env_link.symlink_to(os.path.relpath(ai_keys, env_dir))
    print(f"synced AI keys ({ai_keys}) → {cred_fish}, {cred_zsh}, and {env_link}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
