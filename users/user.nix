{ pkgs, variables, lib, ... }:
let
  capitalizedInitial =
    lib.toUpper( builtins.substring 0 1 "${variables.username}" ) 
    + builtins.substring 1 100 "${variables.username}";

in  { 
  users.users.${variables.username} = {
    isNormalUser = true;
    description = "${capitalizedInitial}";
    extraGroups = [ "networkmanager" "wheel" "video" ]; # Default groups
    shell = pkgs.${variables.shell}; # Set default shell
  };
}
