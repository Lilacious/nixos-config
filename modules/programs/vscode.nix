{ config, lib, pkgs, variables, ... }:

with lib;
let
  cfg = config.myModules.programs.vscode;
in {
  options = {
    myModules.programs.vscode = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };

      package = mkOption {
        type = types.package;
        default = pkgs.vscodium;
      };

      extensions = mkOption {
        type = types.listOf types.package;
        default = [ ];
      };
    };
  };
  config = mkIf (cfg.enable) {
    home-manager.users.${variables.username} = {
      programs.vscode = {
        enable = true;

        package = cfg.package;

        enableExtensionUpdateCheck = false;

        enableUpdateCheck = false;

        userSettings = {
          "vim"."useSystemClipboard" = true;
          "workbench"."colorTheme" = "Catppuccin Mocha";
          "catppuccin"."accentColor" = "pink";
        };

        extensions = with pkgs.vscode-extensions; [
          jnoortheen.nix-ide
          vscodevim.vim
          catppuccin.catppuccin-vsc
        ] ++ cfg.extensions;
      };
    };
  };
}
