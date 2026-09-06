{
  flake.nixosModules.nur = { inputs, pkgs, ... }: {
    nixpkgs.overlays = [ inputs.nur.overlays.default ];
  };
}
