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
      # 🎨 CHANGE YOUR THEME HERE (ONLY 1 LINE)
      # ═══════════════════════════════════════════════════════════
      theme = "berlin";
      # ═══════════════════════════════════════════════════════════

      # Font placeholder
      myFont = "JetBrainsMono Nerd Font";
      myFontPkg = pkgs.nerd-fonts.jetbrains-mono;

      # Logic: Use custom YAML for Berlin, otherwise use built-in schemes
      schemePath =
        if theme == "berlin" then
          ./dotfiles/themes/berlin.yaml
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

        # Use the dynamic path here
        base16Scheme = schemePath;
        polarity = "dark";

        iconTheme = {
          enable = true;
          package = pkgs.papirus-icon-theme;
          dark = "Papirus-Dark";
          light = "Papirus";
        };

        cursor = {
          package = pkgs.bibata-cursors;
          name = "Bibata-Modern-Ice";
          size = 20;
        };

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

        opacity = {
          terminal = 0.98;
          applications = 0.98;
          desktop = 0.98;
          popups = 0.98;
        };
      };
    };
}
