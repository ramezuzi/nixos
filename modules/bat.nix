# modules/bat.nix
{
  flake.homeModules.bat = { pkgs, ... }: {
    programs.bat = {
      enable = true;
      config = {
        style = "full";
        italic-text = "always";
        pager = "less -FR";
      };
      extraPackages = with pkgs.bat-extras; [
        batman
        batgrep
        batdiff
        batwatch
      ];
    };

    home.sessionVariables = {
      MANPAGER = "batman";
      MANROFFOPT = "-c";
    };
  };
}
