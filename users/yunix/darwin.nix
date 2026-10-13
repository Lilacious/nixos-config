{
  inputs,
  config,
  lib,
  ...
}:
with lib;
let
  username = "yunix";
  gitFile = ./git.nix;
in
{
  imports = [
    ./.

    inputs.home-manager.darwinModules.home-manager
    {
      home-manager = {
        extraSpecialArgs = {
          inherit inputs;
        };
        useGlobalPkgs = true;
        useUserPackages = true;

        users.${username} = {
          home = {
            username = "${username}";
            homeDirectory = "${config.users.users.${username}.home}";
            stateVersion = "23.05";
          };
          imports = [
            ../../home/core
            ../../home/programs/alacritty.nix
            ../../home/services/syncthing.nix

          ]
          ++ optional (builtins.pathExists gitFile) gitFile;
          # TODO better solution maybe?
          myHome.services.syncthing.enable = true;
        };
      };
    }
  ];

  # required by user specific options like system.defaults
  system.primaryUser = username;
}
