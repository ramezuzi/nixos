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

    nixpkgs.overlays = [
      (final: prev: {
        pythonPackagesExtensions =
          prev.pythonPackagesExtensions
          ++ [
            (python-final: python-prev: {
              posthog = python-prev.posthog.overridePythonAttrs (_: {
                # For buildPythonPackage, the check phase maps to
                # installCheckPhase. Both must be disabled to actually
                # skip the test suite.
                doCheck = false;
                doInstallCheck = false;
              });
            })
          ];
      })
    ];
  };
}
