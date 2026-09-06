{
  inputs,
  self,
  ...
}:
{
  flake.nixosModules.stylix = { pkgs, lib, ... }: {
    imports = [ inputs.stylix.nixosModules.stylix ];

    stylix = {
      enable = true;
      autoEnable = true;

      targets = {
        # Desktop environments / Window managers
        gtk.enable = true;
        qt.enable = true;
        hyprland.enable = true;      # if you use Hyprland
        waybar.enable = true;        # if you use Waybar
        rofi.enable = true;          # if you use Rofi
        wofi.enable = true;          # if you use Wofi
        tofi.enable = true;          # if you use Tofi

        # Terminals
        kitty.enable = true;
        foot.enable = true;
        wezterm.enable = true;
        ghostty.enable = true;

        # Editors
        neovim.enable = true;
        vim.enable = true;
        vscode.enable = true;

        # Browsers
        firefox.enable = true;
        chromium.enable = true;
        qutebrowser.enable = true;

        # Other apps
        bat.enable = true;           # bat cat replacement
        btop.enable = true;          # system monitor
        dunst.enable = true;         # notification daemon
        fzf.enable = true;           # fuzzy finder
        lazygit.enable = true;       # git TUI
        mpv.enable = true;           # media player
        zathura.enable = true;       # PDF viewer
        vifm.enable = true;          # file manager
        yazi.enable = true;          # file manager
        tmux.enable = true;          # terminal multiplexer
        zellij.enable = true;        # terminal multiplexer
      };

      # Your custom Koda Monochrome palette
      base16Scheme = {
        base00 = "080808";  # background
        base01 = "0c0c0c";  # background alt
        base02 = "121212";  # inactive border
        base03 = "1a1a1a";  # selection background / active border
        base04 = "3d3d3d";  # dark gray (color8)
        base05 = "a6a6a6";  # foreground / main text
        base06 = "c4c4c4";  # selection foreground / cursor
        base07 = "e0e0e0";  # white / lightest (color15)
        base08 = "4a4a4a";  # red / danger (color1)
        base09 = "666666";  # yellow / warning (color3)
        base0A = "848484";  # cyan (color6)
        base0B = "5c5c5c";  # green (color2)
        base0C = "848484";  # cyan
        base0D = "707070";  # blue / highlight (color4)
        base0E = "7a7a7a";  # magenta / pink (color5)
        base0F = "8a8a8a";  # url color
      };

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
        terminal = 0.98;        # Match your kitty opacity
        applications = 0.98;
        desktop = 0.98;
        popups = 0.98;
      };
    };
  };
}
