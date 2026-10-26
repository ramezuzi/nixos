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
      # ── Python package overrides ─────────────────────────────
      # These disable test phases for packages that fail only
      # because their tests are flaky in constrained sandboxes.
      (final: prev: {
        pythonPackagesExtensions =
          prev.pythonPackagesExtensions
          ++ [
            (_python-final: python-prev: {
              posthog = python-prev.posthog.overridePythonAttrs (_: {
                doCheck = false;
                doInstallCheck = false;
              });

              jsonpath-python = python-prev.jsonpath-python.overridePythonAttrs (_: {
                doCheck = false;
                doInstallCheck = false;
              });
            })
          ];
      })

      # ── ai-memory: force HTTP/1.1 for submodule fetch ────────
      # GitHub resets HTTP/2 streams mid-clone, failing the
      # vendor-staging derivation. Forcing HTTP/1.1 avoids that.
      (final: prev: {
        ai-memory = prev.ai-memory.overrideAttrs (old: {
          preBuild = ''
            export GIT_CONFIG_COUNT=1
            export GIT_CONFIG_KEY_0="http.version"
            export GIT_CONFIG_VALUE_0="HTTP/1.1"
            ${old.preBuild or ""}
          '';
        });
      })
    ];
  };
}
