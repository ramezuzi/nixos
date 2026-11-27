{ ... }:
{
  flake.homeModules.foot = {
    programs.foot = {
      enable = true;
      settings = {
        main.term = "xterm-256color";
        environment.COLORTERM = "disabled";
        scrollback.lines = 10000;
        mouse.hide-when-typing = "yes";
        cursor.blink = "no";
        selection.target = "both";
      };
    };
  };
}
