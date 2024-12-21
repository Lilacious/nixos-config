{ self, inputs, ... }:
let
  inherit (inputs.nixpkgs) lib;
  nixhw = inputs.nixos-hardware.nixosModules;
in
{
  flake.nixosConfigurations = {
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

        {
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
