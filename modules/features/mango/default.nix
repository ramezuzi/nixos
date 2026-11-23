# modules/mango.nix
{ ... }: {
  flake.nixosModules.mango = {
    pkgs,
    ...
  }: {
    # ── mango session (wlroots tiling WM) ────────────────────────────────
    # mango ships share/wayland-sessions/mango.desktop and its own user
    # systemd units (mango-session.target, which mango activates on startup
    # so portals see WAYLAND_DISPLAY / XDG_CURRENT_DESKTOP).
    services.displayManager.sessionPackages = [ pkgs.mango ];
    systemd.packages = [ pkgs.mango ];

    # ── Portals ───────────────────────────────────────────────────────────
    # mango ships share/xdg-desktop-portal/mango-portals.conf
    # (default=gtk, ScreenCast/Screenshot=wlr, Inhibit=none). Keep
    # xdg.portal.config.mango undefined — a NixOS-level config entry would
    # shadow that file, and hyprland.nix's config.common.default
    # (["hyprland" "gtk"]) would then be what a mango session reads.
    xdg.portal.configPackages = [ pkgs.mango ];
    xdg.portal.wlr.enable = true; # ScreenCast/Screenshot backend mango references

    environment.systemPackages = with pkgs; [
      playerctl # XF86Audio* media keys

      # mango's config exec_once's the polkit agent by bare name, but
      # polkit_gnome installs it under libexec/ — expose it on PATH
      (runCommand "polkit-gnome-agent-in-path" { } ''
        mkdir -p $out/bin
        ln -s ${polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 \
          $out/bin/polkit-gnome-authentication-agent-1
      '')
    ];
  };
}
