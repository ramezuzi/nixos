{ inputs, self, ... }: {
  flake.nixosModules.nvim = { pkgs, config, ... }: {
    environment.systemPackages = [
      # `v` opens the Neovide GUI with the standalone nvim-salar config and
      # returns to the shell immediately. Everything after `--` is handed to
      # Neovim unmodified; `--neovim-bin` pins the plain nixpkgs Neovim so
      # nvf's plugins and VIMINIT are not pulled in. `setsid -f` detaches the
      # GUI properly (`--fork` alone still blocks the terminal).
      (pkgs.writeShellScriptBin "v" ''
        exec ${pkgs.util-linux}/bin/setsid -f \
          ${pkgs.neovide}/bin/neovide \
          --neovim-bin ${pkgs.neovim}/bin/nvim \
          -- -u "$HOME/.config/nvim-salar/init.lua" "$@"
      '')

      # `vt` is the old terminal-only behaviour.
      (pkgs.writeShellScriptBin "vt" ''
        exec ${pkgs.neovim}/bin/nvim -u "$HOME/.config/nvim-salar/init.lua" "$@"
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
