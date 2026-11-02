{...}: {
  flake.nixosModules.fonts = {pkgs, ...}: {
    # ── Install essential fallback fonts ───────────────────────
    # (JetBrains Mono is handled automatically by Stylix)
    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      liberation_ttf
      font-awesome
    ];

    # ── Fontconfig Settings ────────────────────────────────────
    fonts.fontconfig = {
      enable = true;
      antialias = true;

      hinting = {
        enable = true;
        style = "slight";
      };

      subpixel = {
        rgba = "rgb";
        lcdfilter = "default";
      };

      # ── MAKE EVERYTHING BOLD GLOBALLY ────────────────────────
      # If you ever want to revert this, just delete the localConf block.
      localConf = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
        <fontconfig>
          <match target="font">
            <edit name="weight" mode="assign" binding="strong">
              <const>bold</const>
            </edit>
          </match>
        </fontconfig>
      '';
    };
  };
}
