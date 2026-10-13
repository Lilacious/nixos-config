# Standalone home-manager for non-NixOS linux, apply with
# `home-manager switch --flake .#yunix`
{ self, inputs, ... }:
{
  flake.homeConfigurations = {
    yunix = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = { inherit self inputs; };
      modules = [
        self.homeModules.nix-linux
        ../../../home/core
        ../../../users/yunix/git.nix

        {
          home = {
            username = "yunix";
            homeDirectory = "/home/yunix";
            stateVersion = "23.05";
          };
        }
      ];
    };
  };
}
