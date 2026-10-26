{ inputs, ... }: {
  flake.nixosModules.artcraft = { pkgs, ... }: {
    nixpkgs.overlays = [ inputs.artcraft.overlays.default ];

    environment.systemPackages = with pkgs; [
      artcraft.cadcraft
      artcraft.deckcraft
      artcraft.designcraft
      artcraft.effectcraft
      artcraft.filmcraft
      artcraft.gridcraft
      artcraft.lightcraft
      artcraft.pdfcraft
      artcraft.photocraft
      artcraft.soundcraft
      artcraft.vectorcraft
      artcraft.wordcraft
    ];
  };
}
