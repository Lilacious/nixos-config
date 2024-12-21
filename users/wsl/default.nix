## WSL user
{
  inputs,
  config,
  pkgs,
  ...
}:
let
  user = "nixos";
  inherit (config.users.users.${user}) home;
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        extraSpecialArgs = {
          inherit inputs;
        };
        useGlobalPkgs = true;
        useUserPackages = true;
      };
    }
  ];

  wsl = {
    enable = true;
    defaultUser = "nixos";
  };

  users.users.${user} = {
    isNormalUser = true;
    shell = pkgs.zsh;
  };

  home-manager.users.${user} = {
    home = {
      username = user;
      homeDirectory = home;
      stateVersion = "23.05";
    };
    imports = [
      ../../home/core
    ];
  };
}
