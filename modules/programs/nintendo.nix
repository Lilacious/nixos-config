{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.myModules.programs.nintendo;
in
{
  options = {
    myModules.programs.nintendo = {
      switch.enable = mkEnableOption "Nintendo Switch tools";
      n3ds.enable = mkEnableOption "Nintendo 3ds tools";
    };
  };
  config = {
    environment.systemPackages =
      with pkgs;
      (mkMerge [
        (mkIf cfg.switch.enable [
          # Hekate injector
          fusee-nano
          # Awoo helper
          ns-usbloader
        ])
        (mkIf cfg.n3ds.enable [
          # extract rom data
          ctrtool
        ])
      ]);
  };
}
