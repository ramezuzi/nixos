# modules/boot.nix
{
  flake.nixosModules.boot = {
    boot.loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
        consoleMode = "max";
        editor = false;
      };
      efi.canTouchEfiVariables = true;
      timeout = 3;
    };
  };
}
