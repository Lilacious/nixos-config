{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "lilacious";
    userEmail = "yuchenhe126@gmail.com";
  };
}
