{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    ./common.nix
    ../modules/nixos/grub-efi.nix
    # ../modules/nixos/syncthing.nix
  ];
}
