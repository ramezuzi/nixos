{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
{
  flake.homeModules.zsh = { pkgs, ... }: {
    programs.zsh = {
      enable = true;

      # Same abbreviations as fish.nix, expressed as zsh aliases.
      shellAliases = {
        # NixOS
        nfu = "nix flake update";

        # Git
        g = "git";
        gs = "git status";
        gc = "git commit -m";
        gp = "git push";
        gpl = "git pull";
        gd = "git diff";
        gco = "git checkout";

        # Kubernetes
        k = "kubectl";
        kg = "kubectl get";
        kd = "kubectl describe";
        kl = "kubectl logs -f";
        ke = "kubectl exec -it";

        # Terraform
        tf = "tofu";
        tfp = "tofu plan";
        tfa = "tofu apply";
        tff = "tofu fmt";

        # Docker
        d = "docker";
        dps = "docker ps";
        dc = "docker compose";
        dcu = "docker compose up -d";
        dcd = "docker compose down";

        # Modern replacements
        cat = "bat";
        grep = "rg";
        find = "fd";
        ls = "eza --git";
        ll = "eza -l --git";
        lt = "eza --tree";
        l = "ls -alh"; # same as NixOS's fish default (`alias l 'ls -alh'`)

        # Quick config edits
        vf = "hx ~/nixos/flake.nix";
        vh = "hx ~/nixos/hosts/zbook/default.nix";
        vk = "hx ~/nixos/modules/kitty.nix";
        ve = "hx ~/nixos/modules/helix.nix";
        vfish = "hx ~/nixos/modules/fish.nix";
        vzsh = "hx ~/nixos/modules/zsh.nix";
        vs = "hx ~/nixos/modules/stylix.nix";

        # nh
        nh = "nh os switch ~/nixos --hostname zbook";
      };

      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      history = {
        size = 100000;
        save = 100000;
        path = "$HOME/.zsh_history";
        ignoreDups = true;
        ignoreSpace = true;
        share = true;
        extended = true;
      };

      # Load API keys for all zsh invocations (including non-interactive agents).
      envExtra = ''
        # Keep provider credentials out of Nix and the dotfiles repository.
        # Prefer generated credentials.zsh; then the sops-nix secret; then the
        # legacy plaintext file.
        ai_agents_credentials="$HOME/.config/ai-agents/credentials.zsh"
        if [[ -r "$ai_agents_credentials" ]]; then
          source "$ai_agents_credentials"
        elif [[ -r /run/secrets/ai-keys-env ]]; then
          set -a
          source /run/secrets/ai-keys-env
          set +a
          if [[ -n "''${GEMINI_API_KEY-}" && -z "''${GOOGLE_API_KEY-}" ]]; then
            export GOOGLE_API_KEY="$GEMINI_API_KEY"
          fi
        elif [[ -r "$HOME/.config/ai-keys/env" ]]; then
          set -a
          source "$HOME/.config/ai-keys/env"
          set +a
          if [[ -n "''${GEMINI_API_KEY-}" && -z "''${GOOGLE_API_KEY-}" ]]; then
            export GOOGLE_API_KEY="$GEMINI_API_KEY"
          fi
        fi
      '';

      initContent = ''
        # PATH (same as fish: prepend existing dirs only)
        typeset -U path
        _extra_paths=()
        for _p in "$HOME/.local/bin" "$HOME/go/bin" "$HOME/.cargo/bin"; do
          [[ -d "$_p" ]] && _extra_paths+=("$_p")
        done
        (( $#_extra_paths )) && path=("''${_extra_paths[@]}" $path)
        unset _p _extra_paths

        # Environment
        export EDITOR=hx
        export VISUAL=hx
        export BROWSER=firefox
        export TERMINAL=kitty
        export KUBECONFIG=~/.kube/config

        if command -v starship >/dev/null 2>&1; then
          eval "$(starship init zsh)"
        fi

        # FZF
        if command -v fzf >/dev/null 2>&1; then
          source <(fzf --zsh)
        fi

        # Zoxide (smart cd)
        if command -v zoxide >/dev/null 2>&1; then
          eval "$(zoxide init zsh)"
        fi

        # Atuin (better history)
        if command -v atuin >/dev/null 2>&1; then
          eval "$(atuin init zsh)"
        fi

        # Direnv
        if command -v direnv >/dev/null 2>&1; then
          eval "$(direnv hook zsh)"
        fi

        # Quick rebuild (same as fish's nrs function)
        nrs() {
          sudo nixos-rebuild switch --flake ~/nixos#$(hostname)
        }

        # Switch k8s context with fzf
        kctx() {
          kubectl config use-context "$(kubectl config get-contexts -o name | fzf)"
        }

        # Switch k8s namespace with fzf
        kns() {
          kubectl config set-context --current --namespace "$(kubectl get namespaces -o name | cut -d'/' -f2 | fzf)"
        }

        # Tail pod logs with fzf
        klogs() {
          kubectl logs -f "$(kubectl get pods -o name | fzf | cut -d'/' -f2)"
        }

        # Extract archives
        extract() {
          case "$1" in
            *.tar.gz)  tar xzf "$1" ;;
            *.tar.bz2) tar xjf "$1" ;;
            *.zip)     unzip "$1" ;;
            *.rar)     unrar x "$1" ;;
            *.7z)      7z x "$1" ;;
            *)         echo "Unknown format" ;;
          esac
        }
      '';
    };
  };
}
