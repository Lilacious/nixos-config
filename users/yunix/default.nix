{
  lib,
  pkgs,
  options,
  ...
}:
with lib;
let
  subOpt = options.users.users.type.getSubOptions [ ];
in
{
  imports = [
    ./syncthing.nix
  ];

  # See profile/base.nix
  home-manager.users.yunix.imports = [
    ../../home/core
    ./git.nix
  ];

  users.users.yunix = mkMerge [
    {
      home = if pkgs.stdenv.hostPlatform.isDarwin then "/Users/yunix" else "/home/yunix";
      description = "Yunix";
      shell = pkgs.zsh;

      openssh.authorizedKeys.keys = [
        ## penelope
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGc5xk4R+2CfNV1fyyvZEZgzjaRomO0hCJ55E00pSOsv"
        ## kalypso
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILGVWA+PLmapB6pW+kovWMyShlKEXI7XPemWI8i3GlSY"
        ## deimos
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIkO67nT2HDzhMBswI52SA2BPOrarjnntYcp9YF+AvET"
      ];
    }
    # nix-darwin
    (optionalAttrs (subOpt ? extraGroups) {
      extraGroups = [
        "libvirtd"
        "networkmanager"
        "video"
        "wheel"
      ];
    })
    # initial password, change immediately after first login
    (optionalAttrs (subOpt ? isNormalUser) {
      isNormalUser = true;
    })
    (optionalAttrs (subOpt ? initialPassword) {
      initialPassword = "changeme";
    })
  ];
}
