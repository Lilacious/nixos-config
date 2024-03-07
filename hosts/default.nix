{ inputs, variables, nixpkgs, home-manager, ... }:
let
  lib = nixpkgs.lib;
in {        
  ## penelope, laptop, workstation, Thinkpad T480
  penelope = lib.nixosSystem ( 
    import ./penelope { inherit inputs variables; }
  );

  ## kalypso, workstation
  kalypso = lib.nixosSystem (
    import ./penelope { inherit inputs variables; }
  );

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
  ## orupi 
  orupi = lib.nixosSystem {
    specialArgs = {
      inherit inputs variables;
      system = "aarch64-linux";
    };
    modules = [
      ./orupi/configuration.nix
      home-manager.nixosModules.home-manager {
        home-manager = {
          extraSpecialArgs = {};
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
