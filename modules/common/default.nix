{ lib, ... }:

with lib;
{
  imports = [
    ./font.nix
    ./git.nix
    ./nix.nix
    ./pkgs.nix
    ./security.nix
    ./starship.nix
    ./vim.nix
    ./zsh.nix
  ];

  i18n.supportedLocales = [
    "en_IE.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
    "de_DE.UTF-8/UTF-8"
    "ja_JP.UTF-8/UTF-8"
    "zh_CN.UTF-8/UTF-8"
    "zh_TW.UTF-8/UTF-8"
    "ko_KR.UTF-8/UTF-8"
  ];

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ALL = "en_IE.UTF-8";
    #LC_ADDRESS = "de_DE.UTF-8";
    #LC_IDENTIFICATION = "de_DE.UTF-8";
    #LC_MEASUREMENT = "de_DE.UTF-8";
    #LC_MONETARY = "de_DE.UTF-8";
    #LC_NAME = "de_DE.UTF-8";
    #LC_NUMERIC = "de_DE.UTF-8";
    #LC_PAPER = "de_DE.UTF-8";
    #LC_TELEPHONE = "de_DE.UTF-8";
    #LC_TIME = "de_DE.UTF-8";
  };

  ## Default keymap
  console.keyMap = mkDefault "de";
    
  ## Default time zone
  time.timeZone = mkDefault "Europe/Berlin";
  
  hardware.enableRedistributableFirmware = mkDefault true;
  nixpkgs.config.allowUnfree = mkDefault true;
}
