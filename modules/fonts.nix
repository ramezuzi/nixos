{ ... }: {
  flake.nixosModules.fonts = { pkgs, ... }: {
    # Install essential fallback fonts
    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      liberation_ttf
      font-awesome
    ];

    # Global Fontconfig Settings
    fonts.fontconfig = {
      enable = true;
      antialias = true;

      hinting = {
        enable = true;
        style = "slight"; # 'slight' usually provides the crispest text
      };

      subpixel = {
        rgba = "rgb";
        lcdfilter = "default";
      };

      # Use the real bold face for all application font requests.
      localConf = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
        <fontconfig>
          <match target="pattern">
            <edit name="weight" mode="assign" binding="strong">
              <const>bold</const>
            </edit>
          </match>
        </fontconfig>
      '';

    };
  };
}
