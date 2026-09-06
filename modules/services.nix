{
  flake.nixosModules.services = {pkgs, ... }: {
    services.upower.enable = true;
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
    
  environment.systemPackages = [
    pkgs.cliphist
    ];
  };
}
