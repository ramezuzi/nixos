# modules/attrs/development/default.nix
#
# Development composition: CLI tooling, editors, data/database clients and
# the dotfile manager that feeds the rest of the setup.
{ self, ... }: {
  flake.nixosModules.development = {
    imports = with self.nixosModules; [
      dataAnalysis
      db-servers
      homini
      nvim
      tools
    ];
  };
}
