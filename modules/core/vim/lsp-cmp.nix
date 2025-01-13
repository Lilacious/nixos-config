{ lib, config, ... }:
with lib;
let
  cfg = config.myModules.nixvim.languages;
in
{
  options.myModules.nixvim.languages = {
    nix = mkEnableOption "Nix lsp & cmp" // {
      default = true;
    };
    c = mkEnableOption "C/C++ lsp & cmp";
    python = mkEnableOption "Python lsp & cmp";
    rust = mkEnableOption "Rust lsp & cmp";
    markdown = mkEnableOption "Markdown lsp & cmp";
    php = mkEnableOption "PHP lsp & cmp";
    sql = mkEnableOption "SQL lsp & cmp";
    tex = mkEnableOption "LaTeX lsp & cmp";
  };

  config = {
    programs.nixvim = {
      # Allows extra capabilities providied by nvim-cmp
      plugins = {
        nix.enable = true;
        lsp = {
          enable = true;
          servers = {
            # Nix
            nil_ls = {
              enable = cfg.nix;
              settings.nix.flake.autoArchive = mkDefault false;
            };
            # C/C++
            clangd.enable = cfg.c;
            # Python
            pyright.enable = cfg.python;
            # Rust
            rust_analyzer.enable = cfg.rust;
            # Markdown
            marksman.enable = cfg.markdown;
            # PHP
            phpactor.enable = cfg.php;
            # SQL
            sqls.enable = cfg.sql;
            # LaTeX
            texlab = {
              enable = cfg.tex;
            };
          };
        };

        cmp = {
          enable = true;
          autoEnableSources = true;

          settings = {
            snippet = {
              expand = ''
                function(args)
                  require('luasnip').lsp_expand(args.body)
                end
              '';
            };
            completion = {
              completeopt = "menu,menuone,noinsert";
            };
            sources = [
              { name = "nvim_lsp"; }
              { name = "luasnip"; }
              { name = "path"; }
              { name = "buffer"; }
            ];
            mapping = {
              "<CR>" = "cmp.mapping.confirm { select = true }";
              "<Tab>" = "cmp.mapping.confirm { select = true }";
              "<Down>" = "cmp.mapping.select_next_item()";
              "<Up>" = "cmp.mapping.select_prev_item()";
            };
          };
        };

        # LaTeX filetype plugin
        vimtex = {
          enable = true;
          texlivePackage = null;
        };
        # Completion source for lsp
        cmp-nvim-lsp.enable = true;
        # Snippet Engine & its associated cmp source
        luasnip.enable = true;
        # Useful status updates for LSP.
        fidget.enable = true;
        # Completion source for filesystem path
        cmp-path.enable = true;
        # Premade snippets for various programming languages
        friendly-snippets.enable = true;
      };
    };
  };
}
