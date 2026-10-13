{ self, ... }:
{
  flake.nixosConfigurations.wsl = self.lib.mkNixos "wsl" {
    profile = "wsl";
    system = "x86_64-linux";
    modules = [
      ./configuration.nix
      ../../../users/wsl
      { system.stateVersion = "24.05"; }
    ];
  };
}
