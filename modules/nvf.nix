{
  inputs,
  lib,
  ...
}: {
  flake.homeModules.nvf = {pkgs, ...}: {
    imports = [inputs.nvf.homeManagerModules.default];
    programs.nvf = {
      enable = true;
      settings = {
        vim = {
          viAlias = true;
          vimAlias = true;
          opts.expandtab = true;
          spellcheck.enable = true;

          # LSP
          lsp = {
            enable = true;
            formatOnSave = true;
            lightbulb.enable = true;
            trouble.enable = true;
            lspSignature.enable = false; # conflicts with blink-cmp
          };

          # Debugging
          debugger.nvim-dap = {
            enable = true;
            ui.enable = true;
          };

          # Autocomplete & snippets
          autocomplete.blink-cmp.enable = true;
          snippets.luasnip.enable = true;
          autopairs.nvim-autopairs.enable = true;
          treesitter.context.enable = true;

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
          };

          # Languages
          languages = {
            enableFormat = true;
            enableTreesitter = true;
            enableExtraDiagnostics = true;

            nix.enable = true;
            bash.enable = true;
            markdown.enable = true;
            toml.enable = true;
            json.enable = true;
            docker.enable = true;
            hcl.enable = true; # terraform/opentofu

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
              lsp.servers = ["ruff"];
              format.type = ["black"];
              dap.enable = true;
            };

            typescript = {
              enable = true;
              lsp.enable = true;
              format.enable = true;
            };
          };

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
