{
  self,
  inputs,
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
        ./configuration.nix
        self.darwinModules.darwin

        {
          networking.hostName = "darwin-amd";
          nixpkgs.hostPlatform = amd;
        }
      ];
    };
    darwin-arm = lib.darwinSystem {
      specialArgs = {
        inherit self inputs;
        system = arm;
      };

      modules = [
        ./configuration.nix
        self.darwinModules.darwin

        {
          networking.hostName = "darwin-arm";
          nixpkgs.hostPlatform = amd;
        }
      ];
    };
  };
}
