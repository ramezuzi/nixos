{
  inputs,
  pkgs,
  lib,
  config,
  osConfig,
  ...
}: let
  # nixd requires an absolute flake path; a leading ~ is not expanded.
  flakePath = "/home/ramez/nixos";
  hostName = config.networking.hostName or "zbook";
in {
  flake.homeModules.helix = {pkgs, ...}: {
    programs.helix = {
      enable = true;
      defaultEditor = true;

      # Add all LSPs, formatters, and tools to Helix's PATH
      extraPackages = with pkgs; [
        # Language Servers
        nil # Nix
        nixd # Nix (alternative, with more features)
        rust-analyzer # Rust
        gopls # Go
        ruff # Python linter & formatter
        typescript-language-server # TypeScript/JavaScript
        vtsls # TypeScript (alternative)
        yaml-language-server # YAML
        terraform-ls # Terraform
        helm-ls # Helm
        dockerfile-language-server
        vscode-langservers-extracted
        bash-language-server # Bash
        marksman # Markdown
        taplo # TOML
        lua-language-server # Lua
        jdt-language-server # Java (if needed)
        zls # Zig (if needed)
        basedpyright # Python type checking + completion (ruff does lint/format)
        fish-lsp # Fish shell
        clang-tools # clangd + clang-format for C/C++
        neocmakelsp # CMake
        sqls # SQL
        just-lsp # Justfile
        vue-language-server # Vue (vtsls already references this package for its plugin)
        fish # fish_indent formatter (fish-lsp bundles its own fish for parsing)
        python3 # interpreter used by basedpyright
        zig # zls needs the zig binary; also used by zig fmt

        # Debug adapters (DAP)
        lldb # lldb-dap for C/C++/Rust/Zig
        delve # dlv for Go

        # Formatters
        nixfmt # Nix formatter (RFC style)
        alejandra # Nix formatter (alternative)
        terraform # Terraform fmt
        shfmt # Shell formatting
        prettierd # Prettier daemon for JS/TS/JSON/YAML
        stylua # Lua formatting
        black # Python formatting
        kdlfmt # KDL (niri config)
        gofumpt # Go formatting
        rustfmt # Rust formatting

        # Extra tools for devops
        terraform
        opentofu
        kubectl
        helm
        kustomize
        argocd
        fluxcd
        k9s
        stern
        kubectx
        yq-go
        jq
        hcl2json
        packer
        ansible-lint
        yamllint
        shellcheck
        hadolint
        actionlint
      ];

      settings = {
        # Global editor settings
        editor = {
          line-number = "relative";
          cursorline = true;
          true-color = true;
          undercurl = true;
          scrolloff = 8;
          rulers = [100];
          bufferline = "multiple";
          color-modes = true;
          indent-guides = {
            render = true;
            skip-levels = 1;
          };
          cursor-shape = {
            normal = "block";
            insert = "block";
            select = "block";
          };
          lsp = {
            display-messages = true;
            display-inlay-hints = true;
          };
          auto-save = true;
          auto-format = true;
          idle-timeout = 50;
        };

        # Tab opens the completion menu.  Once the menu is open Helix handles
        # Tab/Shift-Tab itself to cycle entries.  Ctrl-t inserts a real tab.
        keys.insert = {
          tab = "completion";
          "C-t" = "insert_tab";
        };
      };

      # Language configurations
      languages = {
        # Base language server configurations
        language-server = {
          helm_ls = {
            command = "helm_ls";
            args = ["serve"];
          };

          vscode-json-language-server = {
            command = "vscode-json-language-server";
            args = ["--stdio"];
          };

          # Basedpyright supplies Python completion, hover and type checking.
          # Ruff remains in the server list for lint diagnostics.
          basedpyright = {
            command = "basedpyright-langserver";
            args = ["--stdio"];
            config = {
              basedpyright = {
                analysis = {
                  typeCheckingMode = "standard";
                  autoSearchPaths = true;
                  useLibraryCodeForTypes = true;
                };
              };
            };
          };

          # SQL (sqls starts fine without a config; add connections later in
          # ~/.config/sqls/config.yml if schema-aware completion is wanted).
          sqls = {
            command = "sqls";
          };

          # Nixd configuration for NixOS
          nixd = {
            command = "nixd";
            args = ["--semantic-tokens=true"];
            config = {
              nixd = {
                nixpkgs = {
                  expr = "import (builtins.getFlake \"${flakePath}\").inputs.nixpkgs { }";
                };
                options = {
                  nixos = {
                    expr = "(builtins.getFlake \"${flakePath}\").nixosConfigurations.${hostName}.options";
                  };
                };
                formatting = {
                  command = ["${lib.getExe pkgs.nixfmt}"];
                };
              };
            };
          };

          # Rust analyzer
          rust-analyzer = {
            command = "rust-analyzer";
            config = {
              checkOnSave = {
                allTargets = true;
                command = "clippy";
              };
              procMacro = {
                enable = true;
              };
            };
          };

          # Gopls for Go
          gopls = {
            command = "gopls";
            config = {
              usePlaceholders = true;
              completeUnimported = true;
              staticcheck = true;
              analyses = {
                unusedparams = true;
                shadow = true;
              };
            };
          };

          # Terraform LS
          terraform-ls = {
            command = "terraform-ls";
            args = ["serve"];
            config = {
              terraform = {
                logsPath = "/tmp/terraform-ls.log";
              };
            };
          };

          # Typescript via vtsls (better than tsserver)
          vtsls = {
            command = "vtsls";
            args = ["--stdio"];
            config = {
              vtsls = {
                tsserver = {
                  globalPlugins = [
                    {
                      name = "@vue/typescript-plugin";
                      location = "${pkgs.vue-language-server}/lib/language-tools/packages/language-server";
                      languages = ["vue"];
                      configNamespace = "typescript";
                    }
                  ];
                };
              };
            };
          };

          # YAML
          yaml-language-server = {
            command = "yaml-language-server";
            args = ["--stdio"];
            config = {
              yaml = {
                schemas = {
                  "https://json.schemastore.org/github-workflow.json" = ".github/workflows/*.yml";
                  "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json" = "docker-compose*.yml";
                  "https://raw.githubusercontent.com/helm/helm/main/pkg/chartutil/values.schema.json" = "values.yaml";
                  "https://json.schemastore.org/kustomization.json" = "kustomization.yaml";
                  "https://json.schemastore.org/kubernetes.json" = "*.k8s.yaml";
                };
                format = {
                  enable = true;
                };
              };
            };
          };
        };

        # Language definitions
        language = [
          # Nix
          {
            name = "nix";
            language-servers = ["nixd"];
            auto-format = true;
            formatter = {
              command = "${lib.getExe pkgs.nixfmt}";
              args = ["-"];
            };
          }

          # Rust
          {
            name = "rust";
            language-servers = ["rust-analyzer"];
            auto-format = true;
            formatter = {
              command = "${lib.getExe pkgs.rustfmt}";
            };
          }

          # Go
          {
            name = "go";
            language-servers = ["gopls"];
            auto-format = true;
            formatter = {
              command = "${lib.getExe pkgs.gofumpt}";
            };
          }

          # CMake
          {
            name = "cmake";
            language-servers = ["neocmakelsp"];
          }

          # SQL
          {
            name = "sql";
            language-servers = ["sqls"];
          }

          # Python
          {
            name = "python";
            language-servers = ["ruff" "basedpyright"];
            auto-format = true;
            formatter = {
              command = "${lib.getExe pkgs.black}";
              args = ["-"];
            };
          }

          # TypeScript / JavaScript
          {
            name = "typescript";
            language-servers = ["vtsls"];
            auto-format = true;
            formatter = {
              command = "${lib.getExe pkgs.prettierd}";
              args = [
                "--stdin-filepath"
                "%{buffer_name}"
              ];
            };
          }
          {
            name = "javascript";
            language-servers = ["vtsls"];
            auto-format = true;
            formatter = {
              command = "${lib.getExe pkgs.prettierd}";
              args = [
                "--stdin-filepath"
                "%{buffer_name}"
              ];
            };
          }
          {
            name = "tsx";
            language-servers = ["vtsls"];
            auto-format = true;
            formatter = {
              command = "${lib.getExe pkgs.prettierd}";
              args = [
                "--stdin-filepath"
                "%{buffer_name}"
              ];
            };
          }
          {
            name = "jsx";
            language-servers = ["vtsls"];
            auto-format = true;
            formatter = {
              command = "${lib.getExe pkgs.prettierd}";
              args = [
                "--stdin-filepath"
                "%{buffer_name}"
              ];
            };
          }
          {
            name = "vue";
            language-servers = ["vuels"];
            auto-format = true;
            formatter = {
              command = "${lib.getExe pkgs.prettierd}";
              args = [
                "--stdin-filepath"
                "%{buffer_name}"
              ];
            };
          }

          # Terraform
          {
            name = "hcl";
            language-servers = ["terraform-ls"];
            auto-format = true;
            formatter = {
              command = "${lib.getExe pkgs.terraform}";
              args = [
                "fmt"
                "-"
              ];
            };
          }

          # YAML
          {
            name = "yaml";
            language-servers = ["yaml-language-server"];
            auto-format = true;
            formatter = {
              command = "${lib.getExe pkgs.prettierd}";
              args = [
                "--stdin-filepath"
                "%{buffer_name}"
              ];
            };
          }

          # JSON
          {
            name = "json";
            language-servers = ["vscode-json-language-server"];
            auto-format = true;
            formatter = {
              command = "${lib.getExe pkgs.prettierd}";
              args = [
                "--stdin-filepath"
                "%{buffer_name}"
              ];
            };
          }

          # HTML (vscode-html already provides completion/formatting; do not
          # require superhtml, which Helix also lists by default)
          {
            name = "html";
            language-servers = ["vscode-html-language-server"];
          }

          # Dockerfile
          {
            name = "dockerfile";
            language-servers = ["docker-langserver"];
            auto-format = false;
          }

          # Bash
          {
            name = "bash";
            language-servers = ["bash-language-server"];
            auto-format = true;
            formatter = {
              command = "${lib.getExe pkgs.shfmt}";
              args = [
                "-i"
                "2"
                "-ci"
                "-bn"
              ];
            };
          }

          # Markdown
          {
            name = "markdown";
            language-servers = ["marksman"];
            auto-format = false;
          }

          # TOML
          {
            name = "toml";
            language-servers = ["taplo"];
            auto-format = true;
            formatter = {
              command = "${lib.getExe pkgs.taplo}";
              args = [
                "format"
                "-"
              ];
            };
          }

          # Justfile
          {
            name = "just";
            auto-format = false;
          }

          # Helm
          {
            name = "helm";
            language-servers = ["helm_ls"];
            auto-format = true;
          }

          # Kubernetes
          # {
          #   name = "kustomize";
          #   language-servers = [ "kubernetes-langserver" ];
          #   auto-format = false;
          # }
        ];
      };
    };

    # Additional packages available in the shell
    home.packages = with pkgs; [
      # Cloud CLIs
      awscli2
      aws-vault
      google-cloud-sdk
      ssm-session-manager-plugin

      # Kubernetes / GitOps
      kubectl
      kubernetes-helm
      k9s
      kubectx
      stern
      kustomize
      argocd
      fluxcd
      eksctl

      # IaC
      opentofu
      terraform
      terragrunt
      terraform-docs
      tflint
      infracost
      packer
      ansible
      ansible-lint
      yamllint

      # Development
      go
      python3
      nodejs
      rustc
      cargo
      gcc
      gnumake

      # Observability tools
      jq
      yq-go
      hcl2json
      shellcheck
      hadolint
      actionlint
      graphviz

      # Monitoring & debugging
      htop
      btop
      duf
      ncdu
      mtr
      nmap
      netcat-openbsd
      dig
      whois
      httpie
      bat
      eza
      ripgrep
      fd
      fzf
      zoxide
      atuin
      fastfetch
    ];
  };
}
