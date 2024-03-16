{config, ...}: {
  users.users.yunix = {
    isNormalUser = true;
    description = "Yunix";
    extraGroups = [
      "corectrl"
      "libvirtd"
      "networkmanager"
      "video"
      "wheel"
    ];
    initialPassword = "changeme";
    shell = "zsh";
  };

  home-manager.users.yunix = {
    home.username = "yunix";
    home.homeDirectory = "${config.users.users.yunix.home}";
    home.stateVersion = "23.05";
    imports = [
      ./git.nix
      ./syncthing.nix
      ../../home
    ];
  };
}
