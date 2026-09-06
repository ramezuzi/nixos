# modules/firefox.nix
{
  flake.nixosModules.firefox = {
    programs.firefox.enable = true;
  };
}
