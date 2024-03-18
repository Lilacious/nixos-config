{
  inputs,
  config,
  ...
}: let
  cfg = config.myModules;
in {
  home-manager.users.yunix = {
    home = {
      username = "yunix";
      homeDirectory = "${config.users.users.yunix.home}";
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
      inputs.plasma-manager.homeManagerModules.plasma-manager
      ./plasma-config.nix
      ./git.nix
      ../../home
    ];
  };
}
