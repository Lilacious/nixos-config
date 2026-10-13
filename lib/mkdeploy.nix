# deploy-rs helpers
{ inputs, ... }:
let
  inherit (inputs) deploy-rs nixpkgs;
  # deploy-rs lib, but using the deploy-rs binary from nixpkgs
  # so it's fetched from the binary cache instead of compiled locally
  deployLib =
    system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      deployPkgs = pkgs.appendOverlays [
        deploy-rs.overlays.default
        (final: prev: {
          deploy-rs = {
            inherit (pkgs) deploy-rs;
            inherit (prev.deploy-rs) lib;
          };
        })
      ];
    in
    deployPkgs.deploy-rs.lib;
in
{
  # deploy-rs node for a nixosConfiguration, activated as root through sudo
  mkDeployNode =
    nixosConfiguration:
    {
      hostname,
      sshUser ? "yunix",
      # sudo on the hosts needs a password if user is not a trusted user
      interactiveSudo ? true,
      remoteBuild ? true,
    }:
    {
      inherit
        hostname
        sshUser
        interactiveSudo
        remoteBuild
        ;
      profiles.system = {
        user = "root";
        path = (deployLib nixosConfiguration.pkgs.stdenv.hostPlatform.system).activate.nixos nixosConfiguration;
      };
    };
}
