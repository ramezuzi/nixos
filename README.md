# NixOS configuration

Dendritic NixOS + Home Manager flake for `zbook`, organized after the
[voidarc/nixos](https://git.voidarc.co.uk/voidarc/nixos) layout.

## Layout

```text
modules/
├── attrs/       # composition bundles: import features/system modules
│   ├── desktop/
│   ├── development/
│   └── system/
├── features/    # one directory per app/tool; config lives with its module
│   ├── agents/
│   ├── cli/
│   ├── hyprland/
│   ├── mango/
│   ├── niri/
│   ├── sops/    # encrypted secrets live here too
│   └── ...
├── system/
│   ├── audio/
│   ├── core/        # boot, locale, nix, users, Home Manager bridge
│   ├── desktop/     # display manager, xwayland, live config links
│   ├── drivers/     # keyboard, laptop hardware
│   ├── network/
│   ├── nix-ld/
│   ├── services/    # printing, podman, libvirt, bluetooth/power services
│   └── systemTheme/ # stylix + fonts
├── hosts/
│   └── zbook/       # host composition + hardware config
└── parts.nix
```

### How it fits together

- `modules/features/*/default.nix` exports the feature's NixOS and/or Home
  Manager modules.  Anything the feature needs (config files, helper scripts,
  encrypted secrets) stays in that directory.
- `modules/system/*` contains machine services and options, not app bundles.
- `modules/attrs/*/default.nix` are the only composition points.  They import
  modules through `self.nixosModules`, not relative paths.
- `modules/hosts/zbook/default.nix` explicitly selects the attribute bundles
  it wants.  New NixOS modules are therefore not picked up by accident.
- Home Manager modules are still collected automatically by
  `modules/system/core/home.nix` via `config.flake.homeModules`.

## Rebuild

The flake only sees files tracked by git.  Always stage changes first:

```bash
cd ~/nixos
git add -A
sudo nixos-rebuild switch --flake ~/nixos#zbook
```

Build without switching:

```bash
nix build .#nixosConfigurations.zbook.config.system.build.toplevel --no-link
```

## Live-editable configs

`~/.config/niri` and `~/.config/mango` are out-of-store symlinks to
`modules/features/niri/config` and `modules/features/mango/config`.  Edits made
with NiriMod (or by hand) land directly in the repo and do not require a
rebuild.  Commit them when they look right.

## Secrets

The encrypted AI-keys bundle lives at
`modules/features/sops/ai-keys.bin`; `.sops.yaml` matches that path.  The age
private key stays outside the repo at `~/.config/sops/age/keys.txt`.

## Rollback checkpoint

The state before the reorg is tagged:

```bash
git checkout checkpoint-pre-reorg-2026-11-22
```
