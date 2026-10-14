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

      sizes = {
        # JetBrains Mono runs larger than most fonts
        terminal = 10;
        # 10pt is about 13px, the macOS system font size
        applications = 10;
      };
    };
  };
}
