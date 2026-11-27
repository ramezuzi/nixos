{ lib, pkgs, ... }: {
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

    # Binaries used by plugins and pickers that are not LSP/formatter presets.
    # nvf puts these on the wrapper PATH.
    extraPackages = with pkgs; [
      fd
      fzf
      gh
      hunk
      ripgrep
      yazi
    ];

    clipboard = {
      enable = true;
      registers = "unnamedplus";
      providers.wl-copy.enable = true;
    };

    spellcheck = {
      enable = true;
      languages = [ "en" ];
      programmingWordlist.enable = true;
    };

    theme = {
      enable = true;
      name = "rose-pine";
      style = "main";
      transparent = true;
    };

    diagnostics = {
      enable = true;
      config = {
        virtual_text = true;
        underline = true;
        update_in_insert = false;
        severity_sort = true;
        float = {
          border = "rounded";
        };
      };
    };

    treesitter = {
      enable = true;
      fold = true;
      highlight.enable = true;
      indent.enable = true;
      context.enable = true;

      # The language modules already pull in the parsers for every configured
      # language. These extras cover filetypes that nvf has no language module
      # for: git metadata, diffs, embedded shell/config formats, etc.
      grammars = with pkgs.vimPlugins.nvim-treesitter.grammarPlugins; [
        comment
        csv
        diff
        editorconfig
        git_config
        git_rebase
        gitattributes
        gitcommit
        gitignore
        graphql
        http
        hurl
        ini
        jq
        json5
        jsonnet
        luadoc
        mermaid
        ninja
        printf
        prisma
        requirements
        rst
        ssh_config
        templ
      ];

      # nvf's textobjects option still calls the old nvim-treesitter config
      # API, which is a no-op in the pinned nvim-treesitter. Use the plugin's
      # current API directly and bind the mappings below.
      textobjects.enable = false;
    };

    startPlugins = [ "nvim-treesitter-textobjects" ];
    pluginRC.nixcat-treesitter-textobjects = lib.nvim.dag.entryAnywhere ''
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })

      local ts_select = require("nvim-treesitter-textobjects.select")
      local ts_move = require("nvim-treesitter-textobjects.move")

      local function select_object(lhs, query, desc)
        vim.keymap.set({ "x", "o" }, lhs, function()
          ts_select.select_textobject(query, "textobjects")
        end, { desc = desc })
      end

      select_object("af", "@function.outer", "Select outer function")
      select_object("if", "@function.inner", "Select inner function")
      select_object("ac", "@class.outer", "Select outer class")
      select_object("ic", "@class.inner", "Select inner class")
      select_object("aa", "@parameter.outer", "Select outer parameter")
      select_object("ia", "@parameter.inner", "Select inner parameter")

      local function goto_object(lhs, fn, query, desc)
        vim.keymap.set({ "n", "x", "o" }, lhs, function()
          ts_move[fn](query, "textobjects")
        end, { desc = desc })
      end

      goto_object("]f", "goto_next_start", "@function.outer", "Next function start")
      goto_object("]F", "goto_next_end", "@function.outer", "Next function end")
      goto_object("[f", "goto_previous_start", "@function.outer", "Previous function start")
      goto_object("[F", "goto_previous_end", "@function.outer", "Previous function end")
    '';

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

      # LSP for code embedded in markdown/HTML/etc. and hover docs in a split.
      "otter-nvim".enable = true;
      nvim-docs-view.enable = true;

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
        javascript = [ "eslint_d" ];
        javascriptreact = [ "eslint_d" ];
        typescriptreact = [ "eslint_d" ];
      };
    };

    telescope = {
      enable = true;
      extensions = [
        {
          name = "fzf";
          packages = [ pkgs.vimPlugins.telescope-fzf-native-nvim ];
          setup.fzf = {
            fuzzy = true;
          };
        }
      ];
    };
    fzf-lua.enable = true;

    filetree.neo-tree.enable = true;
    utility = {
      oil-nvim.enable = true;
      surround.enable = true;
      undotree.enable = true;
      diffview-nvim.enable = true;
      grug-far-nvim.enable = true;
      nix-develop.enable = true;

      # QoL bundle used by both Primeagen-style and LazyVim-style setups.
      snacks-nvim = {
        enable = true;
        setupOpts.notifier.enabled = false;
      };
      yazi-nvim.enable = true;
      smart-splits.enable = true;
      smart-paste-nvim.enable = true;
      sleuth.enable = true;
      direnv.enable = true;
      mkdir.enable = true;
      icon-picker.enable = true;
      csvview.enable = true;
      multicursors.enable = true;

      yanky-nvim = {
        enable = true;
        # `shada` trips an nvf assertion unless vim.options.shada is set
        # explicitly; memory keeps the ring within a session.
        setupOpts.ring.storage = "memory";
      };

      # Color picker; colorizer.nvim already handles inline highlighting.
      ccc = {
        enable = true;
        setupOpts.highlighter.auto_enable = false;
      };

      outline.aerial-nvim.enable = true;
      preview.glow.enable = true;
      motion.flash-nvim.enable = true;
    };
    navigation.harpoon.enable = true;

    git = {
      gitsigns.enable = true;
      neogit.enable = true;
      vim-fugitive.enable = true;
      git-conflict.enable = true;
      gitlinker-nvim.enable = true;
      hunk-nvim.enable = true;
      octo-nvim.enable = true;
    };

    notes.todo-comments.enable = true;
    projects.project-nvim.enable = true;
    session.persisted.enable = true;
    runner.run-nvim.enable = true;
    # codewindow is not wired up in this nvf revision; minimap-vim is.
    minimap.minimap-vim.enable = true;

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

    binds = {
      whichKey.enable = true;
      hardtime-nvim.enable = true;
      cheatsheet.enable = true;
    };

    statusline.lualine.enable = false;
    tabline.nvimBufferline.enable = true;
    dashboard.alpha.enable = true;
    notify.nvim-notify.enable = true;

    # Primeagen's signature AI plugin. Authenticate once with `:Copilot auth`.
    assistant.copilot.enable = true;

    ui = {
      noice.enable = true;
      borders.enable = true;
      colorizer.enable = true;
      illuminate.enable = true;
      dropbar-nvim.enable = true;
      fastaction.enable = true;
      modes-nvim.enable = true;
      zen-nvim.enable = true;
      smartcolumn.enable = true;
      colorful-menu-nvim.enable = true;
    };

    visuals = {
      fidget-nvim.enable = true;
      indent-blankline.enable = true;
      hlargs-nvim.enable = true;
      rainbow-delimiters.enable = true;
      satellite-nvim.enable = true;
      twilight-nvim.enable = true;
      neoscroll-nvim.enable = true;
      highlight-undo.enable = true;
    };

    mini = {
      ai.enable = true;
      align.enable = true;
      bracketed.enable = true;
      bufremove.enable = true;
      cmdline.enable = true;
      cursorword.enable = true;
      doc.enable = true;
      fuzzy.enable = true;
      hipatterns.enable = true;
      icons.enable = true;
      move.enable = true;
      operators.enable = true;
      splitjoin.enable = true;
      trailspace.enable = true;
      visits.enable = true;
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

      # Classic LSP bindings (nvf also provides the <leader>l* variants).
      {
        mode = "n";
        key = "gd";
        action = "<cmd>lua vim.lsp.buf.definition()<cr>";
        desc = "Go to definition";
      }
      {
        mode = "n";
        key = "gD";
        action = "<cmd>lua vim.lsp.buf.declaration()<cr>";
        desc = "Go to declaration";
      }
      {
        mode = "n";
        key = "gr";
        action = "<cmd>lua vim.lsp.buf.references()<cr>";
        desc = "Find references";
      }
      {
        mode = "n";
        key = "K";
        action = "<cmd>lua vim.lsp.buf.hover()<cr>";
        desc = "Hover documentation";
      }
      {
        mode = "n";
        key = "<leader>ca";
        action = "<cmd>lua vim.lsp.buf.code_action()<cr>";
        desc = "Code action";
      }
      {
        mode = "n";
        key = "<leader>rn";
        action = "<cmd>lua vim.lsp.buf.rename()<cr>";
        desc = "Rename symbol";
      }
      {
        mode = "n";
        key = "[d";
        action = "<cmd>lua vim.diagnostic.goto_prev()<cr>";
        desc = "Previous diagnostic";
      }
      {
        mode = "n";
        key = "]d";
        action = "<cmd>lua vim.diagnostic.goto_next()<cr>";
        desc = "Next diagnostic";
      }
      {
        mode = "n";
        key = "<leader>xx";
        action = "<cmd>Trouble diagnostics toggle<cr>";
        desc = "Workspace diagnostics";
      }
      {
        mode = "n";
        key = "<leader>xX";
        action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
        desc = "Buffer diagnostics";
      }

      # Debugger function keys, alongside nvf's <leader>d* bindings.
      {
        mode = "n";
        key = "<F5>";
        action = "<cmd>lua require('dap').continue()<cr>";
        desc = "Debug: continue";
      }
      {
        mode = "n";
        key = "<F9>";
        action = "<cmd>lua require('dap').toggle_breakpoint()<cr>";
        desc = "Debug: toggle breakpoint";
      }
      {
        mode = "n";
        key = "<F10>";
        action = "<cmd>lua require('dap').step_over()<cr>";
        desc = "Debug: step over";
      }
      {
        mode = "n";
        key = "<F11>";
        action = "<cmd>lua require('dap').step_into()<cr>";
        desc = "Debug: step into";
      }
      {
        mode = "n";
        key = "<F12>";
        action = "<cmd>lua require('dap').step_out()<cr>";
        desc = "Debug: step out";
      }
    ];
  };
}
