{ pkgs, ... }:
{ 
  users.users.kailee = {
    isNormalUser = true;
    description = "kailee";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };
}
