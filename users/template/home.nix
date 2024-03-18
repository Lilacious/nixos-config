{config, ...}: {
  home-manager.users.yunix = {
    home = {
      username = "max";
      homeDirectory = "${config.users.users.max.home}";
      stateVersion = "23.05";
    };

    imports = [
    ];
  };
}
