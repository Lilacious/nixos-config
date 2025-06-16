{ self, inputs, ... }:
let
  inherit (inputs.nixpkgs) lib;
  amd = "x86_64-linux";
  arm = "aarch64-linux";
in
{
  flake.nixosConfigurations = {
    # set hosts for different cpu architecture
    nixos-amd = lib.nixosSystem {
      specialArgs = {
        inherit self inputs;
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
        inherit self inputs;
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
    # set host for different use cases
    server = lib.nixosSystem {
      specialArgs = {
        inherit self inputs;
        system = amd;
      };
      modules = [
        ./configuration.nix
        self.nixosModules.nixos

        {
          networking.hostName = "server";
          nixpkgs.hostPlatform = amd;
        }
      ];
    };
  };
}
