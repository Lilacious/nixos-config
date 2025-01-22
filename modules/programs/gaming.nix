{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.myModules.programs.gaming;
in
{
  options = {
    myModules.programs.gaming = {
      enable = mkEnableOption "gaming applications";

      emulators.enable = mkEnableOption "emulators" // {
        default = true;
      };
      steam.enable = mkEnableOption "steam client" // {
        default = true;
      };
      heroic.enable = mkEnableOption "heroic game launcher" // {
        default = true;
      };
      prism.enable = mkEnableOption "prism launcher" // {
        default = true;
      };
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages =
      with pkgs;
      (mkMerge [
        (mkIf cfg.emulators.enable [
          melonDS # DS Emulator
          # Disable due to
          # 1. build failure
          # 2. apparently will be superseded by azahar emulator
          #lime3ds # 3DS Emulator
        ])
        (mkIf cfg.heroic.enable [
          heroic
        ])
        (mkIf cfg.prism.enable [
          prismlauncher
        ])
      ]);

    programs.steam.enable = cfg.steam.enable;
  };
}
