{ ... }:
{
  flake.homeModules.kitty = {
    programs.kitty = {
      enable = true;
      shellIntegration = {
        enableFishIntegration = true;
        mode = "no-cursor";
      };
      settings = {
        scrollback_lines = 10000;
        enable_audio_bell = false;
        confirm_os_window_close = 0;
        copy_on_select = true;
        allow_remote_control = true;
        cursor_shape = "block";
        cursor_blink_interval = 0;
      };
    };
  };
}
