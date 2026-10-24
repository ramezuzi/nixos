{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.security = {
    pkgs,
    lib,
    ...
  }: {
    nixpkgs.config.problems.handlers = {
      fabric.broken = "warn";
      posthog.broken = "warn";
    };
  };
}
