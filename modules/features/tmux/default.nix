{ ... }:
{
  flake.homeModules.tmux = { pkgs, ... }:
  let
    tmuxConfig = pkgs.writeText "tmux.conf"
      (builtins.readFile ../../../dotfiles/tmux/tmux.conf);
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
