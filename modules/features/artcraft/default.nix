{inputs, ...}: {
  flake.nixosModules.artcraft = {pkgs, ...}: let
    system = pkgs.stdenv.hostPlatform.system;
    artcraft = inputs.artcraft.packages.${system};
  in {
    environment.systemPackages = with artcraft; [
      cadcraft
      deckcraft
      designcraft
      effectcraft
      filmcraft
      gridcraft
      lightcraft
      pdfcraft
      photocraft
      soundcraft
      vectorcraft
      wordcraft
    ];
  };
}
