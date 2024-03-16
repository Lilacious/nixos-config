{lib, ...}:
with lib; {
  options.myModules = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc ''
        Disables local modules entirely if disabled.
      '';
    };
  };

  imports = [
    ./core
    ./desktop
    ./other
    ./programs
    ./services
  ];
}
