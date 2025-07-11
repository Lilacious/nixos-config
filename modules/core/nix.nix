{ config, lib, ... }:
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
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
      settings = {
        experimental-features = "nix-command flakes";
        auto-optimise-store = false;
        warn-dirty = false;

        ## Binary cache
        builders-use-substitutes = true;
        substituters = [
          "https://nix-community.cachix.org"
          "https://hyprland.cachix.org"
        ];
        trusted-substituters = [
          "https://nix-community.cachix.org"
          "https://hyprland.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        ];
      };
    };
    # flakes require a git in PATH
    programs.git.enable = true;
  };
}
