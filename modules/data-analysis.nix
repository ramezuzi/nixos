{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.dataAnalysis = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      # Spreadsheets
      libreoffice
      gnumeric

      # TUI Tools
      visidata
      sc-im
      xleak

      # Visualization
      gnome-graphs
    ];
  };
}
