let
  border = "rounded";
in
{
  plugins = {
    cmp = {
      enable = true;
      autoEnableSources = true;

      settings = {
        snippet.expand = ''
          function(args)
            require("luasnip").lsp_expand(args.body)
          end
        '';
        window = {
          documentation = {
            inherit border;
          };
          completion = {
            inherit border;
            scrollbar = false;
            completeopt = "menu,menuone,noinsert";
          };
        };
        sources = [
          { name = "luasnip"; }
          { name = "nvim_lsp"; }
          { name = "nvim_lsp_signature_help"; }
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

    # Completion source for lsp
    cmp-nvim-lsp.enable = true;
    # Pictograms for completion items
    lspkind.enable = true;
    # Snippet Engine & its associated cmp source
    luasnip.enable = true;
    # Completion source for filesystem path
    cmp-path.enable = true;
    # Premade snippets for various programming languages
    friendly-snippets.enable = true;
  };
}
