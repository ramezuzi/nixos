# modules/tuios.nix
{ inputs, self, ... }: {
  flake.homeModules.tuios = { pkgs, config, lib, ... }:
    let
      # Pull Stylix's base16 colors (with # prefix) into a let-binding
      # so the JSON block stays readable.
      c = config.lib.stylix.colors.withHashtag;
    in
    {
      # 1. Install tuios via Home Manager
      home.packages = [ pkgs.tuios ];

      # 2. Generate a tuios theme from the Stylix palette
      xdg.configFile."tuios/themes/stylix.json".text = builtins.toJSON {
        id = "stylix";
        display_name = "Stylix (Koda)";

        # Core
        fg     = c.base05;   # main text
        bg     = c.base00;   # background
        cursor = c.base06;   # cursor

        # Normal ANSI
        black   = c.base00;
        red     = c.base08;
        green   = c.base0B;
        yellow  = c.base0A;
        blue    = c.base0D;
        purple  = c.base0E;   # tuios uses "purple", not "magenta"
        cyan    = c.base0C;
        white   = c.base05;

        # Bright ANSI
        bright_black  = c.base03;
        bright_red    = c.base08;
        bright_green  = c.base0B;
        bright_yellow = c.base0A;
        bright_blue   = c.base0D;
        bright_purple = c.base0E;
        bright_cyan   = c.base0C;
        bright_white  = c.base07;

        # Optional: chrome colors for tuios' own UI (borders, dockbar,
        # logo). Uncomment and tune if you want the furniture to use
        # specific accents rather than deriving from bright_*.
        # chrome = {
        #   accent        = c.base07;
        #   accent_bright = c.base06;
        #   success       = c.base0B;
        #   warning       = c.base0A;
        #   error         = c.base08;
        #   info          = c.base0D;
        # };
      };

      # 3. Point tuios at the generated theme
      xdg.configFile."tuios/config.toml".text = ''
        [appearance]
        theme = "stylix"
      '';
    };
}
