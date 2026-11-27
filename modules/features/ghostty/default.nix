{ ... }:
{
    flake.homeModules.ghostty = {
        programs.ghostty = {
            enable = true;
            enableFishIntegration = true;
            installBatSyntax = true;
            settings = {
                term = "xterm-256color";
                env = [ "COLORTERM=disabled" ];
                background = 000000;
                background-opacity = 0.85;
                background-blur = false;
                scrollback-limit = 10000000;
                confirm-close-surface = false;
                copy-on-select = true;
                mouse-hide-while-typing = true;
                cursor-style-blink = false;
                shell-integration-features = "no-cursor";
            };
        };
    };
}
