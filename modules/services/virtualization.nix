{ config, lib, pkgs, variables, ... }:

with lib;
let
  cfg = config.myModules.services.virtualization;
in {
  options = {
    myModules.services.virtualization = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf (cfg.enable) {
    virtualisation.libvirtd.enable = true;
    programs.dconf.enable = true;
    environment.systemPackages = with pkgs; [ 
      virt-manager
    ];
    users.users.${variables.username}.extraGroups = [ "libvirtd" ];
  };
}
