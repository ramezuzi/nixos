{ inputs, self, ... }:
{
  flake.nixosModules.nh = { pkgs, ... }: {
    programs.nh = {
      enable = true;

      flake = "/home/ramez/nixos";

      #   clean = {
      #     enable = true;
      #     # Deletes old generations automatically every week
      #     extraArgs = "--keep-since 7d --keep 5";
      #   };
    };

    environment.systemPackages = with pkgs; [
      nix-output-monitor
      nvd
    ];
  };
}
