{ pkgs, lib, ... }:
with lib;
{
  config = mkMerge [
    {
      environment.systemPackages = with pkgs; [
        ### Hard drive monitoring
        smartmontools

        ### Tops
        htop
        btop

        ### Files
        zip
        unzip

        ### Core utils
        ## find
        fd # Simple find command
        fzf # A command-line fuzzy finder

        ## grep
        ripgrep # Better grep for code search
        ## cat
        # lolcat      # A rainbow version of cat
        # bat # Better cat with syntax highlighting
        ## ls/tree
        eza # ls & tree replacement

        ## Nix
        comma # runs software without installing
        nixfmt-rfc-style # nix formating
        deadnix # Find and remove unused code in nix files
        statix # Lints and suggestions for nix-lang
        nixpkgs-review # review nixpkgs pr
        nix-init # package generation
        sops # For sops-nix

        ## Other
        fastfetch # Sys info fetcher
        cheat # cheat sheet
        git
      ];
    }

    (mkIf pkgs.stdenv.isLinux {
      environment.systemPackages = with pkgs; [
        ### Network
        wget
        curl

        ### System
        pciutils
        usbutils
        dmidecode
        lm_sensors

        ### Tops
        powertop

        ### Core utils
        ## du/df
        ncdu # Disk usage analyzer ncurses
        # du-dust     # Disk usage analizer in rust
        duf # Disk Usage/Free Utility
      ];
    })
  ];
}
