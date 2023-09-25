{ pkgs, config, ... }:
{ 
  users.users.yunix = {
    isNormalUser = true;
    description = "Default user";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh; # Set default shell
  };
}