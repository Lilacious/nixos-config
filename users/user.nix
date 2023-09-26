{ pkgs, config, variables, ... }:
{ 
  users.users.${variables.username} = {
    isNormalUser = true;
    description = "Default user";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.${variables.shell}; # Set default shell
  };
}
