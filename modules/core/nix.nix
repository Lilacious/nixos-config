{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.myModules;
in {
  config = mkIf cfg.enable {
    nix = {
      settings = {
        experimental-features = "nix-command flakes";
        auto-optimise-store = true;
        warn-dirty = false;

        substituters = [
          "https://hyprland.cachix.org"
          "https://anyrun.cachix.org"
        ];
        trusted-public-keys = [
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
        ];
      };
    };
  };
}
