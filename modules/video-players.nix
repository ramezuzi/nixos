{ ... }:
{
  flake.homeModules.video-players = { pkgs, ... }: {
    home.Packages = with pkgs; [
      mpv        # core player — terminal output built in, no config needed: mpv --vo=tct file.mp4
      vlc        # also has a real TUI: vlc -I ncurses
      celluloid  # GTK frontend for mpv
      # haruna   # Qt/KDE frontend — drops the KDE stack in; skip if you keep just one GUI frontend
      # smplayer # Qt frontend, same redundancy as haruna/celluloid — pick one
      yt-dlp
      ffmpeg
    ];
  };
}
