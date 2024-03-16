# For home config see nix-config/home/programs/vscode.nix
{
  lib,
  pkgs,
  ...
}:
with lib; let
  jsonFormat = pkgs.formats.json {};
in {
  options = {
    myModules.programs.vscode = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };

      userSettings = mkOption {
        type = jsonFormat.type;
        default = {};
      };

      extensions = mkOption {
        type = types.listOf types.package;
        default = [];
      };
    };
  };
}
