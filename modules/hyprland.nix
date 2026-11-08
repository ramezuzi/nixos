# modules/hyprland.nix
{inputs, ...}: {
  # ── NixOS module – enables Hyprland system-wide ────────────────────────
  flake.nixosModules.hyprland = {
    pkgs,
    config,
    lib,
    ...
  }: {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true; # better session management (systemd-scoped apps)
    };

    security.polkit.enable = true;

    # ── Portals ─────────────────────────────────────────────────────────
    # Ryoku owns the portal stack (including its ABI-matched Hyprland portal)
    # when enabled. Keep this only for a non-Ryoku host.
    xdg.portal = lib.mkIf (!config.programs.ryoku.enable) {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
      config = {
        common.default = ["hyprland" "gtk"];
        hyprland.default = ["hyprland" "gtk"];
      };
    };

    # ── Wayland session vars (fixes Electron/Qt apps) ─────────────────
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      QT_QPA_PLATFORM = "wayland";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      XCURSOR_THEME = "Bibata-Modern-Ice";
      XCURSOR_SIZE = "20";
      HYPRCURSOR_THEME = "Bibata-Modern-Ice";
      HYPRCURSOR_SIZE = "20";
    };

    environment.systemPackages =
      with pkgs; [
        # ── Hyprland essentials ─────────────────────────────────────────
        libnotify
        ddcutil
        hyprsunset
        hyprpicker # Wayland color picker

      # ── Idle + lock ─────────────────────────────────────────────────
      hypridle
      hyprlock

      # ── Core apps / utilities ───────────────────────────────────────
      kitty
      rofi
      wl-clipboard
      grim
      slurp
      wf-recorder # screen recording
      swappy # screenshot annotation
      polkit_gnome

      # ── Hardware controls ───────────────────────────────────────────
      brightnessctl # brightness keys
      pamixer # volume control

        # ── Wallpaper, notifications, audio ─────────────────────────────
        awww
        wireplumber
        cliphist
        udiskie
      ]
      # Ryoku pins its own ABI-matched Hyprland and portal packages. Adding the
      # host copies would put a mismatched hyprctl/portal on PATH.
      ++ lib.optionals (!config.programs.ryoku.enable) (with pkgs; [
        hyprland
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ]);

    # Config files under ~/.config/hypr are materialized by Ryoku and are
    # intentionally not managed by Home Manager, so edits/reloads remain
    # ordinary Linux edits instead of requiring a rebuild.
  };
}
