# modules/nix-settings.nix
{
  flake.nixosModules.nixSettings = {
    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;

      substituters = [
        "https://cache.nixos.org"
        "https://cache.numtide.com"
        "https://numtide.cachix.org"
        "https://nix-community.cachix.org"
        "https://applicative-systems.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
        "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "applicative-systems.cachix.org-1:ND41hRBh0ST2abuI/oee3yWVf3n0FsAftyJJ/Tb7KDE="
      ];
    };

    nixpkgs.config.allowUnfree = true;

    nix.gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d";
    };
  };
}
