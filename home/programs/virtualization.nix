# For system config see nix-config/modules/programs/virt-manager.nix
{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.myHome.programs.virt-manager;
  vm = config.myModules.programs.virt-manager;
in {
  options = {
    myHome.programs.virt-manager = {
      enable = mkOption {
        type = types.bool;
        default = vm.enable;
      };
    };
  };
  config = mkIf cfg.enable {
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };
  };
}
