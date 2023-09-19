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
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.darwin.follows = "";
  };

  outputs = { self, nixpkgs, home-manager, nur, hyprland, nixos-hardware, agenix , ... }@inputs:
    let
      pkgs = import nixpkgs {
        overlays = [
        ];
      };
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        # sisyphos, desktop, workstation
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
        hades = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/hades/configuration.nix

            agenix.nixosModules.default
            {environment.systemPackages = [ agenix.packages.x86_64-linux.default ];}

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

        # penelope, laptop, workstation, Thinkpad T480
        penelope = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/penelope/configuration.nix

            nixos-hardware.nixosModules.lenovo-thinkpad-t480

            nur.nixosModules.nur

            hyprland.nixosModules.default

            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.kailee = {
                imports = [
                  ./hosts/penelope/penelope-home.nix

                  hyprland.homeManagerModules.default

                ];
              };
            }
          ];
        };

      };
    };
}
