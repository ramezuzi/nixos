{ ... }:
{
  flake.homeModules.file-managers = { pkgs, config, ... }:
    let
      c = config.lib.stylix.colors.withHashtag;
      # Superfile's theme file is TOML. Generate it from Stylix's active
      # Base16 palette so changing the system scheme updates Superfile too.
      stylixTheme = ''
        code_syntax_highlight = "base16"
        full_screen_fg = "${c.base05}"
        full_screen_bg = "${c.base00}"
        gradient_color = ["${c.base0D}", "${c.base0E}"]
        directory_icon_color = "${c.base0D}"
        file_panel_fg = "${c.base05}"
        file_panel_bg = "${c.base00}"
        file_panel_border = "${c.base03}"
        file_panel_border_active = "${c.base0D}"
        file_panel_top_directory_icon = "${c.base0B}"
        file_panel_top_path = "${c.base0C}"
        file_panel_item_selected_fg = "${c.base00}"
        file_panel_item_selected_bg = "${c.base0D}"
        footer_fg = "${c.base05}"
        footer_bg = "${c.base00}"
        footer_border = "${c.base03}"
        footer_border_active = "${c.base0D}"
        sidebar_fg = "${c.base05}"
        sidebar_bg = "${c.base00}"
        sidebar_title = "${c.base0C}"
        sidebar_border = "${c.base00}"
        sidebar_border_active = "${c.base0D}"
        sidebar_item_selected_fg = "${c.base00}"
        sidebar_item_selected_bg = "${c.base0D}"
        sidebar_divider = "${c.base03}"
        modal_fg = "${c.base05}"
        modal_bg = "${c.base01}"
        modal_border_active = "${c.base0D}"
        modal_cancel_fg = "${c.base00}"
        modal_cancel_bg = "${c.base08}"
        modal_confirm_fg = "${c.base00}"
        modal_confirm_bg = "${c.base0B}"
        help_menu_hotkey = "${c.base0C}"
        help_menu_title = "${c.base0D}"
        cursor = "${c.base06}"
        correct = "${c.base0B}"
        error = "${c.base08}"
        hint = "${c.base0C}"
        cancel = "${c.base09}"
      '';
    in
    {
      home.packages = with pkgs; [
        yazi       # Rust, fast, image preview via kitty graphics protocol — current community favorite
        superfile  # Go, flashier/more GUI-like (sidebar + metadata panel), newer and heavier than yazi
        nnn        # C, minimal and near-instant, plugin-based — the "stays out of your way" option
      ];

      xdg.configFile."superfile/theme/stylix.toml".text = stylixTheme;
      xdg.configFile."superfile/config.toml".text = ''
        theme = "stylix"
      '';
    };
}
