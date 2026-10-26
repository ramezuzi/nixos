{inputs, ...}: {
  flake.homeModules.agents = {
    pkgs,
    config,
    ...
  }: {
    home.packages = let
      agents =
        inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
    in [
      # Existing tools
      agents.herdr
      agents.opencode
      agents.gemini-cli
      agents.qwen-code
      pkgs.pi-coding-agent
      pkgs.nodejs

      # Claude ecosystem
      agents.claude-agent-acp
      agents.claudebox
      agents.claude-code
      agents.claude-code-router
      agents.claude-desktop
      agents.clauth
      agents.oh-my-claudecode

      # OpenAI / Codex ecosystem
      agents.codex
      agents.codex-acp
      agents.codex-auth
      agents.oh-my-codex
      agents.opencodex

      # OpenCode ecosystem
      agents.opencode2
      agents.opencode2-desktop
      agents.opencode-desktop
      agents.oh-my-opencode

      # Other coding agents and CLIs
      agents.amp
      agents.antigravity-cli
      agents.antigravity-hub
      agents.aven
      agents.ax
      agents.claw-code
      agents.cline
      agents.codebuddy-code
      agents.command-code
      agents.copilot-cli
      agents.copilot-language-server
      agents.crush
      agents.cursor-agent
      agents.droid
      agents.eca
      agents.forgecode
      agents.gemini-cli
      agents.goose-cli
      agents.grok
      agents.grok-bot
      agents.happy-coder
      agents.hax
      agents.hermes-agent
      agents.hermes-desktop
      agents.ironclaw
      agents.jcode
      agents.jules
      agents.junie
      agents.kilocode-cli
      agents.kimi-code
      agents.letta-code
      agents.localgpt
      agents.luvus
      agents.mimo-code
      agents.minimax-code
      agents.mistral-vibe
      agents.muse-code
      agents.nanocoder
      agents.omo-ai
      agents.orbi-cli
      agents.pi-acp
      agents.qoder-cli
      agents.qoder-cli-cn
      agents.reasonix
      agents.unreal-agent
      agents.voxterm
      agents.zcode
      agents.dsh

      # Multi-agent orchestration and dashboards
      agents.agent-deck
      agents.agent-manager
      agents.agentsview
      agents.agentty
      agents.aperant
      agents.bb-app
      agents.executor
      agents.gastown
      agents.hermes-one
      agents.kandev
      agents.kandev-desktop
      agents.multica
      agents.multica-desktop
      agents.oh-my-opencode
      agents.openhands-agent-canvas
      agents.orca
      agents.paperclip
      agents.paseo-desktop
      agents.parallel-cli
      agents.prime-agent
      agents.swamp
      agents.t3code
      agents.t3code-desktop
      agents.treehouse
      agents.workmux

      # Git, worktrees, and codebase navigation
      agents.entire
      agents.git-ai
      agents.gitbutler
      agents.gitclaw
      agents.gitnexus
      agents.git-surgeon
      agents.codegraph
      agents.code-review-graph
      agents.gnhf
      agents.hunk
      agents.tuicr

      # Planning, specs, tasks, and issue tracking
      agents.annot
      agents.backlog-md
      agents.beads
      agents.beads-rust
      agents.beads-viewer
      agents.cc-sdd
      agents.crit
      agents.dolt
      agents.openspec
      agents.openspecui
      agents.plannotator
      agents.plannotator-tui
      agents.ralph-tui
      agents.spec-kit
      agents.td
      agents.trellis

      # Code review, quality, and developer utilities
      agents.coderabbit-cli
      agents.formatelf
      agents.greptile-cli
      agents.jscpd
      agents.no-mistakes
      agents.open-code-review
      agents.rtk
      agents.showboat

      # Context, memory, and knowledge tools
      agents.ai-memory
      agents.context-hub
      agents.ctx
      agents.hindsight
      agents.hindsight-control-plane
      agents.lean-ctx
      agents.memvid-cli
      agents.mindwalk
      agents.openresearch
      agents.qmd
      agents.semble

      # Usage, status, and session visibility
      agents.ccstatusline
      agents.ccusage
      agents.cpa-usage-keeper
      agents.hermes-hud
      agents.tokscale

      # Browser and computer-use tools
      agents.agent-browser
      agents.terminal-browser
      agents.terminal-use
      agents.vessel-browser

      # MCP and integrations
      agents.mcporter
      agents.mcp-remote
      agents.mcptoon
      agents.agent-slack

      # Additional utilities from the catalog
      agents.aionui
      agents.apm
      agents.auv
      agents.bernstein
      agents.but
      agents.chatgpt
      agents.ck
      agents.coco
      agents.collie
      agents.cubic
      agents.docker-sbx
      agents.fence
      agents.freebuff
      agents.funes
      agents.fx
      agents.gno
      agents.handy
      agents.icm
      agents.maki
      agents.mardi-gras
      agents.mirasim
      agents.nono
      agents.officecli
      agents.openclaw
      agents.ori
      agents.picoclaw
      agents.pool
      agents.semble
      agents.sidecar
      agents.site
      agents.skills
      agents.sub2api
      agents.tgrab
      agents.tui-test
      agents.voxtype
      agents.wrapBuddy
      agents.zaly
      agents.zat
      agents.zeroclaw
    ];

    home.sessionPath = [
      "${config.home.homeDirectory}/.local/share/pnpm/bin"
    ];
  };
}
