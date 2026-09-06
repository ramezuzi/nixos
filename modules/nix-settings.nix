# modules/nix-settings.nix
{
  flake.nixosModules.nixSettings = {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nixpkgs.config.allowUnfree = true;
    nix.gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d";
    };
    nix.settings.auto-optimise-store = true;
  };
}
