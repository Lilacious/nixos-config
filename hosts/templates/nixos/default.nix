{ self, ... }:
let
  amd = "x86_64-linux";
  arm = "aarch64-linux";
in
{
  flake.nixosConfigurations = {
    # set hosts for different cpu architecture
    nixos-amd = self.lib.mkNixos "nixos-amd" {
      profile = "nixos";
      system = amd;
      modules = [
        ./configuration.nix
        ../../../users/generic
      ];
    };
    nixos-arm = self.lib.mkNixos "nixos-arm" {
      profile = "nixos";
      system = arm;
      modules = [
        ./configuration.nix
        ../../../users/generic
      ];
    };
    # set host for different use cases
    server = self.lib.mkNixos "server" {
      profile = "server";
      system = amd;
      modules = [ ./configuration.nix ];
    };
    desktop = self.lib.mkNixos "desktop" {
      profile = "desktop";
      system = amd;
      modules = [
        ./configuration.nix
        # desktop does nothing without a DE/WM
        { myModules.desktop.plasma.enable = true; }
      ];
    };
    workstation = self.lib.mkNixos "workstation" {
      profile = "workstation";
      system = amd;
      modules = [
        ./configuration.nix
        { myModules.desktop.plasma.enable = true; }
      ];
    };
  };
}
