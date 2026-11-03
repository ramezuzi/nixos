{
  inputs,
  lib,
  ...
}: {
  flake.homeModules.nvf = {pkgs, lib, ...}: {
    imports = [inputs.nvf.homeManagerModules.default];
    programs.nvf = {
      enable = true;
      settings = {
        vim = {
          viAlias = true;
          vimAlias = true;
          opts = {
            expandtab = true;
            number = true;
            relativenumber = true;
            signcolumn = "yes";
            scrolloff = 6;
            sidescrolloff = 8;
            updatetime = 250;
            timeoutlen = 400;
            undofile = true;
            ignorecase = true;
            smartcase = true;
            splitbelow = true;
            splitright = true;
            cursorline = true;
            termguicolors = true;
            completeopt = "menu,menuone,noselect";
            inccommand = "split";
            tabstop = 4;
            shiftwidth = 4;
            softtabstop = 4;
          };
          spellcheck.enable = true;

          diagnostics = {
            enable = true;
            config = {
              virtual_text = true;
              underline = true;
              update_in_insert = false;
              severity_sort = true;
              float = {
                border = "rounded";
                source = "if_many";
              };
            };
            nvim-lint = {
              enable = true;
              linters_by_ft = {
                nix = [ "deadnix" "statix" ];
                sh = [ "shellcheck" ];
                bash = [ "shellcheck" ];
                markdown = [ "markdownlint-cli2" ];
              };
            };
            presets = {
              deadnix.enable = true;
              statix.enable = true;
              shellcheck.enable = true;
              markdownlint-cli2.enable = true;
            };
          };

          # LSP
          lsp = {
            enable = true;
            formatOnSave = true;
            lightbulb.enable = true;
            trouble.enable = true;
            lspSignature.enable = false; # conflicts with blink-cmp
            # helix: editor.lsp.display-inlay-hints = true
            inlayHints.enable = true;

            # ── Per-server tweaks ported from helix.nix ──────────────
            servers = {
              # Flake-aware nixd (helix: nixd config block)
              nixd.settings.nixd = {
                nixpkgs.expr = "import (builtins.getFlake \"/home/ramez/nixos\").inputs.nixpkgs { }";
                options.nixos.expr =
                  "(builtins.getFlake \"/home/ramez/nixos\").nixosConfigurations.zbook.options";
                formatting.command = ["${lib.getExe pkgs.nixfmt}"];
              };

              # helix: gopls config
              gopls.settings.gopls = {
                usePlaceholders = true;
                completeUnimported = true;
                staticcheck = true;
                analyses = {
                  unusedparams = true;
                  shadow = true;
                };
              };

              # helix: checkOnSave with clippy + proc macros
              # (modern rust-analyzer keys: check.* instead of checkOnSave)
              "rust-analyzer".settings.rust-analyzer = {
                check = {
                  allTargets = true;
                  command = "clippy";
                };
                procMacro.enable = true;
              };

              # helix: yaml-language-server schemas
              yaml-language-server.settings.yaml = {
                format.enable = true;
                schemas = {
                  "https://json.schemastore.org/github-workflow.json" = ".github/workflows/*.yml";
                  "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json" = [
                    "docker-compose*.yml"
                  ];
                  "https://raw.githubusercontent.com/helm/helm/main/pkg/chartutil/values.schema.json" = [
                    "values.yaml"
                  ];
                  "https://json.schemastore.org/kustomization.json" = "kustomization.yaml";
                  "https://json.schemastore.org/kubernetes.json" = [
                    "*.k8s.yaml"
                  ];
                };
              };
            };
          };

          # Debugging
          debugger.nvim-dap = {
            enable = true;
            ui.enable = true;
            presets = {
              codelldb.enable = true;
              debugpy.enable = true;
            };
            adapters.go = {
              type = "server";
              host = "127.0.0.1";
              port = "\${port}";
              executable = {
                command = lib.getExe pkgs.delve;
                args = [ "dap" "-l" "127.0.0.1:\${port}" ];
              };
            };
            configurations = {
              python = [
                {
                  name = "Launch current file";
                  type = "debugpy";
                  request = "launch";
                  program = "\${file}";
                  pythonPath = "python";
                  justMyCode = true;
                }
              ];
              rust = [
                {
                  name = "Launch current executable";
                  type = "codelldb";
                  request = "launch";
                  program = lib.generators.mkLuaInline ''
                    function()
                      return vim.fn.input(
                        "Path to executable: ",
                        vim.fn.getcwd() .. "/target/debug/",
                        "file"
                      )
                    end
                  '';
                  cwd = "\${workspaceFolder}";
                  stopOnEntry = false;
                }
              ];
              c = [
                {
                  name = "Launch current executable";
                  type = "codelldb";
                  request = "launch";
                  program = lib.generators.mkLuaInline ''
                    function()
                      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end
                  '';
                  cwd = "\${workspaceFolder}";
                  stopOnEntry = false;
                }
              ];
              cpp = [
                {
                  name = "Launch current executable";
                  type = "codelldb";
                  request = "launch";
                  program = lib.generators.mkLuaInline ''
                    function()
                      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end
                  '';
                  cwd = "\${workspaceFolder}";
                  stopOnEntry = false;
                }
              ];
              go = [
                {
                  name = "Launch current executable";
                  type = "go";
                  request = "launch";
                  mode = "exec";
                  program = lib.generators.mkLuaInline ''
                    function()
                      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end
                  '';
                  cwd = "\${workspaceFolder}";
                }
              ];
            };
          };

          # Autocomplete & snippets
          autocomplete.blink-cmp.enable = true;
          snippets.luasnip.enable = true;
          autopairs.nvim-autopairs.enable = true;
          treesitter.context.enable = true;

          # Mini.nvim utilities; keep the existing Blink, Oil, autopairs,
          # comment, Telescope and WhichKey integrations as the primary tools.
          mini = {
            ai.enable = true;
            align.enable = true;
            bracketed.enable = true;
            bufremove.enable = true;
            cursorword.enable = true;
            fuzzy.enable = true;
            hipatterns.enable = true;
            move.enable = true;
            operators.enable = true;
            sessions.enable = true;
            splitjoin.enable = true;
            trailspace.enable = true;
            visits.enable = true;
          };

          statusline.lualine.enable = true;

          # Telescope
          telescope.enable = true;

          # WhichKey
          binds.whichKey.enable = true;

          # Git
          git = {
            enable = true;
            gitsigns.enable = true;
          };

          # Utility plugins (built‑in ones that worked)
          utility = {
            diffview-nvim.enable = true;
            undotree.enable = true;
            surround.enable = true;
            oil-nvim = {
              enable = true;
              setupOpts = {
                default_file_explorer = true;
                delete_to_trash = true;
                view_options.show_hidden = true;
              };
            };
          };

          # Terminal
          terminal.toggleterm = {
            enable = true;
            lazygit.enable = true;
          };

          # Comments
          comments.comment-nvim.enable = true;

          # Custom keymaps
          maps.normal = {
            "-" = {
              action = "<cmd>Oil<cr>";
              desc = "Open parent directory with Oil";
            };
            "<leader>ff" = {
              action = "<cmd>Telescope find_files<cr>";
              desc = "Find files";
            };
            "<leader>fg" = {
              action = "<cmd>Telescope live_grep<cr>";
              desc = "Grep string";
            };
            "<leader>fb" = {
              action = "<cmd>Telescope buffers<cr>";
              desc = "Switch buffer";
            };
            "<leader>fh" = {
              action = "<cmd>Telescope help_tags<cr>";
              desc = "Help tags";
            };
            "<leader>fd" = {
              action = "<cmd>Telescope diagnostics<cr>";
              desc = "Find diagnostics";
            };
            "<leader>fs" = {
              action = "<cmd>Telescope lsp_document_symbols<cr>";
              desc = "Find document symbols";
            };
            "<leader>fS" = {
              action = "<cmd>Telescope lsp_workspace_symbols<cr>";
              desc = "Find workspace symbols";
            };
            "<leader>cf" = {
              action = "<cmd>lua require('conform').format({ async = true, lsp_format = 'fallback' })<cr>";
              desc = "Format buffer";
            };
            "<leader>bd" = {
              action = "<cmd>lua require('mini.bufremove').delete(0, true)<cr>";
              desc = "Close buffer";
            };
            "<leader>ss" = {
              action = "<cmd>lua require('mini.sessions').select()<cr>";
              desc = "Open session";
            };
            "<leader>sS" = {
              action = "<cmd>lua require('mini.sessions').write()<cr>";
              desc = "Save session";
            };
            "<leader>tw" = {
              action = "<cmd>lua require('mini.trailspace').trim()<cr>";
              desc = "Trim trailing whitespace";
            };
            "gd" = {
              action = "<cmd>lua vim.lsp.buf.definition()<cr>";
              desc = "Go to definition";
            };
            "gD" = {
              action = "<cmd>lua vim.lsp.buf.declaration()<cr>";
              desc = "Go to declaration";
            };
            "gr" = {
              action = "<cmd>lua vim.lsp.buf.references()<cr>";
              desc = "Find references";
            };
            "gi" = {
              action = "<cmd>lua vim.lsp.buf.implementation()<cr>";
              desc = "Go to implementation";
            };
            "K" = {
              action = "<cmd>lua vim.lsp.buf.hover()<cr>";
              desc = "Show symbol documentation";
            };
            "<leader>ca" = {
              action = "<cmd>lua vim.lsp.buf.code_action()<cr>";
              desc = "Code action";
            };
            "<leader>rn" = {
              action = "<cmd>lua vim.lsp.buf.rename()<cr>";
              desc = "Rename symbol";
            };
            "<leader>e" = {
              action = "<cmd>lua vim.diagnostic.open_float()<cr>";
              desc = "Show line diagnostics";
            };
            "[d" = {
              action = "<cmd>lua vim.diagnostic.goto_prev()<cr>";
              desc = "Previous diagnostic";
            };
            "]d" = {
              action = "<cmd>lua vim.diagnostic.goto_next()<cr>";
              desc = "Next diagnostic";
            };
            "<F5>" = {
              action = "<cmd>lua require('dap').continue()<cr>";
              desc = "Debug: continue";
            };
            "<F9>" = {
              action = "<cmd>lua require('dap').toggle_breakpoint()<cr>";
              desc = "Debug: toggle breakpoint";
            };
            "<F10>" = {
              action = "<cmd>lua require('dap').step_over()<cr>";
              desc = "Debug: step over";
            };
            "<F11>" = {
              action = "<cmd>lua require('dap').step_into()<cr>";
              desc = "Debug: step into";
            };
            "<F12>" = {
              action = "<cmd>lua require('dap').step_out()<cr>";
              desc = "Debug: step out";
            };
            "<leader>du" = {
              action = "<cmd>lua require('dapui').toggle()<cr>";
              desc = "Debug: toggle UI";
            };
            "<leader>dq" = {
              action = "<cmd>lua require('dap').terminate()<cr>";
              desc = "Debug: stop session";
            };
            "<leader>xx" = {
              action = "<cmd>Trouble diagnostics toggle<cr>";
              desc = "Diagnostics: workspace";
            };
            "<leader>xX" = {
              action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
              desc = "Diagnostics: current buffer";
            };
          };

          # Languages
          languages = {
            enableFormat = true;
            enableTreesitter = true;
            enableExtraDiagnostics = true;

            # helix uses nixd + nixfmt (flake-aware server config above)
            nix = {
              enable = true;
              lsp.servers = ["nixd"];
              format.type = ["nixfmt"];
            };

            lua.enable = true;
            bash.enable = true;

            # helix: auto-format = false for markdown
            markdown = {
              enable = true;
              format.enable = false;
            };

            clang.enable = true;
            css.enable = true;
            html.enable = true;
            vue.enable = true;

            toml.enable = true;
            json.enable = true;

            # helix: auto-format = false for dockerfile
            docker = {
              enable = true;
              format.enable = false;
            };

            # helix maps .tf/.hcl to terraform-ls + terraform fmt
            hcl = {
              enable = true;
              lsp.servers = ["terraform-ls"];
              format.type = ["terraform"];
            };
            terraform = {
              enable = true;
              lsp.servers = ["terraform-ls"];
              format.type = ["terraform"];
            };

            # helix has Helm and Justfile language entries
            helm.enable = true;
            just.enable = true;

            yaml = {
              enable = true;
              lsp = {
                enable = true;
                servers = ["yaml-language-server"];
              };
            };

            rust = {
              enable = true;
              lsp.enable = true;
              dap.enable = true;
            };

            go = {
              enable = true;
              lsp.enable = true;
              format.type = ["gofumpt"];
              dap.enable = true;
            };

            python = {
              enable = true;
              # basedpyright provides type checking; Ruff provides fast linting.
              lsp.servers = ["basedpyright" "ruff"];
              format.type = ["black"];
              dap.enable = true;
            };

            # helix uses vtsls (with the Vue TS plugin) — the nvf module's own
            # enum only knows tsserver/deno/etc., so clear it and enable the
            # vtsls preset below instead.
            typescript = {
              enable = true;
              lsp.servers = [];
              format.enable = true;
            };
          };

          # ...and enable vtsls (ports helix's vtsls config incl. Vue plugin)
          lsp.presets.vtsls.enable = true;

          # ----- Manual plugins added via extraPlugins & luaConfigRC -----

          extraPlugins = {
            # lualine = {
            #   package = pkgs.vimPlugins.lualine-nvim;
            # };
            bufferline = {
              package = pkgs.vimPlugins.bufferline-nvim;
            };
            indent-blankline = {
              package = pkgs.vimPlugins.indent-blankline-nvim;
            };
            notify = {
              package = pkgs.vimPlugins.nvim-notify;
            };
            dashboard = {
              package = pkgs.vimPlugins.alpha-nvim;
            };
            colorizer = {
              package = pkgs.vimPlugins.nvim-colorizer-lua;
            };
            flash = {
              package = pkgs.vimPlugins.flash-nvim;
            };
            project = {
              package = pkgs.vimPlugins.project-nvim;
            };
          };

          luaConfigRC = {
            # lualine = ''
            #   require('lualine').setup()
            # '';

            bufferline = ''
              require('bufferline').setup()
            '';

            indent = ''
              require('ibl').setup()
            '';

            notify = ''
              require('notify').setup()
            '';

            dashboard = ''
              local alpha = require('alpha')
              local dashboard = require('alpha.themes.dashboard')
              dashboard.section.header.val = {
                'Welcome to Neovim',
              }
              alpha.setup(dashboard.config)
            '';

            colorizer = ''
              require('colorizer').setup()
            '';

            flash = ''
              require('flash').setup()
            '';

            project = ''
              require('project').setup()
            '';
          };
        };
      };
    };
  };
}
