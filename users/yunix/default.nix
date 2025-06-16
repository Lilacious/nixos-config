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
  users.users.yunix = mkMerge [
    {
      home = if pkgs.stdenv.isDarwin then "/Users/yunix" else "/home/yunix";
      description = "Yunix";
      shell = pkgs.zsh;

      openssh.authorizedKeys.keys = [
        ## penelope
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGc5xk4R+2CfNV1fyyvZEZgzjaRomO0hCJ55E00pSOsv"
        ## kalypso
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILGVWA+PLmapB6pW+kovWMyShlKEXI7XPemWI8i3GlSY"
      ];
    }
    # nix-darwin
    (
      if (builtins.hasAttr "extraGroups" subOpt) then
        {
          extraGroups = [
            "libvirtd"
            "networkmanager"
            "video"
            "wheel"
          ];
        }
      else
        { }
    )
    (
      if (builtins.hasAttr "isNormalUser" subOpt) then
        {
          isNormalUser = true;
        }
      else
        { }
    )
  ];
}
