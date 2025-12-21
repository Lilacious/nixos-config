{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.myModules.programs.jetbrains;
in
{
  options = {
    myModules.programs.jetbrains = {
      enable = mkEnableOption "jetbrains IDEs" // {
        # remember to add new options
        default = cfg.idea.enable || cfg.pycharm.enable;
      };
      idea.enable = mkEnableOption "Java IDE";
      pycharm.enable = mkEnableOption "Python IDE";
    };
  };
  config = {
    programs.nix-ld.enable = mkDefault cfg.enable;
    environment.systemPackages =
      with pkgs;
      (mkMerge [
        (mkIf cfg.idea.enable [
          jetbrains.idea
        ])
        (mkIf cfg.pycharm.enable [
          jetbrains.pycharm-community
        ])
      ]);
  };
}
