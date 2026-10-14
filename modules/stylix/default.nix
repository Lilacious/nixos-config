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
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };

      sansSerif = {
        package = pkgs.inter;
        name = "Inter";
      };

      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };

      # JetBrains Mono runs larger than most fonts
      sizes.terminal = 10;
    };
  };
}
