# modules/hosts/zbook/default.nix
#
# Host composition.  Like the upstream voidarc layout, each host explicitly
# selects the attribute bundles it wants instead of importing every module in
# the flake.  Add new functionality to an attrs bundle (or import a feature
# here directly) so the host stays intentional.
{ inputs, self, ... }: {
  flake.nixosConfigurations.zbook = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs; };
    modules = [
      self.nixosModules.zbookHardware
      self.nixosModules.system
      self.nixosModules.desktop
      self.nixosModules.development
      ({ pkgs, ... }: {
        networking.hostName = "zbook";
        system.stateVersion = "26.05";
      })
    ];
  };
}
