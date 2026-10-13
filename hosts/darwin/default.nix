{ self, ... }:
{
  ## darwinConfigurations in multiple files causes the following error
  ## -> stack overflow; max-call-depth exceeded
  flake.darwinConfigurations = {
    arnaea = self.lib.mkDarwin "arnaea" {
      modules = [ ./arnaea ];
    };

    #### Templates ####
    darwin-arm = self.lib.mkDarwin "darwin-arm" {
      modules = [
        ../templates/darwin/configuration.nix
        ../../users/generic
      ];
    };
  };
}
