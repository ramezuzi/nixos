
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
        # Existing packages — preserved
        agents.herdr
        agents.opencode
        pkgs.aider-chat
        agents.gemini-cli
        agents.qwen-code
        pkgs.pi-coding-agent
        pkgs.nodejs

        # Missing coding-agent backends
        agents.codex
        agents.claude-code

        # Terminal workflow and parallel agent management
        agents.workmux
        agents.agent-manager
        agents.agent-deck

        # GUI orchestration
        agents.vibe-kanban
        agents.kandev
        agents.kandev-desktop
        agents.t3code
        agents.t3code-desktop
        agents.openspec
	agents.coderabbit-cli
	agents.orca
      ];

    home.sessionPath = [
      "${config.home.homeDirectory}/.local/share/pnpm/bin"
    ];

    coding-agents.hermes-agent.enable = true;
  };
}

