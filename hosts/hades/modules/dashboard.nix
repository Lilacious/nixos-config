{ config, lib, pkgs, ... }:
{
  services.homepage-dashboard = {
    enable = true;
    # homepage config path = /var/lib/private
  };

    networking.firewall.allowedTCPPorts = [ 8082 ];
    networking.firewall.allowedUDPPorts = [ 8082 ];

/*
  systemd.services.homepage-dashboard = {
    environment.HOMEPAGE_CONFIG_DIR = lib.mkForce "#";
  };
*/
}
