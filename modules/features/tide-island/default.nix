# modules/tide-island-pkg.nix
{ inputs, self, ... }:
{
  flake.nixosModules.tideIslandPkg = { pkgs, lib, ... }: {
    nixpkgs.overlays = [
      (final: prev: {
        tide-island = prev.qt6.callPackage (
          { stdenv, fetchFromGitHub, cmake, ninja, pkg-config, qt6, udev, python3, dbus, quickshell, makeWrapper, lib }:
          let
            ukishimaSrc = fetchFromGitHub {
              owner = "amanhex";
              repo = "ukishima";
              rev = "9dfe085933bd001fb63603a62df9237ccc9ca46a";
              hash = "sha256-oJl6tnesjO0ExYH4gGtkZ+kLpsjM6/9aA8yRKvgiC74=";
            };
          in
          stdenv.mkDerivation {
            pname = "tide-island";
            version = "1.0.35";

            src = fetchFromGitHub {
              owner = "enhaoswen";
              repo = "Tide-island";
              rev = "27237e261a07cfabc67d85d1308eac3b91690111";
              hash = "sha256-aa8oyGqEsBquV/W8VjJcgJ1QeQKYwsIpUmbDdlmP1e4=";
            };

            nativeBuildInputs = [
              cmake
              ninja
              pkg-config
              qt6.wrapQtAppsHook
              python3
              makeWrapper
            ];

            buildInputs = (with qt6; [ qtbase qtdeclarative qt5compat ]) ++ [ udev quickshell ];

            # Fix typos in the upstream QML that break night mode
            postPatch = ''
              substituteInPlace qml/controlcenter/ControlCenterLayer.qml \
                --replace "property boolnightLightEnabled" "property bool nightLightEnabled" \
                --replace "property boolnightLightBusy" "property bool nightLightBusy"
            '';

            postInstall = ''
              # Patch hardcoded /usr/bin/quickshell in the launcher
              substituteInPlace $out/bin/tide-island \
                --replace /usr/bin/quickshell ${quickshell}/bin/quickshell

              # Move IslandBackend QML plugin to the correct Qt6 path
              mkdir -p $out/lib/qt-6/qml
              if [ -d $out/lib/qt6/qml/IslandBackend ]; then
                cp -r $out/lib/qt6/qml/IslandBackend $out/lib/qt-6/qml/
              fi

              # Copy ukishima clipboard feature directly into installed share
              mkdir -p $out/share/tide-island/qml/ukishima/surfaces
              cp -r ${ukishimaSrc}/components $out/share/tide-island/qml/ukishima/components
              cp -r ${ukishimaSrc}/Singletons $out/share/tide-island/qml/ukishima/Singletons
              cp ${ukishimaSrc}/surfaces/Clipboard.qml $out/share/tide-island/qml/ukishima/surfaces/

              # Wrap the launcher so QML2_IMPORT_PATH is set for quickshell
              wrapProgram $out/bin/tide-island \
                --set QML2_IMPORT_PATH "${qt6.qt5compat}/lib/qt-6/qml:${qt6.qtbase}/lib/qt-6/qml:${qt6.qtdeclarative}/lib/qt-6/qml:$out/lib/qt-6/qml"

              # Create a helper script for IPC commands
              cat > $out/bin/tide-island-ipc <<EOF
              #!/bin/sh
              exec ${quickshell}/bin/quickshell ipc --any-display -p $out/share/tide-island "\$@"
              EOF
              chmod +x $out/bin/tide-island-ipc
            '';
          }
        ) { };
      })
    ];

    environment.systemPackages = [ pkgs.tide-island pkgs.quickshell ];
  };
}
