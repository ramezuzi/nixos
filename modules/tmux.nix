
{ inputs, ... }:

{
  flake.homeModules.tmux = { pkgs, config, ... }: {
    home.packages = [ pkgs.tmux ];

    xdg.configFile."tmux/tmux.conf".source =
      config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/nixos/dotfiles/tmux/tmux.conf";
  };
}

