{ config, ... }:
{
  home-manager.users.${config.variables.username} = {
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
