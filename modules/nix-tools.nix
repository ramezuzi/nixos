{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.nixTools = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      comma
      nix-index
      nurl
      nix-init
      nix-output-monitor
      manix
      alejandra
      statix
      deadnix
    ];
  };
}
