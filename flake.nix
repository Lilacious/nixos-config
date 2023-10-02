{
  description = "My really basic flaky flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    hyprland.url = "github:hyprwm/Hyprland";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.darwin.follows = "";
    };
    anyrun = { 
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nur, hyprland, nixos-hardware, agenix, anyrun, ... }@inputs:
    let
      variables = {
        username = "yunix";
        shell = "zsh";
      };

      pkgs = import nixpkgs {
        overlays = [
        ];
      };
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        # sisyphos, desktop, workstation
        #
        sisyphos = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/sisyphos/configuration.nix

            nur.nixosModules.nur
            
            hyprland.nixosModules.default

            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.kailee = {
                imports = [
                  ./hosts/sisyphos/sisyphos-home.nix

                  hyprland.homeManagerModules.default

                ];
              };
            }
          ];
        };
        # hades, server, nas
        #
        hades = lib.nixosSystem {
          specialArgs = { 
            inherit inputs variables;
            system = "x86_64-linux";
          };
          modules = [
            ./hosts/hades/configuration.nix

            home-manager.nixosModules.home-manager {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.kailee = {
                  imports = [
                    ./users/kailee/server-home.nix
                  ];
                };
              };
            }
          ];
        };

        # penelope, laptop, workstation, Thinkpad T480
        #
        penelope = lib.nixosSystem {
          specialArgs = { 
            inherit inputs variables;
            system = "x86_64-linux";
          };
          modules = [
            ./hosts/penelope/configuration.nix

            home-manager.nixosModules.home-manager {
              home-manager = {
                extraSpecialArgs = {
                  inherit hyprland anyrun;
                };
                useGlobalPkgs = true;
                useUserPackages = true;
                users.yunix = {
                  imports = [
                    ./hosts/penelope/home.nix
                  ];
                };
              };
            }
          ];
        };
        hermes = lib.nixosSystem {
          specialArgs = { 
            inherit inputs variables;
            system = "x86_64-linux";
          };
          modules = [
            ./hosts/hermes/configuration.nix

            home-manager.nixosModules.home-manager {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.yunix = {
                  imports = [
                    ./hosts/hermes/home.nix
                  ];
                };
              };
            }
          ];
        };
        # Add new hosts here
      };
    };
}
