{ inputs, variables, nixpkgs, home-manager, nur, nixos-hardware, agenix, ... }:
let
  pkgs = import nixpkgs {
    config.allowUnfree = true;
  };
  
  lib = nixpkgs.lib;
in {        
  # penelope, laptop, workstation, Thinkpad T480
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
  # sisyphos, desktop, workstation, builder
  sisyphos = lib.nixosSystem {
    specialArgs = { 
      inherit inputs variables;
      system = "x86_64-linux";
    };
    modules = [
      ./sisyphos/configuration.nix
      home-manager.nixosModules.home-manager {
        home-manager = {
          extraSpecialArgs = {
          };
          useGlobalPkgs = true;
          useUserPackages = true;
          users.kailee.imports = [  #TODO
            ./sisyphos/sisyphos-home.nix #TODO
          ];
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
