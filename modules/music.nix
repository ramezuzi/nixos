{ self, inputs, ... }: {
  flake.homeModules.music = { pkgs, config, ... }: {
    home.packages = with pkgs; [
      cmus
      termusic
      ncmpcpp
      mpc
      rmpc
    ];

    services.mpd = {
      enable = true;
      musicDirectory = "/home/ramez/Music";
    };
  };
}
