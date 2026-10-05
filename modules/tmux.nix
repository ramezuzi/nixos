# modules/tmux.nix
{ inputs, self, ... }: {
  flake.homeModules.tmux = { pkgs, config, lib, ... }:
    let
      # Build tmux-workspaces as a proper tmux plugin.
      # Home Manager's tmux module will run workspaces.tmux automatically
      # via run-shell when the plugin is listed in programs.tmux.plugins.
      tmux-workspaces = pkgs.tmuxPlugins.mkTmuxPlugin {
        pluginName = "tmux-workspaces";
        version = "master";
        rtpFilePath = "workspaces.tmux";
        src = pkgs.fetchFromGitHub {
          owner = "niflostancu";
          repo = "tmux-workspaces";
          rev = "master";
          # Replace with the output of:
          #   nix-prefetch-github niflostancu tmux-workspaces --rev master
          hash = lib.fakeHash;
        };
      };
    in
    {
      # Pre-create the session scripts directory so the plugin finds it.
      # The default path is $XDG_DATA_HOME/tmux/sessions, which resolves to
      # ~/.local/share/tmux/sessions when XDG_DATA_HOME isn't overridden.
      home.file.".local/share/tmux/sessions/.keep".text = "";

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

        # Load tmux-workspaces. Home Manager's tmux module handles
        # the run-shell line for us via rtpFilePath.
        plugins = [ tmux-workspaces ];

        extraConfig = ''
          # ── True color ────────────────────────────────────────────
          set -as terminal-features ",*:RGB"
          set -g default-terminal "tmux-256color"

          # ── Koda monochrome palette ───────────────────────────────
          # If Stylix's tmux target is enabled, it will override these.
          set -g status-style                    "bg=#080808,fg=#a6a6a6"
          set -g status-left-style               "bg=#0c0c0c,fg=#a6a6a6"
          set -g status-right-style              "bg=#0c0c0c,fg=#8a8a8a"
          set -g window-status-style             "bg=#080808,fg=#666666"
          set -g window-status-current-style     "bg=#1a1a1a,fg=#e0e0e0,bold"
          set -g pane-border-style               "fg=#1a1a1a"
          set -g pane-active-border-style        "fg=#3d3d3d"
          set -g message-style                   "bg=#1a1a1a,fg=#e0e0e0"
          set -g message-command-style           "bg=#1a1a1a,fg=#e0e0e0"

          # ── Status bar content ────────────────────────────────────
          set -g status-left  " #[bold]#S #[nobold]│ "
          set -g status-left-length 30
          set -g status-right " #{?client_prefix,#[fg=#e0e0e0]PREFIX ,}%H:%M │ %d-%b "
          set -g status-right-length 60
          set -g status-justify centre

          # ── Window list ───────────────────────────────────────────
          set -g window-status-format         " #I:#W "
          set -g window-status-current-format " #I:#W "
          set -g window-status-separator      ""

          # ── Pane numbering & behaviour ────────────────────────────
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

          # Where workspace session scripts live
          set-option -g @workspaces-dir "$XDG_DATA_HOME/tmux/sessions"

          # Enable pane contents capture/restore (optional, recommended)
          set-option -g @capture-pane-enable "1"

          # Fuzzy workspace selector on prefix + Ctrl+j
          bind C-j run-shell "#{@workspaces-srcdir}/scripts/fuzzy-workspaces.sh"

          # Kill current session and switch to previous (prefix + Ctrl+k)
          set -g command-alias[10] skill='run-shell "#{@workspaces-srcdir}/scripts/kill-session.sh"'

          # Reload config
          bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded"

          # New window in current pane's directory
          bind e new-window -c "#{pane_current_path}"
        '';

        # Restore captured pane contents on shell startup.
        # This is the snippet the plugin README recommends putting in your
        # shell config. Using fish because that's your shell.
        shellInit = ''
          if test -n "$TMUX_PANE_RESTORE_CMD"
            eval $TMUX_PANE_RESTORE_CMD
            set -e TMUX_PANE_RESTORE_CMD
          end
        '';
      };
    };
}
