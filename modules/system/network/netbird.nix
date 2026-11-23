{ ... }:
{
  flake.nixosModules.netbird = { pkgs, ... }: {
    services.netbird.enable = true;
    environment.systemPackages = with pkgs; [
      netbird-ui
      netbird-dashboard
      netbird-management
      netbird-proxy
      netbird-relay
      netbird-signal
      netbird-upload
    ];
  };
}
