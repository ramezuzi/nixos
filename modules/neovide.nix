{
    flake.homeModules.neovide =
        {
            config,
            pkgs,
            lib,
            ...
        }:
        let
            # nvf's wrapped Neovim already contains the full config (plugins, LSP,
            # treesitter, theme). Point Neovide at that exact binary so the GUI and the
            # terminal `nvim` share one configuration.
            nvim = config.programs.nvf.finalPackage;

            neovide = pkgs.symlinkJoin {
                name = "neovide-wrapped";
                paths = [ pkgs.neovide ];
                nativeBuildInputs = [ pkgs.makeWrapper ];

                postBuild = ''
                    wrapProgram $out/bin/neovide \
                      --add-flags "--neovim-bin ${lib.getExe' nvim "nvim"}" \
                      --add-flags "--fork"
                '';
            };
        in
        {
            config = lib.mkIf config.programs.nvf.enable {
                home.packages = [ neovide ];

                programs.nvf.settings.vim = {
                    # Matches the terminal font/size from stylix and wezterm.
                    opts = {
                        guifont = "JetBrainsMono Nerd Font:h12";
                        linespace = 1;
                    };

                    # Neovide reads these as g:neovide_* inside the nvf-built config.
                    globals = {
                        neovide_scale_factor = 0.8;
                        neovide_opacity = 1.0;
                        neovide_confirm_quit = false;
                        neovide_fullscreen = false;
                        neovide_remember_window_size = true;
                        neovide_hide_mouse_when_typing = true;
                        neovide_theme = "auto";

                        # Keep animations quick on a laptop.
                        neovide_cursor_animation_length = 0.08;
                        neovide_cursor_trail_size = 0.4;
                        neovide_cursor_animate_in_insert_mode = true;
                        neovide_cursor_animate_command_line = true;
                        neovide_scroll_animation_length = 0.18;
                        neovide_scroll_animation_far_lines = 8;

                        neovide_cursor_vfx_mode = "railgun";
                        neovide_cursor_vfx_opacity = 0.5;
                    };
                };
            };
        };
}
