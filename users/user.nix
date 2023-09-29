{ pkgs, config, variables, ... }:
{ 
  users.users.${variables.username} = {
    isNormalUser = true;
    description = "Default user";
    extraGroups = [ "networkmanager" "wheel" "video" ];
    shell = pkgs.${variables.shell}; # Set default shell
  };
}
