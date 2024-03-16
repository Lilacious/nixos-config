{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.myHome.programs.vscode;
  dsktp = config.myModules.desktop;
  jsonFormat = pkgs.formats.json {};
in {
  options = {
    myHome.programs.vscode = {
      enable = mkOption {
        type = types.bool;
        default = dsktp.enable;
      };

      package = mkOption {
        type = types.package;
        default = pkgs.vscodium;
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
  config = mkIf (cfg.enable) {
    programs.vscode = {
      enable = true;

      package = cfg.package;

      enableExtensionUpdateCheck = false;

      enableUpdateCheck = false;

      userSettings =
        {
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
          "catppuccin"."accentColor" = "pink";
        }
        // cfg.userSettings;

      extensions = with pkgs.vscode-extensions;
        [
          jnoortheen.nix-ide
          vscodevim.vim
          catppuccin.catppuccin-vsc
        ]
        ++ cfg.extensions;
    };
  };
}
