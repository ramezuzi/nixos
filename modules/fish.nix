{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
{
  flake.homeModules.fish = { pkgs, ... }: {
    programs.fish = {
      enable = true;

      # Only essential aliases
      shellAbbrs = {
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

      # Load API keys for every fish invocation (scripts, agents, interactive),
      # matching zsh's envExtra.
      shellInit = ''
        set -l ai_agents_credentials "$HOME/.config/ai-agents/credentials.fish"
        if test -r "$ai_agents_credentials"
            source "$ai_agents_credentials"
        else if test -r "$HOME/.config/ai-keys/env"
            # Fallback: parse KEY=value from ai-keys/env into fish globals.
            for line in (cat $HOME/.config/ai-keys/env)
                set -l line (string trim -- $line)
                if test -z "$line"; or string match -q '#*' -- $line
                    continue
                end
                set -l line (string replace -r '^export\s+' ''' -- $line)
                set -l kv (string split -m 1 = -- $line)
                if test (count $kv) -eq 2
                    set -gx $kv[1] (string trim -- $kv[2])
                end
            end
            if set -q GEMINI_API_KEY; and not set -q GOOGLE_API_KEY
                set -gx GOOGLE_API_KEY $GEMINI_API_KEY
            end
        end
      '';

      interactiveShellInit = ''

        # PATH
        fish_add_path ~/.local/bin ~/go/bin ~/.cargo/bin

        # Deduplicate PATH (zsh's `typeset -U path` does the same)
        set -l __seen
        set -l __newpath
        for __p in $PATH
            if not contains -- $__p $__seen
                set __seen $__seen $__p
                set __newpath $__newpath $__p
            end
        end
        set -gx PATH $__newpath

        # Environment
        set -gx EDITOR hx
        set -gx VISUAL hx
        set -gx BROWSER firefox
        set -gx TERMINAL kitty
        set -gx KUBECONFIG ~/.kube/config
        set -U fish_greeting ""

        if command -v starship >/dev/null
            starship init fish | source
        end

        # FZF
        if command -v fzf >/dev/null
            fzf --fish | source
        end

        # Zoxide (smart cd)
        if command -v zoxide >/dev/null
            zoxide init fish | source
        end

        # Atuin (better history)
        if command -v atuin >/dev/null
            atuin init fish | source
        end

        # Direnv
        if command -v direnv >/dev/null
            direnv hook fish | source
        end

        # Quick rebuild
        function nrs
            sudo nixos-rebuild switch --flake ~/nixos#(hostname)
        end

        # Switch k8s context with fzf
        function kctx
            kubectl config use-context (kubectl config get-contexts -o name | fzf)
        end

        # Switch k8s namespace with fzf
        function kns
            kubectl config set-context --current --namespace (kubectl get namespaces -o name | cut -d'/' -f2 | fzf)
        end

        # Tail pod logs with fzf
        function klogs
            kubectl logs -f (kubectl get pods -o name | fzf | cut -d'/' -f2)
        end

        # Extract archives
        function extract
            switch $argv[1]
                case "*.tar.gz"; tar xzf $argv[1]
                case "*.tar.bz2"; tar xjf $argv[1]
                case "*.zip"; unzip $argv[1]
                case "*.rar"; unrar x $argv[1]
                case "*.7z"; 7z x $argv[1]
                case "*"; echo "Unknown format"
            end
        end
      '';
    };
  };
}
