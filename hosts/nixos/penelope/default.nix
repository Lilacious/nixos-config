{ self, inputs, ... }:
let
  nixhw = inputs.nixos-hardware.nixosModules;
in
{
  flake.nixosConfigurations.penelope = self.lib.mkNixos "penelope" {
    profile = "workstation";
    modules = [
      nixhw.lenovo-thinkpad-t480
      ./hardware-configuration.nix
      ./configuration.nix
      ./modules

      # Remote builder broken on lix
      #inputs.lix-module.nixosModules.default

      {
        ## Custom aliases for penelope
        home-manager.users.yunix.home.shellAliases = {
          battery-info-internal = "upower -i /org/freedesktop/UPower/devices/battery_BAT0";
          battery-info-external = "upower -i /org/freedesktop/UPower/devices/battery_BAT1";
        };
      }
    ];
  };
}
