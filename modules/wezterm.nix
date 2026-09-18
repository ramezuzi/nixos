{ inputs, self, ... }: {
  flake.homeModules.wezterm = { pkgs, config, ... }: {
    programs.wezterm = {
      enable = true;
      extraConfig = ''
        local wezterm = require("wezterm")
        local config = wezterm.config_builder()

        -- Font: same as your other terminals (JetBrainsMono Nerd Font, size 12)
        config.font = wezterm.font("JetBrainsMono Nerd Font")
        config.font_size = 12.0

        -- Opacity: match your Stylix opacity setting (0.98)
        config.window_background_opacity = 0.98
        config.text_background_opacity = 1.0

        -- Window decorations: keep it minimal and consistent
        config.window_decorations = "RESIZE"
        config.window_padding = {
          left = 4,
          right = 4,
          top = 4,
          bottom = 4,
        }

        -- Cursor: block, matching your kitty config
        config.default_cursor_style = "SteadyBlock"
        config.cursor_blink_rate = 800

        -- Colors: Stylix injects these automatically via the generated config.
        -- Don't set color_scheme here or it will override Stylix.

        -- Hide the tab bar (single-window user)
        config.hide_tab_bar_if_only_one_tab = true
        config.use_fancy_tab_bar = false

        -- Scrollback
        config.scrollback_lines = 10000

        -- Shell integration
        config.default_prog = { "fish", "-l" }

        return config
      '';
    };
  };
}
