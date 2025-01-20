{
  inputs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.myModules.desktop.cosmic;
in
{
  options = {
    myModules.desktop.cosmic = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  imports = [ inputs.nixos-cosmic.nixosModules.default ];

  config = mkIf cfg.enable {
    myModules.desktop.desktopEnvironment.enable = true;

    services.desktopManager.cosmic.enable = true;
  };
}
