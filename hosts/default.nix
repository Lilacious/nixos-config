{ inputs, variables, nixpkgs, home-manager, nur, nixos-hardware, plasma-manager, agenix, ... }:
let
  lib = nixpkgs.lib;
in {        
  ## penelope, laptop, workstation, Thinkpad T480
  penelope = lib.nixosSystem {
    specialArgs = { 
      inherit inputs variables;
      system = "x86_64-linux";
    };
    modules = [
      ./penelope/configuration.nix
      home-manager.nixosModules.home-manager {
        home-manager = {
          extraSpecialArgs = {};
          useGlobalPkgs = true;
          useUserPackages = true;
        };
      }
    ];
  };
  ## kalypso
  kalypso = {
    specialArgs = {
      inherit inputs variables;
      system = "x86_64-linux";
    };
    modules = [
      ./kalypso/configuration.nix
      home-manager.nixosModules.home-manager {
        home-manager = {
          extraSpecialArgs = {};
          useGlobalPkgs = true;
          useUserPackages = true;
        };
      }
    ];
  };
  ## arupi 
  arupi = lib.nixosSystem {
    specialArgs = {
      inherit inputs variables;
      system = "aarch64-linux";
    };
    modules = [
      ./arupi/configuration.nix
      home-manager.nixosModules.home-manager {
        home-manager = {
          extraSpecialArgs = {};
          useGlobalPkgs = true;
          useUserPackages = true;
        };
      }
    ];
  };
  ## hades, nas, server
  hades = lib.nixosSystem {
    specialArgs = { 
      inherit inputs variables;
      system = "x86_64-linux";
    };
    modules = [
      ./hades/configuration.nix
      home-manager.nixosModules.home-manager {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
        };
      }
    ];
  };
  # sisyphos, builder
  sisyphos = lib.nixosSystem {
    specialArgs = { 
      inherit inputs variables;
      system = "x86_64-linux";
    };
    modules = [
      ./sisyphos/configuration.nix
      home-manager.nixosModules.home-manager {
        home-manager = {
          extraSpecialArgs = {};
          useGlobalPkgs = true;
          useUserPackages = true;
        };
      }
    ];
  };
  ## rlang, other
  rlang = lib.nixosSystem {
    specialArgs = { 
      system = "x86_64-linux";
    };
    modules = [
      ./rlang/configuration.nix
    ];
  };
  ## Add new hosts here

}
