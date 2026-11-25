{...}: {
  vim = {
    # Keep nixcat's runtime directories separate from the existing `nvf` app.
    appname = "nixcat";

    viAlias = true;
    vimAlias = true;

    globals = {
      mapleader = " ";
      maplocalleader = ",";
      editorconfig = true;
    };

    opts = {
      expandtab = true;
      tabstop = 4;
      shiftwidth = 4;
      softtabstop = 4;
      number = true;
      relativenumber = true;
      signcolumn = "yes";
      scrolloff = 8;
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
      mouse = "a";
      confirm = true;
    };

    clipboard = {
      enable = true;
      registers = "unnamedplus";
      providers.wl-copy.enable = true;
    };

    spellcheck = {
      enable = true;
      languages = ["en"];
      programmingWordlist.enable = true;
    };

    theme = {
      enable = true;
      name = "catppuccin";
      style = "mocha";
      transparent = false;
    };

    diagnostics = {
      enable = true;
      config = {
        virtual_text = true;
        underline = true;
        update_in_insert = false;
        severity_sort = true;
        float = {border = "rounded";};
      };
    };

    treesitter = {
      enable = true;
      fold = true;
      highlight.enable = true;
      indent.enable = true;
      context.enable = true;
      textobjects = {
        enable = true;
        setupOpts = {
          select = {
            enable = true;
            lookahead = true;
            keymaps = {
              af = "@function.outer";
              "if" = "@function.inner";
              ac = "@class.outer";
              ic = "@class.inner";
              aa = "@parameter.outer";
              ia = "@parameter.inner";
            };
          };
        };
      };
    };

    # Completion + snippets.
    autocomplete.blink-cmp = {
      enable = true;
      friendly-snippets.enable = true;
    };
    snippets.luasnip.enable = true;

    lsp = {
      enable = true;
      formatOnSave = true;
      inlayHints.enable = true;
      trouble.enable = true;
      lightbulb.enable = true;

      # vtsls is used for both TypeScript and TSX/JSX. The TypeScript/TSX
      # language modules only accept typescript-language-server, so vtsls is
      # wired directly here instead.
      presets.vtsls.enable = true;
      servers.vtsls = {
        enable = true;
        filetypes = [
          "typescript"
          "javascript"
          "typescriptreact"
          "javascriptreact"
        ];
      };
    };

    formatter.conform-nvim.enable = true;

    # Additional ESLint coverage for JS/JSX/TSX (the TypeScript module only
    # registers `typescript` by itself).
    diagnostics.nvim-lint = {
      enable = true;
      linters_by_ft = {
        javascript = ["eslint_d"];
        javascriptreact = ["eslint_d"];
        typescriptreact = ["eslint_d"];
      };
    };

    telescope.enable = true;

    filetree.neo-tree.enable = true;
    utility = {
      oil-nvim.enable = true;
      surround.enable = true;
      undotree.enable = true;
      diffview-nvim.enable = true;
      grug-far-nvim.enable = true;
      nix-develop.enable = true;
    };
    navigation.harpoon.enable = true;

    git = {
      gitsigns.enable = true;
      neogit.enable = true;
    };

    debugger.nvim-dap = {
      enable = true;
      ui.enable = true;
    };

    terminal.toggleterm = {
      enable = true;
      lazygit.enable = true;
    };

    comments.comment-nvim.enable = true;
    autopairs.nvim-autopairs.enable = true;
    binds.whichKey.enable = true;

    statusline.lualine.enable = true;
    tabline.nvimBufferline.enable = true;
    dashboard.alpha.enable = true;
    notify.nvim-notify.enable = true;

    ui = {
      noice.enable = true;
      borders.enable = true;
      colorizer.enable = true;
      illuminate.enable = true;
      dropbar-nvim.enable = true;
    };

    visuals = {
      fidget-nvim.enable = true;
      indent-blankline.enable = true;
      hlargs-nvim.enable = true;
      rainbow-delimiters.enable = true;
    };

    mini = {
      ai.enable = true;
      align.enable = true;
      bracketed.enable = true;
      cursorword.enable = true;
      move.enable = true;
      splitjoin.enable = true;
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>w";
        action = "<cmd>write<cr>";
        desc = "Save file";
      }
      {
        mode = "n";
        key = "<leader>q";
        action = "<cmd>quit<cr>";
        desc = "Quit window";
      }
      {
        mode = "n";
        key = "<leader>Q";
        action = "<cmd>qa!<cr>";
        desc = "Quit all";
      }
      {
        mode = "n";
        key = "<Esc>";
        action = "<cmd>nohlsearch<cr>";
        desc = "Clear search highlight";
      }
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Neotree toggle<cr>";
        desc = "Toggle file tree";
      }
      {
        mode = "n";
        key = "-";
        action = "<cmd>Oil<cr>";
        desc = "Open parent directory";
      }
      {
        mode = "n";
        key = "<leader>u";
        action = "<cmd>UndotreeToggle<cr>";
        desc = "Toggle undo tree";
      }
      {
        mode = "n";
        key = "<leader>gD";
        action = "<cmd>DiffviewOpen<cr>";
        desc = "Open diff view";
      }
      {
        mode = "n";
        key = "<leader>gX";
        action = "<cmd>DiffviewClose<cr>";
        desc = "Close diff view";
      }
      {
        mode = "n";
        key = "<leader>tt";
        action = "<cmd>ToggleTerm<cr>";
        desc = "Toggle terminal";
      }
      {
        mode = "n";
        key = "<leader>bd";
        action = "<cmd>bdelete<cr>";
        desc = "Delete buffer";
      }
    ];
  };
}
