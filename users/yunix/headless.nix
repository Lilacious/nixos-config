{
  inputs,
  config,
  ...
}:
let
  username = "yunix";
  #gitFile = ./git.nix;
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
            homeDirectory = "${config.users.users.${username}.home}";
            stateVersion = "23.05";
          };
          imports = [
            ../../home/core
            ./git.nix
          ]; # ++ lib.optional (builtins.pathExists gitFile) gitFile;
        };
      };
    }
  ];
}
