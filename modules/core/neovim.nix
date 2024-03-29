{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.myModules;
in {
  config = mkIf cfg.enable {
    # Enable systemwide neovim
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      configure = {
        customRC = ''
          set nocompatible
          set backspace=indent,eol,start
          set number
          "" Clipboard support
          set clipboard+=unnamedplus

          "" Set color scheme
          colorscheme catppuccin-mocha

          "" command alias
          cnoreabbrev W w
          cnoreabbrev Q q
          cnoreabbrev Wq wq
          cnoreabbrev WQ wq
          cnoreabbrev Q! q!
        '';
        packages.myVimPackage = with pkgs.vimPlugins; {
          start = [
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
            ## Collection of configurations for built-in LSP client
            {
              plugin = nvim-lspconfig;
              config = ''
                lua << END
                  local lspconfig = require('lspconfig')
                  require'lspconfig'.nil_ls.setup{
                    settings = {["nil"] = {
                      nix = {flake = {autoArchive = true}},
                    }},
                  }
                END
              '';
            }
          ];
        };
      };
    };

    environment.systemPackages = with pkgs; [
      ## Clipboard
      wl-clipboard
      xclip
      ## Nix language server
      nil
    ];
  };
}
