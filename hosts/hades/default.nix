{ inputs, variables, ... }:
{
  specialArgs = { 
    inherit inputs variables;
    system = "x86_64-linux";
  };
  modules = [
    ./configuration.nix
    inputs.home-manager.nixosModules.home-manager {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
      };
    }
  ];
}
