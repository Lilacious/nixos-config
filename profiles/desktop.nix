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
    ./nixos.nix
    ../modules

    inputs.home-manager.nixosModules.home-manager
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
            ../home
          ] ++ optional (builtins.pathExists gitFile) gitFile;
        };
      };
    }

    ../users/${username}
  ];
}
