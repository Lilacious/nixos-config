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
    ../modules/core/vim
    inputs.nixvim.nixDarwinModules.nixvim

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
          ] ++ optional (builtins.pathExists gitFile) gitFile;
        };
      };
    }

    ../users/${username}
  ];
}
