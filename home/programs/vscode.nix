# For system config see nix-config/modules/programs/vscode.nix
{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.myHome.programs.vscode;
  osCfg = osConfig.myModules.programs.vscode;
  jsonFormat = pkgs.formats.json { };
in
{
  options = {
    myHome.programs.vscode = {
      enable = mkOption {
        type = types.bool;
        default = osCfg.enable;
      };

      userSettings = mkOption {
        inherit (jsonFormat) type;
        default = osCfg.userSettings;
      };

      extensions = mkOption {
        type = types.listOf types.package;
        default = osCfg.extensions;
      };
    };
  };
  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;

      profiles.default = {
        enableUpdateCheck = false;
        userSettings = {
          "editor"."fontFamily" = "Agave Nerd Font";
          "nix"."enableLanguageServer" = true;
          "nix"."serverPath" = "nil";
          "vim"."useSystemClipboard" = true;
          "vim"."enableNeovim" = true;
          "vim"."neovimUseConfigFile" = true;
          "extensions"."experimental"."affinity" = {
            "vscodevim"."vim" = 1;
          };
          "workbench"."colorTheme" = "Catppuccin Mocha";
          "workbench"."iconTheme" = "Catppuccin Mocha";
          "catppuccin"."accentColor" = "mauve";
        } // cfg.userSettings;

        enableExtensionUpdateCheck = false;
        extensions =
          with pkgs.vscode-extensions;
          [
            catppuccin.catppuccin-vsc
            catppuccin.catppuccin-vsc-icons
            jnoortheen.nix-ide
            vscodevim.vim
            gruntfuggly.todo-tree
            mkhl.direnv
          ]
          ++ cfg.extensions;
      };
    };
    home.packages = [
      pkgs.nil
    ];
  };
}
