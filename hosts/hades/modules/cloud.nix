{ config, lib, pkgs, ... }:
{
  services.nextcloud = {
    enable = true;

    # Nextcloud update steps    
    # $ nextcloud-occ maintenance:mode --on
    # Increment the version of services.nextcloud.package in your config by 1
    # $ Update
    # $ nextcloud-occ maintenance:mode --off
    package = pkgs.nextcloud27;

    extraApps = with config.services.nextcloud.package.packages.apps; {
      inherit memories calendar contacts
      maps twofactor_webauthn spreed
      bookmarks polls;
    };
    extraAppsEnable = true;
    hostName = "cloud.yu-nix.de";
    home = "/data/nextcloud/home";
    datadir = "/data/nextcloud/data";
    https = true;
    logType = "file";
    autoUpdateApps.enable = true;
    database.createLocally = true;
    config = {
      adminuser = "lilacious";
      adminpassFile = config.age.secrets.nextcloud.path;
      dbtype = "pgsql";
      extraTrustedDomains = [
        "next.cloud"
      ];
    };
    configureRedis = true;
    caching.apcu = false;
  };

  age.secrets.nextcloud = {
    file = ../../../secrets/nextcloud1.age;
    owner = "nextcloud";
    group = "nextcloud";
  };

  networking.firewall = {
    allowedTCPPorts = [ 80 443 ];
  };
}
