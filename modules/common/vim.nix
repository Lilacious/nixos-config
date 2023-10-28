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
            vim-lastplace
            vim-nix
            yuck-vim
            nvim-surround
            treesj
            nvim-bqf
            vimPlugins.nvim-ufo
          ]; 
          opt = [];
        };
        customRC = ''
          set nocompatible
          set backspace=indent,eol,start
          set clipboard+=unnamedplus
        '';
      };
    })

    ## Clipboard
    wl-clipboard
    xclip
  ];
}
