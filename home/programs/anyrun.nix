{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.myHome.programs.anyrun;
  WM = config.myHome.desktop.windowManager;
in {
  options = {
    myHome.programs.anyrun = {
      enable = mkOption {
        type = types.bool;
        default = WM.wayland;
      };
    };
  };
  imports = [inputs.anyrun.homeManagerModules.default];
  config = mkIf cfg.enable {
    programs.anyrun = {
      enable = true;
      config = {
        plugins = with inputs.anyrun.packages.${pkgs.system}; [
          applications
          dictionary
          randr
          rink
          shell
          translate
          websearch
        ];
        y.fraction = 0.4;
        width.fraction = 0.25;
        hideIcons = false;
        ignoreExclusiveZones = false;
        layer = "overlay";
        hidePluginInfo = true;
        closeOnClick = true;
        showResultsImmediately = false;
        maxEntries = 10;
      };
      extraCss = ''
        * {
          transition: 0ms ease;
          font-family: "Agave Nerd Font";
          font-size: 1.3rem;
        }
        #window {
          background-color: transparent;
        }
        #entry {
          color: #d9e0ee;
          background-color: rgba(30,30,46,1);
        }
        entry#entry {
          border-radius: 20px;

        }
        #entry, #plugin:hover {
          padding-left: 1rem;
          border-radius: 20px;
        }
        box#main {
          color: #d9e0ee;
          border: 2px solid #f5c2e7;
          background-color: rgba(30,30,46,0.7);
          border-radius: 20px;
          padding: 10px;
          padding-top: 10px;
        }
        list#main {
          border-radius: 20px;
        }
        #main {
          border-radius: 20px;
        }
        #plugin {
          border-radius: 20px;
        }
        #match {
          border-radius: 20px;
          padding: 3px;
          padding-left: 0.5rem;
        }
        #match:selected {
          border: 2px solid #f5c2e7;
        }
      '';
      extraConfigFiles."applications.ron".text = ''
        Config(
          desktop_actions: false,
          max_entries: 5,
          terminal: Some("alacritty"),
        )
      '';
      extraConfigFiles."dictionary.ron".text = ''
        Config(
          prefix: ":def",
          max_entries: 5,
        )
      '';
      extraConfigFiles."randr.ron".text = ''
        Config(
          prefix: ":dp",
          max_entries: 5,
        )
      '';
      extraConfigFiles."shell.ron".text = ''
        Config(
          prefix: ":sh",
          // Override the shell used to launch the command
          shell: None,
        )
      '';
      extraConfigFiles."translate.ron".text = ''
        Config(
          prefix: ":",
          language_delimiter: ">",
          max_entries: 5,
        )
      '';
      extraConfigFiles."websearch.ron".text = ''
        Config(
          // Options: Google, Ecosia, Bing, DuckDuckGo, Custom
          //
          // Custom engines can be defined as such:
          // Custom(
          //   name: "Searx",
          //   url: "searx.be/?q={}",
          // )
          //
          // NOTE: `{}` is replaced by the search query
          // and `https://` is automatically added in front.

          prefix: "?",
          engines: [Google]
        )
      '';
    };
  };
}
