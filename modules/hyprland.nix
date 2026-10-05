# modules/hyprland.nix
{ inputs, ... }: {

  # ── NixOS module – enables Hyprland system-wide ────────────────────────
  flake.nixosModules.hyprland =
    { pkgs, config, lib, ... }:
    {
      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
        withUWSM = true;   # better session management (systemd-scoped apps)
      };

      security.polkit.enable = true;

      # ── Portals: hyprland FIRST, gtk fallback ─────────────────────────
      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-hyprland
          xdg-desktop-portal-gtk
        ];
        config = {
          common.default = [ "hyprland" "gtk" ];
          hyprland.default = [ "hyprland" "gtk" ];
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

      environment.systemPackages = with pkgs; [
        # ── Hyprland essentials ─────────────────────────────────────────
        hyprland
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
        libnotify
        ddcutil
        hyprsunset
        hyprpicker            # Wayland color picker

        # ── Idle + lock ─────────────────────────────────────────────────
        hypridle
        hyprlock

        # ── Core apps / utilities ───────────────────────────────────────
        kitty
        rofi
        wl-clipboard
        grim
        slurp
        wf-recorder           # screen recording
        swappy                # screenshot annotation
        polkit_gnome

        # ── Hardware controls ───────────────────────────────────────────
        brightnessctl         # brightness keys
        pamixer               # volume control

        # ── Wallpaper, notifications, audio ─────────────────────────────
        awww
        swaynotificationcenter
        wireplumber
        cliphist
        udiskie
      ];

      # ── Live-editable Hyprland config symlink ─────────────────────────
      system.activationScripts.hyprConfig = lib.stringAfter [ "specialfs" ] ''
        mkdir -p /run/hypr
        ln -sfn /home/ramez/.config/hypr /run/hypr/config
      '';
    };

  # ── Home Manager module ────────────────────────────────────────────────
  flake.homeManagerModules.hyprland =
    { config, lib, pkgs, ... }:
    {
      home.file.".config/hypr/hyprland.lua".source =
        config.lib.file.mkOutOfStoreSymlink "/home/ramez/nixos/dotfiles/.config/hypr/hyprland.lua";

      home.file.".config/hypr/modules".source =
        config.lib.file.mkOutOfStoreSymlink "/home/ramez/nixos/dotfiles/.config/hypr/modules";
    };
}
