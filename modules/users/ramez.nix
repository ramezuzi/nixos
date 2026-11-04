# modules/users/ramez.nix
{
  flake.nixosModules.ramez = { pkgs, ... }: {
    users.users.ramez = {
      isNormalUser = true;
      description = "ramez";
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.zsh;
    };
    programs.fish.enable = true;
    programs.zsh.enable = true;
    security.sudo.wheelNeedsPassword = false;
  };
}
