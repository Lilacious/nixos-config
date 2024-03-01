{ variables, config, ... }:
{
  home-manager.users.${variables.username} = {
    xdg = {
      enable = true;
      cacheHome = "${config.users.users.${variables.username}.home}/.cache";
      configHome = "${config.users.users.${variables.username}.home}/.config";
      dataHome = "${config.users.users.${variables.username}.home}/.local/share";
    };
  };
}
