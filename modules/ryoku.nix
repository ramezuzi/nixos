{ inputs, ... }:
{
  # Ryoku-on-NixOS: Hyprland/niri desktop shell, materialized into ~/.config.
  # Nix owns packages/services; day-to-day config lives in the home directory
  # (and ~/.config/ryoku/user_edits) so edits do not require a rebuild.
  flake.nixosModules.ryoku = {
    imports = [ inputs.ryoku.nixosModules.default ];

    programs.ryoku = {
      # Disabled: Ryoku's shell is too heavy for this laptop. The module and
      # flake input stay wired up so it can be re-enabled by flipping this.
      enable = false;

      # Both Ryoku sessions are deployed. This only picks the session the
      # display manager preselects; switch compositor from Ryoku Hub or the
      # login screen without rebuilding.
      defaultCompositor = "hyprland";

      browser = "firefox";
      shell = "zsh";

      # Keep the Ryoku defaults, except cli-tools: its zsh aliases would
      # collide with this host's aliases. The host already provides eza, bat,
      # ripgrep, fd, etc.
      optionalApps = [
        "prompt"
        "fastfetch"
        "yazi"
        "pavucontrol"
        "songrec"
        "openrgb"
        "upscale"
        "gamescope"
        "gamemode"
        "mangohud"
        "vm"
        "docker"
        "mise"
      ];
    };
  };
}
