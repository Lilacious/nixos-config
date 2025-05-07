{ pkgs, ... }:
{
  imports = [
    ./custom.nix
  ];
  stylix = {
    enable = true;
    autoEnable = false;
    fonts = {
      serif = {
        package = pkgs.nerd-fonts.agave;
        name = "Agave Nerd Font";
      };

      sansSerif = {
        package = pkgs.nerd-fonts.arimo;
        name = "Arimo Nerd Font";
      };

      monospace = {
        package = pkgs.nerd-fonts.agave;
        name = "Agave Nerd Font Mono";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
}
