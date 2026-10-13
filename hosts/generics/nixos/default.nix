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
        ../../../users/generic

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
        ../../../users/generic

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
        self.nixosModules.server

        {
          networking.hostName = "server";
          nixpkgs.hostPlatform = amd;
        }
      ];
    };
    desktop = lib.nixosSystem {
      specialArgs = {
        inherit self inputs;
        system = amd;
      };
      modules = [
        ./configuration.nix
        self.nixosModules.desktop

        {
          networking.hostName = "desktop";
          nixpkgs.hostPlatform = amd;
          # desktop does nothing without a DE/WM
          myModules.desktop.plasma.enable = true;
        }
      ];
    };
    workstation = lib.nixosSystem {
      specialArgs = {
        inherit self inputs;
        system = amd;
      };
      modules = [
        ./configuration.nix
        self.nixosModules.workstation

        {
          networking.hostName = "workstation";
          nixpkgs.hostPlatform = amd;
          myModules.desktop.plasma.enable = true;
        }
      ];
    };
  };
}
