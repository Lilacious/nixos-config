# For home config see nix-config/home/programs/virt-manager.nix
{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.myModules.programs.virt-manager;
in {
  options = {
    myModules.programs.virt-manager = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf (cfg.enable) {
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;
  };
}
