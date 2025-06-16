{
  lib,
  config,
  options,
  ...
}:
with lib;
let
  cfg = config.myModules.core;
in
{
  imports = [
    ./alias.nix
    ./locale.nix
    ./nix.nix
    ./packages.nix
    ./syncthing.nix
    ./zsh.nix
  ];

  options.myModules.core = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc ''
        Disables core modules entirely if disabled.
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      time.timeZone = mkDefault "Europe/Berlin";
      nixpkgs.config.allowUnfree = mkDefault true;
    }
    # nix-darwin has no hardware options
    (
      if (builtins.hasAttr "hardware" options) then
        {
          hardware.enableRedistributableFirmware = mkDefault true;
        }
      else
        { }
    )
  ]);
}
