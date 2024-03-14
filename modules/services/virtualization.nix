{ config, lib, ... }:

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
    programs.virt-manager.enable = true;

    users.users.${config.variables.username}.extraGroups = [ "libvirtd" ];

    home-manager.users.${config.variables.username} = {
      dconf.settings = {
        "org/virt-manager/virt-manager/connections" = {
          autoconnect = ["qemu:///system"];
          uris = ["qemu:///system"];
        };
      };
    };
  };
}
