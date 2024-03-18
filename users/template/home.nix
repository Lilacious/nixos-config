{config, ...}: let
  cfg = config.myModules;
in {
  home-manager.users.yunix = {
    home = {
      username = "max";
      homeDirectory = "${config.users.users.max.home}";
      stateVersion = "23.05";
    };

    myHome = {
      desktop = {
        desktopEnvironment = cfg.desktop.desktopEnvironment;
        windowManager = {
          wayland = cfg.desktop.windowManager.wayland;
          xserver = cfg.desktop.windowManager.xserver;
        };
      };
      programs = {
        virt-manager.enable = cfg.programs.virt-manager.enable;
        vscode = {
          enable = cfg.programs.vscode.enable;
          userSettings = cfg.programs.vscode.userSettings;
          extensions = cfg.programs.vscode.extensions;
        };
      };
    };

    imports = [
    ];
  };
}
