# modules/tmux.nix
{ inputs, self, ... }: {
  flake.homeModules.tmux = { pkgs, config, lib, ... }:
    let
      tmux-workspaces = pkgs.tmuxPlugins.mkTmuxPlugin {
        pluginName = "tmux-workspaces";
        version = "master";
        rtpFilePath = "workspaces.tmux";
        src = pkgs.fetchFromGitHub {
          owner = "niflostancu";
          repo = "tmux-workspaces";
          rev = "master";
          hash = "sha256-fJwZVkhieKhb+bTkoYjsKf0VEcjHQ5v83u4m7GgaXNc=";   # replace with the hash from nix-prefetch-github
        };
      };
    in
    {
      # Pre-create the session scripts directory so the plugin finds it
      home.file.".local/share/tmux/sessions/.keep".text = "";

      # Restore captured pane contents when fish starts inside a tmux pane
      programs.fish.shellInit = ''
        if test -n "$TMUX_PANE_RESTORE_CMD"
          eval $TMUX_PANE_RESTORE_CMD
          set -e TMUX_PANE_RESTORE_CMD
        end
      '';

      programs.tmux = {
        enable = true;
        shell = "${pkgs.fish}/bin/fish";
        terminal = "tmux-256color";
        baseIndex = 1;
        escapeTime = 0;
        historyLimit = 50000;
        keyMode = "vi";
        mouse = true;
        prefix = "C-a";
        sensibleOnTop = true;

        plugins = [ tmux-workspaces ];

        extraConfig = ''
          # ── True color ────────────────────────────────────────────
          set -as terminal-features ",*:RGB"
          set -g default-terminal "tmux-256color"

          # ── Koda monochrome palette ───────────────────────────────
          set -g status-style                    "bg=#080808,fg=#a6a6a6"
          set -g status-left-style               "bg=#0c0c0c,fg=#a6a6a6"
          set -g status-right-style              "bg=#0c0c0c,fg=#8a8a8a"
          set -g window-status-style             "bg=#080808,fg=#666666"
          set -g window-status-current-style     "bg=#1a1a1a,fg=#e0e0e0,bold"
          set -g pane-border-style               "fg=#1a1a1a"
          set -g pane-active-border-style        "fg=#3d3d3d"
          set -g message-style                   "bg=#1a1a1a,fg=#e0e0e0"
          set -g message-command-style           "bg=#1a1a1a,fg=#e0e0e0"

          # ── Status bar ────────────────────────────────────────────
          set -g status-left  " #[bold]#S #[nobold]│ "
          set -g status-left-length 30
          set -g status-right " #{?client_prefix,#[fg=#e0e0e0]PREFIX ,}%H:%M │ %d-%b "
          set -g status-right-length 60
          set -g status-justify centre
          set -g window-status-format         " #I:#W "
          set -g window-status-current-format " #I:#W "
          set -g window-status-separator      ""

          # ── Pane numbering ────────────────────────────────────────
          set -g pane-base-index 1
          set -g renumber-windows on
          setw -g aggressive-resize on

          # ── Splits ────────────────────────────────────────────────
          bind | split-window -h -c "#{pane_current_path}"
          bind - split-window -v -c "#{pane_current_path}"
          unbind '"'
          unbind %

          # ── Vim-style pane navigation ─────────────────────────────
          bind h select-pane -L
          bind j select-pane -D
          bind k select-pane -U
          bind l select-pane -R

          # ── Resize panes ──────────────────────────────────────────
          bind -r H resize-pane -L 5
          bind -r J resize-pane -D 5
          bind -r K resize-pane -U 5
          bind -r L resize-pane -R 5

          # ── Copy mode ─────────────────────────────────────────────
          setw -g mode-keys vi
          bind -T copy-mode-vi v send -X begin-selection
          bind -T copy-mode-vi y send -X copy-selection-and-cancel
          bind -T copy-mode-vi MouseDragEnd1Pane send -X copy-selection-and-cancel

          # ── Misc ──────────────────────────────────────────────────
          set -sg escape-time 0
          set -g focus-events on
          setw -g monitor-activity on
          set -g visual-activity off
          set -g visual-bell off
          set -g bell-action none
          setw -g automatic-rename on
          setw -g automatic-rename-format "#{b:pane_current_path}"
          set -g detach-on-destroy off

          # ═══════════════════════════════════════════════════════════
          # tmux-workspaces
          # ═══════════════════════════════════════════════════════════
          set-option -g @workspaces-dir "$XDG_DATA_HOME/tmux/sessions"
          set-option -g @capture-pane-enable "1"

          bind C-j run-shell "#{@workspaces-srcdir}/scripts/fuzzy-workspaces.sh"

          set -g command-alias[10] skill='run-shell "#{@workspaces-srcdir}/scripts/kill-session.sh"'

          bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded"
          bind e new-window -c "#{pane_current_path}"
        '';
      };
    };
}
