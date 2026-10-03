{
  flake.nixosModules.services = {pkgs, ... }: {
    services.upower.enable = true;
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
    services.tlp.enable = true;
    services.logind.lidSwitch = "suspend";
    
  environment.systemPackages = [
    pkgs.cliphist
    ];

    
 flake.homeModules.services = { pkgs, ... }: {
    home.packages = with pkgs; [
      nvtopPackages.full  # GPU monitor — nixpkgs restructured plain `nvtop` into this
      bluetuith           # TUI bluetooth manager
      kanshi              # Wayland output-profile daemon — auto-switch configs on dock/undock
      wlr-randr           # manual display control, pairs with kanshi
    ];
  };
}
