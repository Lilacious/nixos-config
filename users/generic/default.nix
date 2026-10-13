## Generic user for the generic hosts (NixOS and nix-darwin)
{
  lib,
  pkgs,
  options,
  ...
}:
with lib;
let
  user = "nixos";
  subOpt = options.users.users.type.getSubOptions [ ];
in
{
  users.users.${user} = mkMerge [
    {
      home = if pkgs.stdenv.hostPlatform.isDarwin then "/Users/${user}" else "/home/${user}";
      shell = pkgs.zsh;
    }
    # nix-darwin has no groups, normal users nor passwords
    (optionalAttrs (subOpt ? extraGroups) {
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
    })
    (optionalAttrs (subOpt ? isNormalUser) {
      isNormalUser = true;
    })
    # initial password, change immediately after first login
    (optionalAttrs (subOpt ? initialPassword) {
      initialPassword = "changeme";
    })
  ];
}
