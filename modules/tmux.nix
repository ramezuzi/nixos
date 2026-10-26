{ inputs, ... }:
{
  flake.homeModules.tmux = { pkgs, config, ... }: {
    home.packages = [ pkgs.tmux ];

    home.file.".config/tmux/tmux.conf".source =
      config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/nixos/dotfiles/tmux/tmux.conf";

    home.sessionVariables.TERM = "tmux-256color";
  };
}
