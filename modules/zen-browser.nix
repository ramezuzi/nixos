{ inputs, self, ... }: {

  flake.homeModules.zen = { ... }: {

    imports = [
      inputs.zen-browser.homeModules.beta
    ];

    programs.zen-browser = {
      enable = true;
    };
    stylix.targets.zen-browser = {
      enable = true;
      profileNames = [ "9sdaj60q.Default Profile" ];
    };
  };
}
