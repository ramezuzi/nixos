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
    programs.nixos-cli = {
      enable = true;
      settings = {
        # Whatever settings you want; can be left empty
      };
    };
  };
}
