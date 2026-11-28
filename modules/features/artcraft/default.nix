{ inputs, ... }: {
    flake.nixosModules.artcraft =
        { pkgs, ... }:
        let
            system = pkgs.stdenv.hostPlatform.system;
            artcraft = inputs.artcraft.packages.${system};

            # NVK loses the Quadro T2000 device right after the first frame.
            # Force Mesa's Intel ANV driver so effectcraft uses the iGPU.
            effectcraft = pkgs.symlinkJoin {
                name = "effectcraft-intel-vulkan";
                paths = [ artcraft.effectcraft ];
                nativeBuildInputs = [ pkgs.makeWrapper ];
                postBuild = ''
                    wrapProgram $out/bin/effectcraft \
                        --set WGPU_BACKEND vulkan \
                        --set VK_ICD_FILENAMES /run/opengl-driver/share/vulkan/icd.d/intel_icd.x86_64.json
                '';
            };
        in
        {
            environment.systemPackages =
                (with artcraft; [
                    cadcraft
                    deckcraft
                    designcraft
                    filmcraft
                    gridcraft
                    lightcraft
                    pdfcraft
                    photocraft
                    soundcraft
                    vectorcraft
                    wordcraft
                ]) ++ [
                    effectcraft
                    pkgs.zenity
                ];
        };
}
