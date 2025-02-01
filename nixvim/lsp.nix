{
  plugins = {
    lsp = {
      enable = true;
      inlayHints = true;

      servers = {
        # Nix
        nil_ls = {
          enable = true;
          settings.nix.flake.autoArchive = false;
        };
        # C/C++
        clangd.enable = true;
        # Python
        pyright.enable = true;
        # Rust
        rust_analyzer.enable = true;
        # Markdown
        marksman.enable = true;
        # PHP
        phpactor.enable = true;
        # SQL
        sqls.enable = true;
        # LaTeX
        texlab = {
          enable = true;
        };
      };
    };
    #nix.enable = true;

    # Useful status updates for LSP.
    fidget.enable = true;
    # Remove trailing trailing whitespace and lines.
    trim.enable = true;
  };
}
