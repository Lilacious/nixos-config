{
  inputs,
  config,
  ...
}:
let
  username = "yunix";
  homedir = config.users.users.${username}.home;
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
}
