# modules/attrs/desktop/default.nix
#
# Desktop composition: the graphical session, window managers, display
# manager, portals, Qt/Quickshell widgets and desktop applications.
{ self, ... }: {
  flake.nixosModules.desktop = {
    imports = with self.nixosModules; [
      apps
      artcraft
      firefox
      hyprland
      ly
      mango
      niri
      tideIslandPkg
      ukishima
      xwayland-satellite
    ];
  };
}
