{ pkgs, ... }:
{
  ## Default neovim
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
        set clipboard=unnamedplus

        "" Set color scheme
        colorscheme catppuccin-mocha
      '';
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [
          ## Reopens at last edit position
          vim-lastplace
          ## Support for writing Nix expressions
          vim-nix
          ## Catppuccin theme for nvim
          catppuccin-nvim
        ];        
      };
    };
  };

  environment.systemPackages = with pkgs; [
    ## Clipboard
    wl-clipboard
    xclip
  ];
}
