{
  imports = [
    ./cloud.nix
    ./dashboard.nix
    ./syncthing.nix
    ./torrent.nix
  ];

  myModules.services.reverseProxy.enable = true;
}
