{ inputs, ... }:
{
  flake.nixosModules.sops = { pkgs, ... }: {
    imports = [ inputs.sops-nix.nixosModules.sops ];

    sops = {
      # The encrypted env file lives in the repository. The age private key
      # stays on the machine at ~/.config/sops/age/keys.txt.
      defaultSopsFile = ../secrets/ai-keys.bin;
      defaultSopsFormat = "binary";
      age.keyFile = "/home/ramez/.config/sops/age/keys.txt";

      secrets.ai-keys-env = {
        format = "binary";
        sopsFile = ../secrets/ai-keys.bin;
        path = "/run/secrets/ai-keys-env";
        owner = "ramez";
        group = "users";
        mode = "0400";
      };
    };

    # /run/secrets.d is root:keys 0750; the user needs group access to read
    # the decrypted secret.
    users.groups.keys = { };
    users.users.ramez.extraGroups = [ "keys" ];

    environment.systemPackages = with pkgs; [
      age
      sops
    ];
  };
}
