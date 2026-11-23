{...}: {
  flake.homeModules.obsidian = {
    pkgs,
    config,
    ...
  }: {
    programs.obsidian = {
      enable = true;
      vaults.notes.target = "Documents/Obsidian";
    };
  };
}
