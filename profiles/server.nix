{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    ./common.nix
    # ../modules/nixos/syncthing.nix
  ];
}
