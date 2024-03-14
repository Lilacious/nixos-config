{ lib, ... }:

with lib;
{
  options = {
    variables = {
      username = mkOption {
        type = types.str;
        default = "yunix";
      };
      shell = mkOption {
        type = types.str;
        default = "zsh";
      };
      email = mkOption {
        type = types.str;
        default = "yuchenhe126@gmail.com";
      };
    };
  };
}
