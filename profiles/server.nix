{
  inputs,
  lib,
  config,
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
            ../home/core
          ] ++ optional (builtins.pathExists gitFile) gitFile;
        };
      };
    }

    ../users/${username}
  ];

  services.openssh = {
    enable = true;
    settings = {
      # require public key authentication for better security
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      #PermitRootLogin = "yes";
    };
  };
}
