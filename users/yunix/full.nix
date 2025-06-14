{
  inputs,
  config,
  lib,
  ...
}:
with lib;
let
  username = "yunix";
  homedir = config.users.users.${username}.home;
  isHost = x: config.networking.hostName == x;
  buildEnable = (isHost "penelope" || isHost "kalypso");
in
{
  imports = [
    ./.

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
            homeDirectory = homedir;
            stateVersion = "23.05";
          };
          imports = [
            ../../home
            ./git.nix
          ];
        };
      };
    }
  ];

  programs.ssh.knownHosts = mkIf buildEnable {
    "build1.darmstadt.ccc.de".publicKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE/oyJPRwW3bJoWKtXSrVOiqMaKq+9yd03+N2PuCbMKv";
    "build2.darmstadt.ccc.de".publicKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOZ7/eZLTfUD7Ejjio+8ivNFb8iyK1CD5Pq8uCDojT+z";
    "build3.darmstadt.ccc.de".publicKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM2D/SwJf46XCoim06lOyO42JqJiTeM8UMkT4bYluJJr";
    "build4.darmstadt.ccc.de".publicKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDu9ZsbUYaCzzZv4vn22KrKi/R9pCfOEe4aYWyLd96C1";
  };

  nix = mkIf buildEnable {
    distributedBuilds = mkDefault true;
    buildMachines =
      let
        buildMachine = {
          protocol = "ssh";
          sshUser = username;
          sshKey = "${homedir}/.ssh/id_remotebuild";
          systems = [
            "i686-linux"
            "x86_64-linux"
          ];
          maxJobs = 4;
          speedFactor = 6;
          supportedFeatures = [
            "big-parallel"
            "kvm"
            "nixos-test"
          ];
        };
      in
      [
        (
          {
            hostName = "build1.darmstadt.ccc.de";
          }
          // buildMachine
        )
        (
          {
            hostName = "build2.darmstadt.ccc.de";
          }
          // buildMachine
        )
        (
          {
            hostName = "build3.darmstadt.ccc.de";
          }
          // buildMachine
        )
        (
          {
            hostName = "build4.darmstadt.ccc.de";
            # this node has half the cpu of the others
            maxJobs = mkForce 2;
          }
          // buildMachine
        )
      ];
  };
}
