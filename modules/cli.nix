{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:

{
  # ----------------------------------------------------------------------
  # System-level packages (available to all users)
  # ----------------------------------------------------------------------
  flake.nixosModules.tools = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      # ---- GNU Core Utilities ----
      coreutils # ls, cp, mv, rm, cat, etc.
      findutils # find, xargs
      gnugrep # grep with GNU extensions
      gnused # sed
      gawk # awk
      gnutar # tar
      gzip # gzip, gunzip
      diffutils # diff, cmp
      file # file type detection

      # ---- Modern Replacements ----
      bat # better cat with syntax highlighting
      eza # modern ls with icons and git status
      ripgrep # faster grep (rg)
      fd # faster find (fd)
      jq # JSON processor
      yq-go # YAML/JSON/XML processor
      fzf # fuzzy finder
      zoxide # smarter cd (z)
      atuin # shell history with SQLite
      duf # disk usage viewer
      ncdu # disk usage analyzer (TUI)
      btop # resource monitor (better than htop)
      procs # better ps

      # ---- Networking ----
      curl
      wget
      mtr # traceroute + ping
      nmap # network scanner
      netcat-openbsd # netcat (nc)
      dig # DNS lookup (from bind)
      whois
      httpie # HTTP client (http)
      prettyping # prettier ping

      # ---- Compression ----
      unzip
      p7zip # 7z
      unrar
      gzip
      bzip2
      xz

      # ---- Cloud & DevOps ----
      kubectl
      kubernetes-helm
      k9s
      kubectx
      stern
      kustomize
      argocd
      fluxcd
      opentofu # open-source Terraform
      terraform
      terragrunt
      terraform-docs
      tflint
      packer
      ansible
      ansible-lint
      yamllint
      shellcheck
      hadolint
      actionlint

      # ---- Cloud CLIs ----
      awscli2
      aws-vault
      azure-cli
      google-cloud-sdk
      ssm-session-manager-plugin

      # ---- Development ----
      git
      lazygit # TUI for git
      gh # GitHub CLI
      gnumake
      gcc
      binutils

      # ---- Observability ----
      hcl2json
      graphviz
      age # encryption
      sops # secrets management

      # ---- New Tools ---- 

      zenith         # TUI system monitor with disk/network graphs
      bandwhich      # Network usage per process
      iotop          # IO monitoring
      iftop          # Network monitoring
      strace         # System call tracing
      lsof           # List open files
      sysstat        # sar, iostat, mpstat
      lm_sensors     # Temperature sensors
      ethtool        # Network interface diagnostics
      pciutils       # lspci
      usbutils       # lsusb
    ];
  };

  # ----------------------------------------------------------------------
  # User-level packages (for your user only)
  # ----------------------------------------------------------------------
  flake.homeModules.tools = { pkgs, ... }: {
    home.packages = with pkgs; [
      # Same list as above – these will be installed for your user
      # You can add user-specific tools here
      kubectx # provides both kubectx and kubens
      kubernetes-helm # provides the `helm` binary
      stern
      kustomize
      tflint
      terraform-docs
      pre-commit
      just
      devenv
      bun
      uv
      uv-sort
      ruff
      tealdeer
      dust
      bottom
      delta
      nvd
      glow
      chafa
      asciinema
      just

    ];
  };
}
