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
    services.desktopManager.cosmic.enable = true;
  };
}
