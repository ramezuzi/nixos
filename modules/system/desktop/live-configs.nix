# modules/system/desktop/live-configs.nix
#
# Configs that must be editable in place without a rebuild.  They live next to
# their feature module (modules/features/niri/config, modules/features/mango/
# config) and ~/.config points straight at them with out-of-store symlinks
# (home-manager's mkOutOfStoreSymlink).
#
# The whole directory is linked, not individual files: the GUI editors
# (nirimod) write atomically via temp-file + rename and create sibling
# files such as profiles/ and includes. A directory link keeps every write
# inside the repo working tree instead of replacing a file-level symlink.
#
# Edit ~/.config/niri/config.kdl or ~/.config/mango/*.conf directly:
#   - niri reloads its config automatically on save
#   - mango: SUPER+CTRL+R reloads the config
# The edit is a change in this repo; commit it when you're happy with it.
{
  flake.homeModules.liveConfigs = { config, ... }: {
    home.file = {
      ".config/niri".source =
        config.lib.file.mkOutOfStoreSymlink "/home/ramez/nixos/modules/features/niri/config";
      ".config/mango".source =
        config.lib.file.mkOutOfStoreSymlink "/home/ramez/nixos/modules/features/mango/config";
    };
  };
}
