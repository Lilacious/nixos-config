{ config, lib, pkgs, ... }:
let
  ## Transcoding
  go-vod = pkgs.callPackage ../../../pkgs/go-vod.nix {};
in
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
      inherit calendar contacts mail memories 
      maps spreed previewgenerator;
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
      trustedProxies = [
        "proxy.yu-nix.de"
      ];
    };
    extraOptions = {
      "memories.exiftool_no_local" = true;
      "memories.exiftool" = "${pkgs.exiftool}/bin/exiftool";
      ## Transcoding
      "memories.vod.path" = "${go-vod}/bin/go-vod";
      "memories.vod.ffmpeg" = "${pkgs.ffmpeg}/bin/ffmpeg";
      "memories.vod.ffprobe" = "${pkgs.ffmpeg}/bin/ffprobe";
    };

    phpOptions = {
      "apc.enable_cli" = "1";
    };

    phpExtraExtensions = all: [
      all.imagick
    ];

    maxUploadSize = "32G";

    configureRedis = true;
    caching = {
      apcu = true;
      redis = true;
    };
  };

  age.secrets.nextcloud = {
    file = ../../../secrets/nextcloud1.age;
    owner = "nextcloud";
    group = "nextcloud";
  };

  environment.systemPackages = with pkgs; [
    perl
    exiftool
    ffmpeg

    ## Transcoding
    go-vod
  ];

  ## Background index fix
  systemd.services.nextcloud-cron = {
    path = [pkgs.perl];
  };

  networking.firewall = {
    allowedTCPPorts = [ 80 443 ];
  };

  ## Transcoding
  systemd.services."go-vod" = {
    path = with pkgs; [
      ffmpeg
    ];
    serviceConfig = {
      DynamicUser = true;
      ExecStart = "${go-vod}/bin/go-vod";
      DeviceAllow = [ "/dev/dri/renderD128" "/dev/dri/renderD129" ];
      ReadOnlyPaths = config.services.nextcloud.home;
      SupplementaryGroups = [ "nextcloud" ];
    };
  };
}
