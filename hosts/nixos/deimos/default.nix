{ self, ... }:
{
  flake.nixosConfigurations.deimos = self.lib.mkNixos "deimos" {
    profile = "wsl";
    system = "x86_64-linux";
    modules = [
      ./configuration.nix
      ../../../users/yunix

      {
        wsl.defaultUser = "yunix";
        system.stateVersion = "24.05";
      }
    ];
  };
}
