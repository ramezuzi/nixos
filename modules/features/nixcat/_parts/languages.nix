# Language support for nixcat.
#
# Most language modules inherit `lsp.enable` from `vim.lsp.enable` (set in
# config.nix) and `treesitter.enable`/`format.enable` from the switches below.
# Server/formatter/linter choices are explicit so the result does not silently
# follow nvf's defaults.
{
  vim.languages = {
    enableTreesitter = true;
    enableFormat = true;
    enableExtraDiagnostics = false;
    enableDAP = false;

    nix = {
      enable = true;
      lsp.servers = ["nixd"];
      format.type = ["nixfmt"];
      extraDiagnostics = {
        enable = true;
        types = ["statix" "deadnix"];
      };
    };

    lua = {
      enable = true;
      lsp.servers = ["lua-language-server"];
      format.type = ["stylua"];
      extraDiagnostics = {
        enable = true;
        types = ["selene"];
      };
    };

    python = {
      enable = true;
      lsp.servers = ["basedpyright" "ruff"];
      format.type = ["ruff"];
      dap.enable = true;
    };

    rust = {
      enable = true;
      lsp.servers = ["rust-analyzer"];
      format.type = ["rustfmt"];
      dap = {
        enable = true;
        debugger = ["lldb"];
      };
    };

    go = {
      enable = true;
      lsp.servers = ["gopls"];
      format = {
        enable = true;
        type = ["gofumpt"];
      };
      dap.enable = true;
      extraDiagnostics = {
        enable = true;
        types = ["golangci-lint"];
      };
    };

    clang = {
      enable = true;
      lsp.servers = ["clangd"];
      format.type = ["clang-format"];
      dap.enable = true;
    };

    typescript = {
      enable = true;
      # vtsls is configured directly in config.nix so it can also serve the
      # TSX/JSX filetypes that the TypeScript/TSX modules do not expose.
      lsp.enable = false;
      format.type = ["prettier"];
      extraDiagnostics = {
        enable = true;
        types = ["eslint_d"];
      };
    };

    tsx = {
      enable = true;
      # vtsls (enabled by the TypeScript module) already covers TSX/JSX
      # filetypes; do not start a second TypeScript server.
      lsp.enable = false;
      format.type = ["prettier"];
    };

    vue = {
      enable = true;
      lsp.servers = ["vue-language-server" "vtsls" "emmet-ls"];
      format.type = ["prettier"];
    };

    svelte = {
      enable = true;
      lsp.servers = ["svelte-language-server" "emmet-ls"];
      format.type = ["prettier"];
      extraDiagnostics = {
        enable = true;
        types = ["eslint_d"];
      };
    };

    astro = {
      enable = true;
      lsp.servers = ["astro-language-server" "emmet-ls"];
      format.type = ["prettier"];
      extraDiagnostics = {
        enable = true;
        types = ["eslint_d"];
      };
    };

    html = {
      enable = true;
      lsp.servers = ["superhtml" "emmet-ls"];
      format.type = ["prettier"];
      extraDiagnostics = {
        enable = true;
        types = ["htmlhint"];
      };
    };

    css = {
      enable = true;
      lsp.servers = ["vscode-css-language-server" "emmet-ls"];
      format.type = ["prettier"];
    };

    scss = {
      enable = true;
      lsp.servers = ["some-sass-language-server" "emmet-ls"];
      format.type = ["prettier"];
      extraDiagnostics = {
        enable = true;
        types = ["stylelint"];
      };
    };

    json = {
      enable = true;
      lsp.servers = ["vscode-json-language-server"];
      format.type = ["prettier"];
    };

    yaml = {
      enable = true;
      lsp.servers = ["yaml-language-server"];
      format.type = ["prettier"];
    };

    toml = {
      enable = true;
      lsp.servers = ["taplo"];
      format.type = ["taplo"];
    };

    markdown = {
      enable = true;
      lsp.servers = ["markdown-oxide"];
      format.type = ["prettier"];
      extraDiagnostics = {
        enable = true;
        types = ["markdownlint-cli2"];
      };
    };

    bash = {
      enable = true;
      lsp.servers = ["bash-language-server"];
      format.type = ["shfmt"];
      extraDiagnostics = {
        enable = true;
        types = ["shellcheck"];
      };
    };

    zsh = {
      enable = true;
      lsp.servers = ["bash-language-server"];
      format.type = ["shfmt"];
    };

    fish = {
      enable = true;
      lsp.servers = ["fish-lsp"];
      format.type = ["fish-indent"];
    };

    docker = {
      enable = true;
      lsp.servers = ["docker-language-server"];
      format.type = ["dockerfmt"];
      extraDiagnostics = {
        enable = true;
        types = ["hadolint"];
      };
    };

    terraform = {
      enable = true;
      lsp.servers = ["tofu-ls"];
      format.type = ["opentofu"];
    };

    hcl = {
      enable = true;
      lsp.servers = ["tofu-ls"];
      format.type = ["hclfmt"];
    };

    helm.enable = true;

    cmake = {
      enable = true;
      lsp.servers = ["neocmakelsp"];
      format.type = ["gersemi"];
    };

    sql = {
      enable = true;
      lsp.servers = ["sqls"];
      format.type = ["sqlfluff"];
    };

    zig = {
      enable = true;
      lsp.servers = ["zls"];
      dap.enable = true;
    };

    java = {
      enable = true;
      lsp.servers = ["jdt-language-server"];
      format.type = ["astyle"];
    };

    kotlin = {
      enable = true;
      lsp.servers = ["kotlin-language-server"];
      extraDiagnostics = {
        enable = true;
        types = ["ktlint"];
      };
    };

    csharp = {
      enable = true;
      lsp.servers = ["roslyn-ls"];
      format.type = ["csharpier"];
    };

    ruby = {
      enable = true;
      lsp.servers = ["ruby-lsp"];
      format.type = ["rubocop"];
    };

    php = {
      enable = true;
      lsp.servers = ["intelephense"];
      format.type = ["php-cs-fixer"];
    };

    elixir = {
      enable = true;
      lsp.servers = ["elixir-ls"];
      format.type = ["mix"];
    };

    haskell = {
      enable = true;
      lsp.servers = ["haskell-language-server"];
      format.type = ["fourmolu"];
    };

    scala.enable = true;

    dart = {
      enable = true;
      lsp.servers = ["dart"];
      # Pulling Flutter just for Dart support is unnecessary.
      flutter-tools.enable = false;
    };

    julia.enable = true;

    r = {
      enable = true;
      lsp.servers = ["r-languageserver"];
      format.type = ["styler"];
    };

    xml = {
      enable = true;
      lsp.servers = ["lemminx"];
    };

    just = {
      enable = true;
      lsp.servers = ["just-lsp"];
      format.type = ["just"];
    };

    make = {
      enable = true;
      format.type = ["mbake"];
      extraDiagnostics = {
        enable = true;
        types = ["checkmake"];
      };
    };

    protobuf = {
      enable = true;
      lsp.servers = ["protols"];
      format.type = ["buf"];
    };

    typst = {
      enable = true;
      lsp.servers = ["tinymist"];
      format.type = ["typstyle"];
    };

    tex = {
      enable = true;
      lsp.servers = ["texlab"];
      format.type = ["tex-fmt"];
    };
  };
}
