# modules/ukishima.nix
{
  flake.nixosModules.ukishima =
    { pkgs, ... }:
    let
      ukishima = pkgs.stdenv.mkDerivation {
        pname = "ukishima";
        version = "master";

        src = pkgs.fetchFromGitHub {
          owner = "amanhex";
          repo = "ukishima";
          rev = "master";
          hash = "sha256-kROGdhEpJ4nxZlcj1tNYsZSv3s4WItcGdDW6//HxCk4=";
        };

        nativeBuildInputs = [ pkgs.makeWrapper ];

        # Automatically refresh wallpaper thumbnails when the wallpaper surface opens
        postPatch = ''
          sed -i '/onActiveChanged: if (active) {/a\        Qt.callLater(Walls.refresh);' surfaces/Wallpaper.qml
        '';

        installPhase = ''
          mkdir -p $out/share/ukishima $out/bin
          cp -r . $out/share/ukishima

          makeWrapper ${pkgs.quickshell}/bin/quickshell $out/bin/ukishima \
            --add-flags "-p $out/share/ukishima" \
            --set QML2_IMPORT_PATH "${pkgs.qt6.qt5compat}/lib/qt-6/qml:${pkgs.qt6.qtbase}/lib/qt-6/qml:${pkgs.qt6.qtdeclarative}/lib/qt-6/qml:${pkgs.qt6.qtmultimedia}/lib/qt-6/qml"

          # Stable IPC wrapper – always uses the correct store path
          cat > $out/bin/ukishima-ipc <<EOF
          #!/bin/sh
          exec ${pkgs.quickshell}/bin/quickshell ipc --any-display -p $out/share/ukishima "\$@"
          EOF
          chmod +x $out/bin/ukishima-ipc
        '';
      };
    in
    {
      environment.systemPackages = [ ukishima ];
    };
}
