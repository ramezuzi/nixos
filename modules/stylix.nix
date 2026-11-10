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
            sansFont = "Noto Sans";
            serifFont = "Noto Serif";
            sansFontPkg = pkgs.noto-fonts;
            serifFontPkg = pkgs.noto-fonts;
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
                        package = serifFontPkg;
                        name = serifFont;
                    };
                    sansSerif = {
                        package = sansFontPkg;
                        name = sansFont;
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
                        applications = 10;
                        desktop = 10;
                        popups = 10;
                        terminal = 10;
                    };
                };

                # Keep windows fully opaque for consistent text contrast.
                opacity = {
                    terminal = 1.0;
                    applications = 1.0;
                    desktop = 1.0;
                    popups = 1.0;
                };
            };
        };
}
