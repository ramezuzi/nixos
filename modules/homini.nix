# modules/homini.nix
{ inputs, ... }:
{
  flake.nixosModules.homini = {
    imports = [ inputs.homini.nixosModules.homini ];
    homini = {
      enable = true;
      dir = ../dotfiles;
    };
  };
}
