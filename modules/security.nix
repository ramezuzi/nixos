{inputs, ...}: {
  flake.nixosModules.security = {
    pkgs,
    lib,
    ...
  }: {
    nixpkgs.config.problems.handlers = {
      fabric.broken = "ignore";
      posthog.broken = "ignore";
    };
  };
}
