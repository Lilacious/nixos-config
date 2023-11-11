{ lib, variables, pkgs, ... }:

with lib;
{
  home-manager.users.${variables.username} = {
    home.packages = with pkgs; [
      nil
    ];

    programs = {
      neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;

        plugins = with pkgs.vimPlugins; [
          ## Reopens at last edit position
          vim-lastplace
          ## Support for writing Nix expressions
          vim-nix
          ## Catppuccin theme for nvim
          catppuccin-nvim
          ## Statusline/tabline plugin for Vim
          { 
            plugin = lightline-vim;
            config = "let g:lightline = {'colorscheme': 'catppuccin'}";
          }
          ## Completion engine with LSP
          nvim-lspconfig
          cmp-nvim-lsp
          cmp-buffer
          cmp-path
          cmp-cmdline
          nvim-cmp
          cmp-vsnip
          vim-vsnip
        ];
        
        extraConfig = ''
          ""set nocompatible
          set backspace=indent,eol,start
          set number
          "" Clipboard support
          set clipboard+=unnamedplus

          "" Set color scheme
          colorscheme catppuccin-mocha

          lua << EOF


          ---- lspconfig
          -- Vars
          local lspconfig = require('lspconfig')
          local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

          -- lsp servers
          lspconfig.nil_ls.setup {
            capabilities = lsp_capabilities,
          }

          -- Set up nvim-cmp with default recommended setting
          local cmp = require'cmp'
          
          cmp.setup({
            snippet = {
              expand = function(args)
                vim.fn["vsnip#anonymous"](args.body)
              end,
            },
            window = {
              -- completion = cmp.config.window.bordered(),
              -- documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
              ['<C-u>'] = cmp.mapping.scroll_docs(-4),
              ['<C-d>'] = cmp.mapping.scroll_docs(4),
              ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
              ['<Down>'] = cmp.mapping.select_next_item(select_opts),
              ['<C-y>'] = cmp.mapping.confirm({select = true}),
              ['<CR>'] = cmp.mapping.confirm({select = false}),
              ['<Tab>'] = cmp.mapping(function(fallback)
                local col = vim.fn.col('.') - 1

                if cmp.visible() then
                  cmp.select_next_item(select_opts)
                elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
                  fallback()
                else
                  cmp.complete()
                end
              end, {'i', 's'}),
            }),
            sources = cmp.config.sources({
              { name = 'nvim_lsp' },
              { name = 'vsnip' }, 
            }, {
              { name = 'buffer' },
            })
          })
               

          EOF
        '';
      };
    };
  };
}
