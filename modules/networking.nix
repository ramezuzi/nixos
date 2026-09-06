# modules/networking.nix
{
  flake.nixosModules.networking = {
    networking.networkmanager.enable = true;
  };
}
