{ lib, ... }:

with lib;
{
  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      warn-dirty = false;
    };
    gc = {
      automatic = mkDefault true;
      dates = "weekly";
      options = "--delete-older-than +5";
    };
  };
}
