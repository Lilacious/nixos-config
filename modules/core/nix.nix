{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.myModules;
in {
  config = mkIf cfg {
    nix = {
      settings = {
        experimental-features = "nix-command flakes";
        auto-optimise-store = true;
        warn-dirty = false;
      };
    };
  };
}
