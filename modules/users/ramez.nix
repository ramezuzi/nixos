# modules/users/ramez.nix
{
  flake.nixosModules.ramez = { pkgs, ... }: {
    users.users.ramez = {
      isNormalUser = true;
      description = "ramez";
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.fish;
    };
    programs.fish.enable = true;
    security.sudo.wheelNeedsPassword = false;
  };
}
