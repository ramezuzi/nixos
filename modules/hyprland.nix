# modules/hyprland.nix
{ inputs, ... }: {

  # NixOS module – enables Hyprland system-wide
  flake.nixosModules.hyprland =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
      };

      security.polkit.enable = true;

      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-hyprland
          xdg-desktop-portal-gtk
        ];
        config.common.default = "gtk";
      };

      environment.systemPackages = with pkgs; [
        # Hyprland essentials
        hyprland
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
        libnotify
        ddcutil
        hyprsunset

        # Core apps / utilities
        kitty
        waybar
        rofi
        wl-clipboard
        grim
        slurp
        polkit_gnome

        # Wallpaper, notifications, audio
        awww
        swaynotificationcenter
        wireplumber
        cliphist
        udiskie
      ];

      # Live‑editable config symlink
      system.activationScripts.hyprConfig = lib.stringAfter [ "specialfs" ] ''
        mkdir -p /run/hypr
        ln -sfn /home/ramez/.config/hypr /run/hypr/config
      '';
    };

  # Optional Home Manager module – creates out‑of‑store symlinks
  flake.homeManagerModules.hyprland =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      home.file.".config/hypr/hyprland.lua".source =
        config.lib.file.mkOutOfStoreSymlink "/home/ramez/nixos/dotfiles/.config/hypr/hyprland.lua";

      home.file.".config/hypr/modules".source =
        config.lib.file.mkOutOfStoreSymlink "/home/ramez/nixos/dotfiles/.config/hypr/modules";
    };
}
