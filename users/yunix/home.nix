{
  inputs,
  config,
  ...
}: {
  home-manager.users.yunix = {
    home = {
      username = "yunix";
      homeDirectory = "${config.users.users.yunix.home}";
      stateVersion = "23.05";
    };
    imports = [
      inputs.plasma-manager.homeManagerModules.plasma-manager
      ./plasma-config.nix
      ./git.nix
      ../../home
    ];
  };
}
