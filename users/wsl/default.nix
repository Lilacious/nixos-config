## WSL user
{ pkgs, ... }:
let
  user = "nixos";
in
{
  wsl.defaultUser = user;

  users.users.${user} = {
    isNormalUser = true;
    shell = pkgs.zsh;
  };

  home-manager.users.${user}.imports = [ ../../home/core ];
}
