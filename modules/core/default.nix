{
  lib,
  options,
  ...
}:
with lib;
{
  imports = [
    ./alias.nix
    ./locale.nix
    ./nix.nix
    ./packages.nix
    ./syncthing.nix
    ./zsh.nix
  ];

  config = mkMerge [
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
  ];
}
