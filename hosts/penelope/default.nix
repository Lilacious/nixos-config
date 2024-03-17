{inputs, ...}: let
  lib = inputs.nixpkgs.lib;
  hm = inputs.home-manager.nixosModules.home-manager;
in {
  flake.nixosConfigurations = {
    penelope = lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        system = "x86_64-linux";
      };
      modules = [
        inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
        ./hardware-configuration.nix
        ./configuration.nix
        ./packages.nix
        ../../modules
        ../../secrets

        # Enable Yunix
        ../../users/yunix

        hm
        {
          home-manager = {
            extraSpecialArgs = {};
            useGlobalPkgs = true;
            useUserPackages = true;
          };

          ## Custom aliases for penelope
          home-manager.users.yunix.home.shellAliases = {
            open-front-door = "ssh door@bourbon.w17.io buzzer";
            open-sesame = "ssh door@bourbon.w17.io open";
            close-sesame = "ssh door@bourbon.w17.io close";
            battery-info-internal = "upower -i /org/freedesktop/UPower/devices/battery_BAT0";
            battery-info-external = "upower -i /org/freedesktop/UPower/devices/battery_BAT1";
          };
        }
      ];
    };
  };
}
