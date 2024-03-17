{
  services.transmission = {
    enable = true;
    settings = {
      rpc-host-whitelist-enabled = true;
      rpc-host-whitelist = "torrent.web";
      rpc-whitelist = "192.168.*.*";
      rpc-bind-address = "0.0.0.0";
      download-dir = "/data/transmission/Downloads";
      watch-dir = "/data/transmission/watchdir";
      incomplete-dir = "/data/transmission/.incomplete";
    };
  };
  networking.firewall = {
    allowedTCPPorts = [9091 51413];
    allowedUDPPorts = [9091 51413];
  };
}
