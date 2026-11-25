# nixcat: a second, fully independent nvf-based Neovim configuration.
#
# The existing `programs.nvf` setup keeps `NVIM_APPNAME=nvf`; nixcat is built
# with nvf's standalone `neovimConfiguration` entrypoint and exports
# `NVIM_APPNAME=nixcat`, so config/state/cache/data never overlap.
#
# Helper modules live under `_parts/`: import-tree ignores any path containing
# `/_`, which keeps them from being imported as flake-parts modules.
{
  inputs,
  ...
}: {
  flake.homeModules.nixcat = {pkgs, ...}: let
    nvf = inputs.nvf.lib.neovimConfiguration {
      inherit pkgs;
      modules = [
        ./_parts/config.nix
        ./_parts/languages.nix
      ];
    };

    # The wrapped `nvim` produced by nvf. It is deliberately not installed as
    # `nvim` so the existing nvf/mnw wrapper on PATH stays untouched.
    nvim = nvf.neovim;

    nixcat-nvim = pkgs.runCommand "nixcat-nvim" {} ''
      mkdir -p $out/bin
      ln -s ${nvim}/bin/nvim $out/bin/nixcat-nvim
    '';

    # Mirrors modules/features/neovide: same nvf-built binary and --fork, but
    # installs under a nixcat-specific name to avoid colliding with `neovide`.
    nixcat-neovide = pkgs.runCommand "nixcat-neovide" {
      nativeBuildInputs = [pkgs.makeWrapper];
    } ''
      mkdir -p $out/bin
      makeWrapper ${pkgs.neovide}/bin/neovide $out/bin/nixcat-neovide \
        --add-flags "--neovim-bin ${nvim}/bin/nvim" \
        --add-flags "--fork"
    '';
  in {
    home.packages = [nixcat-nvim nixcat-neovide];

    home.shellAliases = {
      nixcat = "nixcat-nvim";
      nixcatv = "nixcat-neovide";
    };
  };
}
