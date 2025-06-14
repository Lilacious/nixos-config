{ self, inputs, ... }:
let
  inherit (inputs.nixpkgs) lib;
  nixhw = inputs.nixos-hardware.nixosModules;
in
{
  flake = {
    nixosConfigurations = {
      penelope = lib.nixosSystem {
        specialArgs = {
          inherit self inputs;
          system = "x86_64-linux";
        };
        modules = [
          nixhw.lenovo-thinkpad-t480
          ./hardware-configuration.nix
          ./configuration.nix
          ./modules
          self.nixosModules.workstation

          inputs.lix-module.nixosModules.default

          {
            ## Custom aliases for penelope
            home-manager.users.yunix.home.shellAliases = {
              open-front-door = "ssh door@burbon.cccda.de buzzer";
              open-sesame = "ssh door@burbon.cccda.de open";
              close-sesame = "ssh door@burbon.cccda.de close";
              battery-info-internal = "upower -i /org/freedesktop/UPower/devices/battery_BAT0";
              battery-info-external = "upower -i /org/freedesktop/UPower/devices/battery_BAT1";
            };
          }
        ];
      };
    };
  };
}
