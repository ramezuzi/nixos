{
  inputs,
  self,
  ...
}:
let
  # ── Just the theme name ──────────────────────────────────────
  # Any name from: nix build nixpkgs#base16-schemes --no-link --print-out-paths
  #                ls "$(that-path)/share/themes/"
  #
  # Examples:
  #   "catppuccin-mocha", "gruvbox-dark-hard", "tokyonight",
  #   "nord", "dracula", "kanagawa", "oxocarbon-dark", "zenburn",
  #   "rose-pine", "everforest", "solarized-dark", "github-dark"
  #
  theme = "black-metal-mayhem";
  # ────────────────────────────────────────────────────────────
in
{
  flake.nixosModules.stylix = { pkgs, lib, ... }: {
    imports = [ inputs.stylix.nixosModules.stylix ];

    stylix = {
      enable = true;
      autoEnable = true;

      targets = {
        gtk.enable = true;
        qt.enable = true;
      };

      base16Scheme = "${pkgs.base16-schemes}/share/themes/${theme}.yaml";

      polarity = "dark";

      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 20;
      };

      fonts = {
        serif = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font";
        };
        sansSerif = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font";
        };
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font";
        };
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
        sizes = {
          applications = 12;
          desktop = 12;
          popups = 12;
          terminal = 12;
        };
      };

      opacity = {
        terminal = 0.98;
        applications = 0.98;
        desktop = 0.98;
        popups = 0.98;
      };
    };
  };
}
