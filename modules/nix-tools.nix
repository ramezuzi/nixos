{ inputs, self, ... }: {
  flake.nixosModules.nixTools = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      comma
      nix-index
      nix-index-database
      nurl
      nix-init
      nix-output-monitor
      nixos-cli
      manix
      alejandra
      statix
      deadnix
    ];
    programs.command-not-found.enable = true;
  };
}
