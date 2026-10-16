# For system config see nix-config/modules/programs/vscode.nix
{
  config,
  osConfig,
  options,
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
  config = mkIf cfg.enable (mkMerge [
    {
      # 'programs.vscode' now always writes to Visual Studio Code's paths,
      # hence use 'programs.vscodium' so that configuration is
      # written to the fork's own paths.
      programs.vscodium = {
        enable = true;
        mutableExtensionsDir = false;

        profiles.default = {
          enableUpdateCheck = false;
          userSettings = recursiveUpdate {
            "claudeCode.preferredLocation" = "panel";
            "catppuccin"."accentColor" = "mauve";
            "extensions"."experimental"."affinity" = {
              "vscodevim"."vim" = 1;
            };
            "extensions"."autoUpdate" = "off";
            "editor"."fontFamily" = "JetBrainsMono Nerd Font";
            "editor"."fontSize" = 13;
            "editor"."rulers" = [ 100 ];
            "files"."enableTrash" = false;
            "files"."insertFinalNewline" = true;
            "files"."trimTrailingWhitespace" = true;
            "nix"."enableLanguageServer" = true;
            "nix"."serverPath" = getExe pkgs.nil;
            "terminal"."integrated"."stickyScroll"."enabled" = false;
            "vim"."useSystemClipboard" = true;
            "vim"."enableNeovim" = true;
            "vim"."neovimUseConfigFile" = false;
            "workbench"."colorTheme" = "Catppuccin Mocha";
            "workbench"."iconTheme" = "Catppuccin Mocha";
            "workbench"."startupEditor" = "none";
          } cfg.userSettings;

          enableExtensionUpdateCheck = false;
          extensions =
            with pkgs.vscode-extensions;
            [
              anthropic.claude-code
              catppuccin.catppuccin-vsc-icons
              gruntfuggly.todo-tree
              jnoortheen.nix-ide
              mkhl.direnv
              vscodevim.vim
            ]
            ++ cfg.extensions;
        };
      };

      programs.claude-code = {
        enable = true;
        # use VSCode extension binary
        package = null;
        plugins.ponytail = pkgs.fetchFromGitHub {
          owner = "DietrichGebert";
          repo = "ponytail";
          rev = "2961b52fc1fe6a5a87c7a959a79512e5c2f3ffe5";
          hash = "sha256-3GopEvTySUvo0ghGz4CF6xbN7x3kbB/IHEY7Dwr4dls=";
        };
        mcpServers.nixos = {
          type = "stdio";
          command = getExe pkgs.mcp-nixos;
        };
      };
      home.packages = [
        pkgs.nodejs # needed for ponytail plugin hooks
      ];
    }
    (
      if (builtins.hasAttr "stylix" options) then
        {
          programs.vscodium.profiles.default.extensions = [
            (pkgs.callPackage ../../pkgs/catppuccin-vscode/package.nix {
              catppuccinOptions = {
                accent = "mauve";
                colorOverrides.mocha = with config.lib.stylix.colors.withHashtag; {
                  base = base00;
                  mantle = base01;
                  crust = base11;
                  surface0 = base02;
                  overlay0 = base03;
                  subtext0 = base04;
                  text = base05;
                  rosewater = base06;
                  lavender = base07;
                  red = base08;
                  peach = base09;
                  yellow = base0A;
                  green = base0B;
                  teal = base0C;
                  blue = base0D;
                  mauve = base0E;
                  flamingo = base0F;
                  maroon = base12;
                  sky = base15;
                  sapphire = base16;
                  pink = base17;
                };
              };
            })
          ];
        }
      else
        {
          programs.vscodium.profiles.default.extensions = [
            pkgs.vscode-extensions.catppuccin.catppuccin-vsc
          ];
        }
    )
  ]);
}
