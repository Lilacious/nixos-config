{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.myModules;
in {
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ## Network
      wget
      curl

      ## System
      pciutils
      usbutils
      dmidecode
      lm_sensors

      ## Hard drive monitoring
      smartmontools

      ## Tops
      htop
      btop
      powertop

      ## Files
      zip
      unzip

      ### Core utils
      ## find
      fd # Simple find command
      fzf # A command-line fuzzy finder

      ## du/df
      ncdu # Disk usage analyzer ncurses
      # du-dust     # Disk usage analizer in rust
      duf # Disk Usage/Free Utility
      ## grep
      ripgrep # Better grep for code search
      ## cat
      # lolcat      # A rainbow version of cat
      bat # Better cat with syntax highlighting
      ## ls/tree
      eza # ls replacement
      # tree        # Indented directory listing

      ## Other
      alejandra # nix formating
      neofetch # Sys info fetcher
      cheat # cheat sheet

      ### Important
      ## System wide git needed for doas nixos-switch --flake
      git
    ];
  };
}
