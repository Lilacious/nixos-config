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
      programs = {
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
