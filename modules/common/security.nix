{ lib, config, ... }:

with lib;
{
  networking.firewall = {
    enable = mkForce true;
  };

  security.polkit.enable = mkDefault false;

  security.sudo.enable = mkIf( config.security.doas.enable ) false;

  security.doas = {
    enable = mkDefault true;
    extraRules = [{
      groups = [ "wheel" ];
      persist = true;
      keepEnv = true;
    }];
  };

  home-manager.users.${config.variables.username} = mkIf( config.security.doas.enable ) {
    home.shellAliases = {
      sudo = "doas";
    };
  };
}
