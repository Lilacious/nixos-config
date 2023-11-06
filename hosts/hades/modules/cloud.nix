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
      inherit calendar contacts mail memories twofactor_webauthn
      maps spreed;
    };
    extraAppsEnable = true;
    hostName = "cloud.yu-nix.de";
    home = "/data/nextcloud/home";
    datadir = "/data/nextcloud/data";
    https = true;
    logType = "file";
    logLevel = 3;
    autoUpdateApps.enable = true;
    database.createLocally = true;
    config = {
      adminuser = "lilacious";
      adminpassFile = config.age.secrets.nextcloud.path;
      dbtype = "pgsql";
      extraTrustedDomains = [
        "localcloud.yu-nix.de"
      ];
    };

    phpOptions = lib.mkForce {
      catch_workers_output = "yes";
      display_errors = "stderr";
      error_reporting = "E_ALL & ~E_DEPRECATED & ~E_STRICT";
      expose_php = "Off";
      "opcache.enable_cli" = "1";
      "opcache.fast_shutdown" = "1";
      "opcache.interned_strings_buffer" = "8";
      "opcache.max_accelerated_files" = "10000";
      "opcache.memory_consumption" = "128";
      "opcache.revalidate_freq" = "1";
      "openssl.cafile" = "/etc/ssl/certs/ca-certificates.crt";
      short_open_tag = "Off";
      memory_limit = "-1";
    };

    maxUploadSize = "32G";

    configureRedis = true;
    caching.redis = true;
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
