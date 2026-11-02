{ ... }:
{
  # GUI clients (the Windows-style apps)
  flake.homeModules.db-gui = { pkgs, ... }: {
    home.packages = with pkgs; [
      dbeaver-bin # one app for MySQL, Postgres, SQLite, etc.
      mysql-workbench # official MySQL GUI
      pgadmin4-desktopmode # official PostgreSQL GUI, as a desktop app
      lazysql # TUI option
    ];
  };

  # Optional: actual servers, always running as system services.
  # Not enabled by default: your devenv Postgres also uses 5432.
  flake.nixosModules.db-servers = { pkgs, ... }: {
    services.mysql = {
      enable = true;
      package = pkgs.mysql84; # use pkgs.mariadb for MariaDB
    };
    services.postgresql = {
      enable = true;
      settings.port = 5433; # avoids clashing with devenv's 5432
    };
  };
}
