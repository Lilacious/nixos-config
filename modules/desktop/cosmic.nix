{
  inputs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.myModules.desktop.cosmic;
in
{
  options = {
    myModules.desktop.cosmic = {
      enable = mkEnableOption "cosmic desktop";
    };
  };

  config = mkIf cfg.enable {
    myModules.desktop.desktopEnvironment.enable = true;

    services.desktopManager.cosmic.enable = true;
  };
}
