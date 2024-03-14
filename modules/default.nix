{lib, ...}:
with lib; {
  options.myModules = mkOption {
    type = types.bool;
    default = true;
    description = lib.mdDoc ''
      Disables local modules entirely if disabled.
    '';
  };

  imports = [
    ./core
  ];
}
