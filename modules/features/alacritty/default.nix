{ ... }:
{
  flake.homeModules.alacritty = {
    programs.alacritty = {
      enable = true;
      settings = {
        general.live_config_reload = true;
        scrolling.history = 10000;
        selection.save_to_clipboard = true;
        window.dynamic_padding = true;
        mouse.hide_when_typing = true;
        cursor.style.blinking = "Never";
      };
    };
  };
}
