{ ... }:
{
  flake.homeModules.starship = { config, ... }: {
    programs.starship = {
      enable = true;
      settings = {
        "$schema" = "https://starship.rs/config-schema.json";
        scan_timeout = 100;
        command_timeout = 500;
        follow_symlinks = false;
        add_newline = false;
        palette = "custom1";
        format = "$directory\${custom.giturl}$git_branch\${custom.git_worktree}$git_status$line_break$character";
        right_format = "$all";

        palettes.custom1 = {
          base = config.lib.stylix.colors.withHashtag.base00;
          surface0 = config.lib.stylix.colors.withHashtag.base01;
          text = config.lib.stylix.colors.withHashtag.base05;
          teal = config.lib.stylix.colors.withHashtag.base0C;
          lavender = config.lib.stylix.colors.withHashtag.base0D;
          mauve = config.lib.stylix.colors.withHashtag.base0E;
          peach = config.lib.stylix.colors.withHashtag.base09;
          foam = config.lib.stylix.colors.withHashtag.base0B;
        };

        directory = {
          style = "teal";
          format = "[ $path ]($style)";
          truncation_length = 4;
          substitutions = {
            "Documents" = "󰈙 ";
            "Downloads" = " ";
            "Music" = " ";
            "Pictures" = " ";
            "Developer" = "󰲋 ";
            "Others" = " ";
          };
        };

        username = {
          disabled = true;
          show_always = true;
          style_user = "bg:surface0 fg:text";
          style_root = "bg:surface0 fg:text";
          format = " $user ";
        };

        line_break.disabled = true;

        character = {
          disabled = false;
          success_symbol = "[ ](bold fg:green)";
          error_symbol = "[✘ ](bold fg:red)";
          vimcmd_symbol = "[: ](bold fg:yellow)";
        };

        package.disabled = false;

        time = {
          disabled = true;
          time_format = "%R";
          format = "[[  $time ](fg:yellow bg:foam)]($style)";
        };

        custom = {
          giturl = {
            description = "Display symbol for remote Git server";
            command = ''
              GIT_REMOTE=$(command git ls-remote --get-url 2> /dev/null)
              if [[ "$GIT_REMOTE" =~ "github" ]]; then
                  GIT_REMOTE_SYMBOL=" "
              elif [[ "$GIT_REMOTE" =~ "gitlab" ]]; then
                  GIT_REMOTE_SYMBOL="󰮠 "
              elif [[ "$GIT_REMOTE" =~ "bitbucket" ]]; then
                  GIT_REMOTE_SYMBOL=" "
              elif [[ "$GIT_REMOTE" =~ "git" ]]; then
                  GIT_REMOTE_SYMBOL=" "
              else
                  GIT_REMOTE_SYMBOL=" "
              fi
              echo "$GIT_REMOTE_SYMBOL "
            '';
            when = "git rev-parse --is-inside-work-tree 2> /dev/null";
            format = "$output";
            require_repo = true;
            ignore_timeout = true;
          };

          git_worktree = {
            description = "Show indicator when inside a git worktree";
            command = ''
              if git rev-parse --git-dir >/dev/null 2>&1; then
                    common_dir=$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null)
                    git_dir=$(git rev-parse --path-format=absolute --git-dir 2>/dev/null)
                    if [ "$common_dir" != "$git_dir" ]; then
                          echo "⛓ "
                    fi
              fi
            '';
            when = "git rev-parse --is-inside-work-tree >/dev/null 2>&1";
            format = " ([$output ]($style))";
            style = "bold green";
            require_repo = true;
            ignore_timeout = true;
          };
        };

        git_branch = {
          symbol = "[](base) ";
          style = "fg:lavender bg:base";
          format = "  [$symbol$branch]($style)[](base)";
        };

        git_status = {
          format = "[$untracked$staged$modified$renamed$conflicted$ahead_behind ]($style)";
          staged = "[+](green)";
          modified = "[!](yellow)";
          renamed = "[»](blue)";
          deleted = "[-](red)";
          untracked = "[?](red)";
          stashed = "[≡](lavender)";
          conflicted = "[✖](red bold)";
          ahead = "[⇡\${count}](teal)";
          behind = "[⇣\${count}](peach)";
          diverged = "[⇕⇡\${ahead_count}⇣\${behind_count}](mauve)";
        };

        os = {
          disabled = true;
          symbols = {
            Windows = "󰍲"; Ubuntu = "󰕈"; SUSE = ""; Raspbian = "󰐿";
            Mint = "󰣭"; Macos = " "; Manjaro = ""; Linux = "󰌽";
            Gentoo = "󰣨"; Fedora = "󰣛"; Alpine = ""; Amazon = "";
            Android = ""; Arch = "󰣇"; Artix = "󰣇"; CentOS = "";
            Debian = "󰣚"; Redhat = "󱄛"; RedHatEnterprise = "󱄛";
            Nixos = "󱄅";
          };
        };

        nodejs = { symbol = ""; format = "[ $symbol( $version) ]($style)"; };
        bun.detect_files = [ "bun.lock" "bun.lockb" ];
        c = { symbol = " "; format = "[ $symbol( $version) ]($style)"; };
        rust = { symbol = "󱘗"; format = "[ $symbol( $version) ]($style)"; };
        golang = { symbol = "󰟓"; format = "[ $symbol( $version) ]($style)"; detect_files = [ "go.mod" ]; };
        php = { symbol = ""; format = "[ $symbol( $version) ]($style)"; };
        java = { symbol = " "; format = "[ $symbol( $version) ]($style)"; };
        kotlin = { symbol = ""; format = "[ $symbol( $version) ]($style)"; };
        haskell = { symbol = ""; format = "[ $symbol( $version) ]($style)"; };
        python = { symbol = ""; format = "[ $symbol( $version) ]($style)"; };
        docker_context = { symbol = ""; format = "[ $symbol( $context) ]($style)"; };
      };
    };

    stylix.targets.starship.enable = false; # palette.custom1 above already comes from stylix's colors — leave the auto-target off so it doesn't also try to inject its own
  };
}
