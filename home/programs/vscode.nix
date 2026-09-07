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
    # 'programs.vscode' now always writes to Visual Studio Code's paths,
    # hence use 'programs.vscodium' so that configuration is
    # written to the fork's own paths.
    programs.vscodium = {
      enable = true;

      profiles.default = {
        enableUpdateCheck = false;
        userSettings = {
          "claudeCode.preferredLocation" = "panel";
          "catppuccin"."accentColor" = "mauve";
          "extensions"."experimental"."affinity" = {
            "vscodevim"."vim" = 1;
          };
          "editor"."fontFamily" = "Agave Nerd Font";
          "files"."enableTrash" = false;
          "nix"."enableLanguageServer" = true;
          "nix"."serverPath" = "nil";
          "vim"."useSystemClipboard" = true;
          "vim"."enableNeovim" = true;
          "vim"."neovimUseConfigFile" = true;
          "workbench"."colorTheme" = "Catppuccin Mocha";
          "workbench"."iconTheme" = "Catppuccin Mocha";
        }
        // cfg.userSettings;

        enableExtensionUpdateCheck = false;
        extensions =
          with pkgs.vscode-extensions;
          [
            anthropic.claude-code
            catppuccin.catppuccin-vsc
            catppuccin.catppuccin-vsc-icons
            gruntfuggly.todo-tree
            jnoortheen.nix-ide
            mkhl.direnv
            vscodevim.vim
          ]
          ++ cfg.extensions;
      };
    };
    home.packages = [
      pkgs.nil
    ];
  };
}
