{ inputs, self, ... }: {
  flake.nixosModules.nixTools = { pkgs, ... }: {
  	  imports = [ inputs.nixos-cli.nixosModules.nixos-cli ];
    environment.systemPackages = with pkgs; [
      comma
      nix-index
      nurl
      nix-init
      nix-output-monitor
      nixos-cli
      manix
      alejandra
      statix
      deadnix
    ];
  };
}
