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
      desktop = {
        enable = cfg.desktop.enable;
        hyprland.enable = cfg.desktop.hyprland.enable;
      };
      programs = {
        virt-manager.enable = cfg.programs.virt-manager.enable;
        vscode = {
          enable = cfg.programs.vscode.enable;
          userSettings = cfg.programs.vscode.userSettings;
          extensions = cfg.programs.vscode.extensions;
        };
        zsh.enable = cfg.core.zsh.enable;
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
