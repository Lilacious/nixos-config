{ pkgs, config, lib, ... }:
let
  capitalizedInitial =
    lib.toUpper( builtins.substring 0 1 "${config.variables.username}" ) 
    + builtins.substring 1 100 "${config.variables.username}";

in  { 
  users.users.${config.variables.username} = {
    isNormalUser = true;
    description = "${capitalizedInitial}";
    extraGroups = [ "networkmanager" "wheel" "video" ]; # Default groups
    initialPassword = "changeme";
    shell = pkgs.${config.variables.shell}; # Set default shell
  };
  
  home-manager = {
    users.${config.variables.username} = {
      home.username = "${config.variables.username}";
      home.homeDirectory = "/home/${config.variables.username}";
      home.stateVersion = "23.05";
    };
  };
}
