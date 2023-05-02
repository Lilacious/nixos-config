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
  };

  outputs = { self, nixpkgs, home-manager, nur, hyprland, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        # sisyphos, desktop, workstation
        sisyphos = lib.nixosSystem {
          modules = [
            ./hosts/sisyphos/configuration.nix

            nur.nixosModules.nur
            
            hyprland.nixosModules.default

            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.kailee = {
                imports = [
                  ./users/kailee/workstation-home.nix

                  hyprland.nixosModules.default
                ];
              };
            }
          ];
        };
        # hades, server, nas
        hades = lib.nixosSystem {
          modules = [
            ./hosts/hades/configuration.nix

            nur.nixosModules.nur

            hyprland.homeManagerModules.default

            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.kailee = {
                imports = [
                  ./users/kailee/server-home.nix
                ];
              };
            }
          ];
        };

        # penelope, laptop, workstation
        penelope = lib.nixosSystem {
          modules = [
            ./hosts/penelope/configuration.nix

            nur.nixosModules.nur

            hyprland.nixosModules.default

            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.kailee = {
                imports = [
                  ./users/kailee/workstation-home.nix
                  hyprland.homeManagerModules.default
                  ./modules/home/hyprland.nix
                ];
              };
            }
          ];
        };

      };
    };
}
