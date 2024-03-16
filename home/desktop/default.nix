{lib, ...}:
with lib; {
  options = {
    myHome.desktop = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  imports = [
    ./hyprland.nix
  ];
}
