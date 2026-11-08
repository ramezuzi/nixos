{
  flake.nixosModules.services = {pkgs, config, lib, ...}: {
    services.upower.enable = true;
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    # Ryoku ships and enables power-profiles-daemon, which conflicts with TLP.
    # Keep TLP for non-Ryoku hosts so the option can be flipped back.
    services.tlp.enable = lib.mkIf (!config.programs.ryoku.enable) true;
    services.logind.settings.Login.HandleLidSwitch = "suspend";

    environment.systemPackages = with pkgs; [
      cliphist
      nvtopPackages.full # GPU monitor — nixpkgs restructured plain `nvtop` into this
      bluetuith # TUI bluetooth manager
      kanshi # Wayland output-profile daemon — auto-switch configs on dock/undock
      wlr-randr # manual display control, pairs with kanshi
    ];
  };
}
