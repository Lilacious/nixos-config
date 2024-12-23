{
  self,
  inputs,
  pkgs,
  ...
}:
let
  inherit (inputs.darwin) lib;
  amd = "x86_64-darwin";
  arm = "aarch64-darwin";
in
{
  flake.darwinConfigurations = {
    darwin-amd = lib.darwinSystem {
      specialArgs = {
        inherit self inputs;
        system = amd;
      };

      modules = [
        self.darwinModules.darwin

        {
          networking.hostName = "darwin-amd";
          nix.package = pkgs.lix;
          nixpkgs.hostPlatform = amd;
          system.stateVersion = 5;
        }
      ];
    };
    darwin-arm = lib.darwinSystem {
      specialArgs = {
        inherit self inputs;
        system = arm;
      };

      modules = [
        self.darwinModules.darwin

        {
          networking.hostName = "darwin-arm";
          nix.package = pkgs.lix;
          nixpkgs.hostPlatform = amd;
          system.stateVersion = 5;
        }
      ];
    };
  };
}
