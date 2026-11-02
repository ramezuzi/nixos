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

      # Force Bold & Demibold rendering to prevent blurry thin text
      localConf = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
        <fontconfig>
          <!-- 1. Force literally everything to Bold -->
          <match target="font">
            <edit name="weight" mode="assign" binding="strong">
              <const>bold</const>
            </edit>
          </match>
          
          <!-- 2. If an app asks for a lighter weight, give it DemiBold instead -->
          <match target="pattern">
            <test name="weight" compare="less_eq">
              <const>medium</const>
            </test>
            <edit name="weight" mode="assign" binding="strong">
              <const>demibold</const>
            </edit>
          </match>
        </fontconfig>
      '';
    };
  };
}
