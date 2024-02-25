{
  imports = [
    ./adguard.nix
  ];


  myModules.services.reverseProxy.enable = true;
}
