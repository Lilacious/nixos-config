{ lib, inputs, outputs, ... }: {
  imports = [
    ../modules/nixos/common
  ];

  nixpkgs.config.allowUnfree = true;

}
