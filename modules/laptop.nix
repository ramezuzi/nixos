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

    # ── Binary caches (numtide + nixos) ───────────────────────
    nix.settings.substituters = [
      "https://cache.nixos.org"
      "https://cache.numtide.com"
      "https://numtide.cachix.org"
    ];
    nix.settings.trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
    ];

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
    fonts.fontconfig.enable = true;

    fonts.packages = with pkgs; [
      noto-fonts # Broad unicode coverage
      noto-fonts-cjk-sans # Chinese, Japanese, Korean
      liberation_ttf # Arial/Times New Roman replacements for apps/web
      font-awesome # Extra icons for various apps
    ];
    # Wayland utilities
    environment.systemPackages = with pkgs; [
      brightnessctl
      pamixer
      wf-recorder
      swappy
    ];
  };
}
