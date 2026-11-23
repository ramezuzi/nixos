# modules/ly.nix
{
  flake.nixosModules.ly = {
    services.displayManager.ly = {
      enable = true;
      settings = {
        animation = "matrix";
        bigclock = true;
        clear_password = true;
        hide_key_hints = false;
      };
    };

  };
}
