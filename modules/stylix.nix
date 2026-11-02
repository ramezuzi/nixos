{
  inputs,
  self,
  ...
}:
{
  flake.nixosModules.stylix =
    { pkgs, lib, ... }:
    let
      # ═══════════════════════════════════════════════════════════
      # 🎨 CHANGE YOUR THEME AND FONT HERE
      # ═══════════════════════════════════════════════════════════
      theme = "berlin";

      myFont = "JetBrainsMono Nerd Font";
      myFontPkg = pkgs.nerd-fonts.jetbrains-mono;
      # ═══════════════════════════════════════════════════════════

      # Dynamic path: uses your custom file for Berlin, otherwise built-in themes
      schemePath =
        if theme == "berlin" then
          ../dotfiles/themes/berlin.yaml
        else
          "${pkgs.base16-schemes}/share/themes/${theme}.yaml";
    in
    {
      imports = [ inputs.stylix.nixosModules.stylix ];

      stylix = {
        enable = true;
        autoEnable = true;

        targets = {
          gtk.enable = true;
          qt.enable = true;
        };

        # Apply the chosen color scheme
        base16Scheme = schemePath;
        polarity = "dark";

        # ── Icons (Updated to stylix.icons) ─────────────────────
        icons = {
          enable = true;
          package = pkgs.papirus-icon-theme;
          dark = "Papirus-Dark";
          light = "Papirus";
        };

        # ── Cursors ─────────────────────────────────────────────
        cursor = {
          package = pkgs.bibata-cursors;
          name = "Bibata-Modern-Ice";
          size = 20;
        };

        # ── Fonts (Using the one-line variables) ────────────────
        fonts = {
          serif = {
            package = myFontPkg;
            name = myFont;
          };
          sansSerif = {
            package = myFontPkg;
            name = myFont;
          };
          monospace = {
            package = myFontPkg;
            name = myFont;
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

        # ── Opacity ─────────────────────────────────────────────
        opacity = {
          terminal = 0.98;
          applications = 0.98;
          desktop = 0.98;
          popups = 0.98;
        };
      };
    };
}
