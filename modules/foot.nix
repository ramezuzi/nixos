{ ... }:
{
  flake.homeModules.foot = {
    programs.foot = {
      enable = true;
      settings = {
        scrollback.lines = 10000;
        mouse.hide-when-typing = "yes";
        cursor.blink = "no";
        selection.target = "both";
      };
    };
  };
}
