{ self, inputs, ... }:
let
  inherit (inputs.nixpkgs) lib;
  amd = "x86_64-linux";
  arm = "aarch64-linux";
in
{
  flake.nixosConfigurations = {
    nixos-amd = lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        system = amd;
      };
      modules = [
        ./configuration.nix
        self.nixosModules.nixos

        {
          networking.hostName = "nixos-amd";
          nixpkgs.hostPlatform = amd;
        }
      ];
    };
    nixos-arm = lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        system = arm;
      };
      modules = [
        ./configuration.nix
        self.nixosModules.nixos

        {
          networking.hostName = "nixos-arm";
          nixpkgs.hostPlatform = arm;
        }
      ];
    };
  };
}
