{ lib, variables, pkgs, ... }:

with lib;
{
  home-manager.users.${variables.username} = {
    programs = {
      zoxide = {
        enable = true;
      };
    
      zsh.shellAliases = {
        cd = "z";   # zoxide
        cdf = "zi"; # z with fzf
      };
    };
  };
}
