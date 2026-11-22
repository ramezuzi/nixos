{ inputs, self, ... }: {
  flake.nixosModules.apps = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      # Media & Streaming
      (wrapOBS {
        plugins = with obs-studio-plugins; [
          wlrobs
          obs-vkcapture
          obs-backgroundremoval
          obs-pipewire-audio-capture
          obs-vaapi
        ];
      })
      
      
      # Document & Image Viewers
      zathura
      evince
      imv
      nsxiv
      
      # File Managers
      nautilus

      # Compositor config GUIs (edit live configs, no rebuild)
      hyprmod # GTK4/libadwaita settings app for Hyprland (Lua-aware)
      nirimod # GTK4/libadwaita settings app for niri (validates every save)

      # System Utilities
      btop
      pavucontrol
      keepassxc
    ];

  };
}
