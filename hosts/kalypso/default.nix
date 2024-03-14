{ inputs, ... }:
{
  specialArgs = {
    inherit inputs;
    system = "x86_64-linux";
  };
  modules = [
    ./configuration.nix
    inputs.home-manager.nixosModules.home-manager {
      home-manager = {
        extraSpecialArgs = {};
        useGlobalPkgs = true;
        useUserPackages = true;
      };
    }
  ];
}
