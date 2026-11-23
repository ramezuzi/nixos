{ ... }:
{
  flake.homeModules.ghostty = {
    programs.ghostty = {
      enable = true;
      enableFishIntegration = true;
      installBatSyntax = true;
      settings = {
        scrollback-limit = 10000000;
        confirm-close-surface = false;
        copy-on-select = true;
        mouse-hide-while-typing = true;
        cursor-style-blink = false;
        shell-integration-features = "no-cursor";
      };
    };
  };
}
