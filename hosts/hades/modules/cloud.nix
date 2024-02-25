{ config, pkgs, ... }:
let
  go-vod = pkgs.callPackage ../../../pkgs/go-vod/package.nix {};
in
{
  services.nextcloud = {
    enable = true;

    # Nextcloud update steps    
    # $ nextcloud-occ maintenance:mode --on
    # Increment the version of services.nextcloud.package in your config by 1
    # $ Update
    # $ nextcloud-occ maintenance:mode --off
    package = pkgs.nextcloud28;

    extraApps = with config.services.nextcloud.package.packages.apps; {
      inherit calendar contacts mail memories 
      maps previewgenerator;
    };
    extraAppsEnable = true;
    hostName = "cloud.yu-nix.de";
    home = "/data/nextcloud/home";
    datadir = "/data/nextcloud/data";
    https = true;
    autoUpdateApps.enable = true;
    database.createLocally = true;
    config = {
      adminuser = "lilacious";
      adminpassFile = config.age.secrets.nextcloud.path;
      dbtype = "pgsql";
    };

    settings = {
      log_type = "file";
      loglevel = 3;

      default_phone_region = "DE";

      extraTrustedDomains = [
      ];

      "maintenance_window_start" = 1;

      "memories.exiftool_no_local" = true;
      "memories.exiftool" = "${pkgs.exiftool}/bin/exiftool";
      "memories.vod.path" = "${go-vod}/bin/go-vod";
      "memories.vod.ffmpeg" = "${pkgs.jellyfin-ffmpeg}/bin/ffmpeg";
      "memories.vod.ffprobe" = "${pkgs.jellyfin-ffmpeg}/bin/ffprobe";
    };

    phpOptions = {
      "opcache.interned_strings_buffer" = "32";
    };

    maxUploadSize = "128G";

    configureRedis = true;
  };

  age.secrets.nextcloud = {
    file = ../../../secrets/nextcloud1.age;
    owner = "nextcloud";
    group = "nextcloud";
  };

  environment.systemPackages = with pkgs; [
    perl
    exiftool
    jellyfin-ffmpeg

    ## Transcoding
    go-vod
  ];

  ## Background index fix
  systemd.services.nextcloud-cron = {
    path = [pkgs.perl];
  };

  services.nginx.virtualHosts = {
    ${config.services.nextcloud.hostName} = {
      forceSSL = true;
      enableACME = true;
    };
    "localhost".listen = [ { addr = "127.0.0.1"; port = 4080; } ];
  };
}
