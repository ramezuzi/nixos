# modules/podman.nix
{
  flake.nixosModules.podman = { pkgs, ... }: {
    virtualisation.podman = {
      enable = true;
      # `docker` on PATH as a shim backed by rootless podman, so the
      # d / dps / dc / dcu / dcd shell aliases work unmodified.
      dockerCompat = true;
      # /var/run/docker.sock -> podman socket, for tools that expect it.
      dockerSocket.enable = true;
    };

    # Compose provider: podman runs `docker compose` through this binary.
    environment.systemPackages = [ pkgs.docker-compose ];

    users.users.ramez.extraGroups = [ "podman" ];
  };
}
