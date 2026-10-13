{
  self,
  inputs,
  ...
}:
let
  inherit (inputs.darwin) lib;
  arm = "aarch64-darwin";
in
{
  ## darwinConfigurations in multiple files causes the following error
  ## -> stack overflow; max-call-depth exceeded
  flake.darwinConfigurations = {
    arnaea = lib.darwinSystem {
      specialArgs = {
        inherit self inputs;
        system = arm;
      };

      modules = [
        ./arnaea
        self.darwinModules.darwin

        {
          networking.hostName = "arnaea";
          nixpkgs.hostPlatform = arm;
        }
      ];
    };

    #### Templates ####
    darwin-arm = lib.darwinSystem {
      specialArgs = {
        inherit self inputs;
        system = arm;
      };

      modules = [
        ./configuration.nix
        self.darwinModules.darwin
        ../../users/generic

        {
          networking.hostName = "darwin-arm";
          nixpkgs.hostPlatform = arm;
        }
      ];
    };
  };
}
