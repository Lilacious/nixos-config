{
  nix = {
    #`nix.settings.auto-optimise-store` is known to corrupt the Nix Store,
    # please use `nix.optimise.automatic` instead.
    optimise.automatic = true;
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = false;
      warn-dirty = false;

      ## Binary cache
      builders-use-substitutes = true;
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
}
