{
  flake.nixosModules.herbstluftwm= { pkgs, ... }: {
    services.xserver = {
      enable = true;
    };
    environment.systemPackages = [ pkgs.wayland ];
    services.xserver.windowManager.herbstluftwm.enable = true;
  };
}
