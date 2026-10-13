{ self, ... }:
{
  flake.nixosConfigurations.aergia = self.lib.mkNixos "aergia" {
    profile = "desktop";
    modules = [
      ./hardware-configuration.nix
      ./configuration.nix
    ];
  };
}
