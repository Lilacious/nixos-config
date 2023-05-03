{ pkgs, ... }:
{
  environment.variables = { EDITOR = "vim"; };

  environment.systemPackages = with pkgs; [
    (neovim.override {
      vimAlias = true;
      configure = {
        packages.myPlugins = with pkgs.vimPlugins; {
          start = [ 
            vim-lastplace
            vim-nix
            yuck-vim
          ]; 
          opt = [];
        };
        customRC = ''
          set nocompatible
          set backspace=indent,eol,start
          set clipboard+=unnamedplus
        '';
      };
    }
  )];
}
