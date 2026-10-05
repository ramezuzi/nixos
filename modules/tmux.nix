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

      # Helper script that prints battery + wifi status in one line.
      # Called from tmux's status-right every 5 seconds.
      tmux-status = pkgs.writeShellScript "tmux-status" ''
        # ── Battery ─────────────────────────────────────────────
        bat=""
        for b in /sys/class/power_supply/BAT*; do
          [ -e "$b" ] || continue
          cap=$(cat "$b/capacity" 2>/dev/null || echo "?")
          st=$(cat "$b/status"   2>/dev/null || echo "Unknown")
          case "$st" in
            Charging)          icon="⚡" ;;
            Discharging)       icon="🔋" ;;
            Full)              icon="🔌" ;;
            Not charging)      icon="🔌" ;;
            *)                 icon="🔋" ;;
          esac
          bat="$icon $cap%"
          break
        done

        # ── Wi-Fi ───────────────────────────────────────────────
        wifi=""
        if command -v nmcli >/dev/null 2>&1; then
          wifi_state=$(nmcli -t -f WIFI general 2>/dev/null | cut -d: -f2)
          if [ "$wifi_state" = "enabled" ]; then
            ssid=$(nmcli -t -f ACTIVE,SSID dev wifi 2>/dev/null | awk -F: '$1=="yes"{print $2; exit}')
            if [ -n "$ssid" ]; then
              wifi="󰤨 $ssid"
            else
              wifi="󰤭 off"
            fi
          else
            wifi="󰤮 off"
          fi
        else
          # Fallback: check the first wireless interface's operstate
          for iface in /sys/class/net/*/wireless; do
            [ -e "$iface" ] || continue
            name=$(basename "$(dirname "$iface")")
            state=$(cat "/sys/class/net/$name/operstate" 2>/dev/null || echo "down")
            if [ "$state" = "up" ]; then
              wifi="󰤨 $name"
            else
              wifi="󰤮 off"
            fi
            break
          done
        fi

        # Print with a separator; tmux will render this between the clock and prefix
        echo "$wifi  $bat"
      '';
    in
    {
      # Pre-create the session scripts directory
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
          set -g status-right " #{?client_prefix,#[fg=#e0e0e0]PREFIX ,}#(${tmux-status}) │ %H:%M │ %d-%b "
          set -g status-right-length 100
          set -g status-justify centre
          set -g status-interval 5

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
