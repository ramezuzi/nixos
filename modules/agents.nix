{ inputs, ... }:
{
  flake.nixosModules.agents = { ... }: {
    nixpkgs.overlays = [ inputs.coding-agents.overlays.default ];
  };

  flake.homeModules.agents = { pkgs, config, ... }: {
    imports = [ inputs.coding-agents.homeManagerModules.default ];

    home.packages =
      let
        agents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
      in
      [
        agents.herdr
        agents.opencode
        pkgs.aider-chat
        agents.gemini-cli
        agents.qwen-code
        pkgs.pi-coding-agent
        pkgs.nodejs
      ];

    home.sessionPath = [ "${config.home.homeDirectory}/.local/share/pnpm/bin" ];
    coding-agents.hermes-agent.enable = true;
  };
}
