# For system config see nix-config/modules/programs/virt-manager.nix
{
  config,
  osConfig,
  lib,
  ...
}:
with lib; let
  cfg = config.myHome.programs.virt-manager;
  osCfg = osConfig.myModules.programs.virt-manager;
in {
  options = {
    myHome.programs.virt-manager = {
      enable = mkOption {
        type = types.bool;
        default = osCfg.enable;
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
