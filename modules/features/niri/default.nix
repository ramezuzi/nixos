# modules/niri.nix
{ ... }: {
  flake.nixosModules.niri = {
    pkgs,
    ...
  }: {
    # ── niri session (scrollable-tiling Wayland compositor) ───────────────
    # The NixOS niri module adds the session entry, the gnome portal, user
    # systemd units and polkit; xdg-desktop-autostart.target (wired from
    # niri.service) runs the polkit-gnome agent on session start.
    programs.niri = {
      enable = true;
      # keep the gtk file-chooser (dolphin user) instead of pulling nautilus
      useNautilus = false;
    };

    # niri module sets defaultSession = mkDefault "niri"; Hyprland stays
    # the primary session
    services.displayManager.defaultSession = "hyprland";

    environment.systemPackages = with pkgs; [
      playerctl # XF86Audio* media keys
    ];
  };
}
