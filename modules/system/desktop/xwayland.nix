# modules/nixos/xwayland-satellite.nix
{ ... }:
{
  flake.nixosModules.xwayland-satellite = { pkgs, ... }: {
    programs.xwayland.enable = true;                          
    environment.systemPackages = [ pkgs.xwayland-satellite ];  
  };
}
