# modules/keyboard.nix
{ lib,inputs, ... }:
{
  flake.nixosModules.keyboard = { config, ... }: {
    services.xserver.xkb = {
      layout = "us";
      variant = "colemak_dh_ortho";
      options = "caps:escape";
    };
  console.useXkbConfig = true;
  };
}
