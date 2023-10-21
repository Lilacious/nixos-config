{ inputs, variables, nixpkgs, home-manager, nur, hyprland, nixos-hardware, agenix, anyrun, ... }:
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
          extraSpecialArgs = {
            inherit hyprland anyrun;
          };
          useGlobalPkgs = true;
          useUserPackages = true;
          users.${variables.username}.imports = [
            ./penelope/home.nix
          ];
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
      ./configuration.nix
      home-manager.nixosModules.home-manager {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.kailee.imports = [ #TODO
            ../../users/kailee/server-home.nix  #TODO
          ];
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
      ./configuration.nix
      home-manager.nixosModules.home-manager {
        home-manager = {
          extraSpecialArgs = {
            inherit hyprland anyrun;
          };
          useGlobalPkgs = true;
          useUserPackages = true;
          users.kailee.imports = [  #TODO
            sisyphos-home.nix #TODO
          ];
        };
      }
    ];
  };
  ## generic
  generic = lib.nixosSystem {
    specialArgs = { 
      inherit inputs variables;
      system = "x86_64-linux";
    };
    modules = [
      ./generic/configuration.nix
      home-manager.nixosModules.home-manager {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.${variables.username}.imports = [
            ./generic/home.nix
          ];
        };
      }
    ];
  };
  ## Add new hosts here

}
