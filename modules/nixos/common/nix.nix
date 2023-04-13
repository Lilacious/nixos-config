{ config, pkgs, lib, inputs, ... }:
{
  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
    gc = {
      automatic = false;
      #dates = "weekly";
      #options = "--delete-older-than 7d";
    };
    extraOptions = ''
      warn-dirty = false
      '';
  };
}
