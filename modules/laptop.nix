# modules/laptop.nix
{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.laptop = {
    pkgs,
    lib,
    ...
  }: {
    # Thermald (Intel only — remove if AMD)
    services.thermald.enable = true;

    # ── Nix parallelism (fixes OOM kill) ─────────────────────
    nix.settings.max-jobs = 4;
    nix.settings.cores = 4;

    # Binary caches are consolidated in nix-settings.nix.

    # Compressed RAM swap
    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = 50;
    };

    # Firmware updates
    services.fwupd.enable = true;

    # Lid / power key behavior
    services.logind.settings.Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchExternalPower = "lock";
      HandleLidSwitchDocked = "ignore";
      HandlePowerKey = "suspend";
    };

    # Wayland session vars
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      QT_QPA_PLATFORM = "wayland";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      XCURSOR_THEME = "Bibata-Modern-Ice";
      XCURSOR_SIZE = "20";
      HYPRCURSOR_THEME = "Bibata-Modern-Ice";
      HYPRCURSOR_SIZE = "20";
    };

    # Desktop integration
    services.gvfs.enable = true;
    services.udisks2.enable = true;
    programs.dconf.enable = true;
    # Fonts (packages + fontconfig tuning) live in fonts.nix.

    # Wayland utilities
    environment.systemPackages = with pkgs; [
      brightnessctl
      pamixer
      wf-recorder
      swappy
    ];
  };
}
