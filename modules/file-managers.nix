{ ... }:
{
  flake.homeModules.file-managers = { pkgs, ... }: {
    home.packages = with pkgs; [
      yazi       # Rust, fast, image preview via kitty graphics protocol — current community favorite
      superfile  # Go, flashier/more GUI-like (sidebar + metadata panel), newer and heavier than yazi
      nnn        # C, minimal and near-instant, plugin-based — the "stays out of your way" option
    ];
  };
}
