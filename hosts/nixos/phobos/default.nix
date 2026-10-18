{ self, ... }:
{
  flake.nixosConfigurations.phobos = self.lib.mkNixos "phobos" {
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
