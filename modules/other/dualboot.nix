{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.myModules.other.dualboot;
in
{
  options = with types; {
    myModules.other.dualboot = {
      enable = mkEnableOption "dualbooting";
      windowsClockFix = mkOption {
        type = bool;
        default = true;
        description = ''
          Set the hardware clock to local time. This is required for Windows to display the correct time.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    time.hardwareClockInLocalTime = cfg.windowsClockFix;
  };
}
