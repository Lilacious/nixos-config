{ config, lib, pkgs, variables, ... }:

with lib;
{
  options = {
    virt-manager = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf (config.virt-manager.enable) {
    virtualisation.libvirtd.enable = true;
    programs.dconf.enable = true;
    environment.systemPackages = with pkgs; [ 
      virt-manager
    ];
    users.users.${variables.username}.extraGroups = [ "libvirtd" ];
  };
}
