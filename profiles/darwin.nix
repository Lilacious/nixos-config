{
  inputs,
  config,
  lib,
  ...
}:
with lib;
let
  username = "yunix";
  gitFile = ../users/${username}/git.nix;
in
{
  imports = [
    ../modules/core

    inputs.nixvim.nixDarwinModules.nixvim
    ../modules/vim

    inputs.stylix.darwinModules.stylix
    ../modules/stylix

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
            ../home/core
            ../home/programs/alacritty.nix
            ../home/services/syncthing.nix

          ] ++ optional (builtins.pathExists gitFile) gitFile;
          # Very hacky way to get syncthing to work on darwin
          # TODO better solution maybe?
          myHome.services.syncthing.enable = true;
        };
      };
    }
    # Needed for syncthing to work
    ../modules/services/syncthing.nix

    ../users/${username}
  ];
}
