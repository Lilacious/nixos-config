{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.myModules.programs.office;
in
{
  options = {
    myModules.programs.office = {
      enable = mkEnableOption "LibreOffice";
      plasma.enable = mkEnableOption "LibreOffice-qt";
      spellCheck.enable = mkEnableOption "Hunspell";
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages =
      with pkgs;
      (mkMerge [
        (mkIf (!cfg.plasma.enable) [
          libreoffice
        ])
        (mkIf cfg.plasma.enable [
          libreoffice-qt
        ])
        (mkIf cfg.spellCheck.enable [
          hunspell
          hunspellDicts.en_GB-ise
          hunspellDicts.de_DE
        ])
      ]);
  };
}
