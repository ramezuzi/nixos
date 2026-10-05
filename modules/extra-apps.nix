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
      
      # System Utilities
      btop
      pavucontrol
      keepassxc
    ];

  };
}
