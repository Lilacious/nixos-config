{
  self,
  inputs,
  config,
  ...
}:
let
  username = "yunix";
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
            ../users/${username}/git.nix
            self.nixosModules.home-core
          ];
        };
      };
    }

    ../users/${username}
  ];
}
