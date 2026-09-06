{ inputs, self, ... }: {
  flake.nixosModules.nvim = { pkgs, config, ... }: {
    environment.systemPackages = [
      (pkgs.writeShellScriptBin "v" ''
        exec ${pkgs.neovim}/bin/nvim -u ~/.config/nvim-salar/init.lua "$@"
      '')

      # Required dependencies for the config
      pkgs.cmake
      pkgs.gcc
      pkgs.ripgrep
      pkgs.fd
      pkgs.nodejs
      pkgs.python3
      pkgs.unzip
      pkgs.curl
    ];
  };
}
