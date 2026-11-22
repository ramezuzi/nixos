# modules/live-configs.nix
#
# Configs that must be editable in place without a rebuild. They live in the
# repo working tree under configs/, and ~/.config points straight at them
# with out-of-store symlinks (home-manager's mkOutOfStoreSymlink).
#
# Edit ~/.config/niri/config.kdl or ~/.config/mango/*.conf directly:
#   - niri reloads its config automatically on save
#   - mango: SUPER+CTRL+R reloads the config
# The edit is a change in this repo; commit it when you're happy with it.
{
  flake.homeModules.liveConfigs = { config, ... }: {
    home.file = {
      ".config/niri/config.kdl".source =
        config.lib.file.mkOutOfStoreSymlink "/home/ramez/nixos/configs/niri/config.kdl";

      ".config/mango/config.conf".source =
        config.lib.file.mkOutOfStoreSymlink "/home/ramez/nixos/configs/mango/config.conf";
      ".config/mango/env.conf".source =
        config.lib.file.mkOutOfStoreSymlink "/home/ramez/nixos/configs/mango/env.conf";
      ".config/mango/rules.conf".source =
        config.lib.file.mkOutOfStoreSymlink "/home/ramez/nixos/configs/mango/rules.conf";
    };
  };
}
