{ inputs, config, ... }:
{
  flake.nixosConfigurations.zbook = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs; };
    modules = builtins.attrValues config.flake.nixosModules ++ [
      ({ pkgs, ... }: {
        networking.hostName = "zbook";
        system.stateVersion = "26.05";
      })
      config.flake.nixosModules.nur
    ];
  };
}
