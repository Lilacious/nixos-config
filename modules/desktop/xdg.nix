{ config, ... }:
{
  home-manager.users.${config.variables.username} = {
    xdg = {
      enable = true;
      cacheHome = "${config.users.users.${config.variables.username}.home}/.cache";
      configHome = "${config.users.users.${config.variables.username}.home}/.config";
      dataHome = "${config.users.users.${config.variables.username}.home}/.local/share";
    };
  };
}
