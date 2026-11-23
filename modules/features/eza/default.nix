# modules/eza.nix
{
  flake.homeModules.eza = {
    programs.eza = {
      enable = true;
      enableFishIntegration = true;
      git = true;
      icons = "auto";
      extraOptions = [
        "--group-directories-first"
        "--header"
        "--smart-group"
        "--octal-permissions"
        "--time-style=long-iso"
      ];
    };
  };
}
