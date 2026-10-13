{
  imports = [ ./. ];

  home-manager.users.yunix = {
    imports = [
      ../../home/programs/alacritty.nix
      ../../home/services/syncthing.nix
    ];
    # TODO better solution maybe?
    myHome.services.syncthing.enable = true;
  };

  # required by user specific options like system.defaults
  system.primaryUser = "yunix";
}
