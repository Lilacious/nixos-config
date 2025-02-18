{ pkgs, ... }:
{
  nix.package = pkgs.lix;

  system.stateVersion = 5;
}
