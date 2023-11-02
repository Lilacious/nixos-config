{ pkgs, ... }:
{
  environment.variables = { 
    EDITOR = "vim"; 
  };

  environment.systemPackages = with pkgs; [
    (neovim.override {
      vimAlias = true;
      configure = {
        packages.myPlugins = with pkgs.vimPlugins; {
          start = [ 
            ## Reopens at last edit position
            vim-lastplace           
            ## Support for writing Nix expressions
            vim-nix
            ## Surround selections
            nvim-surround
            ## File system explorer
            nerdtree
            ## Catppuccin theme for nvim
            catppuccin-nvim
          ]; 
          opt = [];
        };
        customRC = ''
          set nocompatible
          set backspace=indent,eol,start

          " Clipboard support
          set clipboard+=unnamedplus

          " Set color scheme
          colorscheme catppuccin-mocha
        '';
      };
    })

    ## Clipboard
    wl-clipboard
    xclip
  ];
}
