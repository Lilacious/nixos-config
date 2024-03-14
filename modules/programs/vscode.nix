{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.myModules.programs.vscode;
  jsonFormat = pkgs.formats.json { };
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

      userSettings = mkOption {
        type = jsonFormat.type;
        default = { };
      };

      extensions = mkOption {
        type = types.listOf types.package;
        default = [ ];
      };
    };
  };
  config = mkIf (cfg.enable) {
    home-manager.users.${config.variables.username} = {
      programs.vscode = {
        enable = true;

        package = cfg.package;

        enableExtensionUpdateCheck = false;

        enableUpdateCheck = false;

        userSettings = {
          "nix"."enableLanguageServer" = true;
          "nix"."serverPath" = "nil";
          "vim"."useSystemClipboard" = true;
          "vim"."enableNeovim" = true;
          "vim"."neovimUseConfigFile" = true;
          "extensions"."experimental"."affinity" = {
            "vscodevim"."vim" = 1;
          };
          "workbench"."colorTheme" = "Catppuccin Mocha";
          "catppuccin"."accentColor" = "pink";
        } // cfg.userSettings;

        extensions = with pkgs.vscode-extensions; [
          jnoortheen.nix-ide
          vscodevim.vim
          catppuccin.catppuccin-vsc
        ] ++ cfg.extensions;
      };
    };
  };
}
