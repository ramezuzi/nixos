{ ... }:
{
  flake.homeModules.tmux = { pkgs, config, ... }:
  let
    tmuxConfig = pkgs.writeText "tmux.conf" (
      builtins.replaceStrings
        [ "@base00@" ]
        [ config.lib.stylix.colors.withHashtag.base00 ]
        (builtins.readFile ../dotfiles/tmux/tmux.conf)
    );
  in {
    programs.tmux = {
      enable = true;
      package = pkgs.tmux;
      extraConfig = ''
        source-file ${tmuxConfig}
        run-shell ${pkgs.tmuxPlugins.online-status.rtp}
        run-shell ${pkgs.tmuxPlugins.battery.rtp}
      '';
    };
  };
}
