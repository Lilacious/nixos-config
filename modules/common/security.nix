{ lib, variables, config, ... }:

with lib;
{
  networking.firewall = {
    enable = mkDefault true;
  };

  security.sudo.enable = mkIf( config.security.doas.enable ) false;

  security.doas = {
    enable = mkDefault true;
    extraRules = [{
      groups = [ "wheel" ];
      persist = true;
      keepEnv = true;
    }];
  };
  home-manager.users.${variables.username} = {
    programs.zsh = {
      shellAliases = {
        sudo = "doas";
      };
    };
  };
}
