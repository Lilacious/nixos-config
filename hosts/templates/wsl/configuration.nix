{ pkgs, ... }:
{
  myModules.nixvim.languages = {
    python = true;
    php = true;
    sql = true;
  };

  environment.systemPackages = with pkgs; [
    php
  ];

  environment.shellAliases = {
    startPhp = "sudo php -t . -S 127.0.0.1:80";
    startDbTunnel = "ssh -N -L 3306:127.0.0.1:3306";
  };
}
