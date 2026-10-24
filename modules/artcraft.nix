{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.artcraft = {...}: {
    imports = [
      inputs.artcraft.nixosModules.default
    ];
    programs.artcraft = {
      enable = true;
    };
  };
}
