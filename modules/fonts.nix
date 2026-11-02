{...}: {
  flake.nixosModules.fonts = {pkgs, ...}: {
    # Install the essential missing font packages
    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      liberation_ttf
      font-awesome
    ];

    # Fix the font rendering settings
    fonts.fontconfig = {
      enable = true;
      antialias = true;

      hinting = {
        enable = true;
        style = "slight"; # FIXED: Changed from "hintslight"
      };

      subpixel = {
        enable = true;
        rgba = "rgb";
        lcdfilter = "default"; # FIXED: NixOS expects "default" instead of "lcddefault"
      };

      dpi = 96;
    };
  };
}
