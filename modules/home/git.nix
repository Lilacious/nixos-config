{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Yuchen He";
    userEmail = "yuchenhe126@gmail.com";
  };
}
