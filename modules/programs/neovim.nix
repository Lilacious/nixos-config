{ lib, config, pkgs, ... }:

with lib;
{
  home-manager.users.${config.variables.username} = {

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
          ## Indent guides for Neovim
          {
            plugin = indent-blankline-nvim;
            config = ''lua require("ibl").setup()'';
          }
          ## Neovim colorizer
          {
            plugin = nvim-colorizer-lua;
            config = "lua require'colorizer'.setup()";
          }
          ## File type icons
          nvim-web-devicons
          #### Completion engine with LSP
          ## Collection of configurations for built-in LSP client
          nvim-lspconfig
          ## Autocompletion plugin
          nvim-cmp
          ## LSP source for nvim-cmp
          cmp-nvim-lsp
          ## Snippets source for nvim-cmp
          cmp_luasnip
          ## LuaSnip
          luasnip
        ];
        
        extraConfig = ''
          set nocompatible
          set backspace=indent,eol,start
          set number

          "" Clipboard support

          set clipboard=unnamedplus

          "" Set color scheme
          colorscheme catppuccin-mocha
        '';
        extraLuaConfig = builtins.readFile ./neovim.lua;
      };
    };
    ## Language servers
    home.packages = with pkgs; [
      nil
    ];
  };
}
