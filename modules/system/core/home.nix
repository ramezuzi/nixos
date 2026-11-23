{ inputs, config, ... }:
{
  flake.nixosModules.homeManager = {
    imports = [ inputs.home-manager.nixosModules.default ];
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "hm-bak";
      extraSpecialArgs = { inherit inputs; };
      users.ramez = {
        imports = builtins.attrValues config.flake.homeModules;
        home.stateVersion = "26.05";
      };
    };
  };
}
