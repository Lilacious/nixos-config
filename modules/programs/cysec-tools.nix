{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.myModules.programs.cysecTools;
in
{
  options = {
    myModules.programs.cysecTools = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf (cfg.enable) {
    environment.systemPackages = with pkgs; [
      binwalk
      hashcat
      john
      nmap
    ];
  };
}
