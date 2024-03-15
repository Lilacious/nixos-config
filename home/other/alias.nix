{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.myHome.other.alias;
in {
  options = {
    myHome.other.alias = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf cfg.enable {
    shellAliases = {
      c = "clear";
      cat = "bat";
      update = "cd ~/nixos-config && sudo nixos-rebuild switch --flake .#$HOST";
    };
  };
}
