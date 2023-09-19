{
  services = {
    syncthing = {
      enable = false;
      user = "kailee";
      dataDir = "/home/kailee/.syncthing";
    };


    openvscode-server = {
      enable = false;
      withoutConnectionToken = true;
      user = "kailee";

    };
  };
  nixpkgs.config.permittedInsecurePackages = [
    "nodejs-16.20.2"
  ];


}
