{
  config,
  lib,
  options,
  ...
}:
with lib;
let
  cfg = config.myModules.core;
in
{
  config = mkIf cfg.enable {
    nix = {
      #`nix.settings.auto-optimise-store` is known to corrupt the Nix Store,
      # please use `nix.optimise.automatic` instead.
      optimise.automatic = true;
      gc = {
        automatic = true;
        options = "--delete-older-than 30d";
      }
      # dates option deprecated on darwin, use default interval
      // optionalAttrs (!(options.nix.gc ? interval)) { dates = "weekly"; };
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        auto-optimise-store = false;
        warn-dirty = false;
        trusted-users = [ "@wheel" ];

        ## Binary cache
        builders-use-substitutes = true;
        substituters = [
          "https://nix-community.cachix.org"
        ];
        trusted-substituters = [
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };
    };
    # flakes require a git in PATH (darwin has no programs.git)
    programs = optionalAttrs (options.programs ? git) { git.enable = true; };
  };
}
